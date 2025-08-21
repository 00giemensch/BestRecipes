//
//  CustomTabBar.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 19.08.2025.
//

import UIKit

class CustomTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    private var centerButton: UIButton?
    
    // MARK: - Configuration
    private struct Constants {
        static let buttonRadius: CGFloat = 24
        static let holeInset: CGFloat = 7
        static let borderWidth: CGFloat = 1
        static let customHeight: CGFloat = 106
        static let smallCircleInset: CGFloat = 25
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = Constants.customHeight
        return size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = Constants.customHeight
        return sizeThatFits
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.createCenterButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCenterButtonPosition()
    }
    
    // MARK: - Shape Creation
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath().cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        
        // Shadow
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 2)
        shapeLayer.shadowOpacity = 0.1
        shapeLayer.shadowRadius = 4
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = self.frame.width
        let height = Constants.customHeight
        let centerX = width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        let lineEndPoint = CGPoint(
            x: centerX - Constants.buttonRadius
            - Constants.holeInset
            - Constants.smallCircleInset * 2,
            y: 0
        )
        path.addLine(to: lineEndPoint)
        
        // Левая кривая - выпуклая дуга
        let leftEndPoint = CGPoint(
            x: centerX - Constants.buttonRadius - Constants.holeInset,
            y: Constants.smallCircleInset
        )
        let convexControl1 = CGPoint(
            x: lineEndPoint.x + Constants.smallCircleInset,
            y: lineEndPoint.y
        )
        let convexControl2 = CGPoint(
            x: leftEndPoint.x - Constants.smallCircleInset * 0.2,
            y: leftEndPoint.y - Constants.smallCircleInset * 0.6
        )
        path.addCurve(to: leftEndPoint,
                      controlPoint1: convexControl1,
                      controlPoint2: convexControl2)
        
        // Центральная кривая - вогнутая дуга
        let centerEndPoint = CGPoint(
            x: centerX + Constants.buttonRadius + Constants.holeInset,
            y: Constants.smallCircleInset
        )
        let midX = leftEndPoint.x + (centerEndPoint.x - leftEndPoint.x) / 2
        let midY = leftEndPoint.y + (centerEndPoint.y - leftEndPoint.y) / 2
        
        let sControl1 = CGPoint(
            x: midX - Constants.buttonRadius * 0.7,
            y: midY + Constants.buttonRadius * 1.3
        )
        let sControl2 = CGPoint(
            x: midX + Constants.buttonRadius * 0.7,
            y: midY + Constants.buttonRadius * 1.3
        )
        path.addCurve(to: centerEndPoint,
                      controlPoint1: sControl1,
                      controlPoint2: sControl2)
        
        // Правая кривая - выпуклая дуга
        let rightEndPoint = CGPoint(
            x: centerX + Constants.buttonRadius
            + Constants.holeInset
            + Constants.smallCircleInset * 2,
            y: 0
        )
        let convexControl3 = CGPoint(
            x: centerX + Constants.buttonRadius
            + Constants.holeInset
            + Constants.smallCircleInset * 0.2,
            y: Constants.smallCircleInset - Constants.smallCircleInset * 0.6
        )
        let convexControl4 = CGPoint(
            x: rightEndPoint.x - Constants.smallCircleInset,
            y: rightEndPoint.y
        )
        
        path.addCurve(to: rightEndPoint,
                      controlPoint1: convexControl3,
                      controlPoint2: convexControl4)

        path.addLine(to: CGPoint(x: width,y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        return path
    }
    
    // MARK: - Center Button
    private func createCenterButton() {
        if centerButton == nil {
            let button = UIButton(type: .custom)
            button.backgroundColor = .red
            button.layer.cornerRadius = Constants.buttonRadius
            button.layer.masksToBounds = true
            
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.3
            button.layer.shadowRadius = 4
            
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
            let image = UIImage(systemName: "plus", withConfiguration: config)?
                .withTintColor(.black, renderingMode: .alwaysOriginal)
            button.setImage(image, for: .normal)
            
            button.addTarget(
                self,
                action: #selector(centerButtonTapped),
                for: .touchUpInside
            )
            
            self.addSubview(button)
            self.centerButton = button
            updateCenterButtonPosition()
        }
    }
    
    private func updateCenterButtonPosition() {
        guard let button = centerButton else { return }
        button.frame = CGRect(x: (self.frame.width - Constants.buttonRadius * 2) / 2,
                              y: -Constants.holeInset,
                              width: Constants.buttonRadius * 2,
                              height: Constants.buttonRadius * 2)
    }
    
    @objc private func centerButtonTapped() {
        print("Center button tapped")
    }

    // MARK: - Safe Area Insets
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        self.addShape()
    }
}
