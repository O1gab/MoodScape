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
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.viewControllers = [firstViewController, secondViewController, thirdViewController]
        setupView()
    }
    
    // - MARK: ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMainButtonPosition()
    }
    
    // - MARK: SetupView
    private func setupView() {
        firstViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        thirdViewController.tabBarItem = UITabBarItem(title: "Social", image: UIImage(systemName: "person.3"), tag: 2)
        UITabBar.appearance().tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        
        mainButton.center = CGPoint(x: tabBar.center.x, y: tabBar.frame.origin.y - 16)
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        view.addSubview(mainButton)
        
        // - MARK: SWIPE GESTURES
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    // - MARK: UpdateMainButtonPosition
    func updateMainButtonPosition() {
        let buttonSize: CGFloat = 50
        mainButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        mainButton.center = CGPoint(
            x: tabBar.frame.size.width / 2,
            y: tabBar.frame.size.height + 700
        )
    }
    
    // - MARK: MainButtonTapped
    @objc func mainButtonTapped() {
        selectedIndex = 1
    }
    
    // - MARK: HandleSwipe
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if let currentIndex = viewControllers?.firstIndex(of: selectedViewController!) {
            if gesture.direction == .left {
                if currentIndex < (viewControllers?.count)! - 1 {
                    selectedIndex = currentIndex + 1
                }
            } else if gesture.direction == .right {
                if currentIndex > 0 {
                    selectedIndex = currentIndex - 1
                }
            }
        }
    }
}
