//
//  Double.swift
//  SwiftfulSavingTests
//
//  Created by Nick Sarno on 1/2/22.
//

import Foundation

extension Double {
    
    static func random() -> Double {
        return Double(arc4random()) / Double(UInt32.max)
    }

}
