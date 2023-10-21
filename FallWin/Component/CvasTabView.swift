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
    private var _enabledImage: String
    private var _disabledImage: String
    var tabItem: TabItem
    
    func getStateImage(enabled: Bool) -> String {
        enabled ? _enabledImage : _disabledImage
    }
    
    init(title: String, enabledImage: String, disabledImage: String? = nil, tabItem: TabItem) {
        self.title = title
        self._enabledImage = enabledImage
        self._disabledImage = disabledImage ?? enabledImage
        self.tabItem = tabItem
    }
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
        .background(Colors.backgroundPrimary.color().ignoresSafeArea())
        .onPreferenceChange(CvasTabItemPreferenceKey.self) { value in
            self.tabItems = value
        }
    }
    
    private var tabBar: some View {
        HStack {
            Spacer()
            ForEach(tabItems, id: \.self) { tabItem in
                Spacer()
                Spacer()
                Label {
                    Text(tabItem.title)
                        .font(.system(size: 11))
                } icon: {
                    Image(tabItem.getStateImage(enabled: selection == tabItem.tabItem))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                }
                .labelStyle(TabBarLabelStyle())
                .foregroundStyle(Colors.tabBarItem.color())
                .onTapGesture {
                    selection = tabItem.tabItem
                }
                Spacer()
                Spacer()
            }
            Spacer()
        }
        .frame(height: CvasTabViewValue.tabBarHeight)
        .background(
            Rectangle()
                .fill(Colors.tabBar.color())
                .clipShape(RoundedShape(radius: 24, corners: [.topLeft, .topRight]))
                .ignoresSafeArea()
        )
    }
}

final class CvasTabViewValue {
    static let tabBarHeight: CGFloat = 63
}
