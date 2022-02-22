//
//  Data.swift
//  DreamCacher
//
//  Created by Nick Sarno on 8/14/21.
//

import Foundation

extension Data {

    var bytes: Int {
        [UInt8](self).count
    }

}
