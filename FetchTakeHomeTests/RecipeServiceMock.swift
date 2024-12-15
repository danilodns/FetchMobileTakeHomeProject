//
//  RecipeServiceMock.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-14.
//

@testable import FetchTakeHome

class RecipeServiceMock: APIProtocol {
    let recipeResponse:RecipeResponse = RecipeResponse(recipes: [
            RecipeServerResponse(uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", cuisine: "Malaysian", name: "Apam Balik", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
            RecipeServerResponse(uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", cuisine: "British", name: "Apple & Blackberry Crumble", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg"),
            RecipeServerResponse(uuid: "eed6005f-f8c8-451f-98d0-4088e2b40eb6", cuisine: "British", name: "akewell Tart", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/small.jpg")])
    
    let recipeMalformadResponse:RecipeResponse = RecipeResponse(recipes: [
            RecipeServerResponse(uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", cuisine: "Malaysian", name: "Apam Balik", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
            RecipeServerResponse(uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", cuisine: "British", name: "Apple & Blackberry Crumble", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg"),
            RecipeServerResponse(uuid: "eed6005f-f8c8-451f-98d0-4088e2b40eb6", cuisine: "British", name: "akewell Tart", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/small.jpg")])
    
    var shouldReturnError:Bool = false
    var shouldReturnEmptyResponse:Bool = false
    
    func fetchRecipes() async -> (response: FetchTakeHome.RecipeResponse?, error: (any Error)?) {
        if shouldReturnError {
            return (nil, NetworkError.invalidDataFormart)
        } else if shouldReturnEmptyResponse {
            return (RecipeResponse(recipes: []), nil)
        } else {
            return (recipeResponse, nil)
        }
    }
}
