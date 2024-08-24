//
//  ArtistsSetupController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 25.08.24.
//

import UIKit
import Gifu
import FirebaseAuth
import FirebaseFirestore

class ArtistsSetupView: SetupBaseView {
    
    private var currentIndex: Int = 0
    private var endIndex: Int = 0
    private var genres: [String] = []
    
    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.9), for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // - MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // - MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchSelectedGenres { [weak self] genres in
            
            self?.genres = genres ?? [""]
            self?.endIndex = (genres?.count ?? 1) - 1
            self?.currentIndex = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.displayNextGenre()
                self?.revealButton(button: self?.submitButton ?? UIButton())
            }
        }
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(gifGradient)
        view.addSubview(fieldLabel)
        view.addSubview(submitButton)
        
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            fieldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 210),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // - MARK: DisplayNextGenre
    private func displayNextGenre() {
        guard currentIndex <= endIndex else {
            // All genres have been displayed; handle completion or transition to next view
            navigateToNextView(viewController: MainViewController())
            return
        }

        let genre = genres[currentIndex]
        startTypingAnimation(label: fieldLabel, text: "Your \(currentIndex + 1) choice was \(genre)", typingSpeed: 0.075) {
            self.submitButton.isHidden = false
        }
    }
    
    // - MARK: FetchSelectedGenres
    func fetchSelectedGenres(completion: @escaping ([String]?) -> Void) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        let userDocRef = db.collection("users").document(userId ?? "")

        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let genres = data?["selectedGenres"] as? [String]
                completion(genres)
            } else {
                // TODO: Alert message
                print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    // - MARK: FormatGenres
    func formatGenres(_ genres: [String]) -> String {
        var formattedString = ""
        for (index, genre) in genres.enumerated() {
            let suffix: String
            switch index {
            case 0: suffix = "1st"
            case 1: suffix = "2nd"
            case 2: suffix = "3rd"
            default: suffix = "\(index + 1)th"
            }
            formattedString += "Your \(suffix) choice was \(genre)\n"
        }
        return formattedString
    }
    
    // - MARK: HandleSubmit
    @objc private func handleSubmit() {
        guard currentIndex <= endIndex else {
            // All genres have been processed; handle transition to next view
            saveSelectedArtists()
            navigateToNextView(viewController: MainViewController())
            return
        }
        
        // Start the erasing animation
        startErasingAnimation(label: fieldLabel, typingSpeed: 0.045) {
            self.currentIndex += 1
            self.displayNextGenre()
        }
    }
    
    // - MARK: SaveSelectedArtists
    private func saveSelectedArtists() {
        // TODO: implement this function!
    }
    
}
