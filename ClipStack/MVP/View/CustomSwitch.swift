//
//  CustomSwitch.swift
//  ClipStack
//
//  Created by Chuck on 16/06/2022.
//


import Foundation
import UIKit

// MARK: - CustomSwitch
public class CustomSwitch: UIControl {

    // MARK: - Public Properties
    public var items: [String] = ["Item 1", "Item 2", "Item 3"] {
        didSet {
            setupLabels()
        }
    }

    public var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }

    public var animationDuration: TimeInterval = 0.5
    public var animationSpringDamping: CGFloat = 0.6
    public var animationInitialSpringVelocity: CGFloat = 0.8

    // MARK: - IBInspectable Properties

    public var selectedTitleColor: UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }

    public var titleColor: UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }

    public var font: UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }

    public var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    public var cornerRadius: CGFloat! {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    public var thumbColor: UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }

    public var thumbCornerRadius: CGFloat! {
        didSet {
            thumbView.layer.cornerRadius = thumbCornerRadius
        }
    }

    @IBInspectable public var thumbInset: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Private Properties

    private var labels = [UILabel]()
    private var thumbView = UIView()
    private var selectedThumbViewFrame: CGRect?
    private var panGesture: UIPanGestureRecognizer!

    // MARK: - Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView(){
        backgroundColor = .clear

        setupLabels()

        insertSubview(thumbView, at: 0)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }

    private func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }

        labels.removeAll(keepingCapacity: true)

        for index in 1...items.count {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = font
            label.textColor = index == 1 ? selectedTitleColor : titleColor
            label.translatesAutoresizingMaskIntoConstraints = false

            self.addSubview(label)
            labels.append(label)
        }

        addIndividualItemConstraints(items: labels, mainView: self, padding: thumbInset)
    }

    // MARK: - Touch Events

    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        if let index = indexAtLocation(location: location) {
            selectedIndex = index
            sendActions(for: .valueChanged)
        }
        return false
    }

    @objc func pan(gesture: UIPanGestureRecognizer!) {
        if gesture.state == .began {
            selectedThumbViewFrame = thumbView.frame
        } else if gesture.state == .changed {
            var frame = selectedThumbViewFrame!
            frame.origin.x += gesture.translation(in: self).x
            frame.origin.x = min(frame.origin.x, bounds.width - frame.width)
            thumbView.frame = frame
        } else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
            let location = gesture.location(in: self)
            if let index = indexAtLocation(location: location) {
                selectedIndex = index
                sendActions(for: .valueChanged)
            }
        }
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = cornerRadius ?? frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true

        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth

        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = (thumbCornerRadius ?? thumbView.frame.height / 2) - thumbInset

        displayNewSelectedIndex()
    }

    // MARK: - Private - Helpers

    private func displayNewSelectedIndex() {
        for (_, item) in labels.enumerated() {
            item.textColor = titleColor
        }

        let label = labels[selectedIndex]
        label.textColor = selectedTitleColor

        UIView.animate(withDuration: animationDuration,
            delay: 0.0,
            usingSpringWithDamping: animationSpringDamping,
            initialSpringVelocity: animationInitialSpringVelocity,
            options: [],
            animations: { self.thumbView.frame = label.frame },
            completion: nil)
    }

    private func setSelectedColors() {
        for item in labels {
            item.textColor = titleColor
        }

        if labels.count > 0 {
            labels[selectedIndex].textColor = selectedTitleColor
        }

        thumbView.backgroundColor = thumbColor
    }

    private func setFont() {
        for item in labels {
            item.font = font
        }
    }

    private func indexAtLocation(location: CGPoint) -> Int? {
        var calculatedIndex: Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
                break
            }
        }
        return calculatedIndex
    }

    private func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        for (index, button) in items.enumerated() {
            let topConstraint = NSLayoutConstraint(item: button,
                                                   attribute: NSLayoutConstraint.Attribute.top,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: mainView,
                                                    attribute: NSLayoutConstraint.Attribute.top,
                                                    multiplier: 1.0,
                                                    constant: padding)

            let bottomConstraint = NSLayoutConstraint(item: button,
                                                      attribute: NSLayoutConstraint.Attribute.bottom,
                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: mainView,
                                                    attribute: NSLayoutConstraint.Attribute.bottom,
                                                    multiplier: 1.0,
                                                    constant: -padding)

            var rightConstraint : NSLayoutConstraint!
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutConstraint.Attribute.right,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: mainView,
                                                    attribute: NSLayoutConstraint.Attribute.right,
                                                    multiplier: 1.0,
                                                    constant: -padding)
            } else {
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutConstraint.Attribute.right,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: nextButton,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    multiplier: 1.0,
                                                    constant: -padding)
            }

            var leftConstraint : NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: mainView,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    multiplier: 1.0,
                                                    constant: padding)
            } else {
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: prevButton,
                                                    attribute: NSLayoutConstraint.Attribute.right,
                                                    multiplier: 1.0,
                                                    constant: padding)

                let firstItem = items[0]
                let widthConstraint = NSLayoutConstraint(item: button,
                                                         attribute: .width,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: firstItem,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0)

                mainView.addConstraint(widthConstraint)
            }

            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
}

// MARK: - UIGestureRecognizer Delegate
extension CustomSwitch: UIGestureRecognizerDelegate {

    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return thumbView.frame.contains(gestureRecognizer.location(in: self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
