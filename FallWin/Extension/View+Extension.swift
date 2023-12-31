//
//  View+Extension.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/14/23.
//

import Foundation
import SwiftUI

// MARK: - safeToolbar
extension View {
    /// Adds a safe toolbar to the view with custom content.
    ///
    /// Use this modifier to safely apply a toolbar to the view.
    /// This modifier is designed to handle potential crashes that may occur with the standard `toolbar` modifier on iOS 17.
    ///
    /// - Parameter content: A closure returning the custom content of the toolbar.
    /// - Returns: A modified view with the safe toolbar applied.
    /// - Note: This modifier automatically manages the presentation of the toolbar to prevent potential crashes on iOS 17.
    @ViewBuilder
    public func safeToolbar<Content: View>(@ViewBuilder _ content: @escaping () -> Content) -> some View {
        if #available(iOS 17.0, *) {
            modifier(SafeToolbarView(content))
        } else {
            toolbar(content: content)
        }
    }

    /// Adds a safe toolbar to the view with custom content.
    ///
    /// Use this modifier to safely apply a toolbar to the view.
    /// This modifier is designed to handle potential crashes that may occur with the standard `toolbar` modifier on iOS 17.
    ///
    /// - Parameter content: A closure returning the custom content of the toolbar.
    /// - Returns: A modified view with the safe toolbar applied.
    /// - Note: This modifier automatically manages the presentation of the toolbar to prevent potential crashes on iOS 17.
    @ViewBuilder
    public func safeToolbar<Content: ToolbarContent>(@ToolbarContentBuilder _ content: @escaping () -> Content) -> some View {
        if #available(iOS 17.0, *) {
            modifier(SafeToolbarContent(content))
        } else {
            toolbar(content: content)
        }
    }
}

private struct SafeToolbarView<ToolbarContent: View>: ViewModifier {
    @State private var isPresented: Bool = true
    private let toolBarContent: () -> ToolbarContent
    init(@ViewBuilder _ content: @escaping () -> ToolbarContent) {
        self.toolBarContent = content
    }
    func body(content: Content) -> some View {
        content
            .onAppear { isPresented = true }
            .onDisappear { isPresented = false }
            .toolbar(content: { if isPresented { toolBarContent() } })
    }
}

private struct SafeToolbarContent<S: ToolbarContent>: ViewModifier {
    @State private var isPresented: Bool = true
    private let toolBarContent: () -> S
    init(@ToolbarContentBuilder _ content: @escaping () -> S) {
        self.toolBarContent = content
    }
    func body(content: Content) -> some View {
        content
            .onAppear { isPresented = true }
            .onDisappear { isPresented = false }
            .toolbar(content: { if isPresented { toolBarContent() } })
    }
}
