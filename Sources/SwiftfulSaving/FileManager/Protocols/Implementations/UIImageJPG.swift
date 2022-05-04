//
//  File.swift
//  
//
//  Created by Nick Sarno on 5/3/22.
//

import Foundation
import UIKit

// Note: Removing default implementation of UIImage conforming to DataTransformable
// This will make developers decide between their own strategy, or using UIImage.PNG or UIImage.JPG

public extension UIImage {
    typealias JPG = ImageJPG
}

public extension UIImage {
    func jpg(compression: CGFloat? = nil) -> ImageJPG {
        ImageJPG(image: self, compression: compression)
    }
}

public struct ImageJPG: URLTransformable, DataTransformable {
    public let image: UIImage
    let compression: CGFloat?
    
    init(image: UIImage, compression: CGFloat? = nil) {
        self.image = image
        self.compression = compression
    }
    
    public init?(url: URL) {
        guard let image = UIImage(contentsOfFile: url.path) else { return nil }
        self.image = image
        self.compression = nil
    }
    
    public init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self.image = image
        self.compression = 1.0
    }

    public static let fileExtension: FMFileExtension = .jpg
    
    public func toData() -> Data? {
        image.jpegData(compressionQuality: compression ?? 1.0)
    }
    
}
