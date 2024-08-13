//
//  LaunchViewController.swift
//  MoodScape
//
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {

    private let name = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupName()
        animateName()
    }

    private func setupName() {
        name.text = "MoodScape"
        name.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        name.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        name.textAlignment = .center
        name.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(name)

        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func animateName() {
        UIView.animate(withDuration: 3.0, animations: {
            self.name.alpha = 0.0
        }) { _ in
            self.checkAuthentication()
        }
    }
    
    private func checkAuthentication() {
        //if Auth.auth().currentUser == nil {
            let startViewController = StartViewController()
            startViewController.modalTransitionStyle = .crossDissolve
            startViewController.modalPresentationStyle = .fullScreen
            self.present(startViewController, animated: true, completion: nil)
        /*
         
         } else {
            let mainVC = MainViewController()
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
         */
    }
}
