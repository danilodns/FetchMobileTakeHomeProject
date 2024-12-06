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
        HStack(alignment: .top) {
            AsyncImageCached(url: URL(string: recipe.photoUrlSmall ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    Image(systemName: "questionmark")
                        
                @unknown default:
                    Image(systemName: "questionmark")
                }
            }.frame(width: 50, height: 50)
                .background(Color.gray)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(recipe.cuisine).font(.subheadline)
                    
            }
        }
    }
}

#Preview {
    RecipeCellComponent(recipe: Recipe(recipeServerResponse: RecipeServerResponse(uuid: "2323", cuisine: "Polish", name: "Polskie NaleÅ›nikis sa Cukierkami (Polish Pancakes)", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8b526c42-5121-4ddf-b8f9-a0c1153b5c20/small.jpg")))
}
