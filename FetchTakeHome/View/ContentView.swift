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
            VStack {
                if $viewModel.filteredRecipes.isEmpty {
                    VStack {
                        Text("No recipes are available.")
                        Button("Refresh") {
                            Task {
                                await viewModel.fetchRecipes()
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.filteredRecipes, id: \.id) { recipe in
                            VStack {
                                RecipeCellComponent(recipe: recipe)
                            }
                        }
                        
                    }
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
        .alert(isPresented: $viewModel.hasError, error: viewModel.error, actions: { localizedError in
            Button("Cancel", role: .cancel) {
                
            }
            Button("Retry") {
                Task {
                    await viewModel.fetchRecipes()
                }
            }
            
        }, message: { localizedError in
            Text("Try again in a few minutes")
        })
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    ContentView()
}
