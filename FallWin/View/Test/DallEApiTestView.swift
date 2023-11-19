//
//  DallEApiTestView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/16/23.
//

//import SwiftUI
//
//struct DallEApiTestView: View {
//    @State private var promptInput: String = ""
//    @State private var image: UIImage? = nil
//    @State private var isThereSomethingWrong: Bool = false
//    @State private var promptOutput: String = ""
//    @State private var drawingStyle: String = ""
//    @State private var emotion: String = ""
//    @State private var dallEInputPrompt: String = ""
//    private var apiKey: String = Bundle.main.dallEAPIKey
//    
//    var body: some View {
//        VStack(alignment: .leading){
//            TextField("프롬프트를 입력하세요.", text: $promptInput)
//                .keyboardType(.default)
//            //                .textFieldStyle(.roundedBorder)
//                .textInputAutocapitalization(.never)
//                .disableAutocorrection(true)
//                .border(Color.black)
//            Spacer()
//                .frame(height: 20)
//            TextField("화풍을 입력하세요. (영어)", text: $drawingStyle)
//                .keyboardType(.default)
//                .textInputAutocapitalization(.never)
//                .disableAutocorrection(true)
//                .border(Color.black)
//            Spacer()
//                .frame(height: 20)
//            TextField("감정을 입력하세요. (영어)", text: $emotion)
//                .keyboardType(.default)
//                .textInputAutocapitalization(.never)
//                .disableAutocorrection(true)
//                .border(Color.black)
//            
//            Button("이미지 생성") {
//                Task {
//                    do {
//                        print(apiKey)
//                        let chatResponse = try await ChatGPTApiManager.shared.createChat(withPrompt: promptInput, apiKey: apiKey)
//                        
//                        if let promptOutput = chatResponse.choices.map(\.message.content).first {
//                            let dallEPrompt = DallEApiManager.shared.addDrawingStyle(withPrompt: promptOutput, drawingStyle: drawingStyle, emotion: emotion)
//                            print("chatGPT's output: \(promptOutput)\nprompt with drawing style: \(dallEPrompt)")
//                            dallEInputPrompt = dallEPrompt
//                            let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: dallEPrompt, apiKey: apiKey)
//                            
//                            if let url = imageResponse.data.map(\.url).first {
//                                guard let url = URL(string: url) else {
//                                    isThereSomethingWrong = true
//                                    return
//                                }
//                                let (data, _) = try await URLSession.shared.data(from: url)
//                                image = UIImage(data: data)
//                                isThereSomethingWrong = false
//                            }
//                        } else {
//                            let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: promptInput, apiKey: apiKey)
//                            
//                            if let url = imageResponse.data.map(\.url).first {
//                                guard let url = URL(string: url) else {
//                                    isThereSomethingWrong = true
//                                    return
//                                }
//                                let (data, _) = try await URLSession.shared.data(from: url)
//                                image = UIImage(data: data)
//                                isThereSomethingWrong = false
//                            }
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            .buttonStyle(.borderedProminent)
//            
//            if let image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 256, height: 256)
//            } else {
//                Rectangle()
//                    .fill(Color.gray)
//                    .frame(width: 256, height: 256)
//                    .overlay {
//                        if isThereSomethingWrong {
//                            Text("Something wrong!")
//                        } else {
//                            VStack {
//                                ProgressView()
//                                Text("loading...")
//                            }
//                        }
//                    }
//            }
//            
//            Text("Dall-E에 들어간 프롬프트:\n\(dallEInputPrompt ?? "(Error)")")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    DallEApiTestView()
//}
