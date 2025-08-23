//
//  KitchenModel.swift
//  BestRecipes
//
//  Created by Анастасия Тихонова on 22.08.2025.
//


import UIKit

// MARK: - Kitchen
struct Kitchen {
    let name: String
    let flag: String
    let imageUrl: String
}

extension Kitchen {
    static func getKitchens() -> [Kitchen] {
        return [
            Kitchen(name: "African", flag: "🌍", imageUrl: "https://img.spoonacular.com/recipes/638646-312x231.jpg"),
            Kitchen(name: "Asian", flag: "🌏", imageUrl: "https://img.spoonacular.com/recipes/654959-556x370.jpg"),
            Kitchen(name: "American", flag: "🇺🇸", imageUrl: "https://img.spoonacular.com/recipes/716426-556x370.jpg"),
            Kitchen(name: "British", flag: "🇬🇧", imageUrl: "https://img.spoonacular.com/recipes/716627-312x231.jpg"),
            Kitchen(name: "Cajun", flag: "🎺", imageUrl: "https://img.spoonacular.com/recipes/633841-312x231.jpg"),
            Kitchen(name: "Caribbean", flag: "🏝️", imageUrl: "https://img.spoonacular.com/recipes/648275-556x370.jpg"),
            Kitchen(name: "Chinese", flag: "🇨🇳", imageUrl: "https://img.spoonacular.com/recipes/641803-312x231.jpg"),
            Kitchen(name: "Eastern European", flag: "🇷🇺", imageUrl: "https://img.spoonacular.com/recipes/715538-312x231.jpg"),
            Kitchen(name: "European", flag: "🇪🇺", imageUrl: "https://img.spoonacular.com/recipes/716429-312x231.jpg"),
            Kitchen(name: "French", flag: "🇫🇷", imageUrl: "https://img.spoonacular.com/recipes/715447-312x231.jpg"),
            Kitchen(name: "German", flag: "🇩🇪", imageUrl: "https://img.spoonacular.com/recipes/716417-312x231.jpg"),
            Kitchen(name: "Greek", flag: "🇬🇷", imageUrl: "https://img.spoonacular.com/recipes/715495-556x370.jpg"),
            Kitchen(name: "Indian", flag: "🇮🇳", imageUrl: "https://img.spoonacular.com/recipes/660306-556x370.jpg"),
            Kitchen(name: "Irish", flag: "🇮🇪", imageUrl: "https://img.spoonacular.com/recipes/631763-312x231.jpg"),
            Kitchen(name: "Italian", flag: "🇮🇹", imageUrl: "https://img.spoonacular.com/recipes/716429-312x231.jpg"),
            Kitchen(name: "Japanese", flag: "🇯🇵", imageUrl: "https://img.spoonacular.com/recipes/654959-556x370.jpg"),
            Kitchen(name: "Jewish", flag: "✡️", imageUrl: "https://img.spoonacular.com/recipes/655247-556x370.jpg"),
            Kitchen(name: "Korean", flag: "🇰🇷", imageUrl: "https://img.spoonacular.com/recipes/660405-312x231.jpg"),
            Kitchen(name: "Latin American", flag: "🌎", imageUrl: "https://img.spoonacular.com/recipes/632660-556x370.jpg"),
            Kitchen(name: "Mediterranean", flag: "🌊", imageUrl: "https://img.spoonacular.com/recipes/648279-556x370.jpg"),
            Kitchen(name: "Mexican", flag: "🇲🇽", imageUrl: "https://img.spoonacular.com/recipes/632660-556x370.jpg"),
            Kitchen(name: "Middle Eastern", flag: "🧆", imageUrl: "https://img.spoonacular.com/recipes/635329-556x370.jpg"),
            Kitchen(name: "Nordic", flag: "❄️", imageUrl: "https://img.spoonacular.com/recipes/652997-312x231.jpg"),
            Kitchen(name: "Southern", flag: "🎸", imageUrl: "https://img.spoonacular.com/recipes/648275-556x370.jpg"),
            Kitchen(name: "Spanish", flag: "🇪🇸", imageUrl: "https://img.spoonacular.com/recipes/650495-556x370.jpg"),
            Kitchen(name: "Thai", flag: "🇹🇭", imageUrl: "https://img.spoonacular.com/recipes/652423-556x370.jpg"),
            Kitchen(name: "Vietnamese", flag: "🇻🇳", imageUrl: "https://img.spoonacular.com/recipes/660636-312x231.jpg")
        ]
    }
}
