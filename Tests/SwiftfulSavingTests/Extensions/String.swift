//
//  String.swift
//  SwiftfulSavingTests
//
//  Created by Nick Sarno on 1/2/22.
//

import Foundation

extension String {
    
    static func randomString(length: Int = Int.random(in: 0...50)) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
