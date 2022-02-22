//
//  UIColor.swift
//  DreamCacher
//
//  Created by Nick Sarno on 8/14/21.
//

import Foundation
import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: .random(0, 1), green: .random(0, 1), blue:  .random(0, 1), alpha: 1.0)
    }
    
}
