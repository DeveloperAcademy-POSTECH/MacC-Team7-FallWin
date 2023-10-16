//
//  ApiManager.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/16/23.
//

import Foundation

final class DallEApiManager {
    static let shared = DallEApiManager()
    let sessionID = UUID().uuidString
    
    private init() {}
}

// MARK: - DallE
extension DallEApiManager {
    
    func validatePrompt(_ prompt: String, apiKey: String) async throws -> Bool {
        guard let url = URL(string: "https://api.openai.com/v1/moderations") else {
            print("------------------bad URL------------------")
            throw ImageError.badURL
        }
        
        let parameters: [String: Any] = [
            "input": prompt
        ]
        
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        print("response : \(response)")
        
        let result = try JSONDecoder().decode(ModerationResponse.self, from: responseData)
        
        return result.hasIssues == false
    }
    
    func generateImage(withPrompt prompt: String, apiKey: String) async throws  -> ImageGenerationResponse {
        guard try await validatePrompt(prompt, apiKey: apiKey) else {
            print("----------------Invalid Prompt----------------")
            throw ImageError.invalidPrompt
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            print("------------------bad URL------------------")
            throw ImageError.badURL
        }
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": "256x256",
            "user": sessionID
        ]
        
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        print("response: \(response)")
        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: responseData)
        
        return result
    }
}

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

struct ImageGenerationResponse: Codable {
    struct ImageResponse: Codable {
        let url: String
    }
    
    let created: Int
    let data: [ImageResponse]
}

enum ImageError: Error {
    case invalidPrompt
    case badURL
}

