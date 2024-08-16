//
//  MainTabBarController.swift
//  MoodScape
//
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let firstViewController = FeedViewController()
    private let secondViewController = MainViewController()
    private let thirdViewController = StatsViewController()
    private let fourthViewController = SocialViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        self.viewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]
        
        firstViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "plus.circle.fill"), tag: 1)
        thirdViewController.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "chart.bar"), tag: 2)
        fourthViewController.tabBarItem = UITabBarItem(title: "Social", image: UIImage(systemName: "person.3"), tag: 3)
        UITabBar.appearance().tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        
        // - MARK: SWIPE GESTURES
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
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
