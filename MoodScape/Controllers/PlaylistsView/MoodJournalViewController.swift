//
//  GeneratedPlaylistsViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 18.09.24.
//

import UIKit
import Gifu
import FSCalendar

class MoodJournalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FSCalendarDelegate, FSCalendarDataSource {
    
    private var playlists: [Playlist] = []
    private var collectionView: UICollectionView!
    private var calendar: FSCalendar!
    
    // MARK: - Properties
    private let gifBackground: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Your Mood Journal"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let calendarLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "History"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
    }()
    
    private let noPlaylistsLabel: UILabel = {
        let label = UILabel()
        label.text = "No playlists generated yet"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        loadPlaylists()
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
        view.addSubview(gifGradient)
        
        view.addSubview(backButton)
        view.addSubview(topLabel)
        view.addSubview(noPlaylistsLabel)
        setupCollectionView()
        setupCalendar()
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gifBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            // "Your Mood Journal"
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            
            noPlaylistsLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 40),
            noPlaylistsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Collection view
            collectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: -25),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            
            // Calendar label
            calendarLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            calendarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Calendar
            calendar.topAnchor.constraint(equalTo: calendarLabel.bottomAnchor, constant: 20),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: - SetupCollectionView
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GeneratedPlaylistCell.self, forCellWithReuseIdentifier: "GeneratedPlaylistCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    // MARK: - SetupCalendar
     private func setupCalendar() {
         calendar = FSCalendar(frame: .zero)
         calendar.translatesAutoresizingMaskIntoConstraints = false
         calendar.delegate = self
         calendar.dataSource = self
         calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 16)
         calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
         calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 14)
         calendar.appearance.headerTitleColor = UIColor.white
         calendar.appearance.weekdayTextColor = UIColor.white
         calendar.appearance.selectionColor = UIColor.clear
         calendar.appearance.todayColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
         view.addSubview(calendar)
         view.addSubview(calendarLabel)
     }
    
    // MARK: - LoadPlaylists
    private func loadPlaylists() {
        playlists = PlaylistStorage().fetchPlaylists()
        collectionView.reloadData()
        noPlaylistsLabel.isHidden = !playlists.isEmpty
    }
    
    // MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Handle Pan Gesture
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                view.frame.origin.y = translation.y // Move the view down as you scroll
            }
        case .ended:
            if translation.y > 100 { // If swiped down enough, dismiss
                dismiss(animated: true, completion: nil)
            } else {
                // Reset position if not swiped enough
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = 0
                }
            }
        default:
            break
        }
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneratedPlaylistCell", for: indexPath) as! GeneratedPlaylistCell
        let playlist = playlists[indexPath.item]
        cell.configure(with: playlist)
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    // MARK: Open URL when a cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.item]
        UIApplication.shared.open(playlist.spotifyURL, options: [:], completionHandler: nil)
    }
    
    // MARK: - FSCalendarDataSource
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let playlistDates = playlists.map { $0.date }
        let currentDateString = dateFormatter.string(from: date)
        
        return playlistDates.contains(currentDateString) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let selectedDateString = dateFormatter.string(from: date)
        let playlistsForDate = playlists.filter { $0.date == selectedDateString }
        
        if !playlistsForDate.isEmpty {
            showPlaylists(for: playlistsForDate, date: selectedDateString)
        }
    }

    // MARK: FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let playlistDates = playlists.map { $0.date }
        let currentDateString = dateFormatter.string(from: date)
        
        if let playlist = playlists.first(where: { $0.date == dateFormatter.string(from: date) }) {
            return playlist.color // dot color matching playlist color
        }
        return UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
    }
    
    private func showPlaylists(for playlists: [Playlist], date: String) {
        let playlistViewController = PlaylistsForDateViewController()
        playlistViewController.playlists = playlists
        playlistViewController.selectedDate = date
        present(playlistViewController, animated: true, completion: nil)
    }
}
