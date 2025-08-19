//
//  Recipes.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 15.08.2025.
//

import Foundation

struct Recipes: Codable {
    let recipes: [RecipeModel]
}

struct RecipeModel: Codable {
    let image: String
    let title: String
    let readyInMinutes: Int
    let spoonacularScore: Double
    let cuisines: [String]
    let dishTypes: [String]
    let extendedIngredients: [Ingredient]
    let analyzedInstructions: [Instruction]
}

struct Ingredient: Codable {
    let image: String?
    let name: String
    let amount: Double
    let unit: String
}

struct Instruction: Codable {
    let steps: [Step]
}

struct Step: Codable {
    let number: Int
    let step: String
}

