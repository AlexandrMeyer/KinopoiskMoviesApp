//
//  NetworkManager.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 12.10.21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let apiKinopoisk = "https://api.kinopoisk.cloud/movies/all/page/666/token/7d35e318283a3c4e7b4b4ff049a57fc4"
    
    private init() {}
    
    func fetchMoviesInfo(completion: @escaping(Result<Movies, NetworkError>) -> Void) {
        guard let url = URL(string: apiKinopoisk) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let moviesInfo = try jsonDecoder.decode(Movies.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(moviesInfo))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchPoster(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard url == response.url else { return }
            
            DispatchQueue.main.async {
                completion(data, response)
            }
        }.resume()
    }
    
    func fetchPoster(from url: String?) -> Data? {
        guard let stringURL = url else { return nil }
        guard let url = URL(string: "https:\(stringURL)") else { return nil }
        return try? Data(contentsOf: url)
    }
}
