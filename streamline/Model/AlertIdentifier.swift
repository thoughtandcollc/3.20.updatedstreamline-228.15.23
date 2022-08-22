//
//  AlertModel.swift
//  LikeType
//
//  Created by Tayyab Ali on 06/09/2021.
//

import SwiftUI

struct AlertIdentifier: Identifiable {
    enum AlertType: Equatable {
        case error
        case success
        case custom(String)
        
        var title: String {
            switch self {
            case .error:
                return "Error"
            case .success:
                return "Success"
            case .custom(let title):
                return title
            }
        }
    }
    
    var id = UUID()
    var type: AlertType
    var message: String
    var item: AnyObject? = nil
}
