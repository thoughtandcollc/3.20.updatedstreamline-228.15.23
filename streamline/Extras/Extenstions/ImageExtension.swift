//
//  ImageExtension.swift
//  MyHelperApp
//
//  Created by Sibtain Ali (Fiverr) on 04/06/2022.
//

import SwiftUI

extension UIImage {
    
    func resizeToBoundingSquare(ofLength length: CGFloat) -> UIImage {
        
        let imgScale  = self.size.width > self.size.height ? length / self.size.width : length / self.size.height
        let newWidth  = self.size.width * imgScale
        let newHeight = self.size.height * imgScale
        let newSize   = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return resizedImage!
        
    }
    
}
