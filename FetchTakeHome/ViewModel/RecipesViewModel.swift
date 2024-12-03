//
//  RecipesViewModel.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import Foundation

class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var error: Error?
    
    let api: APIProtocol
    
    init(api: APIProtocol = NetworkManager.shared) {
        self.api = api
    }
    
    func fetchRecipes() async {
        let result = await api.fetchRecipes()
        recipes = result.recipes.map({ Recipe(recipeServerResponse: $0) })
        error = result.error
    }
}
