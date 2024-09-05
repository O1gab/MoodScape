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

class ProfileSetupViewController: ProfileBaseView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {

    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Set up your profile"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        topLabel.textAlignment = .center
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
        imageView.layer.cornerRadius = 50
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
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Your bio:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .none
        textView.textColor = .white
        textView.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 18
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let bioCharacterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/200"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let preferencesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set up preferences", for: .normal)
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
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
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
        fetchExistingData()
        loadProfileImage()
    }
    
    // - MARK: SetupView
    private func setupView() {
        backButton.isHidden = true
        
        view.addSubview(topLabel)
        view.addSubview(profileImage)
        view.addSubview(imageButton)
        view.addSubview(nameLabel)
        view.addSubview(name)
        view.addSubview(bioLabel)
        view.addSubview(bioField)
        view.addSubview(bioCharacterCountLabel)
        view.addSubview(preferencesButton)
        view.addSubview(submitButton)
        view.addSubview(skipButton)
        
        setPlaceholder(textField: name, placeholder: "Enter your first name", color: .gray)
        bioField.text = "Set up your description (max. 200 chars)"
        bioField.textColor = .gray
        
        
        preferencesButton.addTarget(self, action: #selector(editPreferences), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(changeProfileImageTapped), for: .touchUpInside)
        
        bioField.delegate = self
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            profileImage.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            
            imageButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            name.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            name.heightAnchor.constraint(equalToConstant: 55),
            
            bioLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30),
            bioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            bioField.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 10),
            bioField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bioField.heightAnchor.constraint(equalToConstant: 150),
            bioField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            bioCharacterCountLabel.topAnchor.constraint(equalTo: bioField.bottomAnchor, constant: 5),
            bioCharacterCountLabel.leadingAnchor.constraint(equalTo: bioField.leadingAnchor),
            
            preferencesButton.topAnchor.constraint(equalTo: bioCharacterCountLabel.bottomAnchor, constant: 15),
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
    
    // - MARK: FetchExistingData
    private func fetchExistingData() {
        guard let user = Auth.auth().currentUser else { return }
           
        let db = Firestore.firestore()
        let documentRef = db.collection("users").document(user.uid)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.name.text = data?["name"] as? String ?? ""
                self.bioField.text = data?["bio"] as? String ?? ""
            } else {
                print("Document does not exist or error occurred: \(String(describing: error))")
            }
        }
    }
    
    // - MARK: editPreferences
    @objc private func editPreferences() {
        let musicSetupView = MusicSetupView()
        musicSetupView.modalPresentationStyle = .fullScreen
        self.present(musicSetupView, animated: true)
    }
    
    // - MARK: HandleSave
    @objc private func handleSave() {
        // BIO CHECK
        let bioText = bioField.text ?? ""
        if bioText.count > 200 {
            print("Bio exceeds maximum character limit.")
            return
        }
        
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let documentRef = db.collection("users").document(user.uid)
        
        documentRef.updateData([
            "name": name.text ?? "",
            "bio": bioField.text ?? ""
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
    
    // - MARK: Change Profile Image
    @objc private func changeProfileImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // - MARK: UITextViewDelegate - Character Count and Placeholder Handling
    func textViewDidChange(_ textView: UITextView) {
        let maxLength = 200
        let currentText = textView.text ?? ""
        
        let charCount = currentText.count
        bioCharacterCountLabel.text = "\(charCount)/200"
        
        if charCount > maxLength {
            bioCharacterCountLabel.textColor = .red
        } else {
            bioCharacterCountLabel.textColor = .gray
        }
    }
    
    // Prevent user from entering more than 200 characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Set up your description (max. 200 chars)"
            textView.textColor = .gray
        }
    }
    
    // - MARK: HandleSkip
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImage.image = selectedImage
            saveProfileImage(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // - MARK: SaveProfileImage
    private func saveProfileImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
    }
    
    // - MARK: LoadProfileImage
    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImage.image = UIImage(data: imageData)
        } else {
            profileImage.image = UIImage(systemName: "person.circle")
        }
    }
}
