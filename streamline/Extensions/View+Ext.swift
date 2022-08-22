//
//  View+Ext.swift
//  streamline
//
//  Created by Tayyab Ali on 24/01/2022.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}
