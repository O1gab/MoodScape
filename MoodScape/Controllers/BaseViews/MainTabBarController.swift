//
//  MainTabBarController.swift
//  MoodScape
//
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let firstViewController = FeedViewController()
    private let secondViewController = MainViewController()
    private let thirdViewController = SocialViewController()

    private let mainButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        return button
    }()
    
    private var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var targetViewController: UIViewController?
    private var originalViewPosition: CGPoint?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.viewControllers = [firstViewController, secondViewController, thirdViewController]
        
        preloadViews()
        setupView()
    }
    
    // MARK: ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = 100
        tabBarFrame.origin.y = view.frame.height - 95
        tabBar.frame = tabBarFrame
        updateMainButtonPosition()
    }
    
    // MARK: - PreloadViews
    private func preloadViews() {
        _ = firstViewController.view
        _ = secondViewController.view
        _ = thirdViewController.view
    }
    
    // MARK: SetupView
    private func setupView() {
        firstViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "safari.fill"), tag: 0)
        thirdViewController.tabBarItem = UITabBarItem(title: "Social", image: UIImage(systemName: "person.3"), tag: 2)
        UITabBar.appearance().tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        
        mainButton.center = CGPoint(x: tabBar.center.x, y: tabBar.frame.origin.y)
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        view.addSubview(mainButton)
        
        // - MARK: SWIPE GESTURES
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
          view.addGestureRecognizer(panGesture)
    }
    
    // MARK: UpdateMainButtonPosition
    func updateMainButtonPosition() {
        let buttonSize: CGFloat = 50
        mainButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        mainButton.center = CGPoint(
            x: tabBar.frame.size.width / 2,
            y: tabBar.frame.origin.y + 40
        )
    }
    
    // MARK: MainButtonTapped
    @objc func mainButtonTapped() {
        selectedIndex = 1
    }
    
    // MARK: HandlePan
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .began:
            initialTouchPoint = gesture.location(in: view)
        case .changed:
            guard let currentIndex = viewControllers?.firstIndex(of: selectedViewController!) else { return }
            var nextIndex = currentIndex
            
            if translation.x < 0 { // Swiping left
                nextIndex = min(currentIndex + 1, (viewControllers?.count ?? 1) - 1)
            } else if translation.x > 0 { // Swiping right
                nextIndex = max(currentIndex - 1, 0)
            }

            guard nextIndex != currentIndex else { return }
            animatePanTransition(to: nextIndex, translation: translation.x)
            
        case .ended, .cancelled:
            let shouldComplete = abs(translation.x) > view.bounds.width / 2 || abs(velocity.x) > 500
            finishPanTransition(shouldComplete: shouldComplete)
            
        default:
            break
        }
    }

    // MARK: . AnimatePanTransition
    private func animatePanTransition(to nextIndex: Int, translation: CGFloat) {
        guard let fromView = selectedViewController?.view else { return }
        guard let toView = viewControllers?[nextIndex].view else { return }

        if targetViewController == nil || targetViewController != viewControllers?[nextIndex] {
            targetViewController = viewControllers?[nextIndex]
            toView.frame = fromView.frame.offsetBy(dx: translation < 0 ? view.bounds.width : -view.bounds.width, dy: 0)
            view.addSubview(toView)
            originalViewPosition = toView.frame.origin
        }
        
        let newFromViewPosition = fromView.frame.origin.x + translation
        let newToViewPosition = (originalViewPosition?.x ?? 0) + translation
        
        fromView.frame.origin.x = newFromViewPosition
        toView.frame.origin.x = newToViewPosition
    }

    // MARK: FinishPanTransition
    private func finishPanTransition(shouldComplete: Bool) {
        guard let fromView = selectedViewController?.view else { return }
        guard let toView = targetViewController?.view else { return }
        
        let completeDuration: TimeInterval = 0.2
        let cancelDuration: TimeInterval = 0.2
        
        if shouldComplete {
            UIView.animate(withDuration: completeDuration, animations: {
                fromView.frame.origin.x = fromView.frame.origin.x > 0 ? self.view.bounds.width : -self.view.bounds.width
                toView.frame.origin.x = 0
            }) { _ in
                fromView.removeFromSuperview()
                self.selectedIndex = self.viewControllers?.firstIndex(of: self.targetViewController!) ?? 0
                self.targetViewController = nil
            }
        } else {
            UIView.animate(withDuration: cancelDuration, animations: {
                fromView.frame.origin.x = 0
                toView.frame.origin.x = self.originalViewPosition?.x ?? 0
            }) { _ in
                toView.removeFromSuperview()
                self.targetViewController = nil
            }
        }
    }
}
