//
//  UIImage.swift
//  DreamCacher
//
//  Created by Nick Sarno on 8/14/21.
//

import Foundation
import UIKit

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    static func random(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        return UIImage(color: UIColor.random(), size: size)
    }
    
}
