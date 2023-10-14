//
//  DallETestView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/14/23.
//

import SwiftUI

struct DallETestView: View {
    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isThereSomethingWrong: Bool = false
    private var apiKey: String = APIKeys.testApiKey
    
    var body: some View {
        VStack(alignment: .leading){
            TextField("프롬프트를 입력하세요.", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Button("이미지 생성") {
                Task {
                    do {
                        let response = try await DallEImageGenerator.shared.generateImage(withPrompt: prompt, apiKey: apiKey)
                        
                        if let url = response.data.map(\.url).first {
                            guard let url = URL(string: url) else {
                                isThereSomethingWrong = true
                                return
                            }
                            let (data, _) = try await URLSession.shared.data(from: url)
                            image = UIImage(data: data)
                            isThereSomethingWrong = false
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
    DallETestView()
}
