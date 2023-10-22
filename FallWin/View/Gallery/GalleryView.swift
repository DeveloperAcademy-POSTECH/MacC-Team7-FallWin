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
            GeometryReader { proxy in
                ZStack {
                    VStack {
                        Spacer()
                        
                        dateController
                        
                        Carousel(viewStore.journals, id: \.self, index: viewStore.binding(get: \.carouselIndex, send: GalleryFeature.Action.setCarouselIndex), spacing: 36, visibleSpacing: 24, initialPage: viewStore.journals.endIndex) { newValue in
                            // OnPageChanged
                            
                        } _: { journal in
                            Button {
                                viewStore.send(.showJournalView(journal))
                            } label: {
                                journalCell(journal: journal)
                            }
                        }
                        .aspectRatio(0.7, contentMode: .fit)
                        
                        Spacer()
                    }
                }
                
                writingActionButton
                    .padding()
            }
            .onAppear {
                viewStore.send(.fetchAll)
                viewStore.send(.setCarouselIndex(viewStore.journals.count - 1))
            }
            .fullScreenCover(store: store.scope(state: \.$journal, action: GalleryFeature.Action.journal)) { store in
                NavigationStack {
                    JournalView(store: store)
                }
            }
        }
        .padding(.bottom, CvasTabViewValue.tabBarHeight)
    }
    
    var writingActionButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewStore.send(.showWritingView)
                        
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(Colors.tabBarItem.color())
                            .padding()
                            .background(
                                Circle()
                                    .fill(Colors.button.color())
                            )
                    }
                }
            }
        }
    }
    
    var dateController: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Button("Previous Month", systemImage: "chevron.left") {
                    viewStore.send(.prevMonth)
                }
                .labelStyle(.iconOnly)
                
                Button(String(format: "%d년 %02d월", viewStore.date.year, viewStore.date.month)) {
                    
                }
                .font(.body.bold())
                
                Button("Next Month", systemImage: "chevron.right") {
                    viewStore.send(.nextMonth)
                }
                .labelStyle(.iconOnly)
                .disabled(!viewStore.hasNextMonth)
            }
        }
    }
    
    @ViewBuilder
    func journalCell(journal: Journal) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
            .aspectRatio(0.6, contentMode: .fit)
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
    
    let journal2 = Journal(context: context)
    journal2.id = UUID()
    journal2.content = "blah blah blah"
    journal2.image = nil
    journal2.mind = 1
    journal2.timestamp = Date()
    context.insert(journal2)
    
    let journal3 = Journal(context: context)
    journal3.id = UUID()
    journal3.content = "blah blah blah"
    journal3.image = nil
    journal3.mind = 1
    journal3.timestamp = Date()
    context.insert(journal3)
    
    return NavigationStack {
        ContentView(store: Store(initialState: Feature.State(), reducer: {
            Feature()
        }))
    }
}
