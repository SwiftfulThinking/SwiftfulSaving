//
//  CGFloat.swift
//  DreamCacher
//
//  Created by Nick Sarno on 8/14/21.
//

import Foundation
import UIKit

public extension CGFloat {
    
    static func random(_ lower: CGFloat = -999999, _ upper: CGFloat = 999999) -> CGFloat {
        return CGFloat.random(in: lower...upper)
    }
    
}
