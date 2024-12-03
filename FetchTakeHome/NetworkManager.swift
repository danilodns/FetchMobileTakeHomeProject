//
//  NetworkManager.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let recipesEndpoint: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    func fetchRecipes() async -> (recipes: [Recipe], error: Error?) {
        guard let url = URL(string: recipesEndpoint) else {
            return ([], NetworkError.invalidURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let responseURL = response as? HTTPURLResponse else {
                return ([], NetworkError.invalidURL)
            }
            switch responseURL.statusCode {
            case 200..<300:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode([Recipe].self, from: data)
                return (result, nil)
            case 400..<500:
                return ([], NetworkError.clientError(statusCode: responseURL.statusCode))
            case 500..<600:
                return ([], NetworkError.serverError(statusCode: responseURL.statusCode))
            default:
                return ([], NetworkError.noData)
            }
            
        } catch let decodingError as DecodingError {
            return ([], NetworkError.invalidDataFormart)
        } catch let urlError as URLError {
            return ([], NetworkError.networkFailure(error: urlError))
        } catch {
            return ([], NetworkError.unknowenError(error: error))
        }
        
    }
}

// Created this Enum to help developers to handle the errors. If any of errors should be send to the user we can show in an AlertView or any other way the designer choose. I add the localized description to give better message.
enum NetworkError: Error {
    case noData
    case invalidDataFormart
    case invalidToken
    case invalidURL
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    // Indicates there was a network-related issue, like no internet connection.
    case networkFailure(error: Error)
    case unknowenError(error: Error)
    
    var localizedDescription: String {
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
