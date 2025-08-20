//
//  SceneDelegate.swift
//  BestRecipes
//
//  Created by Ilnur on 11.08.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // Check if onboarding was shown using the storage service
        let storage = OnboardingStorage()
        
        // TEMPORARY: Reset onboarding for testing - REMOVE THIS LINE AFTER TESTING
        storage.resetOnboardingState()
        
        let onboardingShown = storage.isOnboardingShown()
        
        if onboardingShown {
            // Show main app
            window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        } else {
            // Show onboarding
            window?.rootViewController = OnboardingViewController()
        }
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

