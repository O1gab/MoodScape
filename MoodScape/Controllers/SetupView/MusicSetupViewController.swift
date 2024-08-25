//
//  MusicSetupController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit
import Gifu
import FirebaseAuth
import FirebaseFirestore

class MusicSetupView: SetupBaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var genres = [
        "Pop", "Rap", "Classical", "Jazz", "Rock", "Electronic", "Country",
        "Blues", "Reggae", "Metal", "Indie", "Techno", "K-Pop", "Folk", "Punk",
        "Afro", "Funk", "R&B", "Soul", "Alternative", "Latin", "House", "Trance",
        "Dubstep", "Ambient", "Disco", "Ska", "Grunge", "Gospel", "Opera",
        "Bluegrass", "Synthwave", "Drum and Bass", "Trap", "Reggaeton",
        "New Age", "Post-Rock", "Emo", "Chillout", "Dancehall", "Lo-Fi",
        "Avant-Garde", "Hardcore", "Industrial", "Experimental"]
    
    private var selectedGenres: [String] = []
    
    private let genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        collectionView.alpha = 0
        collectionView.isHidden = true
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
        label.numberOfLines = 2
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
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        
        setupView()
        setupConstraints()
    }
    
    // - MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: "Choose the music genres you listen to the most", typingSpeed: 0.05) {
                self?.revealCollectionView()
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
        view.addSubview(genreCollectionView)
        
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
            
            genreCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 215),
             genreCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
             genreCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            genreCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            submitButton.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 210),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // - MARK: HandleSubmit
    @objc private func handleSubmit() {
        if selectedGenres.isEmpty {
            let alert = UIAlertController(title: "No Genre Selected",
                                          message: "Please, select at least one genre before submitting",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            print("Selected genres: \(selectedGenres)") // debug
            saveSelectedGenres()
            navigateToNextView(viewController: ArtistsSetupView())
        }
    }
    
    // - MARK: SaveSelectedGenres
    private func saveSelectedGenres() {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userDocRef = db.collection("users").document(userID)
        
        userDocRef.setData(["selectedGenres": selectedGenres], merge: true) { error in
            if let error = error {
                print("Error saving selected genres: \(error.localizedDescription)")
            } else {
                print("Selected genres successfully saved!")
            }
        }
    }
    
    // - MARK: RevealCollectionView
    private func revealCollectionView() {
        genreCollectionView.isHidden = false
        
        UIView.animate(withDuration: 1.5) {
            self.genreCollectionView.alpha = 1
        }
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as! GenreCell
        let genre = genres[indexPath.item]
        let isSelected = selectedGenres.contains(genre)
        cell.configure(with: genre, isSelected: isSelected)
        return cell
    }
        
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.item]
        if let index = selectedGenres.firstIndex(of: genre) {
            selectedGenres.remove(at: index) } else {
            selectedGenres.append(genre)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
