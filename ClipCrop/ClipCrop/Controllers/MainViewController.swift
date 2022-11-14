//
//  ViewController.swift
//  ClipCrop
//
//  Created by Todor Dimitrov on 13.11.22.
//

import UIKit
import FYPhoto

protocol PhotoPickerDelegate: AnyObject {
    func openPhotoPicker()
}

class MainViewController: UIViewController {
    
    //MARK: IBActions
    @IBOutlet private weak var selectBtn: UIButton!
    
    private var pickerConfig = FYPhotoPickerConfiguration()
    private var photoPickerVC: PhotoPickerViewController?
    private var videoURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupPickerConfig()
        setupPickerViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.openPhotoPicker()
        })

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openVideo",
            let url = videoURL {
            let vc = segue.destination as! VideoPlayer
            vc.configure(url: url, photoPickerDelegate: self)
        }
    }

}

//MARK: Helpers
extension MainViewController {
    private func setupPickerConfig() {
        pickerConfig.selectionLimit = 0
        pickerConfig.supportCamera = true
        pickerConfig.mediaFilter = [.video]
        
        // Color
        let colorConfig = FYColorConfiguration()
        colorConfig.topBarColor = FYColorConfiguration.BarColor(itemTintColor: .white,
                                                                itemDisableColor: .gray,
                                                                itemBackgroundColor: .gray,
                                                                backgroundColor: .gray)
        
        // Similar setting code for pickerBottomBarColor and browserBottomBarColor
        
        pickerConfig.colorConfiguration = colorConfig
        
        pickerConfig.compressedQuality = .mediumQuality
        pickerConfig.maximumVideoMemorySize = 40 // MB
        pickerConfig.maximumVideoDuration = 15 // Secs
    }
    
    private func setupPickerViewController() {
        photoPickerVC = PhotoPickerViewController(configuration: pickerConfig)
        if let photoPickerVC = photoPickerVC {
            photoPickerVC.selectedVideo = { [weak self] selectedResult in
                switch selectedResult {
                case .success(let video):
                    self?.videoURL = video.url
                    self?.performSegue(withIdentifier: "openVideo", sender: nil)
                case .failure(let error):
                    print("selected video error: \(error)")
                }
            }
        }
    }
}

//MARK: PhotoPickerDelegate
extension MainViewController: PhotoPickerDelegate {
    func openPhotoPicker() {
            if let photoPickerVC = self.photoPickerVC {
                photoPickerVC.modalPresentationStyle = .fullScreen
                self.present(photoPickerVC, animated: false, completion: nil)
            }
    }
}


