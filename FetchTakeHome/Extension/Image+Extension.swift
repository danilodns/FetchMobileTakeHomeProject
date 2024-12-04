//
//  Image+Extension.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-04.
//

import SwiftUI

extension Image {
    // Convert SwiftUI Image to UIImage
    @MainActor func asUIImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        if let image = renderer.cgImage {
            return UIImage(cgImage: image)
        }
        return nil
    }
}
