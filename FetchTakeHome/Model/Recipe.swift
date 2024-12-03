//
//  Recipe.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

struct Recipe: Decodable {
    var uuid: String
    var cuisine: String
    var name: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var sourceUrl: String?
    var youtubeUrl: String?
}
