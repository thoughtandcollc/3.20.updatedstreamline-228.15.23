//
//  CustomModifiers.swift
//  
//
//  Created by Sibtain Ali (Fiverr) on 16/02/2022.
//

import SwiftUI


// MARK: - Top

struct TopLeading: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            HStack {
                content
                Spacer()
            }
            Spacer()
        }
    }
}

struct Top: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content
            Spacer()
        }
    }
}

struct TopTrailing: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            HStack {
                Spacer()
                content
            }
            Spacer()
        }
    }
}


// MARK: - Center

struct Leading: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }
    }
}

struct Center: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

struct Trailing: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
        }
    }
}


// MARK: - Bottom

struct BottomLeading: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            HStack {
                content
                Spacer()
            }
        }
    }
}

struct Bottom: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            content
        }
    }
}

struct BottomTrailing: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                content
            }
        }
    }
}


extension View {
    
    // MARK: - Top
    
    func topLeading() -> some View {
        modifier(TopLeading())
    }
    
    func top() -> some View {
        modifier(Top())
    }
    
    func topTrailing() -> some View {
        modifier(TopTrailing())
    }
    
    
    // MARK: - Center
    
    func leading() -> some View {
        modifier(Leading())
    }
    
    func center() -> some View {
        modifier(Center())
    }
    
    func trailing() -> some View {
        modifier(Trailing())
    }
    

    // MARK: - Bottom
    
    func bottomLeading() -> some View {
        modifier(BottomLeading())
    }
    
    func bottom() -> some View {
        modifier(Bottom())
    }
    
    func bottomTrailing() -> some View {
        modifier(BottomTrailing())
    }
    
}
