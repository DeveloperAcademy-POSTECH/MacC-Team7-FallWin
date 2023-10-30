//
//  GeneratedDiaryView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct GeneratedDiaryView: View {
    let store: StoreOf<GeneratedDiaryFeature>
    @ObservedObject var viewStore: ViewStoreOf<GeneratedDiaryFeature>
    private let apiKey: String = Bundle.main.apiKey
    
    let drawingStyleToEnglish: [String: String] = [
        "크레용": "Childlike crayon",
        "스케치": "Sketch, Croquis, Black and White",
        "동화": "Children's illustration",
        "수채화": "Water color",
        "디지털 아트": "Digital art",
        "네온": "Neon",
        "반 고흐": "Vincent Van Gogh",
        "살바도르 달리": "Salvador Dali"
    ]
    
    let emotionToEnglish: [String: String] = [
        "happy": "Happy",
        "nervous": "Nervous",
        "grateful": "Grateful",
        "sad": "Sad",
        "joyful": "Joyful",
        "lonely": "Lonely",
        "proud": "Proud",
        "suffocated": "Suffocated",
        "touched": "Touched",
        "shy": "Shy",
        "exciting": "Exciting",
        "lazy": "Lazy",
        "annoyed": "Annoyed",
        "frustrated": "Frustrated"
    ]
    
    init(store: StoreOf<GeneratedDiaryFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    
    var body: some View {
        ZStack {
            if viewStore.imageSet.count > 0 {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 32) {
                            ForEach(viewStore.imageSet, id: \.self) { image in
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture {
                                            if viewStore.image == image {
                                                viewStore.send(.setImage(nil))
                                            } else {
                                                viewStore.send(.setImage(image))
                                            }
                                        }
                                } else {
                                    Color.white
                                        .scaledToFit()
                                }
                            }
                            
                            //                        ForEach(images, id: \.0) { image in
                            //                            Image(UIImage(data: URL(string: image)))
                            //                                .onTapGesture {
                            //                                    if viewStore.image == image {
                            //                                        viewStore.send(.setImage(nil))
                            //                                    } else {
                            //                                        viewStore.send(.setImage(image))
                            //                                    }
                            //                                }
                            //                        }
                        }
                        .padding()
                        .padding(.bottom, 32)
                    }
                    Button {
                        viewStore.send(.doneGenerating)
                    } label: {
                        HStack {
                            Spacer()
                            Text("다음")
                                .font(.pretendard(.semiBold, size: 18))
                            Spacer()
                        }
                        .padding()
                        .background(viewStore.image == nil ? Color.buttonDisabled : Color.button)
                        .cornerRadius(9)
                        .foregroundColor(Color.white)
                    }
                    .disabled(viewStore.image == nil)
                    .padding(.top, 15)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    .background{
                        Color.backgroundPrimary
                            .ignoresSafeArea()
                            .shadow(color: Color(hexCode: "#191919").opacity(0.05), radius: 4, y: -2)
                    }
                }
                //                    Image(uiImage: image)
                //                        .onAppear {
                //                            viewStore.send(.doneGenerating)
                //                        }
            } else {
                ZStack {
                    LottieImageGenView(jsonName: "LottieImageGen")
                    VStack {
                        Spacer()
                        Text("폴윈의 하루를\n그림으로 그리고 있어요")
                            .font(.pretendard(.bold, size: 28))
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
            }
            
        }
        .task {
            do {
                print(apiKey)
                print("input to chatGPT: \(ChatGPTApiManager.shared.generatePromptForChat2(viewStore.mainText, emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "", drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? ""))")
                let chatResponse = try await ChatGPTApiManager.shared.createChat2(prompt: viewStore.mainText, emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "", drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? "", apiKey: apiKey)
                
                var image: UIImage?
                //                    if let promptOutput = chatResponse.choices.map(\.message.content).first {
                //                        let dallEPrompt = DallEApiManager.shared.addDrawingStyle(withPrompt: promptOutput, drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? "", emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "")
                //                        print("original input text:\n\(viewStore.mainText)\nchatGPT's output:\n\(promptOutput)\nprompt with drawing style:\n\(dallEPrompt)")
                //                        let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: dallEPrompt, apiKey: apiKey)
                //
                //                        if let url = imageResponse.data.map(\.url).first {
                //                            guard let url = URL(string: url) else {
                //                                return
                //                            }
                //                            let (data, _) = try await URLSession.shared.data(from: url)
                //                            image = UIImage(data: data)
                //                        }
                //                    } else {
                //                        let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: viewStore.mainText, apiKey: apiKey)
                //
                //                        if let url = imageResponse.data.map(\.url).first {
                //                            guard let url = URL(string: url) else {
                //                                return
                //                            }
                //                            let (data, _) = try await URLSession.shared.data(from: url)
                //                            image = UIImage(data: data)
                //                        }
                //                    }
                
                if let promptOutput = chatResponse.choices.map(\.message.content).first {
                    let karloPrompt = KarloApiManager.shared.addDrawingStyle(withPrompt: promptOutput, drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? "", emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "")
                    print("original input text:\n\(viewStore.mainText)\n------\nchatGPT's output:\n\(promptOutput)\n------\nprompt with drawing style:\n\(karloPrompt)")
                    let imageResponse = try await KarloApiManager.shared.generateImage(prompt: promptOutput, negativePrompt: "scary, dirty, ugly, text, letter, poorly drawn face, side face, poorly drawn feet, poorly drawn hand, divided, framed, cross line", apiKey: apiKey)
                    
//                    if let url = imageResponse.images.map(\.image).first {
//                        guard let url = URL(string: url) else {
//                            return
//                        }
//                        let (data, _) = try await URLSession.shared.data(from: url)
//                        image = UIImage(data: data)
//                        viewStore.send(.setImages([image]))
//                    }
                    var images: [UIImage?] = []
                    for imageOutput in imageResponse.images {
                        let imageString = imageOutput.image
                        guard let imageURL = URL(string: imageString) else {
                            print("imageURL something wrong")
                            return
                        }
                        print("imageURL: \(imageURL)")
                        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
                        images.append(UIImage(data: imageData))
                    }
//                    guard let imageURLs = imageResponse.images.map( URL(string: $0.image) ) else {
//                        return
//                    }
//                    let imageDatas = try await imageURLs.map( URLSession.shared.data(from: $0).0 )
//                    let images = imageDatas.map( UIImage(data: $0) )
                    viewStore.send(.setImages(images))
                    
                } else {
                    let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: viewStore.mainText, apiKey: apiKey)
                    
                    if let url = imageResponse.data.map(\.url).first {
                        guard let url = URL(string: url) else {
                            return
                        }
                        let (data, _) = try await URLSession.shared.data(from: url)
                        image = UIImage(data: data)
                        viewStore.send(.setImages([image]))
                    }
                }
                
                //                    if let image = image {
                //                        viewStore.send(.setImage(image))
                //                    }
            } catch {
                print(error)
            }
        }
        
    }
    
    @ViewBuilder
    func generateDiaryView() -> some View {
        //        VStack {
        //            Image
        //        }
    }
}

//#Preview {
//    GeneratedDiaryView()
//}
