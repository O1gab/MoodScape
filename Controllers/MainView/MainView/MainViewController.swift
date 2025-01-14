//
//  MainViewController.swift
//  MoodScape
//
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: MainBaseView {
    
    // MARK: - Properties
    private let gestureThreshold: CGFloat = 500
    private var panGesture: UIPanGestureRecognizer!
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "How are you feeling now?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gradientCircleView: GradientCircleView = {
        let view = GradientCircleView()
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addMoodButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addShadow()
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
    
    private lazy var moodSelectionView: MoodSelectionView = {
        let viewController = MoodSelectionView()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Drag down to see your mood journal"
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moodJournalView: MoodJournalViewController = {
        let viewController = MoodJournalViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        determineGreeting()
        setupView()
        setupGesture()
    }
    
    // - MARK: SetupLayout
    private func setupView() {
        view.addSubview(greetingLabel)
        view.addSubview(topLabel)
        view.addSubview(gradientCircleView)
        view.addSubview(addMoodButton)
        addMoodButton.addTarget(self, action: #selector(handleAddMood), for: .touchUpInside)
        view.addSubview(bottomLabel)
        view.addSubview(addMoodLabel)
            
        NSLayoutConstraint.activate([
            // Greeting Label constraints
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            greetingLabel.widthAnchor.constraint(equalToConstant: 250),
            
            // Top label
            topLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: greetingLabel.leadingAnchor),
            
            gradientCircleView.centerXAnchor.constraint(equalTo: addMoodButton.centerXAnchor),
            gradientCircleView.centerYAnchor.constraint(equalTo: addMoodButton.centerYAnchor),
            gradientCircleView.widthAnchor.constraint(equalToConstant: 150),
            gradientCircleView.heightAnchor.constraint(equalTo: addMoodButton.widthAnchor),
            
            // "Add Mood" Button
            addMoodButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addMoodButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            addMoodButton.widthAnchor.constraint(equalToConstant: 70),
            addMoodButton.heightAnchor.constraint(equalToConstant: 70),
                
            // "Add Mood" Label
            addMoodLabel.topAnchor.constraint(equalTo: addMoodButton.bottomAnchor, constant: 3),
            addMoodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // "Drag Down" Label
            bottomLabel.topAnchor.constraint(equalTo: addMoodLabel.bottomAnchor, constant: 200),
            bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // - MARK: DetermineGreeting
    private func determineGreeting() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            if let name = document.data()?["name"] as? String {
                print("fetched name: \(name)")
                DispatchQueue.main.async {
                    let hour = Calendar.current.component(.hour, from: Date())
                    var greeting = ""
                    
                switch hour {
                    case 5..<12:
                        greeting = "Good Morning"
                    case 12..<17:
                        greeting = "Hello"
                    case 17..<21:
                        greeting = "Good Afternoon"
                    case 21..<24, 0..<5:
                        greeting = "Good Night"
                    default:
                        greeting = "Hello"
                }
                    self?.greetingLabel.text = "\(greeting), \(name)"
                }
            } else {
                self?.greetingLabel.text = "Good to see you here"
            }
        }
    }
    
    // MARK: - SetupGesture
    private func setupGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleVerticalSwipe(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Handle Gesture
    @objc func handleVerticalSwipe(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: view)
        let translation = gesture.translation(in: view)
        
        // Detect if the user has swiped down hard enough
        if gesture.state == .ended {
            if velocity.y < -gestureThreshold && translation.y < -100 {
                moodJournalView.modalPresentationStyle = .overFullScreen
                moodJournalView.modalTransitionStyle = .crossDissolve
                present(moodJournalView, animated: true, completion: nil)
            }
        }
    }
    
    // - MARK: HandleAddMood
    @objc private func handleAddMood() {
        let moodSelectionView = MoodSelectionView()
        moodSelectionView.modalPresentationStyle = .overCurrentContext
        moodSelectionView.modalTransitionStyle = .crossDissolve
        present(moodSelectionView, animated: true, completion: nil)
    }
}
