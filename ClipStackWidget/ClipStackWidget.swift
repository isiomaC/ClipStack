//
//  ClipStackWidget.swift
//  ClipStackWidget
//
//  Created by Chuck on 05/06/2022.
//

import WidgetKit
import SwiftUI

@available(iOS 14.0, *)
struct Provider: TimelineProvider {
    
    let snapShotEntry = WidgetContent(date: Date(), content: Data(), name: "name",
                                      type: CopyItemType.image.rawValue, dateCreated: Date(), id: UUID())
    
    
    private func readContents() -> [WidgetContent] {
        guard let archiveUrl = FileManager.default.containerURL(
          forSecurityApplicationGroupIdentifier: "group.com.chuck.clipstack.contents"
        ) else { return [] }
        
        var contents: [WidgetContent] = []
        
        let archiveURL = archiveUrl.appendingPathComponent("contents1.json")
        print(">>> \(archiveURL)")

        let decoder = JSONDecoder()
        if let codeData = try? Data(contentsOf: archiveURL) {
        do {
          contents = try decoder.decode([WidgetContent].self, from: codeData)
        } catch {
          print("Error: Can't decode contents")
        }
        }
        return contents
    }
    
    func placeholder(in context: Context) -> WidgetContent {
        return snapShotEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> ()) {
        
        //ftech new snapshot to show
        let entry = snapShotEntry
        
        var entries: [WidgetContent] = readContents()
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetContent] = readContents()

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let interval = 5
        
        for hourOffset in 0 ..< entries.count {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset * interval, to: currentDate)!
            entries[hourOffset].date = entryDate
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

@available(iOS 14.0, *)
struct ClipStackWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
//        ZStack {
//            Color(.systemBlue).edgesIgnoringSafeArea(.all)
//            Text(entry.date, style: .time)
//                .font(.largeTitle)
//        }
        VStack(alignment: .leading) {
            Text(entry.type)
                .font(.system(size: 10))
              .lineLimit(2)
              .fixedSize(horizontal: false, vertical: true)
              .padding([.trailing], 15)
              .foregroundColor(Color.green)
            
            Text(entry.name)
              .font(.system(size: 8))
              .lineLimit(nil)
              .foregroundColor(Color.green)
            
//            isTrue ? Text(entry.type)
//              .font(.system(size: 12))
//              .fixedSize(horizontal: false, vertical: true)
//              .lineLimit(2)
//              .lineSpacing(3)
//              .foregroundColor(Color.green) as! Text
//            : Text("blah")
            
//            Text(model.releasedAtDateTimeString)
//              .font(.uiCaption)
//              .lineLimit(1)
//              .foregroundColor(.contentText)
          }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pink)
//          .padding()
          .cornerRadius(6)
          .edgesIgnoringSafeArea(.all)
         
    }
}

@available(iOS 14.0, *)
@main
struct ClipStackWidget: Widget {
    let kind: String = "ClipStackWidget"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ClipStackWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge, .systemSmall])
    }
}

@available(iOS 14.0, *)
struct ClipStackWidget_Previews: PreviewProvider {
    static var previews: some View {
        ClipStackWidgetEntryView(entry: WidgetContent(date: Date(), content: Data(), name: "name",
                                                      type: CopyItemType.image.rawValue, dateCreated: Date(), id: UUID()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
