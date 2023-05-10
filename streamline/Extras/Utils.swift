//
//  Utils.swift
//  CardsScanner
//
//  Created by Sibtain Ali (Fiverr) on 14/12/2021.
//

import SwiftUI
import SDWebImage
import LocalAuthentication
import AVKit

class Utils {
    
    static let shared = Utils()
    
    private init() {}
    
}


// MARK: - Helper
// MARK: -
extension Utils {
    
    func printImageSize(image: UIImage) {
        
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useKB
        formatter.countStyle = .file
        let string = formatter.string(fromByteCount: Int64(imageData!.count))
        printOnDebug("++++ image size: \(string)")
        
    }

    func printImageSize(imadeData: Data) {
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useKB
        formatter.countStyle = .file
        let string = formatter.string(fromByteCount: Int64(imadeData.count))
        printOnDebug("++++ image data size: \(string)")
        
    }
    
    func isContainSmallLetter( _string : String) -> Bool{

            let numberRegEx  = ".*[a-z]+.*"
            let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let containsNumber = testCase.evaluate(with: _string)

            return containsNumber
    }
    
    func isContainSpecialLetter( _string : String) -> Bool{

            let numberRegEx  = ".*[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+.*"
            let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let containsNumber = testCase.evaluate(with: _string)

            return containsNumber
    }
    
    func isDebug() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    func now() -> Int {
        Int(NSDate().timeIntervalSince1970)
    }
    
}


// MARK: - SDWebImage
// MARK: -
extension Utils {
    
    func getImage(key: String) -> UIImage {
        return SDImageCache.shared.imageFromCache(forKey: key) ?? UIImage()
    }
    
    func saveImage(key: String, image: UIImage) {
        
        // resize image
        let newImage = image.resizeToBoundingSquare(ofLength: 1000)
        printOnDebug("Height = \(newImage.size.height)")
        printOnDebug("Width = \(newImage.size.width)")
        
        // print resized image size
        printImageSize(image: newImage)
        
        // save image in cache
        SDImageCache.shared.store(newImage, forKey: key, toDisk: true) {}
    }
    
    func removeImages(keys: [String]) {
        for key in keys {
            SDImageCache.shared.diskCache.removeData(forKey: key)
        }
    }
    
}


// MARK: - Local Files
// MARK: -
extension Utils {
    
    func getJSONFile(name: String, type: String = "json") -> Data? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: type) else { return nil }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
            //self.drugs = try JSONDecoder().decode([Drug].self, from: date)
            
        } catch {
            printOnDebug("**** error: \(error)")
            return nil
        }
        
    }
    
}

// MARK: - Camera Functions
// MARK: -
extension Utils {
    
    func checkCameraPermission(completion: @escaping (_ success: Bool)->()) {
        
        func requestCamera(completion: @escaping (_ success: Bool) -> ()){
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                completion(true)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    completion(granted)
                })
            }
        }
        
        func showCameraAlert() {
            
            var title = "No Camera Access"
            var message = "To give this app your camera access. Go to Settings -> Docformative -> Switch on camera"
            
            customAlertApple(title: title, message: message, showDestructive: true) { success in
                guard success else { return }
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        printOnDebug("Settings opened: \(success)") // Prints true
                    })
                }
            }
            
        }
        
        requestCamera { success in
            DispatchQueue.main.async {
                guard success else { showCameraAlert(); completion(false); return }// error
                completion(true) // success
            }
        }
        
    }
    
}
