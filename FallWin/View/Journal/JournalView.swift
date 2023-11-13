//
//  JournalView.swift
//  FallWin
//
//  Created by 최명근 on 10/19/23.
//

import SwiftUI
import SwiftKeychainWrapper
import ComposableArchitecture
import FirebaseAnalytics

struct JournalView: View {
    let store: StoreOf<JournalFeature>
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                ScrollView(.vertical) {
                    VStack(spacing: 28) {
                        journalDrawing
                        
                        journalContent
                    }
                    .padding()
                }
                .refreshable {
                    dismiss()
                }
                
                if viewStore.invisible {
                    Rectangle()
                        .fill(.regularMaterial)
                        .ignoresSafeArea()
                }
            }
            .fullScreenCover(isPresented: viewStore.binding(get: \.showImageDetailView, send: JournalFeature.Action.showImageDetailView)) {
                NavigationStack {
                    ImageZoomView(image: viewStore.journal.wrappedImage)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    viewStore.send(.showImageDetailView(false))
                                } label: {
                                    Label("닫기", systemImage: "xmark")
                                }
                                .labelStyle(.iconOnly)
                            }
                        }
                }
            }
            .sheet(item: viewStore.binding(get: \.shareItem, send: JournalFeature.Action.shareItem)) { item in
                ActivityView(image: item)
            }
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .onChange(of: viewStore.dismiss) { value in
                dismiss()
            }
            .onChange(of: scenePhase) { value in
                if !UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.lock) {
                    return
                }
                
                switch value {
                case .background:
                    break
                    
                case .inactive:
                    viewStore.send(.setInvisibility(true))
                    break
                    
                case .active:
                    viewStore.send(.setInvisibility(false))
                    break
                    
                @unknown default: break
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .labelStyle(.iconOnly)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("공유", systemImage: "square.and.arrow.up") {
                        viewStore.send(.showShareSheet(true))
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Button("삭제", systemImage: "trash", role: .destructive) {
                        viewStore.send(.delete)
                    }
                }
            }
            .sheet(isPresented: viewStore.binding(get: \.showShareSheet, send: JournalFeature.Action.showShareSheet)) {
                shareSheetView
                    .presentationDetents([.fraction(0.8)])
            }
        }
        .onAppear {
            Tracking.logScreenView(screenName: Tracking.Screen.V3__상세페이지뷰.rawValue)
            print("@Log : V3__상세페이지뷰")
           }
    }
    
    private var journalDrawing: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 22) {
                Group {
                    if let image = viewStore.journal.wrappedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } else {
                        Rectangle()
                            .fill(.blue)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .shadow(color: .shadow.opacity(0.14), radius: 6, y: 3)
                .onTapGesture {
                    viewStore.send(.showImageDetailView(true))
                }
                
                if let timestamp = viewStore.journal.timestamp {
                    Text(String(format: "%d/%02d/%02d(\(timestamp.dayOfWeek))", timestamp.year, timestamp.month, timestamp.day))
                        .font(.uhbeeSehyun(size: 22))
                        .padding(.bottom, 8)
                }
            }
            .padding()
            .background {
                Rectangle()
                    .fill(.backgroundCard)
                    .shadow(color: .shadow.opacity(0.14), radius: 8, y: 4)
            }
        }
    }
    
    private var journalContent: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                let mind = viewStore.journal.wrappedMind
                let drawingStyle = viewStore.journal.wrappedDrawingStyle
                
                HStack {
                    if mind != .none, let string = mind.string(), let icon = mind.iconName() {
                        Spacer()
                        VStack {
                            Text("오늘의 기분")
                            HStack(spacing: 0) {
                                Image(icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                                Text(string)
                                    .font(.pretendard(.medium, size: 16))
                            }
                        }
                        Spacer()
                    }
                    if mind != .none && drawingStyle != .none {
                        Divider()
                            .background(.separator)
                    }
                    if drawingStyle != .none, let string = drawingStyle.name() {
                        Spacer()
                        VStack {
                            Text("오늘의 그림")
                            Text(string)
                        }
                        Spacer()
                    }
                }
                
                if mind != .none || drawingStyle != .none {
                    Divider()
                        .background(.separator)
                }
                
                LineNoteView(text: .constant(viewStore.journal.content ?? ""), fontSize: 20, lineSpacing: 20)
            }
            .padding()
            .background {
                Rectangle()
                    .fill(.backgroundCard)
                    .shadow(color: .shadow.opacity(0.14), radius: 8, y: 4)
            }
        }
    }
    
    private var shareSheetView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Capsule()
                    .fill(.buttonDisabled)
                    .frame(width: 36, height: 5)
                Text("공유하기")
                    .font(.pretendard(.semiBold, size: 18))
                    .padding(.top, 20)
                Spacer()
                ZStack {
                    shareView
                }
                .padding()
                Spacer()
                Button {
                    viewStore.send(.showShareSheet(false))
                    DispatchQueue.main.async {
                        if let image = _shareView.frame(width: 720).render() {
                            viewStore.send(.shareItem(ShareImageWrapper(id: UUID(), image: image)))
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("오늘의 일기 공유")
                            .font(.pretendard(.semiBold, size: 18))
                            .foregroundColor(.textOnButton)
                        Spacer()
                    }
                    .padding(20)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
    
    private var shareView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                Group {
                    if let image = viewStore.journal.wrappedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } else {
                        Rectangle()
                            .fill(.blue)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(22)
                .overlay {
                    Image("templatesTop")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                ZStack {
                    Image("templatesBottom")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text(String(viewStore.journal.timestamp?.journalShareString ?? ""))
                        .font(.uhbeeSehyun(.regular, size: 22))
                }
                .padding(.top, -20)
            }
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("sharesheetBottomIcon")
                            .shadow(color: .shadow.opacity(0.14), radius: 4, y: 2)
                    }
                }
                .padding(6)
            }
        }
    }
    
    private var _shareView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                Group {
                    if let image = viewStore.journal.wrappedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } else {
                        Rectangle()
                            .fill(.blue)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(22)
                .overlay {
                    Image("templatesTop")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                ZStack {
                    Image("templatesBottom")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text(String(viewStore.journal.timestamp?.journalShareString ?? ""))
                        .font(.uhbeeSehyun(.regular, size: 44))
                }
                .padding(.top, -20)
            }
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("sharesheetBottomIcon")
                            .shadow(color: .shadow.opacity(0.14), radius: 4, y: 2)
                    }
                }
                .padding(6)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.debug.container.viewContext
    let journal = Journal(context: context)
    journal.id = UUID()
    journal.content = "blah blah blah sdlkfjas fjklasd flkasjd flaksdjf laksdjflkasdj flkasjdf lkasjdflkawjfoiejalskdmf laskdjf lkawjfl kewj lidsjflkawjs deflkjaw dsoifjaweiopfj awoeifj osdaijf oawijf oiawej foiawejf iowajef oiawjef oisdjf oiasdj foiawje foiwaje foij\nasdf \nasdfasdf"
    journal.image = nil
    journal.mind = 1
    journal.timestamp = Date()
    context.insert(journal)
    
    return NavigationStack {
        JournalView(store: Store(initialState: JournalFeature.State(journal: journal, showShareSheet: false), reducer: {
            JournalFeature()
        }))
    }
}
