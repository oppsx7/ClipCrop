//
//  Extensions.swift
//  ClipCrop
//
//  Created by Todor Dimitrov on 13.11.22.
//
import UIKit
import Foundation

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}


