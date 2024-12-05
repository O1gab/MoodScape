//
//  SettingsViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth

class SettingsViewController: ProfileBaseView, UITableViewDelegate, UITableViewDataSource {
    
    private let settingsLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
    
    private let settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        return tableView
    }()
    
    private let settingsOptions = ["Change Password", "Help & Support", "Contact us", "Log Out"]
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "MoodScape"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contactView: ContactViewController = {
        let viewController = ContactViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private lazy var authView: AuthViewController = {
        let viewController = AuthViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(settingsLabel)
        view.addSubview(label)
        view.addSubview(settingsTableView)
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20),
            
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsOptions[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = settingsOptions[indexPath.row]
        
        switch selectedOption {
            case "Change Password":
                print("TODO")
            
            case "Help & Support":
                contactView.modalPresentationStyle = .fullScreen
                self.present(contactView, animated: true)
            
            case "Contact us":
                contactView.modalPresentationStyle = .fullScreen
                self.present(contactView, animated: true)
            
            case "Log Out":
                loadingIndicator.startAnimating()
                do {
                    try Auth.auth().signOut()
                    authView.modalPresentationStyle = .overCurrentContext
                    self.present(authView, animated: false) {
                        self.loadingIndicator.stopAnimating()
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                    loadingIndicator.stopAnimating()
                }
            
            default:
                break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
