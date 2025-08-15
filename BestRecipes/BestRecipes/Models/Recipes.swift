//
//  Recipes.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 15.08.2025.
//

import Foundation

struct Recipes: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable {
    let image: String
    let title: String
    let readyInMinutes: Int
    let extendedIngredients: [Ingredient]
}

struct Ingredient: Codable {
    let name: String
    let amount: Double
    let unit: String
}

