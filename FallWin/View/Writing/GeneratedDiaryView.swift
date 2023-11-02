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
        "유화": "<<Oil painting>>",
        "스케치": "<<Sketch>>, <<Croquis>>, <<Black and White>>",
        "르누아르": "<<Renoir>>",
        "화풍 선택 안함": "",
        "샤갈": "Modernism, <<Chagall>>",
        "애니메이션": "<<Anime>>",
        "반 고흐": "Impressionism, <<Van Gogh>>",
        "칸딘스키": "<<Kandinsky>>"
    ]
    
    let emotionToEnglish: [String: String] = [
        "happy": "<<Happy>>",
        "nervous": "<<Nervous>>",
        "grateful": "<<Grateful>>",
        "sad": "<<Sad>>",
        "joyful": "<<Joyful>>",
        "lonely": "<<Lonely>>",
        "proud": "<<Proud>>",
        "suffocated": "<<Suffocated>>",
        "touched": "<<Touched>>",
        "shy": "<<Shy>>",
        "exciting": "<<Exciting>>",
        "lazy": "<<Lazy>>",
        "annoyed": "<<Annoyed>>",
        "frustrated": "<<Frustrated>>"
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
                                        .shadow(color: viewStore.image == image ? Color(hexCode: "#191919").opacity(0.2) : Color(hexCode: "#191919").opacity(0.1), radius: viewStore.image == image ?  8 : 4)
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
                let chatResponse = try await ChatGPTApiManager.shared.createChat3(prompt: viewStore.mainText,  apiKey: apiKey)
                
                var image: UIImage?
                
                if let promptOutput = chatResponse.choices.map(\.message.content).first {
                    let karloPrompt = KarloApiManager.shared.addEmotionDrawingStyle(prompt: promptOutput, emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "", drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? "")
                    print("original input text:\n\(viewStore.mainText)\n------\nchatGPT's output:\n\(promptOutput)\n------\nprompt with drawing style:\n\(karloPrompt)")
                    
                    let imageResponse = try await KarloApiManager.shared.generateImage(prompt: karloPrompt, negativePrompt: "scary, dirty, ugly, text, letter, alphabet, signature, watermark, text-like, letter-like, alphabet-like, poorly drawn face, side face, poorly drawn feet, poorly drawn hand, divided, framed, cross line", priorSteps: viewStore.priorSteps, priorScale: viewStore.priorScale, steps: viewStore.steps, scale: viewStore.scale, apiKey: apiKey)
                    
                    var images: [UIImage?] = []
                    for imageOutput in imageResponse.images {
                        let imageString = imageOutput.image
                        guard let imageURL = URL(string: imageString) else {
                            print("imageURL something wrong")
                            return
                        }
                        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
                        images.append(UIImage(data: imageData))
                    }
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
