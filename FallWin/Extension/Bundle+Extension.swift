//
//  Bundle+Extension.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import Foundation


extension Bundle {
    
    var dallEAPIKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["DallEAPIKey"] as? String else {
            print("API KEY를 가져오는데 실패하였습니다.")
            return ""
        }
        return key
    }
    
    var karloAPIKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["KarloAPIKey"] as? String else {
            print("API KEY를 가져오는데 실패하였습니다.")
            return ""
        }
        return key
    }
}
