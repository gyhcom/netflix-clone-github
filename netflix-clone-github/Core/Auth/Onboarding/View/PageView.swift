//
//  PageView.swift
//  netflix-clone-github
//
//  Created by gyhmac on 1/14/26.
//

import SwiftUI

struct PageView<Content: View> :  View {
    @Binding var currentPage: Int
    var pages: Int
    var content: Content
    
    init(currentPage: Binding<Int>, pages: Int, @ViewBuilder content: () -> Content) {
        self._currentPage = currentPage
        self.pages = pages
        self.content = content()
    }
    
    
    var body: some View {
        TabView (selection: $currentPage){
            content
        }
        
        
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
        IndicatorsView(currentIndex: currentPage, pages: pages)
    }
}

struct IndicatorsView: View{
    var currentIndex: Int = 0
    var pages: Int
    var body: some View{
        HStack{
            ForEach(0..<pages, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.blue : Color.gray
                        .opacity(0.5))
                    .frame(width: index == currentIndex ? 12: 10,
                           height: index == currentIndex ? 12: 10
                    )
                    .animation(.spring(response: 0.25), value: index)
            }
        }
    }
}
#Preview {
    IndicatorsView(pages: 3)
}
