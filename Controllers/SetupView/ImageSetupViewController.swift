//
//  ImageSetupView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit
import Gifu
import FirebaseAuth
import FirebaseStorage

class ImageSetupView: SetupBaseView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 30
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(red: 181/255, green: 23/255, blue: 23/255, alpha: 1.0), for: .normal)
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
        loadProfileImage()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(gifGradient)
        view.addSubview(profileImageView)
        view.addSubview(fieldLabel)
        view.addSubview(submitButton)
        view.addSubview(skipButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
        
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
    }
    
    // - MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: "Select your profile's future image", typingSpeed: 0.04) {
                self?.revealButton(button: self?.submitButton ?? UIButton())
                self?.revealButton(button: self?.skipButton ?? UIButton())
            }
        }
    }
    
    // - MARK: ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            
            fieldLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            fieldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            
            skipButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 80),
            skipButton.leadingAnchor.constraint(equalTo: fieldLabel.leadingAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 120),
            skipButton.heightAnchor.constraint(equalToConstant: 60),
            
            submitButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 80),
            submitButton.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 45),
            submitButton.widthAnchor.constraint(equalToConstant: 150),
            submitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // - MARK: SelectProfileImage
    @objc private func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // - MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            saveProfileImage(image: selectedImage)
            profileImageView.image = selectedImage
        }
    }
    
    // - MARK: SaveProfileImage
    private func saveProfileImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.75),
              let userId = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference()
        print("storage ref: \(storageRef)")
        let profileImageRef = storageRef.child("profile_images/\(userId).jpg")
        
        // Upload the image
        profileImageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            
            // Get download URL
            profileImageRef.downloadURL { url, error in
                if let downloadURL = url {
                    print("Image uploaded successfully: \(downloadURL)")
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }
        }
    }
    
    // - MARK: LoadProfileImage
    private func loadProfileImage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId).jpg")
        
        profileImageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    self?.profileImageView.image = UIImage(systemName: "person.crop.circle")
                }
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }
        }
    }
    
    // - MARK: HandleSubmit
    @objc private func handleSubmit() {
        guard let image = profileImageView.image else {
            // TODO: implement error label
            return
        }
        navigateToNextView(viewController: SpotifySetupView())
    }
    
    // - MARK: HandleSkip
    @objc private func handleSkip() {
        navigateToNextView(viewController: SpotifySetupView())
    }
}

