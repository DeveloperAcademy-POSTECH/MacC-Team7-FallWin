//
//  FeedbackSettingView.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import SwiftUI
import ComposableArchitecture

struct FeedbackView: View {
    let store: StoreOf<FeedbackFeature>
    @State var feedbackText = ""
    //TCA로 하니까 그냥 꺼져버려요......
    @State var isClicked = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0){
                Text("의견을 보내주세요.")
                    .font(.pretendard(.medium, size: 18))
                    .padding(.vertical, 20)
                
                TextEditor(text: $feedbackText)
                //힌트 추가해야함
                    .font(.pretendard(.medium, size: 18))
                    .foregroundColor(.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding([.top, .bottom], 9)
                    .padding([.leading, .trailing], 12)
                    .background() {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color(hexCode: "#191919").opacity(0.14), radius: 8, y: 2)
                    }
                    .padding(.bottom, 20)
                    .overlay {
                        VStack(alignment: .leading ,spacing: 0){
                            if feedbackText.isEmpty {
                                Text("궁금하거나 불편한 점이 있나요?")
                                    .font(.pretendard(size: 18))
                                    .foregroundStyle(.textTeritary)
                                
                            }
                            
                        }
                        
                    }
                
                Button(action: {
                    isClicked.toggle()
                }, label: {
                    HStack {
                        Spacer()
                        Text("보내기")
                            .font(.pretendard(.semiBold, size: 18))
                            .foregroundStyle(.textOnButton)
                            
                        Spacer()
                    }
                    .frame(height: 50)
                    
                        
                })
                .buttonStyle(.borderedProminent)
                .disabled(false)
                
                
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 24)
  
        }
        .alert("", isPresented: $isClicked, actions: {
            Button("취소", role: .cancel) {
                isClicked = false
            }
            Button("삭제", role: .destructive) {
                isClicked = false
            }
        }, message: {
            Text("의견주셔서 감사합니다.\n더 좋은 서비스로 보답해드릴게요 :)")
        })
        .navigationTitle("피드백 남기기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

