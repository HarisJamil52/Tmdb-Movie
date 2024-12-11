//
//  PopularResponseModel.swift
//  Task TMDB
//
//  Created by Haris Jamil on 11/12/2024.
//

import Foundation

class PopularResponseModel: Decodable {
    let page: Int
    let results: [MovieInfoModel]
    let totalPages: Int
    let totalResults: Int
}
