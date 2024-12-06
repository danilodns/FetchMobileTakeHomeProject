//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RecipesViewModel()
    @State var isOpenedOptionView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredRecipes, id: \.self) { recipe in
                    RecipeCellComponent(recipe: recipe)
                }
            }.refreshable {
                await viewModel.fetchRecipes()
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    isOpenedOptionView.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }

            }
        }.sheet(isPresented: $isOpenedOptionView) {
            FilterRecipeView(filterRecipeVM: viewModel)
        }
        .alert(viewModel.error?.localizedDescription ?? "Error", isPresented: $viewModel.hasError, actions: {
            
        })
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    ContentView()
}
