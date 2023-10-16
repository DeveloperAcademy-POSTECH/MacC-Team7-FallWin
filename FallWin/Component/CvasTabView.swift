//
//  CvasTabView.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import SwiftUI

enum TabItem {
    case gallery
    case search
    case surf
    case profile
}

struct TabBarItem: Equatable, Hashable {
    var title: String
    var image: String
    var tabItem: TabItem
}

struct CvasTabItemPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct CvasTabItemModifier: ViewModifier {
    let tabBarItem: TabBarItem
    @Binding var selection: TabItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tabBarItem.tabItem ? 1 : 0)
            .preference(key: CvasTabItemPreferenceKey.self, value: [tabBarItem])
    }
}

extension View {
    func tabItem(_ tabBarItem: TabBarItem, selection: Binding<TabItem>) -> some View {
        self.modifier(CvasTabItemModifier(tabBarItem: tabBarItem, selection: selection))
    }
}

struct CvasTabView<Content>: View where Content: View {
    @Binding private var selection: TabItem
    @State private var tabItems: [TabBarItem] = []
    private let content: Content
    
    init(selection: Binding<TabItem>, @ViewBuilder _ content: @escaping () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                tabBar
            }
            .padding(0)
        }
        .onPreferenceChange(CvasTabItemPreferenceKey.self) { value in
            self.tabItems = value
        }
    }
    
    private var tabBar: some View {
        HStack {
            Spacer()
            ForEach(tabItems, id: \.self) { tabItem in
                //                    Label(tabItem.title, image: tabItem.image)
                Label {
                    Text(tabItem.title)
                } icon: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36)
                }
                .labelStyle(TabBarLabelStyle())
                .onTapGesture {
                    selection = tabItem.tabItem
                }
                Spacer()
            }
        }
        .padding(.top, 16)
        .background(
            Rectangle()
                .fill(.white)
                .clipShape(RoundedShape(radius: 16, corners: [.topLeft, .topRight]))
                .ignoresSafeArea()
        )
    }
}

#Preview {
    CvasTabView(selection: .constant(.gallery)) {
        Rectangle()
            .fill(.gray)
            .tabItem(.init(title: "갤러리", image: "", tabItem: .gallery), selection: .constant(.gallery))
        
        Rectangle()
            .fill(.black)
            .tabItem(.init(title: "프로필", image: "", tabItem: .profile), selection: .constant(.gallery))
    }
}
