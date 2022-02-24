//
//  Double.swift
//  DreamCacher
//
//  Created by Nick Sarno on 8/14/21.
//

import Foundation

extension Double {
    
    var convertingMBToBytes: Int {
        let bytes: Double = self * 1000000
        let bytesAsInt: Int = Int(bytes.rounded(.up))
        return bytesAsInt
    }
        
}
