//
//  DallEApiTestView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/16/23.
//

import SwiftUI

struct DallEApiTestView: View {
    @State private var promptInput: String = ""
    @State private var image: UIImage? = nil
    @State private var isThereSomethingWrong: Bool = false
    @State private var promptOutput: String = ""
    private var apiKey: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            TextField("프롬프트를 입력하세요.", text: $promptInput)
                .keyboardType(.default)
            //                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Button("이미지 생성") {
                Task {
                    do {
                        let chatResponse = try await ChatGPTApiManager.shared.createChat(withPrompt: promptInput, apiKey: apiKey)
                        
                        if let promptOutput = chatResponse.choices.map(\.message.content).first {
                            print(promptOutput)
                            let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: promptOutput, apiKey: apiKey)
                            
                            if let url = imageResponse.data.map(\.url).first {
                                guard let url = URL(string: url) else {
                                    isThereSomethingWrong = true
                                    return
                                }
                                let (data, _) = try await URLSession.shared.data(from: url)
                                image = UIImage(data: data)
                                isThereSomethingWrong = false
                            }
                        } else {
                            let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: promptInput, apiKey: apiKey)
                            
                            if let url = imageResponse.data.map(\.url).first {
                                guard let url = URL(string: url) else {
                                    isThereSomethingWrong = true
                                    return
                                }
                                let (data, _) = try await URLSession.shared.data(from: url)
                                image = UIImage(data: data)
                                isThereSomethingWrong = false
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 256, height: 256)
                    .overlay {
                        if isThereSomethingWrong {
                            Text("Something wrong!")
                        } else {
                            VStack {
                                ProgressView()
                                Text("loading...")
                            }
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    DallEApiTestView()
}
