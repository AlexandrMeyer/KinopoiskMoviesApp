//
//  MovieImageView.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 21.10.21.
//

import UIKit

class MovieImageView: UIImageView {
    func fetchImage(from url: String) {
        guard let url = URL(string: "https:\(url)") else {
            image = UIImage(systemName: "photo")
            return
        }
        
        // Используем изображение из кеша, если оно там есть
        if let cachedImage = getCachedImage(from: url) {
            image = cachedImage
            return
        }
        
        // Если изображения нет, то грузим его из сети
        NetworkManager.shared.fetchPoster(from: url) { data, response in
            self.image = UIImage(data: data)
            self.saveDataToCache(with: data, and: response)
        }
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
