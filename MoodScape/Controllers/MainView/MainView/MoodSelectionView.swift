//
//  MoodSelectionView.swift
//  MoodScape
//
//

import UIKit

class MoodSelectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1.0)
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emotions = [
        "annoyed", "offended", "shocked", "disgusted", "guilty",
        "happy", "surprised", "pressured", "upset", "sad",
        "worried", "nervous", "embarrassed", "angry", "lonely",
        "nostalgic", "insecure", "disappointed", "powerless", "tired",
        "agressive", "scared", "energized", "confused", "doubtful"
    ]
    
    private var selectedEmotions: [IndexPath] = []
        
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
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
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
    
    @objc private func saveEmotions() {
        // TODO: Save selected emotions and generate a playlist based on the selection
        
        dismiss(animated: true, completion: nil)
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
    
    // - MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCell", for: indexPath) as! EmotionCell
        cell.configure(with: emotions[indexPath.item])
        cell.isSelected = selectedEmotions.contains(indexPath)
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
