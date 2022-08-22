//
//  LazyView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/29/21.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping() -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
