//
//  Count.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import Foundation

enum SpaceType: String {
    case includeBoth
    case includeSpace
    case includeEnter
    case neither
}

struct Count {
    var text: String
    var spaceType: SpaceType
    
    // MARK: 공백 전처리
    var spaceExcluded: String {
        var replaced: String
        switch spaceType {
        case .includeBoth:
            replaced = text
            break
        case .includeSpace:
            replaced = text.replacingOccurrences(of: "\n", with: "")
            break
        case .includeEnter:
            replaced = text.replacingOccurrences(of: " ", with: "")
            break
        case .neither:
            replaced = text.replacingOccurrences(of: " ", with: "")
            replaced = replaced.replacingOccurrences(of: "\n", with: "")
            break
        }
        return replaced
    }
    
    // MARK: 바이트 계산
    var bytes: Int {
        return spaceExcluded.utf8.count
    }
    
    // MARK: 글자 계산
    var letters: Int {
        return spaceExcluded.count
    }
    
    // MARK: 단어 계산
    var words: Int {
        let splits = text.split(maxSplits: Int.max, omittingEmptySubsequences: true, whereSeparator: {
            $0 == " " || $0 == "\n"
        })
        return splits.count
    }
}
