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
    
    // MARK: - SetupView
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
    
    // MARK: - ClosePopUp
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
        fetchSelectedArtists { [weak self] artistNames in
            guard let self = self, let artistNames = artistNames, !artistNames.isEmpty else {
                self?.showError("Failed to fetch artist names or no artists selected")
                return
            }
            
            let prompt = """
                Generate a JSON object representing a playlist based on the following criteria:

                1. User's current emotions: \(selectedEmotions)
                2. User's selected artists: \(selectedArtists)

                Guidelines:
                - Create a playlist of exactly 25 songs.
                - Each song should match the user's selected mood(s).
                - Lyrics should correlate with the mood/vibe.
                - Include songs from artists similar to the user's preferences.
                - Ensure the sound of each song aligns with the selected mood(s).
                - Give unique answers

                The JSON object should follow this schema:
                {
                  "playlist": [
                    {
                      "artist": "string",
                      "song": "string",
                      "id": "string"
                    }
                  ]
                }

                Provide the complete JSON object with 25 songs, ensuring all artist and song fields including song id taken from Spotify are filled.
                """
            
            // Step 2: Send the prompt to the Groq API
            groqClient.sendPrompt(prompt) { [weak self] result in
                switch result {
                case .success(let songList):
                    self?.processGroqResponse(songList)
                    
                case .failure(let error):
                    print("Error sending prompt: \(error.localizedDescription)")
                    self?.showError("Failed to generate playlist")
                }
            }
        }
        //dismiss(animated: true, completion: nil)
    }
    
    private func processGroqResponse(_ songList: String) {
        // Step 3: Parse the Groq response and fetch artist IDs for the songs
        let songs = parseSongList(songList)
        print(songs)
        var fetchedSongs: [Song] = []
        var trackURIs: [String] = []
        let group = DispatchGroup()
        
        for song in songs {
            group.enter()
            
            // Fetch the song details
            SpotifyAPIManager.shared.searchForTrack(artist: song.artist, song: song.name) { track in
                if let track = track {
                    
                    fetchedSongs.append(track)
                    trackURIs.append("spotify:track:\(track.id)")
                    
                    print("we just added: \(track) by \(track.artist)")  // DEBUG
                } else {
                    print("Track not found for \(song.name) by \(song.artist)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            
            guard let userID = UserDefaults.standard.string(forKey: "user_id") else {
                self?.showError("Failed to fetch UserID")
                return
            }
            print("user id was fetched!")
            
            // Create the playlist on Spotify
            SpotifyAPIManager.shared.createPlaylist(name: "MoodScape Playlist", userId: userID) { playlistID in
                guard let playlistID = playlistID else {
                    self?.showError("Failed to create Spotify playlist")
                    return
                }
                print("a new playlist was created!")
                
                // Add tracks to the newly created playlist
                SpotifyAPIManager.shared.addTracksToPlaylist(playlistID: playlistID, trackURIs: trackURIs) { success in
                    if success {
                        print("Playlist created and songs added successfully!")
                        let newPlaylist = NewPlaylistView()
                        self?.colorPlaylist(newPlaylist: newPlaylist)
                        self?.view.addSubview(newPlaylist)
                    } else {
                        self?.showError("Failed to add songs to playlist")
                    }
                }
            }
        }
    }
    
    func colorPlaylist(newPlaylist: NewPlaylistView) {
        let prompt = "Generate a pastel color based on the following emotions: \(selectedEmotions). The color should reflect the mood associated with these emotions. Return the color as an object with red, green, and blue (RGB) values. Only provide the RGB values generated as JSONObject"
        
        groqClient.sendPrompt(prompt) { [weak self] result in
            switch result {
            case .success(let response):
                guard let color = self?.parseGroqColorResponse(response) else {
                    let color = UIColor.black
                    newPlaylist.configure(with: color, date: Date())
                    return
                }
                newPlaylist.configure(with: color, date: Date())
            case .failure(_):
                break
            }
        }
    }
    
    func addSongsToPlaylist(playlistID: String, songs: [Song], accessToken: String) {
            let uris = songs.map { song in
                "spotify:track:\(song.id)" // Assuming `spotifyID` was fetched for each song
            }
            
            let urlString = "https://api.spotify.com/v1/playlists/\(playlistID)/tracks"
            guard let url = URL(string: urlString) else {
                showError("Invalid URL for adding tracks")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "uris": uris
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error adding tracks: \(error.localizedDescription)")
                    self.showError("Failed to add tracks to Spotify playlist")
                    return
                }
                
                print("Successfully added tracks to playlist")
            }
            
            task.resume()
    }
    
    // - MARK: ExtractJSON
    private func extractJSON(from response: String) -> String? {
        guard let startIndex = response.range(of: "{")?.lowerBound,
              let endIndex = response.range(of: "}", options: .backwards)?.upperBound else {
            print("Error: Unable to locate JSON boundaries.")
            return nil
        }
        
        let jsonSubstring = response[startIndex..<endIndex]
        
        let jsonString = String(jsonSubstring)
        return jsonString
    }

    
    // - MARK: ParseSongList
    private func parseSongList(_ jsonResponse: String) -> [Song] {
       // TODO: IMPLEMENT THE PARSING
        var parsedSongs: [Song] = []
        
        let corrected = extractJSON(from: jsonResponse)!
        
        guard let jsonData = corrected.data(using: .utf8) else {
            print("Error: Unable to convert string to Data. String might not be properly encoded.")
            return []
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                
                if let playlist = json["playlist"] as? [[String: Any]] {
                    
                    for songData in playlist {
                        if let artist = songData["artist"] as? String,
                           let songName = songData["song"] as? String,
                           let id = songData["id"] as? String {
                            
                            let song = Song(name: songName, id: id, artist: artist, duration: "N/A", spotifyUrl: "N/A", releaseDate: "N/A", imageUrl: nil)
                            parsedSongs.append(song)
                        } else {
                            print("Error: Missing artist or song in playlist entry.")
                        }
                    }
                } else {
                    print("Error: 'playlist' key is missing or not an array.")
                }
            } else {
                print("Error: JSON data is not a dictionary or does not match expected schema.")
            }
        } catch {
            print("Error parsing JSON data: \(error.localizedDescription)")
        }
        
        return parsedSongs
    }
    
    func parseGroqColorResponse(_ jsonResponse: String) -> UIColor? {
        guard let corrected = extractJSON(from: jsonResponse) else {
            return UIColor.black
        }
        
        guard let jsonData = corrected.data(using: .utf8) else {
            return UIColor.black
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                
                if let r = json["r"] as? Int,
                   let g = json["g"] as? Int,
                   let b = json["b"] as? Int {
                    
                    let color = UIColor(
                        red: CGFloat(r) / 255.0,
                        green: CGFloat(g) / 255.0,
                        blue: CGFloat(b) / 255.0,
                        alpha: 1.0
                    )
                    return color
                } else {
                    let newPlaylist = NewPlaylistView()
                    colorPlaylist(newPlaylist: newPlaylist)
                }
            } else {
                let newPlaylist = NewPlaylistView()
                colorPlaylist(newPlaylist: newPlaylist)
            }
        } catch {
            print("Error parsing JSON data: \(error.localizedDescription)")
        }
        
        return nil
        
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
