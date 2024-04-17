//
//  PAImageCacheManager.swift
//  PAGrid
//
//  Created by Admin on 15/04/24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private lazy var diskCacheDirectory: URL = {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = paths[0].appendingPathComponent("Bheema_ImageCache")
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        return cacheDirectory
    }()
    private let imageDownloadQueue = DispatchQueue(label: "com.example.ImageDownloadQueue")
    
    private init() {}
    
    func getImage(mediaObj: MediaCoverage, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Check memory cache
        if let cachedImage = memoryCache.object(forKey: mediaObj.id as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        // Check disk cache
        let diskCacheURL = diskCacheDirectory.appendingPathComponent(mediaObj.id)
        if let diskCachedImage = UIImage(contentsOfFile: diskCacheURL.path) {
            // Store in memory cache for future use
            memoryCache.setObject(diskCachedImage, forKey: mediaObj.id as NSString)
            completion(.success(diskCachedImage))
            return
        }
        
        // Fetch image from API
        imageDownloadQueue.async {
            do {
                //URL(string: $0.coverageURL
                let imageData = try Data(contentsOf: URL(string:mediaObj.coverageURL)!)
                guard let image = UIImage(data: imageData) else {
                    completion(.failure(ImageCacheError.invalidImageData))
                    return
                }
                
                // Store in memory cache
                self.memoryCache.setObject(image, forKey: mediaObj.id as NSString)
                
                // Store in disk cache
                try imageData.write(to: diskCacheURL)
                
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum ImageCacheError: Error {
    case invalidImageData
}
