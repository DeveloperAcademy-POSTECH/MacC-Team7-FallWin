//
//  ImageGenerationResponse.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/14/23.
//

import Foundation

struct ImageGenerationResponse: Codable {
    struct ImageResponse: Codable {
        let url: String
    }
    
    let created: Int
    let data: [ImageResponse]
}
