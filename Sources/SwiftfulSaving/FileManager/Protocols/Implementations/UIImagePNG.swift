//
//  URLTransformable+UIImage.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation
import UIKit

// Note: Removing default implementation of UIImage conforming to DataTransformable
// This will make developers decide between their own strategy, or using UIImage.PNG or UIImage.JPG

public extension UIImage {
    typealias PNG = ImagePNG
}

public extension UIImage {
    func png() -> ImagePNG {
        ImagePNG(image: self)
    }
}

public struct ImagePNG: URLTransformable, DataTransformable {
    public let image: UIImage

    public static let fileExtension: FMFileExtension = .png
    
    init(image: UIImage) {
        self.image = image
    }
    
    public init?(url: URL) {
        guard let image = UIImage(contentsOfFile: url.path) else { return nil }
        self.image = image
    }
    
    public init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self.image = image
    }
    
    public func toData() -> Data? {
        image.pngData()
    }
}
