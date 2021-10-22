//
//  Movie.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 12.10.21.
//

import Foundation

struct Movies: Codable {
    let movies: [Film]
    let pagination: Pagination
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

struct Pagination: Codable {
    let currentPage: String?
    let endPage: String?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case endPage = "end_page"
    }
}

