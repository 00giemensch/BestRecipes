//
//  PopularKiitchenModels.swift
//  BestRecipes
//
//  Created by Анастасия Тихонова on 21.08.2025.
//


// MARK: Model

struct Kitchen {
    let id: Int
    let name: String
    var flagEmoji: String
    let ImageUrl: String
    let isPopular: Bool
    
    
    init (id: Int, name: String, flagEmoji:String, imageUrl:String, isPopular:Bool) {
        
        self.id = id
        self.name = name
        self.flagEmoji = flagEmoji
        self.ImageUrl = imageUrl
        self.flagEmoji = flagEmoji
        self.isPopular = isPopular
    }
}

class KitchenService {
    func getPopularKitchen() -> [Kitchen] {
      return [
    Kitchen(id: 1, name: "Italian cuisine", flagEmoji: "🇮🇹", imageUrl:"https://img.spoonacular.com/recipes/716429-312x231.jpg", isPopular: true),
    Kitchen(id: 2, name: "Asian cuisine", flagEmoji: "🇯🇵",imageUrl: "https://img.spoonacular.com/recipes/654959-556x370.jpg", isPopular: true),
    Kitchen(id: 3, name: "Russian cuisine", flagEmoji: "🇷🇺",imageUrl: "https://img.spoonacular.com/recipes/715538-312x231.jpg", isPopular: true),
          Kitchen(id: 4, name: "Mexican cuisine", flagEmoji: "🇲🇽", imageUrl: "https://img.spoonacular.com/recipes/632660-556x370.jpg", isPopular: true),
          Kitchen(id: 5, name: "French cuisine", flagEmoji: "🇫🇷", imageUrl: "https://img.spoonacular.com/recipes/715447-312x231.jpg", isPopular: true)
      ]
  }
}

