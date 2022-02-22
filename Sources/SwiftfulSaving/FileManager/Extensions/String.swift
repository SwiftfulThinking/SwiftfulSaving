//
//  String.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/2/22.
//

import Foundation

extension String {
    
    func lowercasedWithoutSpacesOrPunctuation() -> Self {
        var lowercased = self.lowercased()
        lowercased.removeAll(where: { $0.isPunctuation })
        lowercased = lowercased.replacingOccurrences(of: " ", with: "_")
        lowercased = lowercased.replacingOccurrences(of: "-", with: "_")
        return lowercased
    }
    
}
