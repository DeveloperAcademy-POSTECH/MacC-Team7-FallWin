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
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Text("기댜려")
                
                if let image = viewStore.image {
                    Image(uiImage: image)
                        .onAppear {
                            viewStore.send(.doneGenerating)
                        }
                }
                
            }
            .task {
                do {
                    print(apiKey)
                    let chatResponse = try await ChatGPTApiManager.shared.createChat(withPrompt: viewStore.mainText, apiKey: apiKey)
                    
                    var image: UIImage?
                    if let promptOutput = chatResponse.choices.map(\.message.content).first {
                        let dallEPrompt = DallEApiManager.shared.addDrawingStyle(withPrompt: promptOutput, drawingStyle: viewStore.selectedDrawingStyle)
                        print("original input text: \(viewStore.mainText)\nchatGPT's output: \(promptOutput)\nprompt with drawing style: \(dallEPrompt)")
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
