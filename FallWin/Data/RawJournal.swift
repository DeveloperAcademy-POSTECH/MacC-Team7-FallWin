//
//  RawJournal.swift
//  FallWin
//
//  Created by 최명근 on 11/10/23.
//

import Foundation

struct RawJournal: Codable {
    var id: UUID?
    var content: String?
    var timestamp: Date?
    var mind: Int
    var drawingStyle: Int
    var image: String?
}

extension RawJournal {
    static func convert(from journal: Journal) -> RawJournal {
        return RawJournal(id: journal.id, content: journal.content, timestamp: journal.timestamp, mind: Int(journal.mind), drawingStyle: Int(journal.drawingStyle), image: journal.image)
    }
    
    static func convert(from journals: [Journal]) -> [RawJournal] {
        var raws: [RawJournal] = []
        for journal in journals {
            raws.append(RawJournal.convert(from: journal))
        }
        return raws
    }
}
