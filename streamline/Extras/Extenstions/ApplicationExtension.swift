//
//  ApplicationExtension.swift
//  MyHelperApp
//
//  Created by Sibtain Ali (Fiverr) on 04/06/2022.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var keyWindowCustom: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil}
        guard let window = windowScene.windows.first else { return nil}
        return window
    }
    
    class func isFirstLaunch() -> Bool {
        // if app is running for first time
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
}
