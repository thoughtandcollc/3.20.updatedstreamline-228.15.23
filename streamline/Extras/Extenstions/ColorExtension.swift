//
//  ColorExtension.swift
//  MyHelperApp
//
//  Created by Sibtain Ali (Fiverr) on 04/06/2022.
//

import SwiftUI

extension Color {
    
    static let whiteInverted  = Color("WhiteInverted")
    static let accentInverted = Color("AccentInverted")
    static let accentDark     = Color("AccentDark")
    static let text           = Color("Text")
    
    init(hex:String) {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.count) != 6) { self = Color.gray }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        let uiColor = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
        self = Color(uiColor: uiColor)
    }

}
