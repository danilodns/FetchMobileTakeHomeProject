//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.recipes, id: \.self) { recipe in
                RecipeCellComponent(recipe: recipe)
            }
        }.alert(viewModel.error?.localizedDescription ?? "Error", isPresented: $viewModel.hasError, actions: {
            
        })
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    ContentView(viewModel: RecipesViewModel())
}
