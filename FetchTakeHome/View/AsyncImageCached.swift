//
//  AsyncImageCached.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import SwiftUI
import os

// Create to cache the images on memory

class ImageCache {
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: ImageCache.self)
        )
    static private let fileManager = FileManager.default
    
    static private var cacheDirectory: URL? {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    static subscript(url: URL) -> UIImage? {
        get {
            // Fetch UIImage from disk
            return fetchImageData(with: String(url.relativePath.dropFirst()))
        }
        set {
            // Save UIImage to disk
            if let newValue = newValue {
                save(newValue, for: String(url.relativePath.dropFirst()))
            }
        }
    }
    
    static func save(_ uiImage: UIImage, for url: String) {
        // Convert UIImage to PNG data
        guard let data = uiImage.pngData() else {
            logger.error("Failed to convert UIImage to PNG data.")
            return
        }
        
        // Save the PNG data to disk
        guard let cacheDirectory = cacheDirectory else {
            logger.error("Failed to locate cache directory.")
            return
        }
        
        
        let fileURL = cacheDirectory.appendingPathComponent(url)
        let folderURL = fileURL.deletingLastPathComponent()
        
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                logger.info( "Folder created at \(folderURL)")
            } catch {
                logger.error("Error creating folder: \(error.localizedDescription)")
                return
            }
        }
        do {
            try data.write(to: fileURL)
            logger.info("Image saved to disk at: \(fileURL)")
        } catch {
            logger.error("Error saving image to disk: \(error)")
        }
    }
    
    static func delete(url: URL) throws {
        guard let cacheDirectory = cacheDirectory else { return }
        let fileURL = cacheDirectory.appendingPathComponent(String(url.relativePath.dropFirst()))
        try FileManager.default.removeItem(at: fileURL)
    }
    
    static func fetchImageData(with fileName: String) -> UIImage? {
        guard let cacheDirectory = cacheDirectory else { return nil }
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}



/// Class to show image from cache or Download image using AsyncImage and cache the image
struct AsyncImageCached<Content>: View where Content: View{
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(url: URL?,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let url, let cached = fetchFromCache(url: url) {
            content(.success(Image(uiImage: cached)))
        } else {
            AsyncImage(url: url,scale: scale, transaction: transaction) { phase in
                cacheAndShow(phase: phase)
            }
        }
    }
    
    private func fetchFromCache(url: URL) -> UIImage? {
        // Access the cache in a non-SwiftUI-dependent manner
        return ImageCache[url]
    }
    
    private func cacheImage(_ image: Image, for url: URL) {
        guard let uiImage = image.asUIImage() else {
            return
        }
        ImageCache[url] = uiImage
    }
    
    func cacheAndShow(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase, let url {
            cacheImage(image, for: url)
        }
        return content(phase)
    }
}
