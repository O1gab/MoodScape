//
//  LaunchViewController.swift
//  MoodScape
//
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 1.0)
        setupConstraints()
        animateName()
        checkAuthentication()
    }

    let name: UILabel = {
        let name = UILabel()
        name.text = "MoodScape"
        name.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        name.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        name.textAlignment = .center
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        view.addSubview(name)

        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // - MARK: AnimateName
    private func animateName() {
        UIView.animate(withDuration: 3.0, animations: {
            self.name.alpha = 0.0
        }) { _ in
            self.checkAuthentication()
        }
    }
    
    // - MARK: CheckAuthentication
    private func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            let startViewController = StartViewController()
            startViewController.modalTransitionStyle = .crossDissolve
            startViewController.modalPresentationStyle = .fullScreen
            self.present(startViewController, animated: true, completion: nil)
        
         } else {
            let mainVC = MainTabBarController()
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }
}
