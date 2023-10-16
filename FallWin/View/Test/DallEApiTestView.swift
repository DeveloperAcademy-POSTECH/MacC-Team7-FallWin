//
//  DallEApiTestView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 10/16/23.
//

import SwiftUI

struct DallEApiTestView: View {
    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isThereSomethingWrong: Bool = false
    private var apiKey: String = "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"
    
    var body: some View {
        VStack(alignment: .leading){
            TextField("프롬프트를 입력하세요.", text: $prompt)
                .keyboardType(.default)
//                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                
            Button("이미지 생성") {
                Task {
                    do {
                        let response = try await DallEApiManager.shared.generateImage(withPrompt: prompt, apiKey: apiKey)
                        
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
    DallEApiTestView()
}
