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
        <<INPUT TEXT>>

        "\(prompt)"

        <</INPUT TEXT>>

        <<FORM>>

        - Subject
        - Subject pose or action
        - Setting
        - Background Imagery
        - Mood
        - Time of day
        - Artist's Style

        <</FORM>>

        <<EXAMPLES>>
        <<BEST EXAMPLE 1>>

        INPUT TEXT: 오늘은 하루 종일 대학교에서 보냈어. 아침에 일어나서 바쁜 아침을 시작했어. 강의에 늦지 않으려고 서둘러 간단한 아침 식사를 하고, 학교로 출발했어. 강의 중에는 교수님의 열정적인 강의를 듣는 동안 재미있게 시간을 보낼 수 있었어.
        
        점심 시간에는 친구들과 함께 학식에서 맛있는 음식을 먹었어. 얘기를 나누면서 편안한 시간을 보낼 수 있어서 기분이 좋았어.

        오후에는 도서관에서 과제를 마무리하려고 열심히 공부했어. 공부하는 동안 몇몇 어려운 문제에 부딪쳐서 고민하다가, 친구한테 도움을 청하니 함께 공부하면서 문제를 해결할 수 있었어.

        저녁에는 동아리 모임이 있어서 함께 활동했어. 동아리 멤버들과 함께 프로젝트를 진행하는 것은 항상 즐거워.

        오늘은 하루 종일 바쁘게 보냈지만, 즐거운 순간들이 많았어. 항상 내 곁에 있는 친구들과 함께 시간을 보내는 것이 얼마나 소중한 지 깨달았어. 내일도 더 행복한 순간들이 가득하기를 기대해봐야겠다.

        RESULT:

        - Subject: Daily life in University
        - Subject pose or action: University, breakfast, lectures, learning with friends, studying assignments in the library, club meetings
        - Setting: University Campus
        - Background Imagery: Inside the University and library
        - mood: Positive, Happy
        - time of day: From Morning to Evening

        <</BEST EXAMPLE 1>>
        
        <<BEST EXAMPLE 2>>

        INPUT TEXT: 바쁘지만 내가 좋아하는 일들로 채운 하루. 가벼운 브런치, 햇살 뜨거운 바닷가에서의 오후. 저녁엔 술 한잔과 좋아하는 사람들. 모닥불 앞에서 나눈 대화.
        
        별이 쏟아지는 밤하늘은 덤이었지. 가끔 너무 정신 없는 나머지 내가 진실로 원하던 일들이 무엇이었는지 잊곤 해. 그 사실을 일꺠워주는 하루였어.

        RESULT:

        - Subject: Special Day in Beach
        - Subject pose or action: brunch, afternoon, beach, sunshine, talking with friends, a bottle of drink, lovely people, campfire, conversation, comtemplation
        - Setting: Sunshine Beach, Starry Night
        - Background Imagery: Beach and Horizon
        - mood: Peaceful, Sentimental, Calm
        - time of day: From Morning to Night

        <</BEST EXAMPLE 2>>
        
        <<BEST EXAMPLE 3>>

        INPUT TEXT: 할 일이 많아 하루종일 까페에 있던 날이었다. 내가 먹은 커피만 몇 잔인지. 정신없이 일할 땐 정말 우울하기만 했는데 끝내고 나니 문득 감성적이게 되더라고.
        
        밖은 어느새 어두워져서 조명이 별처럼 빛났고 커피 때문인지, 문득 찾아온 정적 떄문인지 머릿속은 온갖 감상들이 뒤섞였어.

        RESULT:

        - Subject: Busy time at the cafe
        - Subject pose or action: working, sitting, chair, table, cafe, coffe, thinking, light
        - Setting: Cafe
        - Background Imagery: Cafe
        - mood: Passionate, Sentimental
        - time of day: From Afternoon to Night

        <</BEST EXAMPLE 3>>
        <</EXAMPLES>>

        Make prompt for Dall-E 2 image generator referring to <<INPUT TEXT>>, <<FORM>> and <<EXAMPLES>>.

        The output must be simple and brief. The output must contain the context and meaning of the input text. The output must be english prompt.
        """
        
        return template
    }
    
    func generatePromptForChat2(_ prompt: String, emotion: String, drawingStyle: String) -> String {
        let template: String = """
        Make comma seperated english prompt(keyword#1, keyword#2, keyword#3, ..., keyword#n, <<MOOD>>, [[<<DRAWING STYLE>>]]) for AI Image generator referring to below <<INPUT TEXT>>, <<MOOD>>, <<DRAWING STYLE>>.

        The output must be 'english' prompt.
        The output must be simple and brief.
        The output must be comma seperated.
        The output must contain the context and meaning of <<INPUT TEXT>>.
        The drawing style mush be in double brackets.
        
        <<INPUT TEXT>>
        \(prompt)
        <</INPUT TEXT>>
        
        <<MOOD>>
        \(emotion)
        <</MOOD>>
        
        <<DRAWING STYLE>>
        \(drawingStyle)
        <</DRAWING STYLE>>
        """
        
        return template
    }

    func generatePromptForChat3(_ prompt: String) -> String {
//        let template: String = """
//        Make comma seperated english noun phrases(noun phrase #1, noun phrase #2, noun phrase #3, ..., noun phrase #n) that can be drawn referring to below <<INPUT TEXT>>.
//
//        The noun phrases must be 'english'.
//        The noun phrases must be 'comma seperated'.
//        Each element must be 'noun phrase'.
//        
//        The noun phrases must contain the context of <<INPUT TEXT>>.
//        The noun phrases must be condensed into a few noun phrases that are key to the <<INPUT TEXT>>. Some phrases can be removed.
//        The noun phrases can be modified, such as adding modifiers or changing words to be related to each other.
//        
//        <<INPUT TEXT>>
//        \(prompt)
//        <</INPUT TEXT>>
//        """
        
        let template: String = """
        Make one to three drawable noun phrases that best express most important subjects of smooth english translation of <<INPUT TEXT>>.

        The output must be only comma seperated noun phrases.
        The output must contain upto three noun phrases.
        The output must be english.
        Each noun phrase should contain enough modifiers.
        If they are all noun phrase containing only emotion, convert the phrase into representative object.
        
        <<INPUT TEXT>>
        \(prompt)
        <</INPUT TEXT>>
        """
        
        return template
    }

    func generatePromptForChat4(_ prompt: String) -> String {
        let template: String = """
        Make noun phrases that best express smooth english translation of <<INPUT TEXT>> very well.

        The output must be only comma seperated noun phrases.
        The output must be english.
        Each noun phrase should contain enough modifiers(like pose, action, perspective).
        
        <<INPUT TEXT>>
        \(prompt)
        <</INPUT TEXT>>
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
    
    func createChat2(prompt: String, emotion: String, drawingStyle: String, apiKey: String) async throws -> ChatCreationResponse {
        guard try await validatePrompt(generatePromptForChat2(prompt, emotion: emotion, drawingStyle: drawingStyle), apiKey: apiKey) else {
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
                    "content": generatePromptForChat2(prompt, emotion: emotion, drawingStyle: drawingStyle)
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
    
    func createChat3(prompt: String, apiKey: String) async throws -> ChatCreationResponse {
        let output = generatePromptForChat3(prompt)
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
//                [
//                    "role": "system",
//                    "content": "Pick some noun phrases that can be drawn."
//                ],
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
