//
//  VideoPlayer.swift
//  ClipCrop
//
//  Created by Todor Dimitrov on 13.11.22.
//

import Foundation
import UIKit
import AVFoundation
import BackgroundRemoval

class VideoPlayer: UIViewController {
    //MARK: IBOutlets
    @IBOutlet private weak var magicSelectionSwitch: UISwitch!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var playerView: UIView!
    
    private weak var photoPickerDelegate: PhotoPickerDelegate?
    private var playerAV: AVPlayer!
    private var url: URL?
    private var playingView: UIView!
    
    override func viewDidLoad() {
        self.playVideo(videourl: url!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        photoPickerDelegate?.openPhotoPicker()
    }
    
    func configure(url: URL, photoPickerDelegate: PhotoPickerDelegate) {
        self.url = url
        self.photoPickerDelegate = photoPickerDelegate
    }
    
    func playVideo(videourl: URL) {
        configureVideoPlayer(videoURL: videourl)
        playerAV.play()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(animationDidFinish(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerAV.currentItem)
    }
    
    
    //this is done in order to have endless loop
    @objc func animationDidFinish(_ notification: NSNotification) {
        playerAV.seek(to: .zero)
        playerAV.play()
    }
    
    @IBAction func didTapMagicSelection(_ sender: Any) {
        if magicSelectionSwitch.isOn {
            playerAV.pause()
            playerView.bringSubviewToFront(getImageViewForCroppedImage())
        } else {
            playerAV.play()
            playerView.bringSubviewToFront(playingView)
        }
    }
}

//MARK: Helpers

extension VideoPlayer {
    private func configureVideoPlayer(videoURL: URL) {
        playerAV = AVPlayer(url: videoURL)
        let playerLayerAV = AVPlayerLayer(player: playerAV)
        playerLayerAV.frame = playerView.bounds
        playerLayerAV.videoGravity = .resizeAspectFill
        playingView = UIView(frame: CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height))
        playingView.layer.addSublayer(playerLayerAV)
        playerView.addSubview(playingView)
    }
    
    private func getImageViewForCroppedImage() -> UIImageView {
        let image = BackgroundRemoval.init().removeBackground(image: playerView.asImage())
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = self.view.backgroundColor
        imageView.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        imageView.contentMode = .scaleAspectFill
        playerView.addSubview(imageView)
        return imageView
    }
}
