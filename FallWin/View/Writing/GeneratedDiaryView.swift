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
    private let apiKey: String = Bundle.main.apiKey
    
    let drawingStyleToEnglish: [String: String] = [
        "크레용": "Childlike crayon",
        "스케치": "Sketch",
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

    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                if let image = viewStore.image {
                    Image(uiImage: image)
                        .onAppear {
                            viewStore.send(.doneGenerating)
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
                    let chatResponse = try await ChatGPTApiManager.shared.createChat(withPrompt: viewStore.mainText, apiKey: apiKey)
                    
                    var image: UIImage?
                    if let promptOutput = chatResponse.choices.map(\.message.content).first {
                        let dallEPrompt = DallEApiManager.shared.addDrawingStyle(withPrompt: promptOutput, drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? "", emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "")
                        print("original input text:\n\(viewStore.mainText)\nchatGPT's output:\n\(promptOutput)\nprompt with drawing style:\n\(dallEPrompt)")
                        let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: dallEPrompt, apiKey: apiKey)
                        
                        if let url = imageResponse.data.map(\.url).first {
                            guard let url = URL(string: url) else {
                                return
                            }
                            let (data, _) = try await URLSession.shared.data(from: url)
                            image = UIImage(data: data)
                        }
                    } else {
                        let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: viewStore.mainText, apiKey: apiKey)
                        
                        if let url = imageResponse.data.map(\.url).first {
                            guard let url = URL(string: url) else {
                                return
                            }
                            let (data, _) = try await URLSession.shared.data(from: url)
                            image = UIImage(data: data)
                        }
                    }
                    
                    if let image = image {
                        viewStore.send(.setImage(image))
                    }
                } catch {
                    print(error)
                }
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
