//
//  OnboardingViewController.swift
//  BestRecipes
//
//  Created by Nurislam on 20.08.2025.
//

import UIKit

// MARK: - Onboarding Storage Protocol
protocol OnboardingStorageProtocol {
    func saveOnboardingShown() throws
    func isOnboardingShown() -> Bool
    func resetOnboardingState()
}

// MARK: - Onboarding Storage Implementation
final class OnboardingStorage: OnboardingStorageProtocol {
    private enum Keys {
        static let onboardingShown = "OnboardingShown"
    }
    
    func saveOnboardingShown() throws {
        UserDefaults.standard.set(true, forKey: Keys.onboardingShown)
        if !UserDefaults.standard.synchronize() {
            throw OnboardingError.failedToSaveState
        }
    }
    
    func isOnboardingShown() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.onboardingShown)
    }
    
    func resetOnboardingState() {
        UserDefaults.standard.removeObject(forKey: Keys.onboardingShown)
    }
}

// MARK: - Onboarding Service Protocol
protocol OnboardingServiceProtocol {
    func getOnboardingPages() -> [OnboardingPage]
}

// MARK: - Onboarding Service Implementation
final class OnboardingService: OnboardingServiceProtocol {
    func getOnboardingPages() -> [OnboardingPage] {
        return OnboardingPage.validatedPages
    }
}

// MARK: - Page Direction
private enum PageDirection {
    case next
    case previous
}

// MARK: - Page View Controller
final class OnboardingPageViewController: UIViewController {
    let pageView: OnboardingPageView
    
    init(pageView: OnboardingPageView) {
        self.pageView = pageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageView()
    }
    
    private func setupPageView() {
        view.addSubview(pageView)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Main Onboarding Controller
final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let pageControlBottomPadding: CGFloat = 20
        static let animationDuration: TimeInterval = 0.3
    }
    
    // MARK: - Dependencies
    private let storage: OnboardingStorageProtocol
    private let service: OnboardingServiceProtocol
    
    // MARK: - Properties
    private var pages: [OnboardingPage] = []
    private var currentPageIndex: Int = 0
    private var cachedViewControllers: [Int: OnboardingPageViewController] = [:]
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = UIColor(named: "Primary50") ?? UIColor.red
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.accessibilityIdentifier = "onboarding_page_control"
        return pageControl
    }()
    
    // MARK: - Initialization
    init(storage: OnboardingStorageProtocol = OnboardingStorage(),
         service: OnboardingServiceProtocol = OnboardingService()) {
        self.storage = storage
        self.service = service
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        self.storage = OnboardingStorage()
        self.service = OnboardingService()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboarding()
    }
    
    // MARK: - Setup
    private func setupOnboarding() {
        loadOnboardingPages()
        setupPageViewController()
        setupPageControl()
    }
    
    private func loadOnboardingPages() {
        pages = service.getOnboardingPages()
        
        guard !pages.isEmpty else {
            print("⚠️ No valid onboarding pages found")
            finishOnboarding()
            return
        }
        
        pageControl.numberOfPages = pages.count
    }
    
    private func setupPageViewController() {
        dataSource = self
        delegate = self
        
        guard let firstViewController = createPageViewController(for: 0) else {
            print("⚠️ Failed to create first onboarding page")
            finishOnboarding()
            return
        }
        
        setViewControllers([firstViewController], direction: .forward, animated: false)
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.pageControlBottomPadding),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Helper Methods
    private func createPageViewController(for index: Int) -> OnboardingPageViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        
        // Check cache first
        if let cached = cachedViewControllers[index] {
            return cached
        }
        
        let pageView = OnboardingPageView()
        let page = pages[index]
        
        do {
            try page.validate()
            pageView.configure(with: page)
        } catch {
            print("⚠️ Failed to configure onboarding page at index \(index): \(error.localizedDescription)")
            return nil
        }
        
        // Setup callbacks
        pageView.onActionButtonTapped = { [weak self] in
            self?.handleActionButtonTapped()
        }
        
        pageView.onSkipButtonTapped = { [weak self] in
            self?.finishOnboarding()
        }
        
        let controller = OnboardingPageViewController(pageView: pageView)
        cachedViewControllers[index] = controller
        
        return controller
    }
    
    private func getPageViewController(for direction: PageDirection) -> OnboardingPageViewController? {
        let targetIndex = direction == .next ? currentPageIndex + 1 : currentPageIndex - 1
        return createPageViewController(for: targetIndex)
    }
    
    private func handleActionButtonTapped() {
        if currentPageIndex < pages.count - 1 {
            // Go to next page
            currentPageIndex += 1
            if let nextViewController = createPageViewController(for: currentPageIndex) {
                setViewControllers([nextViewController], direction: .forward, animated: true)
                updatePageControl()
            }
        } else {
            // Last page - finish onboarding
            finishOnboarding()
        }
    }
    
    private func updatePageControl() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.pageControl.currentPage = self.currentPageIndex
        }
    }
    
    private func finishOnboarding() {
        do {
            try storage.saveOnboardingShown()
            presentMainApp()
        } catch {
            print("⚠️ Failed to save onboarding state: \(error.localizedDescription)")
            // Continue anyway
            presentMainApp()
        }
    }
    
    private func presentMainApp() {
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true) { [weak self] in
            // Clear cache after transition
            self?.cachedViewControllers.removeAll()
        }
    }
    
    // MARK: - Memory Management
    deinit {
        cachedViewControllers.removeAll()
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let _ = viewController as? OnboardingPageViewController else { return nil }
        return getPageViewController(for: .previous)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let _ = viewController as? OnboardingPageViewController else { return nil }
        return getPageViewController(for: .next)
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let currentViewController = pageViewController.viewControllers?.first as? OnboardingPageViewController else {
            return
        }
        
        // Find current index by comparing titles
        if let currentTitle = currentViewController.pageView.titleLabel.text,
           let index = pages.firstIndex(where: { $0.title == currentTitle }) {
            currentPageIndex = index
            updatePageControl()
        }
    }
}
