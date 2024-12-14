//
//  NetworkManager.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import Foundation

protocol APIProtocol {
    func fetchRecipes() async -> (response: RecipeResponse?, error: Error?)
}

fileprivate enum Endpoint {
    var baseURL: String { "https://d3jbb8n5wk0qxi.cloudfront.net/" }
    
    case recipes
    case malformedData
    case emptyData
    
    // variable used to concatenate the api domain and paths
    var rawValue: String {
        switch self {
        case .recipes: return "recipes.json"
        case .malformedData: return "recipes-malformed.json"
        case .emptyData: return "recipes-empty.json"
        }
    }
    
    var url: URL? { URL(string:baseURL + rawValue) }
}

class NetworkManager: APIProtocol {
    static let shared = NetworkManager()
    
    private func fetchData(endpoint: Endpoint) async -> (response: RecipeResponse?, error: Error?) {
        guard let url = endpoint.url else {
            return (nil, NetworkError.invalidURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let responseURL = response as? HTTPURLResponse else {
                return (nil, NetworkError.invalidURL)
            }
            switch responseURL.statusCode {
            case 200..<300:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(RecipeResponse.self, from: data)
                return (result, nil)
            case 400..<500:
                return (nil, NetworkError.clientError(statusCode: responseURL.statusCode))
            case 500..<600:
                return (nil, NetworkError.serverError(statusCode: responseURL.statusCode))
            default:
                return (nil, NetworkError.noData)
            }
            
        } catch _ as DecodingError {
            return (nil, NetworkError.invalidDataFormart)
        } catch let urlError as URLError {
            return (nil, NetworkError.networkFailure(error: urlError))
        } catch {
            return (nil, NetworkError.unknowenError(error: error))
        }
    }
    
    func fetchRecipes() async -> (response: RecipeResponse?, error: Error?) {
        await fetchData(endpoint: .recipes)
    }
    
    func fetchRecipesMalformed() async -> (response: RecipeResponse?, error: Error?) {
        await fetchData(endpoint: .malformedData)
    }
    
    func fetchEmptyRecipes() async -> (response: RecipeResponse?, error: Error?) {
        await fetchData(endpoint: .emptyData)
    }
}

// Created this Enum to help developers to handle the errors. If any of errors should be send to the user we can show in an AlertView or any other way the designer choose. I add the localized description to give better message.
enum NetworkError: LocalizedError {
    case noData
    case invalidDataFormart
    case invalidToken
    case invalidURL
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    // Indicates there was a network-related issue, like no internet connection.
    case networkFailure(error: Error)
    case unknowenError(error: Error)
    
    /// A localized message describing the reason for the failure.
    var failureReason: String? { "" }
    
    var errorDescription: String? {
        switch self {
        case .invalidDataFormart:
            return "Invalid data format was received from the server"
        case .invalidToken:
            return "No user token set or it is invalid"
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server"
        case .clientError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        case .serverError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        case .networkFailure(let error):
            return "Network request failed with error: \(error.localizedDescription)"
        case .unknowenError(error: let error):
            return "Unknowen Network error: \(error.localizedDescription)"
        }
    }
}
