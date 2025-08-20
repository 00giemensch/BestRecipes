//
//  OnboardingPage.swift
//  BestRecipes
//
//  Created by Nurislam on 20.08.2025.
//

import Foundation

// MARK: - Onboarding Error
enum OnboardingError: Error, LocalizedError {
    case invalidPageData
    case missingImage
    case emptyTitle
    case failedToSaveState
    
    var errorDescription: String? {
        switch self {
        case .invalidPageData:
            return "Invalid onboarding page data"
        case .missingImage:
            return "Onboarding image not found"
        case .emptyTitle:
            return "Onboarding page title cannot be empty"
        case .failedToSaveState:
            return "Failed to save onboarding state"
        }
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage {
    let image: String
    let title: String
    let subtitle: String?
    let buttonTitle: String
    let showSkip: Bool
    
    // MARK: - Validation
    func validate() throws {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw OnboardingError.emptyTitle
        }
        
        guard !image.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw OnboardingError.missingImage
        }
        
        guard !buttonTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw OnboardingError.invalidPageData
        }
    }
    
    // MARK: - Static Data
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            image: "onboarding1",
            title: "Best Recipe",
            subtitle: "Find best recipes for cooking",
            buttonTitle: "Get started",
            showSkip: false
        ),
        OnboardingPage(
            image: "onboarding2", 
            title: "Recipes from all over the World",
            subtitle: nil,
            buttonTitle: "Continue",
            showSkip: true
        ),
        OnboardingPage(
            image: "onboarding3",
            title: "Recipes with each and every detail", 
            subtitle: nil,
            buttonTitle: "Continue",
            showSkip: true
        ),
        OnboardingPage(
            image: "onboarding4",
            title: "Cook it now or save it for later",
            subtitle: nil,
            buttonTitle: "Start Cooking",
            showSkip: true
        )
    ]
    
    // MARK: - Validated Pages
    static var validatedPages: [OnboardingPage] {
        return pages.compactMap { page in
            do {
                try page.validate()
                return page
            } catch {
                print("⚠️ Onboarding page validation failed: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
