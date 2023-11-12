//
//  GeneratedDiaryView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import SwiftUI
import UIKit
import ComposableArchitecture
import FirebaseAnalytics

struct GeneratedDiaryView: View {
    let store: StoreOf<GeneratedDiaryFeature>
    @ObservedObject var viewStore: ViewStoreOf<GeneratedDiaryFeature>
    private let dallEAPIKey: String = Bundle.main.dallEAPIKey
    private let karloAPIKey: String = Bundle.main.karloAPIKey
    
    let drawingStyleToEnglish: [String: String] = [
        "oilPainting": "oil painting",
        "sketch": "sketch, black and white",
        "renoir": "painting of Renoir",
        "noDrawingStyle": "",
        "chagall": "modernism, painting of Chagall",
        "anime": "anime",
        "vanGogh": "impressionism, painting of Van Gogh",
        "kandinsky": "painting of Kandinsky",
        "gauguin": "painting of Gauguin",
        "picasso": "painting of Picasso",
        "rembrandt": "painting of Rembrandt",
        "henriRousseau": "painting of Henri Rousseau",
        "henriMatisse": "painting of Henri Matisse",
        "egonSchiele": "painting of Egon Schiele",
        "webtoon": "webtoon",
        "dcComics": "DC comics",
        "ghibli": "studio Ghibli",
        "film": "film Stills",
        "illustration": "children's book illustration",
        "cg": "extremely detailed CG unity 8k wallpaper"
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
                    ZStack {
                        Color.backgroundPrimary
                            .ignoresSafeArea()
                        VStack(spacing: 0) {
//                            DateView()
                            MessageView(titleText: "하루와 가장 잘 어울리는 그림을 선택하세요")
                                .padding(.top, 40)
                            imageView()
                                .padding(.top, 16)
                                .padding(.horizontal)
                            Button {
                                viewStore.send(.doneGenerating)
                                Tracking.logEvent(Tracking.Event.A2_5_4__일기작성_그림선택_일기마무리버튼.rawValue)
                                print("@Log : A2_5_4__일기작성_그림선택_일기마무리버튼")
                            } label: {
                                ConfirmButtonLabelView(text: "일기 마무리하기", backgroundColor: viewStore.image == nil ? Color.buttonDisabled : Color.button, foregroundColor: .textOnButton)
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
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        DateView()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewStore.send(.cancelWriting)
                            Tracking.logEvent(Tracking.Event.A2_5_2__일기작성_그림선택_닫기.rawValue)
                            print("@Log : A2_5_2__일기작성_그림선택_닫기")
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    Tracking.logScreenView(screenName: Tracking.Screen.V2_5__일기작성_결과선택뷰.rawValue)
                    print("@Log : wrtingSelectEmotionView")
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
                .onAppear {
                    Tracking.logScreenView(screenName: Tracking.Screen.V2_4__일기작성_대기뷰.rawValue)
                    print("@Log : wrtingSelectEmotionView")
                   }
                
            }
            
        }
        .task {
            do {
                print(dallEAPIKey)
                let chatResponse = try await ChatGPTApiManager.shared.createChat3(prompt: viewStore.mainText,  apiKey: dallEAPIKey)
                
                var image: UIImage?
                
                if let promptOutput = chatResponse.choices.map(\.message.content).first {
                    let karloPrompt = KarloApiManager.shared.addEmotionDrawingStyle(prompt: promptOutput, emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "", drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? "")
                    print("original input text:\n\(viewStore.mainText)\n------\nchatGPT's output:\n\(promptOutput)\n------\nprompt with drawing style:\n\(karloPrompt)")
                    
                    let imageResponse = try await KarloApiManager.shared.generateImage(prompt: karloPrompt, negativePrompt: "scary, dirty, ugly, text, letter, alphabet, signature, watermark, text-like, letter-like, alphabet-like, poorly drawn face, side face, poorly drawn feet, poorly drawn hand, divided, framed, cross line", priorSteps: viewStore.priorSteps, priorScale: viewStore.priorScale, steps: viewStore.steps, scale: viewStore.scale, apiKey: karloAPIKey)
                    
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
                    let imageResponse = try await DallEApiManager.shared.generateImage(withPrompt: viewStore.mainText, apiKey: dallEAPIKey)
                    
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func imageView() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 32) {
                    ForEach(viewStore.imageSet, id: \.self) { image in
                        imageCardView(image: image)
                            .opacity((viewStore.image == nil || viewStore.image == image) ? 1 : 0.5)
                            .onTapGesture {
                                if viewStore.image == image {
                                    viewStore.send(.setImage(nil))
                                } else {
                                    viewStore.send(.setImage(image))
                                }
                            }
                    }
                }
                .padding()
                .padding(.bottom, 32)
            }
        }
    }
    
    @ViewBuilder
    func imageCardView(image: UIImage?) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Color.white
                            .scaledToFit()
                    }
                }
                .padding(.bottom, 30)
            }
            .padding()
            .background(
                Color.backgroundCard
                    .shadow(color: viewStore.image == image ? Color(hexCode: "#191919").opacity(0.2) : Color(hexCode: "#191919").opacity(0.1), radius: viewStore.image == image ?  8 : 4)
            )
        }
    }
}

//#Preview {
//    GeneratedDiaryView()
//}
