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

        firstViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "1.circle"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "2.circle"), tag: 1)
        thirdViewController.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "3.circle"), tag: 2)
        fourthViewController.tabBarItem = UITabBarItem(title: "Social", image: UIImage(systemName: "4.circle"), tag: 3)
    }
}
