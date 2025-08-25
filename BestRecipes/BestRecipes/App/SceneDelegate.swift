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
        
//        // Check if onboarding was shown using the storage service
//        let storage = UserStorage.shared
//        
//        // TEMPORARY: Reset onboarding for testing - REMOVE THIS LINE AFTER TESTING
////        storage.resetOnboardingState()
//        
//        let onboardingShown = storage.pastOnboarding
//        
        if UserStorage.shared.pastOnboarding {
            // Show main app
            window?.rootViewController = CustomTabBarController()
        } else {
            // Show onboarding
            window?.rootViewController = OnboardingViewController()
        }
//        window?.rootViewController = UINavigationController(rootViewController: PopularCategoryViewController())
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

