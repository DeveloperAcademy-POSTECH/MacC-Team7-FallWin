//
//  GeneratedDiaryView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/22/23.
//

import SwiftUI
import ComposableArchitecture

struct GeneratedDiaryView: View {
    let store: StoreOf<GeneratedDiaryFeature>
    private let apiKey: String = Bundle.main.apiKey
    @State var image: UIImage? = nil
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Text("기댜려")
                
                if let image = image {
                    Image(uiImage: image)
                }
                
            }
            .task {
                do {
                    let chatResponse = try await ChatGPTApiManager.shared.createChat(withPrompt: viewStore.mainText, apiKey: apiKey)
                    
                    if let promptOutput = chatResponse.choices.map(\.message.content).first {
                        let dallEPrompt = DallEApiManager.shared.addDrawingStyle(withPrompt: promptOutput, drawingStyle: viewStore.selectedDrawingStyle)
                        print("chatGPT's output: \(promptOutput)\nprompt with drawing style: \(dallEPrompt)")
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
