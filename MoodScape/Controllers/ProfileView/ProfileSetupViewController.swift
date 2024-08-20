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
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1.0)
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstName: UITextField = {
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
    
    private let lastName: UITextField = {
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
        
    // fix it as geopoint
    private let location: UITextField = {
        let location = UITextField()
        location.backgroundColor = .none
        location.textColor = .white
        location.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        location.layer.borderWidth = 2
        location.layer.cornerRadius = 18
        location.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: location.frame.height))
        location.leftViewMode = .always
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
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
        
    private let addProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I'll do it later", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupView()
        setupConstraints()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(contentView)
        contentView.addSubview(firstName)
        contentView.addSubview(lastName)
        contentView.addSubview(location)
        contentView.addSubview(profileImageView)
        contentView.addSubview(addProfileImageButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(closeButton)
        
        setPlaceholder(textField: firstName, placeholder: "Enter your first name", color: .systemGray)
        setPlaceholder(textField: lastName, placeholder: "Enter your last name", color: .systemGray)
        setPlaceholder(textField: location, placeholder: "Enter your location", color: .systemGray)
                
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
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                
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
                
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 160),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
                
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    // - MARK: HandleAddProfileImage
    @objc private func handleAddProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // - MARK: HandleSave
    @objc private func handleSave() {
        guard let user = Auth.auth().currentUser else { return }
           
        let ref = Database.database().reference().child("users").child(user.uid)
        let values = [
            "first_name": firstName.text ?? "",
            "last_name": lastName.text ?? "",
            "location": location.text ?? ""
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
    
    // - MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateShow()
    }
    
    // - MARK: ClosePopUp
    @objc private func closePopUp() {
        animateHide()
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
    
    // - MARK: SetPlaceholder
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
}
