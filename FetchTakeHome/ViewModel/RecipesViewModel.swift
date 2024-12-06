//
//  RecipesViewModel.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import Foundation

class RecipesViewModel: ObservableObject {
    private var recipes: [Recipe] = [] {
        didSet {
            selectedFilters = Set(recipes.map(\..cuisine))
            cusines = selectedFilters.sorted()
        }
    }
    @Published var filteredRecipes: [Recipe] = []
    @Published var error: NetworkError?
    @Published var hasError: Bool = false
    @Published var selectedFilters: Set<String> = [] {
        didSet {
            filteredRecipes = recipes.filter({ selectedFilters.contains($0.cuisine)})
        }
    }
    var cusines: [String] = []
    let api: APIProtocol
    
    init(api: APIProtocol = NetworkManager.shared) {
        self.api = api
    }
    
    func fetchRecipes() async {
        let result = await api.fetchRecipes()
        await MainActor.run {
            recipes = result.response?.recipes.compactMap({ Recipe(recipeServerResponse: $0) }) ?? []
            error = result.error as? NetworkError
            if error != nil {
                hasError.toggle()
            }
        }
        
    }
    
    func selectAllFilters() {
        selectedFilters = Set(cusines)
    }
    
    func deselectAllFilters() {
        selectedFilters = []
    }
    
    func toggleFilter(_ filter: String) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
    }
}
