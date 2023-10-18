//
//  Bundle+Extension.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/18/23.
//

import Foundation


extension Bundle {
    
    var apiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["APIKey"] as? String else {
            print("API KEY를 가져오는데 실패하였습니다.")
            return ""
        }
        return key
    }
}
