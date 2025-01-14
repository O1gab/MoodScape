//
//  ProfileSetupViewController.swift
//  MoodScape
//
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileSetupViewController: ProfileBaseView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {

    // MARK: - Properties
    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Set up your profile"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 75
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your name:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let name: UITextField = {
        let name = UITextField()
        name.backgroundColor = .none
        name.textColor = .white
        name.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        name.layer.borderWidth = 2
        name.layer.cornerRadius = 18
        name.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: name.frame.height))
        name.leftViewMode = .always
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let preferencesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set up Preferences", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .white
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 30
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExistingData()
        loadProfileImage()
    }
    
    // MARK: - SetupView
    private func setupView() {
        backButton.isHidden = true
        
        view.addSubview(topLabel)
        view.addSubview(profileImage)
        view.addSubview(imageButton)
        view.addSubview(nameLabel)
        view.addSubview(name)
        view.addSubview(preferencesButton)
        view.addSubview(submitButton)
        view.addSubview(skipButton)
        
        preferencesButton.addTarget(self, action: #selector(editPreferences), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(changeProfileImageTapped), for: .touchUpInside)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            profileImage.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            imageButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            name.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            name.heightAnchor.constraint(equalToConstant: 55),
            
            preferencesButton.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            preferencesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            preferencesButton.widthAnchor.constraint(equalToConstant: 200),
            preferencesButton.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 160),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
                
            skipButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - FetchExistingData
    private func fetchExistingData() {
        guard let user = Auth.auth().currentUser else { return }
           
        let db = Firestore.firestore()
        let documentRef = db.collection("users").document(user.uid)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.name.text = data?["name"] as? String ?? ""
            } else {
                print("Document does not exist or error occurred: \(String(describing: error))")
            }
        }
    }
    
    // MARK: - EditPreferences
    @objc private func editPreferences() {
        let musicSetupView = MusicSetupView()
        musicSetupView.modalPresentationStyle = .fullScreen
        self.present(musicSetupView, animated: true)
    }
    
    // MARK: HandleSave
    @objc private func handleSave() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let documentRef = db.collection("users").document(user.uid)
        
        documentRef.updateData([
            "name": name.text ?? "",
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Data successfully updated")
                let profileView = ProfileViewController()
                profileView.modalPresentationStyle = .overCurrentContext
                self.present(profileView, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Change Profile Image
    @objc private func changeProfileImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - HandleSkip
    @objc private func handleSkip() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // - MARK: SetPlaceholder
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
    // MARK: - ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            saveProfileImage(image: selectedImage)
        }
    }
    
    // MARK: SaveProfileImage
    private func saveProfileImage(image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid,
              let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        ImageCache.shared.setImage(image, forKey: userId)
        
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId)/profile.jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let loadingAlert = UIAlertController(title: nil, message: "Uploading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true)
        
        profileImageRef.putData(imageData, metadata: metadata) { [weak self] metadata, error in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
            
            if let error = error {
                print("Error uploading profile image: \(error)")
                DispatchQueue.main.async {
                    self?.showError("Failed to upload image")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.profileImage.image = image
            }
        }
    }
    
    // MARK: LoadProfileImage
    private func loadProfileImage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(forKey: userId) {
            profileImage.image = cachedImage
            return
        }
        
        // If not in cache, load from Firebase Storage
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId)/profile.jpg")
        
        // Set default image while loading
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.tintColor = .white
        
        profileImageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading profile image: \(error)")
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                // Cache the image
                ImageCache.shared.setImage(image, forKey: userId)
                
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }
    }
    
    // Add helper function for error alerts
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
