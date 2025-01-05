//
//  SongDetailsViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 02.09.24.
//

import UIKit
import SafariServices

class SongDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var song: Song
    
    let groqClient = GroqAPIClient()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let spotifyLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Spotify_Icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let songName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider: CALayer = {
        let divider = CALayer()
        divider.backgroundColor = UIColor.lightGray.cgColor
        return divider
    }()
    
    private let similarSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "Other similar Songs"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let similarSongsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SimilarSongCell.self, forCellWithReuseIdentifier: "SimilarSongCell")
        return collectionView
    }()
    
    private var similarSongs: [Song] = []
    
    private let spotifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open on Spotify", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .yellow
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var hasFetchedSimilarSongs = false
    
    // MARK: - Initializer
    init(song: Song) {
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureWithSong()
    }
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFavorites()
    }
    
    // MARK: ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let releaseDateLabelFrame = releaseDateLabel.superview?.convert(releaseDateLabel.frame, to: contentView) else { return }
        divider.frame = CGRect(
            x: 10,
            y: releaseDateLabelFrame.maxY + 15,
            width: contentView.frame.width - 20,
            height: 2
        )
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(songImageView)
        contentView.addSubview(spotifyLogoImageView)
        contentView.addSubview(artistLabel)
        contentView.addSubview(songName)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(similarSongsLabel)
        contentView.addSubview(similarSongsCollectionView)
        contentView.addSubview(spotifyButton)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(shareButton)
        
        contentView.layer.addSublayer(divider)
        
        releaseDateLabel.alpha = 0
        divider.opacity = 0
        similarSongsLabel.alpha = 0
        
        closeButton.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        spotifyButton.addTarget(self, action: #selector(openInSpotify), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareAlbum), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openInSpotify))
        songImageView.addGestureRecognizer(tapGesture)
        songImageView.isUserInteractionEnabled = true
        
        similarSongsCollectionView.delegate = self
        similarSongsCollectionView.dataSource = self
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            songImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            songImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            songImageView.widthAnchor.constraint(equalToConstant: 300),
            songImageView.heightAnchor.constraint(equalToConstant: 300),
            
            spotifyLogoImageView.bottomAnchor.constraint(equalTo: songImageView.bottomAnchor, constant: -8),
            spotifyLogoImageView.trailingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: -8),
            spotifyLogoImageView.widthAnchor.constraint(equalToConstant: 50),
            spotifyLogoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            artistLabel.topAnchor.constraint(equalTo: songImageView.bottomAnchor, constant: 10),
            artistLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            songName.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            songName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            songName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            songName.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            releaseDateLabel.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 10),
            releaseDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            similarSongsLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 40),
            similarSongsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            similarSongsCollectionView.topAnchor.constraint(equalTo: similarSongsLabel.bottomAnchor, constant: 20),
            similarSongsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            similarSongsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            similarSongsCollectionView.heightAnchor.constraint(equalToConstant: 350),
            
            favoriteButton.centerYAnchor.constraint(equalTo: spotifyButton.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: spotifyButton.leadingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            spotifyButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            spotifyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spotifyButton.widthAnchor.constraint(equalToConstant: 180),
            spotifyButton.heightAnchor.constraint(equalToConstant: 60),
            
            shareButton.centerYAnchor.constraint(equalTo: spotifyButton.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: spotifyButton.trailingAnchor, constant: 20),
            shareButton.widthAnchor.constraint(equalToConstant: 60),
            shareButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - CheckFavorites
    private func checkFavorites() {
        if FavoritesManager.shared.isFavoriteSong(song) {
            self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    // MARK: ClosePopUp
    @objc func closePopUp() {
        animateHide()
    }
    
    // MARK: AnimateShow
    func animateShow() {
        contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = .identity
        })
    }
    
    // MARK: AnimateHide
    func animateHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: AnimateElements
    private func animateElements() {
        UIView.animate(withDuration: 0.5, animations: {
            self.releaseDateLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.divider.opacity = 1
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.similarSongsLabel.alpha = 1
                })
            }
        }
    }
    
    // MARK: - OpenInSpotify
    @objc private func openInSpotify() {
        if let url = URL(string: song.spotifyUrl) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - ConfigureWithSong
    private func configureWithSong() {
        if let url = URL(string: song.imageUrl ?? "") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.songImageView.image = image
                    if let color = image.dominantColor() {
                        let complementaryColor = color.complementaryColor()
                        self.animateBackgroundGradient(from: color, to: complementaryColor)
                        self.artistLabel.textColor = color.contrastingColor()
                        self.songName.textColor = color.contrastingComplementaryColor()
                        self.shareButton.tintColor = color.contrastingColor()
                    }
                }
            }
            task.resume()
        }
        artistLabel.text = "\(song.artist)"
        songName.text = "\(song.name)"
        releaseDateLabel.text = "Released: \(song.releaseDate)"
        animateElements()
        
        // Only fetch similar songs if we haven't already
        if !hasFetchedSimilarSongs {
            fetchSimilarSongsWithGroq()
            hasFetchedSimilarSongs = true
        }
    }
    
    // MARK: AnimateBackgroundGradient
    private func animateBackgroundGradient(from dominantColor: UIColor, to complementaryColor: UIColor) {
        var adjustedDominantColor = dominantColor
        var adjustedComplementaryColor = complementaryColor
            
        // Check if the colors are too similar and adjust
        if dominantColor.isTooSimilar(to: complementaryColor) {
            adjustedDominantColor = dominantColor.darker(by: 20)
            adjustedComplementaryColor = complementaryColor.lighter(by: 20)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [adjustedDominantColor.cgColor, adjustedComplementaryColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.contentView.bounds
        gradientLayer.cornerRadius = self.contentView.layer.cornerRadius
        gradientLayer.name = "backgroundGradient"
        
        if let oldGradientLayer = self.contentView.layer.sublayers?.first(where: { $0.name == "backgroundGradient" }) {
            oldGradientLayer.removeFromSuperlayer()
        }
        
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [adjustedDominantColor.cgColor, adjustedComplementaryColor.cgColor]
        animation.toValue = [adjustedComplementaryColor.cgColor, adjustedDominantColor.cgColor]
        animation.duration = 7.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: nil)
    }
    
    // MARK: - ToggleFavorite
    @objc private func toggleFavorite() {
        if FavoritesManager.shared.isFavoriteSong(song) {
            FavoritesManager.shared.removeFavoriteSong(song)
            self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            NotificationCenter.default.post(name: .songRemoved, object: nil, userInfo: ["song": song])
        } else {
            FavoritesManager.shared.addFavoriteSong(song)
            self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        let feedback = FavoritesManager.shared.isFavoriteSong(song) ? "Added to favorites" : "Removed from favorites"
        let alert = UIAlertController(title: nil, message: feedback, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: ShareAlbum
    @objc private func shareAlbum() {
        let activityViewController = UIActivityViewController(activityItems: [song.spotifyUrl], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - FetchSimilarSongsWithGroq
    private func fetchSimilarSongsWithGroq() {
        let prompt = """
        Generate a JSON object representing a playlist based on the following criteria:

        1. Selected song: \(song.name)
        2. Artist of the selected song: \(song.artist)

        Guidelines:
        - Find similar songs to this one
        - Give unique answers

        The JSON object should follow this schema:
        {
          "song": [
            {
              "artist": "string",
              "name": "string",
              "id": "string"
            }
          ]
        }

        Provide the complete JSON object with 10 songs, ensuring all artist and song fields including song id taken from Spotify are filled.
        """
        
        groqClient.sendPrompt(prompt) { [weak self] result in
            switch result {
            case .success(let response):
                if let jsonString = self?.extractJSON(from: response) {
                    print(response)
                    self?.processSimilarSongs(jsonString)
                }
            case .failure(let error):
                print("Error getting similar songs: \(error)")
            }
        }
    }

    private func extractJSON(from response: String) -> String? {
        guard let startIndex = response.range(of: "{")?.lowerBound,
              let endIndex = response.range(of: "}", options: .backwards)?.upperBound else {
            print("Error: Unable to locate JSON boundaries.")
            return nil
        }
        
        let jsonSubstring = response[startIndex..<endIndex]
        return String(jsonSubstring)
    }

    private func processSimilarSongs(_ jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let songs = json["song"] as? [[String: Any]] {
                
                similarSongs = songs.compactMap { songData -> Song? in
                    guard let artist = songData["artist"] as? String,
                          let name = songData["name"] as? String,
                          let id = songData["id"] as? String else {
                        return nil
                    }
                    
                    return Song(
                        name: name,
                        id: id,
                        artist: artist,
                        duration: "",
                        spotifyUrl: "https://open.spotify.com/track/\(id)",
                        releaseDate: "",
                        imageUrl: ""
                    )
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.similarSongsCollectionView.reloadData()
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
}

extension SongDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let song = similarSongs[indexPath.item]
        let text = "\"\(song.name)\" by \(song.artist)"
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 20
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension SongDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarSongCell", for: indexPath) as! SimilarSongCell
        let song = similarSongs[indexPath.item]
        cell.configure(with: song)
        
        // Add smaller random horizontal offset only
        let randomX = CGFloat.random(in: -10...10)
        cell.transform = CGAffineTransform(translationX: randomX, y: 0)
        
        return cell
    }
}

extension SongDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedSong = similarSongs[indexPath.item]
        
        if let url = URL(string: selectedSong.spotifyUrl) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
}
