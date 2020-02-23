//
//  ImageDownloader.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation
import UIKit

final class UIImageLoader {
    
    static let loader = UIImageLoader()
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ url: URL, for imageView: UIImageView) {
        
        let token = imageLoader.loadImage(url) { (result) in
            
            DispatchQueue.main.async {
                do { self.uuidMap.removeValue(forKey: imageView) }
            }
            
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                
            }
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = self.uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
    
}

final private class ImageLoader {
    
    private var loadImageRequest = [URL: UIImage]()
    private var runningRequest = [UUID: URLSessionDataTaskProtocol]()
    
    func loadImage(_ url: URL,
                   using session: URLSessionProtocol = URLSession.shared,
                   _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = loadImageRequest[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            defer { self.runningRequest.removeValue(forKey: uuid)}
            
            if let data = data, let image = UIImage(data: data) {
                self.loadImageRequest[url] = image
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        
        task.resume()
        
        runningRequest[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequest[uuid]?.cancel()
        runningRequest.removeValue(forKey: uuid)
    }
}
