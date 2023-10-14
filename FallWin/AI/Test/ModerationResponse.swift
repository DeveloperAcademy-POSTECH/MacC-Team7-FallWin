//
//  ModerationResponse.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/14/23.
//

import Foundation

struct ModerationResponse: Codable {
    struct ModerationResult: Codable {
        struct Category: Codable {
            let sexual: Bool
            let hate: Bool
            let harassment: Bool
            let selfHarm: Bool
            let sexualMinors: Bool
            let hateThreatening: Bool
            let violenceGraphic: Bool
            let selfHarmIntent: Bool
            let selfHarmInstructions: Bool
            let harassmentThreatening: Bool
            let violence: Bool
            
            private enum CodingKeys: String, CodingKey {
                case sexual
                case hate
                case harassment
                case selfHarm = "self-harm"
                case sexualMinors = "sexual/minors"
                case hateThreatening = "hate/threatening"
                case violenceGraphic = "violence/graphic"
                case selfHarmIntent = "self-harm/intent"
                case selfHarmInstructions = "self-harm/instructions"
                case harassmentThreatening = "harassment/threatening"
                case violence
            }
        }
        
        struct CategoryScores: Codable {
            let sexual: Double
            let hate: Double
            let harassment: Double
            let selfHarm: Double
            let sexualMinors: Double
            let hateThreatening: Double
            let violenceGraphic: Double
            let selfHarmIntent: Double
            let selfHarmInstructions: Double
            let harassmentThreatening: Double
            let violence: Double
            
            private enum CodingKeys: String, CodingKey {
                case sexual
                case hate
                case harassment
                case selfHarm = "self-harm"
                case sexualMinors = "sexual/minors"
                case hateThreatening = "hate/threatening"
                case violenceGraphic = "violence/graphic"
                case selfHarmIntent = "self-harm/intent"
                case selfHarmInstructions = "self-harm/instructions"
                case harassmentThreatening = "harassment/threatening"
                case violence
            }
        }
        
        let categories: Category
        let categoryScores: CategoryScores
        let flagged: Bool
        
        private enum CodingKeys: String, CodingKey {
            case categories
            case categoryScores = "category_scores"
            case flagged
        }
    }
    
    let id: String?
    let model: String?
    let results: [ModerationResult]
    
    
    var hasIssues: Bool {
        return results.map(\.flagged).contains(true)
    }
}
