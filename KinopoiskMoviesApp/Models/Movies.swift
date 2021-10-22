//
//  Movie.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 12.10.21.
//

import Foundation

struct Movies: Codable {
    let movies: [Film]
}

struct Film: Codable {
    let title: String
    let titleEn: String?
    var description: String?
    let poster: String?
    let year: Int?
    let directors: [String]?
    let actors: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case titleEn = "title_alternative"
        case description
        case poster
        case year
        case actors
        case directors
    }
}

