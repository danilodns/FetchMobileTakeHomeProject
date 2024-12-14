//
//  Recipe.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

struct Recipe: Hashable, Decodable {
    var id: String
    var cuisine: String
    var name: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var sourceUrl: String?
    var youtubeUrl: String?
    
    init(recipeServerResponse: RecipeServerResponse) {
        self.id = recipeServerResponse.uuid
        self.cuisine = recipeServerResponse.cuisine
        self.name = recipeServerResponse.name
        self.photoUrlLarge = recipeServerResponse.photoUrlLarge
        self.photoUrlSmall = recipeServerResponse.photoUrlSmall
        self.sourceUrl = recipeServerResponse.sourceUrl
        self.youtubeUrl = recipeServerResponse.youtubeUrl
    }
}
