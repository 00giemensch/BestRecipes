//
//  NetworkManager.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 15.08.2025.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case decodingError
    case noData
    case urlSessionError(Error)
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    // MARK: - Private Properties
    private let apiKey = "e6c43b44170840ab8cd46bedce80bf3f"
    private let baseURL = "https://api.spoonacular.com/recipes"
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchRandomRecipes(completion: @escaping ((Result<[Recipe], NetworkError>) -> Void)) {
        let parameters: [String: Any] = [
            "apiKey": apiKey,
            "number": 10
        ]
        
        guard var urlComponents = URLComponents(string: "\(baseURL)/random") else {
            completion(.failure(.invalidURL))
            return
        }
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.urlSessionError(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Recipes.self, from: data)
                completion(.success(decodedData.recipes))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
