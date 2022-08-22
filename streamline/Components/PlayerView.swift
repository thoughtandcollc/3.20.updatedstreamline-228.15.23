//
//  PlayerView.swift
//  streamline
//
//  Created by Tayyab Ali on 19/05/2022.
//

import SwiftUI
import UIKit
import AVKit

struct PlayerViewController: UIViewControllerRepresentable {
    var videoURL: URL?
    
    private var player: AVPlayer {
        return AVPlayer(url: videoURL!)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller =  AVPlayerViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.player = player
        controller.player?.play()
        return controller
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        
    }
}
