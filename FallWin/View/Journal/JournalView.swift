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
                    .padding(20)
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
            .onAppear {
                print("textEdit is nil? \(viewStore.textEdit == nil)")
            }
            .fullScreenCover(isPresented: viewStore.binding(get: \.showImageDetailView, send: JournalFeature.Action.showImageDetailView)) {
                NavigationStack {
                    ImageZoomView(image: viewStore.journal.wrappedImage)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    viewStore.send(.showImageDetailView(false))
                                } label: {
                                    Label("dismiss", systemImage: "xmark")
                                }
                                .labelStyle(.iconOnly)
                            }
                        }
                }
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
            .safeToolbar {
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
                    Button("share", systemImage: "square.and.arrow.up") {
                        Tracking.logEvent(Tracking.Event.A3_1__상세페이지_공유하기.rawValue)
                        print("@Log : A3_1__상세페이지_공유하기")
                        
                        DispatchQueue.main.async {
                            if let image = shareView(image: viewStore.journal.wrappedImage).render() {
                                viewStore.send(.shareItem(ShareImageWrapper(id: UUID(), image: image)))
                            }
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .secondaryAction) {
                    Button("edit", systemImage: "pencil"){
                        viewStore.send(.showTextEditView)
                    }
                    Button("delete", systemImage: "trash", role: .destructive) {
                        viewStore.send(.showDeleteAlert(true))
                    }
                    .alert(isPresented: viewStore.binding(get: \.showDeleteAlert, send: JournalFeature.Action.showDeleteAlert), title: "journal_delete_alert_title".localized) {
                        Text("journal_delete_alert_message")
                    } primaryButton: {
                        OhwaAlertButton(label: Text("cancel"), color: .clear) {
                            viewStore.send(.showDeleteAlert(false))
                        }
                    } secondaryButton: {
                        OhwaAlertButton(label: Text("delete").foregroundColor(.textOnButton), color: .button) {
                            Tracking.logEvent(Tracking.Event.A3_3__상세페이지_일기삭제.rawValue)
                            print("@Log : A3_3__상세페이지_일기삭제")
                            viewStore.send(.delete)
                            viewStore.send(.showDeleteAlert(false))
                        }
                        
                    }
                }
            }
            .toolbar(.visible, for: .navigationBar)
            .sheet(item: viewStore.binding(get: \.shareItem, send: JournalFeature.Action.shareItem)) { image in
                shareSheetView(image: image.image)
                    .presentationDetents([.fraction(0.8)])
            }
            .navigationDestination(store: store.scope(state: \.$textEdit, action: JournalFeature.Action.textEdit), destination: { store in
                TextEditView(store: store)
            })
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
                        .foregroundStyle(Color.textPrimary)
                        .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom)
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
                
                HStack(spacing: 16) {
                    if mind != .none, let string = mind.string(), let icon = mind.iconName() {
                        Spacer()
                        VStack {
                            Text("journal_mind")
                                .font(.sejong(size: 16))
                            Spacer()
                            HStack(spacing: 8) {
                                Image(icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                Text(string)
                                    .font(.sejong(size: 18))
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
                            Text("journal_drawing_style")
                                .font(.sejong(size: 16))
                            Spacer()
                            Text(string)
                                .font(.sejong(size: 18))
                        }
                        Spacer()
                    }
                }
                .foregroundStyle(.textPrimary)
                .padding(8)
                .frame(maxHeight: 112)
                
                if mind != .none || drawingStyle != .none {
                    Divider()
                        .background(.separator)
                }
                
                LineNoteView(text: .constant(viewStore.journal.content ?? ""), fontSize: 20, lineSpacing: 20)
                    .foregroundStyle(.textPrimary)
            }
            .padding()
            .background {
                Rectangle()
                    .fill(.backgroundCard)
                    .shadow(color: .shadow.opacity(0.14), radius: 8, y: 4)
            }
        }
    }
    
    @ViewBuilder
    private func shareSheetView(image: UIImage) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Capsule()
                    .fill(.buttonDisabled)
                    .frame(width: 36, height: 5)
                Text("journal_share")
                    .font(.pretendard(.semiBold, size: 18))
                    .padding(.top, 20)
                Spacer()
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                .padding()
                Spacer()
                ShareLink(item: Image(uiImage: image), preview: SharePreview("journal_share_preview", image: Image(uiImage: image))) {
                    HStack {
                        Spacer()
                        Text("journal_share_button")
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
    
    @ViewBuilder
    private func shareView(image: UIImage?) -> some View {
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
                        Image("shareSheetBottomIcon")
                            .shadow(color: .shadow.opacity(0.14), radius: 4, y: 2)
                    }
                }
                .padding(12)
            }
            .frame(width: 720)
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
    journal.drawingStyle = 1
    journal.timestamp = Date()
    context.insert(journal)
    
    return NavigationStack {
        JournalView(store: Store(initialState: JournalFeature.State(journal: journal, showShareSheet: true), reducer: {
            JournalFeature()
        }))
    }
}
