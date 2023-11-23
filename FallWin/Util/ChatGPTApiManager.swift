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
    
    func generatePromptForChat3(_ prompt: String) -> String {
        print("<<'generatePromptyForChat3' in ChatGPTApiManager is called>>")
        let template: String = """
Let’s work this out in a step by step way to be sure we have the right answer.
1. Please summarize smooth english translation of <<\(prompt)>>
2. Limit your summary upto five english noun phrases.
3. Your summary should focus on tangible subjects, Including concrete, visual subjects such as a person, object, or location.
4. In cases where a clear object that can be depicted in a drawing is absent, such as emotions or concepts, let's arbitrarily choose a representative object that resonates universally. This chosen object should be widely relatable to the majority of people.
5. Your answer must be in the form of comma-separated noun phrases or words.
"""
        
        return template
    }
    
    
    func validatePrompt(_ prompt: String, apiKey: String) async throws -> Bool {
        print("<<'validatePrompt' in ChatGPTApiManager is called>>")
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
    
    func createChat3(prompt: String, apiKey: String) async throws -> ChatCreationResponse {
        print("<<'createChat3 in ChatGPTApiManager is called>>")
        let output = generatePromptForChat3(prompt)
//        let output = prompt
        guard try await validatePrompt(output, apiKey: apiKey) else {
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
                [
                    "role": "system",
                    "content": "Yours are ten different experts who pick the keywords in my diary. All experts will write down 1 step of their thinking, then share it with the group. Then all experts will go on to the next step, etc. If any expert realizes they're wrong at any point then they leave. If any one expert remains alone, the expert answer alone until last step. If they are at last step and two or more experts remain, they discuss about last step and pick the most probable answer."
                ],
                [
                    "role": "user",
                    "content": """
                    Let’s work this out in a step by step way to be sure we have the right answer.
                    1. Please summarize smooth english translation of <<할 일이 많아 하루종일 카페에 있던 날이었다. 내가 먹은 커피만 몇 잔인지. 정신없이 일할 땐 정말 우울하기만 했는데 끝내고 나니 문득 감성적이게 되더라고. 밖은 어느새 어두워져서 조명이 별처럼 빛났고 커피 때문인지, 문득 찾아온 정적 때문인지 머릿속은 온갖 감상들이 뒤섞였어.>>
                    2. Limit your summary upto five english noun phrases.
                    3. Your summary should focus on tangible subjects, Including concrete, visual subjects such as a person, object, or location.
                    4. In cases where a clear object that can be depicted in a drawing is absent, such as emotions or concepts, let's arbitrarily choose a representative object that resonates universally. This chosen object should be widely relatable to the majority of people.
                    5. Your answer must be in the form of comma-separated noun phrases or words.
"""
                ],
                [
                    "role": "assistant",
                    "content": "busy time at the cafe, drinking lots of coffee, lights shining like stars"
                ],
                [
                    "role": "user",
                    "content": """
                    Let’s work this out in a step by step way to be sure we have the right answer.
                    1. Please summarize smooth english translation of <<해야 할 일에 대해서는 이런저런 생각을 많이 했는데, 정작 내가 좋아하는 일에 대해서는 많이 생각해보지 않았다. 오늘 워크샵을 하면서 '나'에 대해 생각할 수 있는 시간을 갖게 되었고 그동안 외면했던 나 자신을 조금 더 돌아보게 되었다. 아마 평생을 계속 고민해야 할 일일 것이다. 다만 스스로를 돌아보는 시간이 필요하다는 것을 인지하기 시작했다는 것 자체가 중요한 것 같다. 내 인생은 어디로 어떻게 갈 수 있을까.>>
                    2. Limit your summary upto five english noun phrases.
                    3. Your summary should focus on tangible subjects, Including concrete, visual subjects such as a person, object, or location.
                    4. In cases where a clear object that can be depicted in a drawing is absent, such as emotions or concepts, let's arbitrarily choose a representative object that resonates universally. This chosen object should be widely relatable to the majority of people.
                    5. Your answer must be in the form of comma-separated noun phrases or words.
"""
                ],
                [
                    "role": "assistant",
                    "content": "what I truly love, today's workshop, lifelong pondering, importance of self-reflection recognition"
                ],
                [
                    "role": "user",
                    "content": """
                    Let’s work this out in a step by step way to be sure we have the right answer.
                    1. Please summarize smooth english translation of <<드디어 군고구마의 계절이 돌아왔다ㅠㅠ 붕어빵이랑 군고구마랑 다 사먹어야지ㅋㅋㅋㅋㅋㅋ 행복이 별거냐. 3000원의 행복이 여기 있다!>>
                    2. Limit your summary upto five english noun phrases.
                    3. Your summary should focus on tangible subjects, Including concrete, visual subjects such as a person, object, or location.
                    4. In cases where a clear object that can be depicted in a drawing is absent, such as emotions or concepts, let's arbitrarily choose a representative object that resonates universally. This chosen object should be widely relatable to the majority of people.
                    5. Your answer must be in the form of comma-separated noun phrases or words.
"""
                ],
                [
                    "role": "assistant",
                    "content": "fried sweet potatoes, fish-shaped pastry, The return of winter, happiness worth 3000 won, tears of joy"
                ],
                [
                    "role": "user",
                    "content": output
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
