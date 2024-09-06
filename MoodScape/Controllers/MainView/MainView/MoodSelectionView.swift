//
//  MoodSelectionView.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MoodSelectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let groqClient = GroqAPIClient()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1.0)
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emotions = [
        "Happy", "Sad", "Angry", "Fearful", "Disgusted", "Surprised",
        "Joyful", "Excited", "Grateful", "Proud", "Optimistic", "Inspired",
        "Amused", "Confident", "Peaceful", "Content", "Hopeful", "Enthusiastic",
        "Elated", "Satisfied", "Anxious", "Frustrated", "Jealous", "Guilty",
        "Ashamed", "Disappointed", "Envious", "Insecure", "Overwhelmed", "Stressed",
        "Depressed", "Hopeless", "Resentful", "Bitter", "Hurt", "Nostalgic",
        "Melancholic", "Bittersweet", "Ambivalent", "Conflicted", "Apathetic",
        "Indifferent", "Numb", "Empathetic", "Compassionate", "Admiring",
        "Loving", "Affectionate", "Lonely", "Rejected", "Betrayed", "Curious",
        "Confused", "Focused", "Distracted", "Bored", "Interested", "Energetic",
        "Tired", "Relaxed", "Tense"
    ]
    
    private var selectedEmotions: [IndexPath] = []
    
    private var selectedArtists: [Artist] = []
        
    private let emotionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmotionCell.self, forCellWithReuseIdentifier: "EmotionCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
        
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        emotionsCollectionView.delegate = self
        emotionsCollectionView.dataSource = self
    }
    
    // - MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateShow()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(contentView)
        contentView.addSubview(emotionsCollectionView)
        contentView.addSubview(saveButton)
        contentView.addSubview(closeButton)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        closeButton.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveEmotions), for: .touchUpInside)
                
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    
            emotionsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emotionsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emotionsCollectionView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            emotionsCollectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
                    
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // - MARK: ClosePopUp
    @objc private func closePopUp() {
        animateHide()
    }
    
    private func fetchSelectedArtists(completion: @escaping ([String]?) -> Void) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        let userDocRef = db.collection("users").document(userId ?? "")
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let artists = data?["selectedArtists"] as? [String]
                completion(artists)
            } else {
                self.showError("Failed to fetch selected artists")
                completion(nil)
            }
        }
    }
    
    @objc private func saveEmotions() {
        // TODO: Save selected emotions and generate a playlist based on the selection
        fetchSelectedArtists { [weak self] artistNames in
            guard let self = self, let artistNames = artistNames, !artistNames.isEmpty else {
                self?.showError("Failed to fetch artist names or no artists selected")
                return
            }
            
            let prompt = """
                Generate a JSON object following this schema:
                    {
                      "type": "object",
                      "properties": {
                        "playlist": {
                          "type": "array",
                          "items": {
                            "type": "object",
                            "properties": {
                              "artist": {"type": "string"},
                              "song": {"type": "string"}
                            },
                            "required": ["artist", "song"]
                          }
                        }
                      },
                      "required": ["playlist"]
                    }
                A user currently has the following emotions: \(selectedEmotions). Based on these emotions, generate a playlist of 20 songs that match the user's selected mood. Pay attention to the lyrics; they must correlate with the mood/vibe. The user has also selected the following artists they like to listen to, so it would be great if you could include songs from similar genres/sounds: \(selectedArtists). Ensure the sound of each song matches the user's selected mood (and respect each selected mood.
                """
            
            // Step 2: Send the prompt to the Groq API
            groqClient.sendPrompt(prompt) { [weak self] result in
                switch result {
                case .success(let songList):
                    // Parse the song list and process each artist
                    self?.processGroqResponse(songList)
                    print("SUCCESS WITH PROMPT")
                    print (songList)
                    
                case .failure(let error):
                    print("Error sending prompt: \(error.localizedDescription)")
                    self?.showError("Failed to generate playlist")
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func processGroqResponse(_ songList: String) {
        // Step 3: Parse the Groq response and fetch artist IDs for the songs
        let songs = parseSongList(songList) // Assumes you have a function to parse song text into Song structs
        
        var fetchedSongs: [Song] = []
        let group = DispatchGroup()
        
        for song in songs {
            group.enter()
            
            SpotifyAPIManager.shared.fetchArtistID(for: song.artist) { artistID in
                guard let artistID = artistID else {
                    print("Failed to fetch artist ID for \(song.artist)")
                    group.leave()
                    return
                }
                
                // Fetch additional data for the song using artist ID (if needed) here
                fetchedSongs.append(song) // You can also fetch other song details if necessary
                print("we just added: \(song) by \(song.artist)") // DEBUG
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard fetchedSongs.count == 20 else {
                self?.showError("Failed to retrieve 20 songs")
                return
            }
            
            // TODO: Generate playlist on Spotify
            print(fetchedSongs)
        }
    }
    
    // Function to parse the song list from Groq API into Song structs
    private func parseSongList(_ songList: String) -> [Song] {
       // TODO: IMPLEMENT THE PARSING
    }
    
    // - MARK: AnimateShow
    private func animateShow() {
        contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = .identity
        })
    }
    
    // - MARK: AnimateHide
    private func animateHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // - MARK: ShowError
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // - MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCell", for: indexPath) as! EmotionCell
        let emotion = emotions[indexPath.item]
        let isSelected = selectedEmotions.contains(indexPath)
        cell.configure(with: emotion, isSelected: isSelected)
        return cell
    }
        
    // - MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedEmotions.firstIndex(of: indexPath) {
            selectedEmotions.remove(at: index)
        } else {
            selectedEmotions.append(indexPath)
        }
        collectionView.reloadItems(at: [indexPath])
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let emotion = emotions[indexPath.item]
        let font = UIFont.systemFont(ofSize: 16)
        let textWidth = emotion.size(withAttributes: [NSAttributedString.Key.font: font]).width
        
        let padding: CGFloat = 20
        let itemWidth = textWidth + padding
        let itemHeight: CGFloat = 40
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
