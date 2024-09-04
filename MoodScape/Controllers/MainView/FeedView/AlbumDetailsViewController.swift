//
//  AlbumDetailsViewController.swift
//  MoodScape
//
//

import UIKit
import SafariServices

class AlbumDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var album: Album
    
    private var isSelected: Bool = false
    
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
    
    private let albumImageView: UIImageView = {
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
    
    private let albumName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider: CALayer = {
        let divider = CALayer()
        divider.backgroundColor = UIColor.lightGray.cgColor
        return divider
    }()
    
    private let spotifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open in Spotify", for: .normal)
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
    
    private let topSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "The Best 3 Songs from this Album:"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topSongsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        topSongsTableView.dataSource = self
        topSongsTableView.delegate = self
    }
    
    // - MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWithAlbum()
        checkFavorites()
    }
    
    // - MARK: ViewDidLayoutSubviews
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
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(albumImageView)
        contentView.addSubview(spotifyLogoImageView)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(albumName)
        contentView.addSubview(spotifyButton)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(topSongsTableView)
        contentView.addSubview(topSongsLabel)
        
        contentView.layer.addSublayer(divider)
        
        closeButton.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        spotifyButton.addTarget(self, action: #selector(openInSpotify), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareAlbum), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openInSpotify))
        albumImageView.addGestureRecognizer(tapGesture)
        albumImageView.isUserInteractionEnabled = true
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
            
            albumImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            albumImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 300),
            albumImageView.heightAnchor.constraint(equalToConstant: 300),
            
            spotifyLogoImageView.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: -8),
            spotifyLogoImageView.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: -8),
            spotifyLogoImageView.widthAnchor.constraint(equalToConstant: 50),
            spotifyLogoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            artistLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 10),
            artistLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            albumName.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            albumName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            releaseDateLabel.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 10),
            releaseDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            favoriteButton.centerYAnchor.constraint(equalTo: spotifyButton.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: spotifyButton.leadingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            topSongsLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 30),
            topSongsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topSongsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            topSongsTableView.topAnchor.constraint(equalTo: topSongsLabel.bottomAnchor, constant: 15),
            topSongsTableView.leadingAnchor.constraint(equalTo: topSongsLabel.leadingAnchor, constant: 20),
            topSongsTableView.trailingAnchor.constraint(equalTo: topSongsLabel.trailingAnchor, constant: -20),
            topSongsTableView.bottomAnchor.constraint(equalTo: spotifyButton.topAnchor, constant: -20),
            
            spotifyButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            spotifyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spotifyButton.widthAnchor.constraint(equalToConstant: 160),
            spotifyButton.heightAnchor.constraint(equalToConstant: 60),
            
            shareButton.centerYAnchor.constraint(equalTo: spotifyButton.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: spotifyButton.trailingAnchor, constant: 20),
            shareButton.widthAnchor.constraint(equalToConstant: 60),
            shareButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkFavorites() {
        if FavoritesManager.shared.isFavoriteAlbum(album) {
            self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    // - MARK: ClosePopUp
    @objc func closePopUp() {
        animateHide()
    }
    
    // - MARK: AnimateShow
    func animateShow() {
        contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = .identity
        })
    }
    
    // - MARK: AnimateHide
    func animateHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // - MARK: OpenInSpotify
    @objc private func openInSpotify() {
        if let url = URL(string: album.spotifyUrl) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    // - MARK: ConfigureWithAlbum
    private func configureWithAlbum() {
        if let url = URL(string: album.imageUrl) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.albumImageView.image = image
                    if let color = image.dominantColor() {
                        let complementaryColor = color.complementaryColor()
                        self.animateBackgroundGradient(from: color, to: complementaryColor)
                        self.artistLabel.textColor = color.contrastingColor()
                        self.albumName.textColor = color.contrastingComplementaryColor()
                        self.shareButton.tintColor = color.contrastingColor()
                        self.topSongsLabel.textColor = color.contrastingComplementaryColor()
                        self.releaseDateLabel.textColor = color.contrastingColor()
                    }
                   
                }
            }
            task.resume()
        }
        releaseDateLabel.text = "Release Date: \(album.releaseDate)"
        artistLabel.text = "\(album.artist)"
        albumName.text = "\(album.name)"
        topSongsTableView.reloadData()
    }
    
    // - MARK: AnimateBackgroundGradient
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
    
    // - MARK: ToggleFavorite
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        if FavoritesManager.shared.isFavoriteAlbum(album) {
            FavoritesManager.shared.removeFavoriteAlbum(album)
            self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            
            NotificationCenter.default.post(name: .albumRemoved, object: nil, userInfo: ["album": album])
        } else {
            FavoritesManager.shared.addFavoriteAlbum(album)
            self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        // Optionally, update UI or notify the user
        let feedback = FavoritesManager.shared.isFavoriteAlbum(album) ? "Added to favorites" : "Removed from favorites"
        let alert = UIAlertController(title: nil, message: feedback, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // - MARK: ShareAlbum
    @objc private func shareAlbum() {
        let activityViewController = UIActivityViewController(activityItems: [album.spotifyUrl], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // - MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.topSongs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        
        if let backgroundColor = self.view.colorAtPoint(point: cell.frame.origin) {
            cell.songLabel.textColor = backgroundColor.contrastingColor()
        }
        
        let song = album.topSongs[indexPath.row]
        cell.configure(with: song)
        return cell
    }
    
    // - MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = album.topSongs[indexPath.row]
        
        if let url = URL(string: song.spotifyUrl) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}
