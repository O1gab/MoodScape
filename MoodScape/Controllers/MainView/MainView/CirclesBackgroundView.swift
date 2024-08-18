//
//  CirclesBackgroundView.swift
//  MoodScape
//
//

import UIKit
import CoreMotion

class CirclesBackgroundView: UIView {
    
    private var circles: [UIView] = []
    private let circleCount = 5
    private let circleSizes: [CGFloat] = [100, 140, 180, 220, 250]
    private let circleColors: [UIColor] = [
        UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.1),
        UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.2),
        UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.5),
        UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.4),
        UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.3)
    ]
    private let motionManager = CMMotionManager()
    private let movementFactor: CGFloat = 50
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircles()
        startAccelerometerUpdates()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircles()
        startAccelerometerUpdates()
    }
    
    // - MARK: SetupCircles
    private func setupCircles() {
        for i in 0..<circleCount {
            let circle = UIView()
            circle.backgroundColor = circleColors[i % circleColors.count]
            circle.layer.cornerRadius = circleSizes[i] / 2
            circle.translatesAutoresizingMaskIntoConstraints = false
            addSubview(circle)
            circles.append(circle)
        }
        layoutSubviews()
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
    
    // - MARK: StartAccelerometerUpdates
    private func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1 // Update interval
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let data = data, error == nil else { return }
                self?.updateCirclesPosition(with: data.acceleration)
            }
        }
    }
        
    // - MARK: UpdateCirclesPosition
    private func updateCirclesPosition(with acceleration: CMAcceleration) {
        let shiftX = CGFloat(acceleration.x) * movementFactor
        let buttonCenterX = bounds.midX
        let buttonCenterY = bounds.midY
            
        for (index, circle) in circles.enumerated() {
            let size = circleSizes[index]
            let offsetX = circleSizes[index] / 2 + shiftX
            let offsetY = circleSizes[index] / 2
                
            circle.frame = CGRect(
                x: buttonCenterX + offsetX - size / 2,
                y: buttonCenterY + offsetY - size / 2,
                width: size,
                height: size
            )
            circle.layer.cornerRadius = size / 2
        }
    }
}
