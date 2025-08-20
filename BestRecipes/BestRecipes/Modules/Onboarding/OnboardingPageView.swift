//
//  OnboardingPageView.swift
//  BestRecipes
//
//  Created by Nurislam on 20.08.2025.
//

import UIKit

final class OnboardingPageView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let titleVerticalOffset: CGFloat = -60
        static let buttonWidth: CGFloat = 200
        static let buttonHeight: CGFloat = 50
        static let skipButtonWidth: CGFloat = 60
        static let skipButtonHeight: CGFloat = 30
        static let cornerRadius: CGFloat = 25
        static let horizontalPadding: CGFloat = 32
        static let titleSubtitleSpacing: CGFloat = 16
        static let buttonSkipSpacing: CGFloat = 16
        static let bottomPadding: CGFloat = 40
        static let gradientStartLocation: CGFloat = 0.0
        static let gradientEndLocation: CGFloat = 0.6
        static let gradientAlpha: CGFloat = 0.7
    }
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "onboarding_background_image"
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(Constants.gradientAlpha).cgColor
        ]
        gradient.locations = [Constants.gradientStartLocation, Constants.gradientEndLocation].map { NSNumber(value: $0) }
        return gradient
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(.bold, size: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "onboarding_title_label"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(.regular, size: 18)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "onboarding_subtitle_label"
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "Primary50") ?? UIColor(red: 0.99, green: 0.36, blue: 0.27, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.custom(.semibold, size: 18)
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "onboarding_action_button"
        button.accessibilityTraits = .button
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = UIFont.custom(.regular, size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "onboarding_skip_button"
        button.accessibilityTraits = .button
        return button
    }()
    
    // MARK: - Properties
    var onActionButtonTapped: (() -> Void)?
    var onSkipButtonTapped: (() -> Void)?
    
    // MARK: - Private Properties
    private var lastGradientFrame: CGRect = .zero
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionButton)
        addSubview(skipButton)
        
        setupConstraints()
        setupActions()
        setupAccessibility()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background Image
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Title Label
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.titleVerticalOffset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.titleSubtitleSpacing),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            // Action Button
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomPadding),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            // Skip Button
            skipButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: Constants.buttonSkipSpacing),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: Constants.skipButtonWidth),
            skipButton.heightAnchor.constraint(equalToConstant: Constants.skipButtonHeight)
        ])
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = false
        accessibilityElements = [titleLabel, subtitleLabel, actionButton, skipButton]
    }
    
    // MARK: - Actions
    @objc private func actionButtonTapped() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        onActionButtonTapped?()
    }
    
    @objc private func skipButtonTapped() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        onSkipButtonTapped?()
    }
    
    // MARK: - Configuration
    func configure(with page: OnboardingPage) {
        // Validate page data
        do {
            try page.validate()
        } catch {
            print("⚠️ Onboarding page validation failed: \(error.localizedDescription)")
            // Use fallback data
            configureWithFallback()
            return
        }
        
        // Configure UI with validated data
        configureBackgroundImage(named: page.image)
        titleLabel.text = page.title
        subtitleLabel.text = page.subtitle
        actionButton.setTitle(page.buttonTitle, for: .normal)
        skipButton.isHidden = !page.showSkip
        
        // Update accessibility
        updateAccessibility(with: page)
        
        // Add gradient overlay
        addGradientOverlay()
    }
    
    // MARK: - Private Methods
    private func configureBackgroundImage(named imageName: String) {
        if let image = UIImage(named: imageName) {
            backgroundImageView.image = image
        } else {
            // Fallback to default image
            backgroundImageView.image = UIImage(named: "defaultOnboarding") ?? createPlaceholderImage()
            print("⚠️ Onboarding image '\(imageName)' not found, using fallback")
        }
    }
    
    private func configureWithFallback() {
        titleLabel.text = "Welcome to Best Recipes"
        subtitleLabel.text = "Discover amazing recipes"
        actionButton.setTitle("Get Started", for: .normal)
        skipButton.isHidden = false
        backgroundImageView.image = createPlaceholderImage()
    }
    
    private func createPlaceholderImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.systemGray5.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    private func addGradientOverlay() {
        // Remove existing gradient layers
        backgroundImageView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        // Add new gradient
        gradientLayer.frame = bounds
        backgroundImageView.layer.addSublayer(gradientLayer)
        lastGradientFrame = bounds
    }
    
    private func updateAccessibility(with page: OnboardingPage) {
        titleLabel.accessibilityLabel = page.title
        subtitleLabel.accessibilityLabel = page.subtitle ?? ""
        actionButton.accessibilityLabel = page.buttonTitle
        actionButton.accessibilityHint = "Double tap to continue"
        skipButton.accessibilityLabel = "Skip onboarding"
        skipButton.accessibilityHint = "Double tap to skip to main app"
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Optimize gradient updates
        if lastGradientFrame != bounds {
            gradientLayer.frame = bounds
            lastGradientFrame = bounds
        }
    }
    
    // MARK: - Memory Management
    deinit {
        onActionButtonTapped = nil
        onSkipButtonTapped = nil
    }
}
