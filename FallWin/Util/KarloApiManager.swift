//
//  KarloApiManager.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/25/23.
//

import Foundation

final class KarloApiManager {
    static let shared = KarloApiManager()
    let sessionID = UUID().uuidString
    
    private init() {}
}

// MARK: - DallE
extension KarloApiManager {
    
    func validatePrompt(_ prompt: String, apiKey: String) async throws -> Bool {
        
        return false
    }
    
    func addEmotionDrawingStyle(prompt: String, emotion: String, drawingStyle: String) -> String {
        
        return prompt + (emotion == "" ? "" : ", \(emotion)") + (drawingStyle == "" ? "" : ", \(drawingStyle)")
    }
    
    func generateImage(prompt: String, negativePrompt: String, priorSteps: Double, priorScale: Double, steps: Double, scale: Double, apiKey: String) async throws  -> KarloImageGenerationResponse {
        
        guard let url = URL(string: "https://api.kakaobrain.com/v2/inference/karlo/t2i") else {
            print("------------------bad URL------------------")
            throw KarloImageError.badURL
        }
        print(Int(priorSteps), Int(steps))
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "negative_prompt": negativePrompt,
            "samples": 8,
            "prior_num_inference_steps": Int(priorSteps),
            "prior_guidance_scale": priorScale,
            "num_inference_steps": Int(steps),
            "guidance_scale": scale
        ]
        
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("KaKaoAK 2c6515b9fb1db8ba3875f3a3c6fba239", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = data
        
        print("Karlo request input : \(String(describing: request)), \(String(describing: request.httpBody))")
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        print("response: \(response)")
        let result = try JSONDecoder().decode(KarloImageGenerationResponse.self, from: responseData)
        
        return result
    }
}



struct KarloImageGenerationResponse: Codable {
    struct ImageResponse: Codable {
        let id: String
        let seed: Int
        let image: String
    }
    
    let id: String
    let modelVersion: String
    let images: [ImageResponse]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case modelVersion = "model_version"
        case images
    }
}

enum KarloImageError: Error {
    case invalidPrompt
    case badURL
}
