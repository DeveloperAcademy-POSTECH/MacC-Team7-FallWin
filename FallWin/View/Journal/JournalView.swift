//
//  JournalView.swift
//  FallWin
//
//  Created by 최명근 on 10/19/23.
//

import SwiftUI
import ComposableArchitecture

struct JournalView: View {
    let store: StoreOf<JournalFeature>
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                CollapsingScrollView {
                    if let image = viewStore.journal.wrappedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } else {
                        Rectangle()
                            .fill(.blue)
                            .aspectRatio(1, contentMode: .fit)
                    }
                } content: {
                    VStack(spacing: 9) {
                        if let date = viewStore.journal.timestamp {
                            HStack {
                                Text(String(format: "%d년 %02d월 %02d일", date.year, date.month, date.day))
                                    .font(.pretendard(.bold, size: 22))
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                            }
                        }
                        
                        if let content = viewStore.journal.content {
                            HStack {
                                Text(content)
                                    .font(.pretendard(.medium, size: 18))
                                    .foregroundStyle(Color.textSecondary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                    }
                    .padding(21)
                    .padding(.top, 3)
                }
                
                VStack {
                    toolbar
                    Spacer()
                }
                .padding(12)
            }
        }
    }
    
    @ViewBuilder
    private var toolbar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .padding(8)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
            .labelStyle(.iconOnly)
            
            Spacer()
            
            Button {
                // TODO: Share
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .padding(8)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
            .labelStyle(.iconOnly)
            
            Menu {
                Button("편집", systemImage: "pencil") {
                    // TODO: Edit
                }
                
                Button("삭제", systemImage: "trash", role: .destructive) {
                    // TODO: Delete
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .padding(8)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
        }
    }
}

#Preview {
    let context = PersistenceController.debug.container.viewContext
    let journal = Journal(context: context)
    journal.id = UUID()
    journal.content = "blah blah blah"
    journal.image = nil
    journal.mind = 1
    journal.timestamp = Date()
    context.insert(journal)
    
    return JournalView(store: Store(initialState: JournalFeature.State(journal: journal), reducer: {
        JournalFeature()
    }))
}
