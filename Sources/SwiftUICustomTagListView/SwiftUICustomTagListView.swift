//
//  SwiftUICustomTagListView.swift
//  
//
//  Created by 福田正知 on 2024/02/11.
//

import SwiftUI

/// A SwiftUI view that presents a customizable tag list.
public struct SwiftUICustomTagListView<Content: View>: View {
    
    /// An array of Tag View
    private let tagViews: [SwiftUICustomTagView<Content>]
    /// Horizontal space between each tag
    private let horizontalSpace: CGFloat
    /// Vertical space between each tag
    private let verticalSpace: CGFloat
    
    public init(_ views: [SwiftUICustomTagView<Content>],
                horizontalSpace: CGFloat,
                verticalSpace: CGFloat) {
        self.tagViews = views
        self.horizontalSpace = horizontalSpace
        self.verticalSpace = verticalSpace
    }
    
    public var body: some View {
        // Remove the problematic GeometryReader and fixed frame height
        generateTags(views: tagViews)
    }
    
    private func generateTags(views: [SwiftUICustomTagView<Content>]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(views, id: \.self) { view in
                    view
                        .padding(.trailing, horizontalSpace)
                        .alignmentGuide(.leading) { dimension in
                            // Keep original width logic but fix the overflow check
                            if abs(width - dimension.width) > geometry.size.width {
                                width = 0
                                height += dimension.height + verticalSpace
                            }
                            let result = width
                            if view == views.last {
                                width = 0
                            } else {
                                width -= dimension.width // Keep original logic
                            }
                            return result
                        }
                        .alignmentGuide(.top) { dimension in
                            let result = height
                            if view == views.last {
                                height = 0 // Reset for next layout pass
                            }
                            return result
                        }
                }
            }
        }
        // Let SwiftUI determine the height naturally
        .fixedSize(horizontal: false, vertical: true)
    }
}


// MARK: - Sample
struct SwiftUICustomTagListView_Previews: PreviewProvider {
    
    static let data: [SampleTagViewData] = [
        .init(text: "#Technology", color: Color(hex: "#ff4d4d")),
        .init(text: "#News", color: Color(hex: "#b33636")),
        .init(text: "#Politics", color: Color(hex: "#ff944d")),
        .init(text: "#Breaking", color: Color(hex: "#ff4dd3")),
        .init(text: "#Global", color: Color(hex: "#b33693")),
    ]
    
    static var views: [SwiftUICustomTagView<SampleTagView>] {
        self.data.map { data in
            SwiftUICustomTagView(content: {
                SampleTagView(data: data)
            })
        }
    }
    
    static var previews: some View {
        SwiftUICustomTagListView(views,
                                 horizontalSpace: 8,
                                 verticalSpace: 8)
            .frame(width: 240, height: 220, alignment: .top)
            .previewLayout(.sizeThatFits)
    }
}
