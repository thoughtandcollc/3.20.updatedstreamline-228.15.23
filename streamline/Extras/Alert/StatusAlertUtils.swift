//
//  StatusAlert
//  Copyright © 2017-2018 Yegor Miroshnichenko. Licensed under the MIT license.
//

import UIKit

extension AlertNew {
    
    @objc(StatusAlertAppearance)
    public final class Appearance: NSObject {
        
        @objc public static let common: Appearance = Appearance()
        
        /// - Note: Do not change to save system look
        @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        
        /// - Note: Do not change to save system look
        @objc public var messageFont: UIFont = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        
        /// - Note: Do not change to save system look
        @objc public var tintColor: UIColor = UIColor.darkGray
        
        /// Used if device does not support blur or if `Reduce Transparency` toggle
        /// in `General->Accessibility->Increase Contrast` is on
        /// - Note: Do not change to save system look
        @objc public var backgroundColor: UIColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        static func copyCommon() -> Appearance {
            let common = Appearance.common
            let copy = Appearance()
            copy.titleFont          = common.titleFont
            copy.messageFont        = common.messageFont
            copy.tintColor          = common.tintColor
            copy.backgroundColor    = common.backgroundColor
            return copy
        }
    }
    
    @objc(StatusAlertVerticalPosition)
    public enum VerticalPosition: Int {
        
        /// Position in the center of the view
        case center
        
        /// Position on the top of the view
        case top
        
        /// Position at the bottom of the view
        case bottom
    }
    
    enum SizesAndDistances {
        static let defaultInitialScale: CGFloat = 0.9
        static let defaultCornerRadius: CGFloat = 20
        
        static let defaultTopOffset: CGFloat = 15
        static let defaultBottomOffset: CGFloat = 15
        
        static let defaultImageWidth: CGFloat = 90
        static let defaultAlertWidth: CGFloat = 200
        static let minimumAlertHeight: CGFloat = 200
        
        static let minimumStackViewTopSpace: CGFloat = 40
        static let minimumStackViewBottomSpace: CGFloat = 40
        static let stackViewSideSpace: CGFloat = 20
        
        static let defaultImageBottomSpace: CGFloat = 10
        static let defaultTitleBottomSpace: CGFloat = 5
    }
}

// Compatibility

#if swift(>=4.0)
    private let UIFontWeightSemibold = UIFont.Weight.semibold
    private let UIFontWeightRegular = UIFont.Weight.bold
#endif
