//
//  ProfileSetupViewController.swift
//  MoodScape
//
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileSetupViewController: UIViewController {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstName: UITextField = {
        let name = UITextField()
        name.backgroundColor = .none
        name.textColor = .black
        name.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        name.layer.borderWidth = 2
        name.layer.cornerRadius = 18
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let lastName: UITextField = {
        let name = UITextField()
        name.backgroundColor = .none
        name.textColor = .black
        name.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        name.layer.borderWidth = 2
        name.layer.cornerRadius = 18
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
        
    // fix it as geopoint
    let location: UITextField = {
        let location = UITextField()
        location.backgroundColor = .none
        location.textColor = .black
        location.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        location.layer.borderWidth = 2
        location.layer.cornerRadius = 18
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
    }()
    
    // multiple choice
    let musicPreferences: UITextField = {
        let music = UITextField()
        music.backgroundColor = .none
        music.textColor = .black
        music.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        music.layer.borderWidth = 2
        music.layer.cornerRadius = 18
        music.translatesAutoresizingMaskIntoConstraints = false
        return music
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    let addProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I'll do it later", for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupForm()
        setupConstraints()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        view.addSubview(contentView)
        contentView.addSubview(firstName)
        contentView.addSubview(lastName)
        contentView.addSubview(location)
        contentView.addSubview(musicPreferences)
        contentView.addSubview(profileImageView)
        contentView.addSubview(addProfileImageButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(closeButton)
        
        setPlaceholder(textField: firstName, placeholder: " Enter your first name", color: .systemGray)
        setPlaceholder(textField: lastName, placeholder: " Enter your last name", color: .systemGray)
        setPlaceholder(textField: location, placeholder: " Enter your location", color: .systemGray)
        setPlaceholder(textField: musicPreferences, placeholder: " Enter your music preferences", color: .systemGray)
                
        addProfileImageButton.addTarget(self, action: #selector(handleAddProfileImage), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.67),
                
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
                
            addProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            addProfileImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                
            firstName.topAnchor.constraint(equalTo: addProfileImageButton.bottomAnchor, constant: 20),
            firstName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            firstName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            firstName.heightAnchor.constraint(equalToConstant: 40),
                
            lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 10),
            lastName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lastName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lastName.heightAnchor.constraint(equalToConstant: 40),
                
            location.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 10),
            location.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            location.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            location.heightAnchor.constraint(equalToConstant: 40),
                
            musicPreferences.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            musicPreferences.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            musicPreferences.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            musicPreferences.heightAnchor.constraint(equalToConstant: 40),
                
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
                
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func handleAddProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
       
    @objc private func handleSave() {
        guard let user = Auth.auth().currentUser else { return }
           
        let ref = Database.database().reference().child("users").child(user.uid)
        let values = [
            "first_name": firstName.text ?? "",
            "last_name": lastName.text ?? "",
            "location": location.text ?? "",
            "music_preferences": musicPreferences.text ?? ""
        ]
           
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to update user:", error)
                return
            }
               
            print("Successfully updated user")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateShow()
    }
    
    @objc func closePopUp() {
        animateHide()
    }
    
    func animateShow() {
        contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = .identity
        })
    }
       
    func animateHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
            
}



