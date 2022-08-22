//
//  TextWithLinks.swift
//  streamline
//
//  Created by Tayyab Ali on 12/05/2022.
//

import SwiftUI
import UIKit
import ActiveLabel

struct TextWithLinks: UIViewRepresentable {
    
    @State var string: String
    var fontSize: CGFloat
    @Binding var dynamicHeight: CGFloat
    var openLink: (URL) -> Void

//    init(string: String, width: CGFloat, dynamicHeight: CGFloat, openLink: @escaping (URL) -> Void) {
//        self.string = string
//        self.width = width
//        self.dynamicHeight = dynamicHeight
//        self.openLink = openLink
//    }
    
    func makeUIView(context: Context) -> ActiveLabel {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.preferredMaxLayoutWidth = width
        label.enabledTypes = [.url]
//        label.text = string
//        label.urlMaximumLength = 5
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = UIColor(named: "AdaptiveColor")
        label.URLColor = UIColor(named: "linkColor") ?? .white
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        label.setContentHuggingPriority(.defaultHigh,
//                                        for: .vertical)

        label.handleURLTap { url in
            openLink(url)
        }
        return label
    }
    
    func updateUIView(_ uiView: ActiveLabel, context: Context) {
        uiView.text = string

        DispatchQueue.main.async {
            dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
    }
}
