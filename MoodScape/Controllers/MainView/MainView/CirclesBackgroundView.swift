//
//  CirclesBackgroundView.swift
//  MoodScape
//
//

import UIKit

class CirclesBackgroundView: UIView {
    
    private var circles: [UIView] = []
    private let circleCount = 5
    private let circleSizes: [CGFloat] = [50, 70, 90, 110, 130]
    private let circleColors: [UIColor] = [
        UIColor.green.withAlphaComponent(0.1),
        UIColor.green.withAlphaComponent(0.2),
        UIColor.green.withAlphaComponent(0.3),
        UIColor.green.withAlphaComponent(0.4),
        UIColor.green.withAlphaComponent(0.5)
    ]
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircles()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircles()
    }
    
    // - MARK: SetupCircles
    private func setupCircles() {
        for i in 0..<circleCount {
            let circle = UIView()
            circle.backgroundColor = circleColors[i % circleColors.count]
            circle.layer.cornerRadius = circleSizes[i] / 2
            addSubview(circle)
            circles.append(circle)
        }
    }
    
    // - MARK: LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let superview = superview else { return }
            
        let buttonCenterX = superview.bounds.midX
        let buttonCenterY = superview.bounds.midY
            
        let positions: [(CGFloat, CGFloat)] = [
            (-30, -30),
            (30, -30),
            (-30, 30),
            (30, 30),
            (0, 0)
        ]
            
        for (index, circle) in circles.enumerated() {
            let size = circleSizes[index]
            let offsetX = positions[index].0
            let offsetY = positions[index].1
                
            circle.frame = CGRect(
                x: buttonCenterX + offsetX - size / 2,
                y: buttonCenterY + offsetY - size / 2,
                width: size,
                height: size
            )
            circle.layer.cornerRadius = size / 2
        }
        animateCircles()
    }
        
    // - MARK: AnimateCircles
    private func animateCircles() {
        for circle in circles {
            UIView.animate(withDuration: TimeInterval.random(in: 5...10),
                delay: 0,
                options: [.repeat, .autoreverse, .allowUserInteraction],
                animations: {
                circle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        }
    }
}
