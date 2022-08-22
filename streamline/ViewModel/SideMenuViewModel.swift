//
//  SideViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 6/28/21.
//

import Foundation

enum SideMenuViewModel: Int, CaseIterable {
    case profile
    case lists
    case titles
    case logout
    
    var description: String {
        switch self {
        case .profile: return "Profile"
        case .lists: return "Lists"
        case .titles: return "Titles"
        case .logout: return "Logout"
        }
    }
    
    var imageName: String {
        switch self {
        case .profile: return "person"
        case .lists: return "list.bullet"
        case .titles: return "book"
        case .logout: return "arrow.left.square"
        }
    }
}
