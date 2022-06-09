//
//  WidgetContent.swift
//  ClipStack
//
//  Created by Chuck on 06/06/2022.
//

import Foundation
import WidgetKit

struct WidgetContent: Codable, TimelineEntry {
    var date: Date = Date()
    let content: Data
    let name: String
    let type: String
    let dateCreated: Date
    let id: UUID?
}
