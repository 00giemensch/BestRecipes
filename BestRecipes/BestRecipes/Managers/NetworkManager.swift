//
//  NetworkManager.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 15.08.2025.
//

import UIKit


enum NetworkError: Error {
    case invalidURL
    case decodingError
    case noData
    case noImage
    case urlSessionError(Error)
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    // MARK: - Private Properties
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    private let baseURL = "https://api.spoonacular.com/recipes"
    private let imageBaseURL = "https://img.spoonacular.com/ingredients_100x100/"
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchRandomRecipes(
        completion: @escaping ((Result<[RecipeModel], NetworkError>) -> Void)
    ) {
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
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                completion(.failure(.urlSessionError(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
//                print(jsonString)
            }

            do {
                let decodedData = try JSONDecoder().decode(Recipes.self, from: data)
                completion(.success(decodedData.recipes))
              //  decodedData.recipes.forEach({print($0.image)})
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func loadImage(
        from urlString: String,
        completion: @escaping ((Result<UIImage, NetworkError>) -> Void)
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(.urlSessionError(error)))
                return
            }
            
            guard let data, let image = UIImage(data: data) else {
                completion(.failure(.noImage))
                return
            }
            completion(.success(image))
        }.resume()
    }
    
    func loadIngredientImage(
        imageName: String?,
        completion: @escaping ((Result<UIImage, NetworkError>) -> Void)
    ) {
        guard let imageName else {
            completion(.failure(.noImage))
            return
        }
        
        let fullImagePath = imageBaseURL + imageName
        loadImage(from: fullImagePath, completion: completion)
    }
}
