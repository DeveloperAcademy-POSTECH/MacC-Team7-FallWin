//
//  ChatGPTApiManager.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/17/23.
//

import Foundation

final class ChatGPTApiManager {
    static let shared = ChatGPTApiManager()
    let sessionID = UUID().uuidString
    
    private init() {}
}

extension ChatGPTApiManager {
    
    func generatePromptForChat(_ prompt: String) -> String {
        let template: String = """
        <<YOUR ROLE>>
        DALL-E 2 prompt engineer

        <<GOAL>>
        1) Making appropriate prompt to get image that describe input text
        2) Making the image like masterpiece in gallery

        <<INPUT TEXT>>
        "\(prompt)"

        Make prompt for Dall-E2 image generator referring to <<YOUR ROLE>>, <<GOAL>>, <<INPUT TEXT>>.
        Generated image must consists of only image.
        The output must be simple and brief and must contain keywords in input text.
        Output must be english prompt without other text.
        Output must be between <<PROMPT>> and <</PROMPT>>
        """
        
        return template
    }
    
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
    
    func createChat(withPrompt prompt: String, apiKey: String) async throws -> ChatCreationResponse {
        guard try await validatePrompt(generatePromptForChat(prompt), apiKey: apiKey) else {
            print("----------------Invalid Prompt----------------")
            throw ImageError.invalidPrompt
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("------------------bad URL------------------")
            throw ImageError.badURL
        }
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
//                [
//                    "role": "system",
//                    "content": "You are Dall-E version 2 prompt engineer."
//                ],
                [
                    "role": "user",
                    "content": generatePromptForChat(prompt)
                ]
            ]
        ]
        
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        print("response: \(response)")
        let result = try JSONDecoder().decode(ChatCreationResponse.self, from: responseData)
        
        return result
    }
    
    struct ChatCreationResponse: Codable {
        struct Choice: Codable {
            struct Message: Codable {
                let role: String
                let content: String
            }
            
            let index: Int
            let message: Message
            let finishReason: String
            
            private enum CodingKeys: String, CodingKey {
                case index
                case message
                case finishReason = "finish_reason"
            }
        }
        
        struct Usage: Codable {
            let promptTokens: Int
            let completionTokens: Int
            let totalTokens: Int
            
            private enum CodingKeys: String, CodingKey {
                case promptTokens = "prompt_tokens"
                case completionTokens = "completion_tokens"
                case totalTokens = "total_tokens"
            }
        }
        
        let id: String
        let object: String
        let created: Int
        let model: String
        let choices: [Choice]
        let usage: Usage
    }
}
