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
    @Environment(\.dismiss) var dismiss
    @State var isError = false
    let store: StoreOf<GeneratedDiaryFeature>
    @ObservedObject var viewStore: ViewStoreOf<GeneratedDiaryFeature>
    private let dallEAPIKey: String = Bundle.main.dallEAPIKey
    private let karloAPIKey: String = Bundle.main.karloAPIKey
    
    let drawingStyleToEnglish: [String: String] = [
        "Childlike crayon": "babyish Poor detailed Oil pastel rough doodle",
        "Oil Painting": "Oil painting, Varnish",
        "Water Color": "Watercolor Painting, gouache",
        "Sketch": "Poor detailed simple pencil sketch",
        "Anime": "Studio Ghibli's enchanting and whimsical animation reflecting Studio Ghibli's animated features painting",
        "Pixel Art": "Retro-styled pixel-by-pixel non-alphabet video game graphics Style",
        "Vincent Van Gogh": "Vibrant and bold impressionist art inspired by Vincent Van Gogh Painting",
        "Monet": "Impressionism art in the style of Claude Monet Painting",
        "Salvador Dali": "Dream-like and bizarre surreal art in the style of Salvador Dali Painting"
    ]
    
    let emotionToEnglish: [String: String] = [
        "happy": "POSITIVE",
        "proud": "POSITIVE",
        "touched": "POSITIVE",
        "annoyed": "NEGATIVE",
        "sad": "NEGATIVE",
        
        "suffocated": "NEGATIVE",
        "lazy": "NEUTRAL",
        "grateful": "POSITIVE",
        "joyful": "POSITIVE",
        "exciting": "POSITIVE",
        
        "nervous": "NEGATIVE",
        "lonely": "NEGATIVE",
        "shy": "NEUTRAL",
        "frustrated": "NEUTRAL",
        "tough": "NEGATIVE",
        
        "peaceful": "POSITIVE",
        "surprised": "NEUTRAL",
        "reassuring": "POSITIVE"
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
                            MessageView(titleText: "generated_title".localized)
                                .padding(.top, 40)
                            imageView()
                                .padding(.top, 16)
                                .padding(.horizontal, 8)
                            Button {
                                Tracking.logEvent(Tracking.Event.A2_5_4__일기작성_그림선택_일기마무리버튼.rawValue)
                                print("@Log : A2_5_4__일기작성_그림선택_일기마무리버튼")
                                //                                print(ChatGPTApiManager)
                                print("--parameters: \(viewStore.priorSteps), \(viewStore.priorScale), \(viewStore.steps), \(viewStore.scale)--")
                                viewStore.send(.doneGenerating)
                            } label: {
                                ConfirmButtonLabelView(text: "generated_finish_button".localized, backgroundColor: viewStore.image == nil ? Color.buttonDisabled : Color.button, foregroundColor: .textOnButton)
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
                .safeToolbar {
                    ToolbarItem(placement: .principal) {
                        DateView(pickedDateTagValue: viewStore.binding(get: \.pickedDateTagValue, send: GeneratedDiaryFeature.Action.pickDate))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Tracking.logEvent(Tracking.Event.A2_5_2__일기작성_그림선택_닫기.rawValue)
                            print("@Log : A2_5_2__일기작성_그림선택_닫기")
                            viewStore.send(.cancelWriting)
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
                        Text("generated_generating".localized.replacingOccurrences(of: "{nickname}", with: UserDefaults.standard.string(forKey: UserDefaultsKey.User.nickname) ?? "PICDA"))
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
                let chatResponse = try await ChatGPTApiManager.shared.createChat3(prompt: viewStore.mainText,  apiKey: dallEAPIKey)
                
                var image: UIImage?
                
                if let promptOutput = chatResponse.choices.map(\.message.content).first {
                    print("--chatGPT response is not null--")
                    let karloPrompt = KarloApiManager.shared.addEmotionDrawingStyle(prompt: promptOutput, emotion: emotionToEnglish[viewStore.selectedEmotion] ?? "", drawingStyle: drawingStyleToEnglish[viewStore.selectedDrawingStyle] ?? "")
                    print("original input text:\n\(viewStore.mainText)\n------\nchatGPT's output:\n\(promptOutput)\n------\nprompt with drawing style:\n\(karloPrompt)")
                    
                    let imageResponse = try await KarloApiManager.shared.generateImage(prompt: karloPrompt, negativePrompt: "text, alphabet, child, crayon, realistic photo, ugly, poorly drawn face, nsfw, error, extra digit, fewer digit, cropped, worst quality, low quality, signature, watermark, username, scary, dirty, poorly drawn feet, poorly drawn hand, mutilated, disfigured", priorSteps: viewStore.priorSteps, priorScale: viewStore.priorScale, steps: viewStore.steps, scale: viewStore.scale, apiKey: karloAPIKey)
                    
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
                    FilmManager.shared.reduceCount()
                    viewStore.send(.setImages(images))
                    
                } else {
                    print("--chatGPT response is null--")
                    let imageResponse = try await KarloApiManager.shared.generateImage(prompt: viewStore.mainText, negativePrompt: "text, alphabet, child, crayon, realistic photo, ugly, poorly drawn face, nsfw, error, extra digit, fewer digit, cropped, worst quality, low quality, signature, watermark, username, scary, dirty, poorly drawn feet, poorly drawn hand, mutilated, disfigured", priorSteps: viewStore.priorSteps, priorScale: viewStore.priorScale, steps: viewStore.steps, scale: viewStore.scale, apiKey: karloAPIKey)
                    
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
                }
            } catch {
                print(error)
                isError.toggle()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .alert(isPresented: $isError, title: "generated_fail_alert_title".localized) {
            Text("generated_fail_alert_message".localized)
        } primaryButton: {
            OhwaAlertButton(label: Text("confirm").foregroundColor(.textOnButton), color: .button) {
                isError.toggle()
                dismiss()
            }
        }

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
                .padding(.top, 4)
                .padding(.bottom, 40)
            }
            .padding(10)
            .background(
                Color.backgroundCard
                    .shadow(color: viewStore.image == image ? Color.shadow.opacity(0.2) : Color.shadow.opacity(0.1), radius: viewStore.image == image ?  8 : 4)
            )
        }
    }
}

