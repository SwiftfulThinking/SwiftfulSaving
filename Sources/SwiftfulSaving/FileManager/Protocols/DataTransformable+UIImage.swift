//
//  DataTransformable+UIImage.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 12/19/21.
//

import Foundation
import UIKit

// MARK: UIImage

extension UIImage {
    typealias PNG = ImagePNG
    typealias JPG = ImageJPG
}

// MARK: CONVENIENCE

extension UIImage {
    
    func jpg(compression: CGFloat? = nil) -> ImageJPG {
        ImageJPG(image: self, compression: compression)
    }
    
    func png() -> ImagePNG {
        ImagePNG(image: self)
    }
    
}

// MARK: DataTransformable

extension UIImage: DataTransformable {
    
    public func toData() -> Data? {
        self.jpegData(compressionQuality: 1)
    }

    public static let fileExtension: FMFileExtension = .jpg

    public static func fromData(data: Data) -> Self? {
        Self.init(data: data)
    }
    
}

// MARK: ImageJPG

struct ImageJPG {
    let image: UIImage
    let compression: CGFloat?
    
    init(image: UIImage, compression: CGFloat? = nil) {
        self.image = image
        self.compression = compression
    }
}

extension ImageJPG: DataTransformable {

    static let fileExtension: FMFileExtension = .jpg

    
    func toData() -> Data? {
        image.jpegData(compressionQuality: compression ?? 1.0)
    }

    static func fromData(data: Data) -> Self? {
        guard let image = UIImage(data: data) else { return nil }
        return self.init(image: image)
    }
    
    init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self.image = image
        self.compression = nil
    }


}

// MARK: ImagePNG

struct ImagePNG {
    let image: UIImage
}

extension ImagePNG: DataTransformable {

    static let fileExtension: FMFileExtension = .png

    func toData() -> Data? {
        image.pngData()
    }
    
    init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self.image = image
    }

}
