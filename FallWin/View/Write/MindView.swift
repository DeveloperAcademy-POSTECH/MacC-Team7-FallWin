//
//  MindView.swift
//  FallWin
//
//  Created by 최명근 on 11/14/23.
//

import SwiftUI

struct MindValueObject: Identifiable {
    var mind: Mind
    var icon: String
    var color: Color
    
    var id: Mind {
        self.mind
    }
}

struct MindView: View {
    @Binding var tab: JournalWritingTab
    @Binding var selected: Mind?
    
    let emotions: [MindValueObject] = [
        MindValueObject(mind: .happy, icon: "IconHappy", color: .emotionHappy),
        MindValueObject(mind: .proud, icon: "IconProud", color: .emotionProud),
        MindValueObject(mind: .touched, icon: "IconTouched", color: .emotionTouched),
        MindValueObject(mind: .annoyed, icon: "IconAnnoyed", color: .emotionAnnoyed),
        MindValueObject(mind: .sad, icon: "IconSad", color: .emotionSad),
        MindValueObject(mind: .suffocated, icon: "IconSuffocated", color: .emotionSuffocated),
        MindValueObject(mind: .lazy, icon: "IconLazy", color: .emotionLazy),
        MindValueObject(mind: .grateful, icon: "IconGrateful", color: .emotionGrateful),
        MindValueObject(mind: .joyful, icon: "IconJoyful", color: .emotionJoyful),
        MindValueObject(mind: .exciting, icon: "IconExciting", color: .emotionExciting),
        MindValueObject(mind: .nervous, icon: "IconNervous", color: .emotionNervous),
        MindValueObject(mind: .lonely, icon: "IconLonely", color: .emotionLonely),
        MindValueObject(mind: .shy, icon: "IconShy", color: .emotionShy),
        MindValueObject(mind: .frustrated, icon: "IconFrustrated", color: .emotionFrustrated),
        MindValueObject(mind: .tough, icon: "IconTough", color: .emotionTough),
        MindValueObject(mind: .peaceful, icon: "IconPeaceful", color: .emotionPeaceful),
        MindValueObject(mind: .surprised, icon: "IconSurprised", color: .emotionSurprised),
        MindValueObject(mind: .reassuring, icon: "IconReassuring", color: .emotionReassuring),
    ]
    
    var body: some View {
        VStack {
            WritingHeaderView(title: "writing_title".localized, message: "writing_subtitle".localized) {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center, spacing: 0) {
                        ForEach(emotions) { emotion in
                            emotionCell(emotion: emotion)
                                .padding()
                                .onTapGesture {
                                    selected = emotion.mind
                                }
                        }
                    }
                }
            }
            HStack {
                Button {
                    selected = nil
                    tab = .content
                } label: {
                    Text("skip")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundStyle(.textSecondary)
                }
                .buttonStyle(.borderless)
                .frame(minWidth: 140)
                
                Button {
                    tab = .content
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
    
    @ViewBuilder
    private func emotionCell(emotion: MindValueObject) -> some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Image(emotion.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(String(emotion.mind.string() ?? ""))
                    .font(selected == emotion.mind ? .pretendard(.bold, size: 16) : .pretendard(.medium, size: 16))
                    .foregroundColor(selected == emotion.mind ? emotion.color : Color.textPrimary)
            }
            Spacer()
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(selected == emotion.mind ? emotion.color : Color.clear, lineWidth: selected == emotion.mind ? 2 : 0)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selected == emotion.mind ? Color.backgroundPrimary : Color.clear)
                }
                .aspectRatio(1, contentMode: .fill)
                .shadow(color: selected == emotion.mind ? emotion.color.opacity(0.3) : Color.shadow.opacity(0), radius: 6)
        }
        .opacity((selected == nil || selected == emotion.mind) ? 1 : 0.5)
    }
}

#Preview {
    MindView(tab: .constant(.mind), selected: .constant(.happy))
}
