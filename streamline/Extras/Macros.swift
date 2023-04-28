//
//  Macros.swift
//  MyHelperApp
//
//  Created by Sibtain Ali (Fiverr) on 27/01/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

var userId: String {
    if let id = Auth.auth().currentUser?.uid {  return id }
    try? Auth.auth().signOut()
    return ""
}


var rootVC: UIViewController? {
    keyWindow?.rootViewController
}

var keyWindow: UIWindow? {
    UIApplication.shared.keyWindowCustom
}

var screenHeight: CGFloat {
    UIScreen.main.bounds.height
}

var screenWidth: CGFloat {
    UIScreen.main.bounds.width
}

func isGroupOwner(memberId: String, group: Group?) -> Bool {
    group?.createdBy ?? "" == memberId
}

func isGroupSubLeader(memberId: String, group: Group?) -> Bool {
    group?.subLeaders?.contains(memberId) ?? false
}


// MARK: - Functions
// MARK: -

func printOnDebug(_ object: Any) {
#if DEBUG
    print(object)
#endif
}


func customAlertApple(title: String,
                      message: String,
                      yesButtonTitle: String = "Yes",
                      noButtonTitle: String = "No",
                      showDestructive: Bool = false,
                      completion: ((_ success: Bool) -> Void)? = nil) {

    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

    let yesAction = UIAlertAction(title: yesButtonTitle, style: .default, handler: { (alert) in
        completion?(true)
    })

    let cancelOption = UIAlertAction(title: noButtonTitle, style: .destructive, handler: { (alert) in
        completion?(false)
    })

    alertController.addAction(yesAction)
    if showDestructive { alertController.addAction(cancelOption) }
    alertController.modalPresentationStyle = .overFullScreen

    var vc = rootVC
    if let tempVC = vc?.presentedViewController { vc = tempVC }
    vc?.present(alertController, animated: true, completion: nil)

} 

func customAlert(title: String = "", message: String, alertType: AlertType = .error, duration: TimeInterval = 2, completion:(() -> ())? = nil) {
    
    var statusAlert: AlertNew?
    var imageP =  UIImage()

    DispatchQueue.main.async {
        
        switch alertType {
            
        case .success:
            imageP = UIImage(systemName: "checkmark")!
            
        case .error:
            imageP = UIImage(systemName: "exclamationmark.triangle")!
            
        case .custom:
            break;
            
        }
        
        statusAlert = AlertNew.instantiate(
            withImage : imageP,
            title     : message.count < 20 ? message : "",
            message   : message.count >= 20 ? message : "",
            canBePickedOrDismissed: true)
        
        statusAlert?.appearance.tintColor       = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        statusAlert?.appearance.backgroundColor = #colorLiteral(red: 0.8934668837, green: 0.9241782767, blue: 0.9145140566, alpha: 1)
        
        statusAlert?.showInKeyWindow()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
            if let completionBlock = completion { completionBlock() }
        })
        
    }
    
}

func keyBoardDoneButton() -> some ToolbarContent {
    ToolbarItem(placement: .keyboard) {
        HStack {
            Spacer()
            Button("Done") {
                UIApplication.shared.endEditing()
            }
            .font(.system(size: 17, weight: .bold))
        }
    }
}

func dismissKeyboard() {
    UIApplication.shared.endEditing()
}


