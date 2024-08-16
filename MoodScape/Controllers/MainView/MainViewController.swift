//
//  MainViewController.swift
//  MoodScape
//
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: MainBaseView {
    
    private let topLabel: UILabel = {
            let label = UILabel()
            label.text = "How are you feeling now?"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let addMoodButton: UIButton = {
            let button = UIButton(type: .system)
            let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .medium))
            button.setImage(image, for: .normal)
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
        private let addMoodLabel: UILabel = {
            let label = UILabel()
            label.text = "Add Mood"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
        private let bottomInfoView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            view.layer.cornerRadius = 20
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let uniqueFeelingsLabel: UILabel = {
            let label = UILabel()
            label.text = "2\nunique feelings"
            label.numberOfLines = 2
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let dayStreakLabel: UILabel = {
            let label = UILabel()
            label.text = "0\nday streak"
            label.numberOfLines = 2
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let bottomTabBar: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let checkInButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Check in", for: .normal)
            button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            button.tintColor = .red
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private let toolsButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Tools", for: .normal)
            button.setImage(UIImage(systemName: "hammer"), for: .normal)
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private let friendsButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Friends", for: .normal)
            button.setImage(UIImage(systemName: "person.3"), for: .normal)
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private let analyzeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Analyze", for: .normal)
            button.setImage(UIImage(systemName: "chart.bar"), for: .normal)
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
            addMoodButton.addTarget(self, action: #selector(handleAddMood), for: .touchUpInside)
            
            setupLayout()
        }
        
        private func setupLayout() {
            view.addSubview(topLabel)
            view.addSubview(addMoodButton)
            view.addSubview(addMoodLabel)
            view.addSubview(bottomInfoView)
            bottomInfoView.addSubview(uniqueFeelingsLabel)
            bottomInfoView.addSubview(dayStreakLabel)
            view.addSubview(bottomTabBar)
            
            bottomTabBar.addSubview(checkInButton)
            bottomTabBar.addSubview(toolsButton)
            bottomTabBar.addSubview(friendsButton)
            bottomTabBar.addSubview(analyzeButton)
            
            NSLayoutConstraint.activate([
                // Top label constraints
                topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
                topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                // "Add Mood" Button constraints
                addMoodButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                addMoodButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
                addMoodButton.widthAnchor.constraint(equalToConstant: 70),
                addMoodButton.heightAnchor.constraint(equalToConstant: 70),
                
                // "Add Mood" Label constraints (below the button)
                addMoodLabel.topAnchor.constraint(equalTo: addMoodButton.bottomAnchor, constant: 3),
                addMoodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                // Bottom info view constraints
                bottomInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                bottomInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                bottomInfoView.bottomAnchor.constraint(equalTo: bottomTabBar.topAnchor, constant: -16),
                bottomInfoView.heightAnchor.constraint(equalToConstant: 60),
                
                // Unique Feelings Label
                uniqueFeelingsLabel.leadingAnchor.constraint(equalTo: bottomInfoView.leadingAnchor, constant: 16),
                uniqueFeelingsLabel.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor),
                
                // Day Streak Label
                dayStreakLabel.trailingAnchor.constraint(equalTo: bottomInfoView.trailingAnchor, constant: -16),
                dayStreakLabel.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor),
                
                // Bottom tab bar constraints
                bottomTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                bottomTabBar.heightAnchor.constraint(equalToConstant: 60),
                
                // Bottom tab bar buttons constraints
                checkInButton.leadingAnchor.constraint(equalTo: bottomTabBar.leadingAnchor, constant: 20),
                checkInButton.centerYAnchor.constraint(equalTo: bottomTabBar.centerYAnchor),
                
                toolsButton.centerXAnchor.constraint(equalTo: bottomTabBar.centerXAnchor, constant: -50),
                toolsButton.centerYAnchor.constraint(equalTo: bottomTabBar.centerYAnchor),
                
                friendsButton.centerXAnchor.constraint(equalTo: bottomTabBar.centerXAnchor, constant: 50),
                friendsButton.centerYAnchor.constraint(equalTo: bottomTabBar.centerYAnchor),
                
                analyzeButton.trailingAnchor.constraint(equalTo: bottomTabBar.trailingAnchor, constant: -20),
                analyzeButton.centerYAnchor.constraint(equalTo: bottomTabBar.centerYAnchor),
            ])
        }
    
    @objc private func handleAddMood() {
        let popUpViewController = PopUpViewController()
        popUpViewController.modalPresentationStyle = .overCurrentContext
        popUpViewController.modalTransitionStyle = .crossDissolve
        present(popUpViewController, animated: true, completion: nil)
    }
    
}
