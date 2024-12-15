//
//  ImageCacheTest.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-14.
//

import Testing
import UIKit
import SwiftUI

@testable import FetchTakeHome

struct ImageCacheTest {

    @Test func testCacheImageWheater() async throws {
        guard let url = URL(string: "https://www.test.com/photosTest/image.png") else { return }
        ImageCache[url] = UIImage(systemName: "person")
        #expect(ImageCache[url] != nil)
        do {
            try ImageCache.delete(url: url)
            #expect(ImageCache[url] == nil)
        } catch {
            fatalError()
        }
    }
    
    @Test func testImageConversionToUIImage() async throws {
        let image = Image(systemName: "person")
        let uiImage = await image.asUIImage()
        #expect(uiImage != nil)
    }

}
