//
//  ViewExtensions.swift
//  MyHelperApp
//
//  Created by Sibtain Ali (Fiverr) on 04/10/2022.
//

import SwiftUI

extension View {
    
    @ViewBuilder func isHidden(_ shouldHide: Bool, removed: Bool = false) -> some View {
        if shouldHide { EmptyView() }
        else { self }
    }
    
    @ViewBuilder func isVisible(_ shouldBeVisible: Bool, removed: Bool = false) -> some View {
        if shouldBeVisible { self }
        else { EmptyView() }
    }
    
    func defaultShadow() -> some View {
           self.shadow(
               color: .primary.opacity(0.2),
               radius: 3.0,
               x: 0,
               y: 1
           )
       }
    
}
