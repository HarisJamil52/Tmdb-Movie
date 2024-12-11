//
//  MovieInfoModel.swift
//  Task TMDB
//
//  Created by Haris Jamil on 11/12/2024.
//

import Foundation

class MovieInfoModel: Codable {
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Float
    let popularity: Float
    let id: Int
    let title: String
    let overview: String
}
