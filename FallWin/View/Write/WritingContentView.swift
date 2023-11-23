//
//  WritingContentView.swift
//  FallWin
//
//  Created by 최명근 on 11/14/23.
//

import SwiftUI

struct WritingContentView: View {
    @Binding var tab: JournalWritingTab
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack {
            WritingHeaderView(title: "main_text_title".localized) {
                TextEditor(text: $text)
                    .font(.pretendard(.medium, size: 18))
                    .foregroundColor(.textPrimary)
                    .scrollContentBackground(.hidden)
                    .focused($isFocused)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.backgroundPrimary)
                            .shadow(color: .shadow.opacity(0.14), radius: 8, y: 2)
                    }
                    .overlay {
                        VStack {
                            if text.isEmpty {
                                HStack {
                                    Text("main_text_placeholder")
                                        .font(.pretendard(.regular, size: 18))
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.textTertiary)
                                    Spacer()
                                }
                                .padding(.top, 17)
                                .padding(.horizontal, 16)
                            }
                            Spacer()
                            HStack(spacing: 0) {
                                Spacer()
                                Group {
                                    if text.count > 1000 {
                                        Text(String("\(text.count)"))
                                            .foregroundStyle(.red)
                                    }else {
                                        Text(String("\(text.count)"))
                                            .foregroundStyle(.textSecondary)
                                    }
                                }
                                .font(.pretendard(.medium, size: 14))
                                
                                Text(String(" / \(1000)"))
                                    .font(.pretendard(.regular, size: 14))
                                    .foregroundStyle(.textTertiary)
                                    .padding(.trailing, 8)
                            }
                            .padding(.bottom, 12)
                            .padding(.trailing, 8)
                        }
                    }
                    .padding(.bottom, 20)
            }
            HStack {
                Button {
                    tab = .mind
                } label: {
                    Text("prev")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textSecondary)
                }
                .buttonStyle(.borderless)
                .frame(minWidth: 140)
                
                Button {
                    tab = .style
                } label: {
                    HStack {
                        Spacer()
                        Text("next")
                            .font(.pretendard(.semiBold, size: 18))
                            .foregroundStyle(.textOnButton)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .disabled(text.isEmpty)
            }
            .padding(20)
            .background {
                Rectangle()
                    .fill(.backgroundPrimary)
                    .shadow(color: .shadow.opacity(0.14), radius: 8, y: 4)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    WritingContentView(tab: .constant(.content), text: .constant(""))
}
