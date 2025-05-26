//
//  SwiftUICustomTagView.swift
//  
//
//  Created by 福田正知 on 2024/02/11.
//

import SwiftUI

public struct SwiftUICustomTagView<Content: View>: View, Hashable {
    
    private let id = UUID()
    private let content: Content // Remove @State - content shouldn't change
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
    }
    
    public static func == (lhs: SwiftUICustomTagView, rhs: SwiftUICustomTagView) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
