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

class ProfileSetupViewController: ProfileBaseView {

    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Set up your profile"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        topLabel.textAlignment = .center
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
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
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your first name:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your last name:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let location: UITextField = {
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
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Your location:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.setTitle("I will do it later", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let countries = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }.sorted()
        
    private let countryPicker = UIPickerView()
    
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
    }

    
    // - MARK: SetupView
    private func setupView() {
        backButton.isHidden = true
        
        view.addSubview(topLabel)
        view.addSubview(firstNameLabel)
        view.addSubview(firstName)
        view.addSubview(lastNameLabel)
        view.addSubview(lastName)
        view.addSubview(locationLabel)
        view.addSubview(location)
        view.addSubview(submitButton)
        view.addSubview(skipButton)
        
        setPlaceholder(textField: firstName, placeholder: "Enter your first name", color: .gray)
        setPlaceholder(textField: lastName, placeholder: "Enter your last name", color: .gray)
        setPlaceholder(textField: location, placeholder: "Choose your location", color: .gray)
                
        submitButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        location.inputView = countryPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        location.inputAccessoryView = toolbar
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            firstNameLabel.topAnchor.constraint(equalTo: firstName.topAnchor, constant: -30),
            firstNameLabel.leadingAnchor.constraint(equalTo: firstName.leadingAnchor, constant: 5),
            
            firstName.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 55),
            firstName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstName.heightAnchor.constraint(equalToConstant: 55),
            
            lastNameLabel.topAnchor.constraint(equalTo: lastName.topAnchor, constant: -30),
            lastNameLabel.leadingAnchor.constraint(equalTo: lastName.leadingAnchor, constant: 5),
            
            lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 50),
            lastName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lastName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lastName.heightAnchor.constraint(equalToConstant: 55),
            
            locationLabel.topAnchor.constraint(equalTo: location.topAnchor, constant: -30),
            locationLabel.leadingAnchor.constraint(equalTo: location.leadingAnchor, constant: 5),
            
            location.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 50),
            location.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            location.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            location.heightAnchor.constraint(equalToConstant: 55),
                
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
                self.firstName.text = data?["first_name"] as? String ?? ""
                self.lastName.text = data?["last_name"] as? String ?? ""
                self.location.text = data?["location"] as? String ?? ""
            } else {
                print("Document does not exist or error occurred: \(String(describing: error))")
            }
        }
    }
    
    // - MARK: HandleSave
    @objc private func handleSave() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let documentRef = db.collection("users").document(user.uid)
        
        documentRef.updateData([
            "first_name": firstName.text ?? "",
            "last_name": lastName.text ?? "",
            "location": location.text ?? ""
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
    
    // - MARK: DonePicker
    @objc private func donePicker() {
        view.endEditing(true)
    }
}
