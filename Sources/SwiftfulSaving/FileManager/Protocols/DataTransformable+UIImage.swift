//
//  DataTransformable+UIImage.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation
import UIKit

// MARK: UIImage

public extension UIImage {
    typealias PNG = ImagePNG
    typealias JPG = ImageJPG
}

// MARK: CONVENIENCE

public extension UIImage {
    
    func jpg(compression: CGFloat? = nil) -> ImageJPG {
        ImageJPG(image: self, compression: compression)
    }
    
    func png() -> ImagePNG {
        ImagePNG(image: self)
    }
    
}

// MARK: DataTransformable
// Note: Removing default implementation of UIImage conforming to DataTransformable
// This will make developers decide between their own strategy, or using UIImage.PNG or UIImage.JPG

//extension UIImage: DataTransformable {
//
//    public func toData() -> Data? {
//        self.jpegData(compressionQuality: 1)
//    }
//
//    public static let fileExtension: FMFileExtension = .jpg
//
//    public static func fromData(data: Data) -> Self? {
//        Self.init(data: data)
//    }
//
//}

// MARK: ImageJPG

public struct ImageJPG {
    public let image: UIImage
    let compression: CGFloat?
    
    init(image: UIImage, compression: CGFloat? = nil) {
        self.image = image
        self.compression = compression
    }
}

extension ImageJPG: DataTransformable {

    public static let fileExtension: FMFileExtension = .jpg

    
    public func toData() -> Data? {
        image.jpegData(compressionQuality: compression ?? 1.0)
    }
    
    public init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self.image = image
        self.compression = nil
    }

    public static let canBeCached: Bool = true
}

// MARK: ImagePNG

public struct ImagePNG {
    public let image: UIImage
}

extension ImagePNG: DataTransformable {

    public static let fileExtension: FMFileExtension = .png

    public func toData() -> Data? {
        image.pngData()
    }
    
    public init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self.image = image
    }
    
    public static let canBeCached: Bool = true
}
