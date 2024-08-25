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

class ArtistsSetupView: SetupBaseView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var currentIndex: Int = 0
    private var endIndex: Int = 0
    private var genres: [String] = []
    
    private var selectedGenre: String?
    
    private var artists: [Artist] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
        appLabel.alpha = 0
        view.addSubview(gifGradient)
        view.addSubview(fieldLabel)
        view.addSubview(submitButton)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ArtistCell.self, forCellWithReuseIdentifier: "ArtistCell")
        collectionView.backgroundColor = .clear // Change background to clear
        
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            fieldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20),
            
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 210),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // - MARK: DisplayNextGenre
    private func displayNextGenre() {
        guard currentIndex <= endIndex else {
            navigateToNextView(viewController: MainViewController())
            return
        }

        let genre = genres[currentIndex]
        selectedGenre = genre
        
        /*SpotifyAPIManager.shared.fetchArtistsByGenre(for: genre) { [weak self] artists in
            guard let self = self, let artists = artists else { return }
            self.artists = artists
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.startTypingAnimation(label: self.fieldLabel, text: "Your \(self.currentIndex + 1) choice was \(genre)", typingSpeed: 0.075) {
                    self.submitButton.isHidden = false
                }
            }
        }
         */
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.bounds.width - 30) / 3 // 3 cells per row with some spacing
            return CGSize(width: width, height: width + 30) // Height a bit larger to accommodate text
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        let artist = artists[indexPath.item]
        cell.backgroundColor = .green
        return cell
    }
    
    // on touch
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArtist = artists[indexPath.item]
        /*fetchSimilarArtists(for: selectedArtist) { [weak self] similarArtists in
            guard let self = self, let similarArtists = similarArtists else { return }
            // Update the collection view with similar artists
            self.artists = similarArtists
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
         */
    }
}
