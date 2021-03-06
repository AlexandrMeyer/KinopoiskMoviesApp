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
    var currentPage = Int.random(in: 1...1000)
    
    private var apiKinopoisk: String {
    "https://cloud-api.kinopoisk.dev/movies/all/page/\(currentPage)/token/3532f15744651d4229ace2cdc90359f3"
    }
    
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
            
            guard url.lastPathComponent == response.url?.lastPathComponent else { return }
            
            DispatchQueue.main.async {
                completion(data, response)
            }
        }.resume()
    }
}
