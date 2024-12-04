//
//  RecipeCellComponent.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import SwiftUI

struct RecipeCellComponent: View {
    @State var recipe: Recipe
    var body: some View {
        LazyHStack {
            AsyncImageCached(url: URL(string: recipe.photoUrlSmall ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                case .failure(_):
                    Image(systemName: "questionmark")
                        .frame(width: 40, height: 40)
                        .background(Color.gray)
                        .clipShape(Circle())
                @unknown default:
                    Image(systemName: "questionmark")
                        .frame(width: 40, height: 40)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
            }
            VStack(alignment: .leading) {
                Text(recipe.name).font(.headline)
                Text(recipe.cuisine).font(.subheadline)
                
            }
        }
    }
}

#Preview {
    RecipeCellComponent(recipe: Recipe(recipeServerResponse: RecipeServerResponse(uuid: "2323", cuisine: "aetea", name: "ababab")))
}
