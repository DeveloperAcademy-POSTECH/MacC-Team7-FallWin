//
//  GalleryView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI
import ComposableArchitecture

struct GalleryView: View {
    let store: StoreOf<GalleryFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Carousel(viewStore.journals, id: \.self, spacing: 24, visibleSpacing: 24, initialPage: viewStore.journals.endIndex) { oldValue, newValue in
                // OnPageChanged
                
            } _: { journal in
                ZStack {
                    if let image = journal.wrappedImage {
                        Image(uiImage: image)
                    } else {
                        Rectangle()
                            .fill(.white)
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
                .shadow(color: .black.opacity(0.12), radius: 10)
                
            }
            .onAppear {
                viewStore.send(.fetchAll)
                print(viewStore.journals)
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
    
    return GalleryView(store: Store(initialState: GalleryFeature.State(), reducer: {
        GalleryFeature()
    }))
}
