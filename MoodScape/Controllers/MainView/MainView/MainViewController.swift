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
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 2
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
    
    private let circlesBackgroundView: CirclesBackgroundView = {
        let view = CirclesBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addMoodButton.addTarget(self, action: #selector(handleAddMood), for: .touchUpInside)
        setupView()
    }
    
    // - MARK: SetupLayout
    private func setupView() {
        view.addSubview(circlesBackgroundView)
        view.addSubview(topLabel)
        view.addSubview(addMoodButton)
        view.addSubview(addMoodLabel)
        view.addSubview(bottomInfoView)
            
        NSLayoutConstraint.activate([
            // Circles background view constraints
            circlesBackgroundView.centerXAnchor.constraint(equalTo: addMoodButton.centerXAnchor),
            circlesBackgroundView.centerYAnchor.constraint(equalTo: addMoodButton.centerYAnchor),
            circlesBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            circlesBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
                        
            // Top label constraints
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // "Add Mood" Button constraints
            addMoodButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addMoodButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            addMoodButton.widthAnchor.constraint(equalToConstant: 70),
            addMoodButton.heightAnchor.constraint(equalToConstant: 70),
                
            // "Add Mood" Label constraints (below the button)
            addMoodLabel.topAnchor.constraint(equalTo: addMoodButton.bottomAnchor, constant: 3),
            addMoodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    // - MARK: HandleAddMood
    @objc private func handleAddMood() {
        let moodSelectionView = MoodSelectionView()
        moodSelectionView.modalPresentationStyle = .overCurrentContext
        moodSelectionView.modalTransitionStyle = .crossDissolve
        present(moodSelectionView, animated: true, completion: nil)
    }
}
