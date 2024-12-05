//
//  LaunchViewController.swift
//  MoodScape
//
//

import UIKit
import Firebase

class LaunchViewController: StartBaseView {

    // MARK: - Properties
    private let name: UILabel = {
        let name = UILabel()
        name.text = "MoodScape"
        name.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        name.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        name.textAlignment = .center
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var authView: AuthViewController = {
        let viewController = AuthViewController()
        viewController.loadViewIfNeeded()  // Preload the view when first accessed
        return viewController
    }()
    
    private lazy var mainView: MainTabBarController = {
        let viewController = MainTabBarController()
        viewController.loadViewIfNeeded()  // Preload the view when first accessed
        return viewController
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.animateName()
            self.checkAuthentication()
        }
    }
    
    // MARK: SetupView
    private func setupView() {
        appLabel.alpha = 0
        view.addSubview(name)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    // MARK: - CheckAuthentication
    private func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            authView.modalTransitionStyle = .crossDissolve
            authView.modalPresentationStyle = .fullScreen
            self.present(authView, animated: true, completion: nil)
        
         } else {
            mainView.modalTransitionStyle = .crossDissolve
            mainView.modalPresentationStyle = .fullScreen
            self.present(mainView, animated: true, completion: nil)
        }
    }
    
    // MARK: - AnimateName
    private func animateName() {
        UIView.animate(withDuration: 3.0, animations: {
            self.name.alpha = 0.0
        }) { _ in
            self.checkAuthentication()
        }
    }
}
