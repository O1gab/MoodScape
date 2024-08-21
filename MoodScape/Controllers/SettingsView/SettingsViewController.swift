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
    
    private let settingsOptions = ["Change Password", "Log out", "Notification Preferences", "Help & Support", "Contact us"]
   
    private let exitButton: UIButton = {
        let exitButton = UIButton(type: .system)
        exitButton.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        exitButton.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    private let label: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "MoodScape"
        settingsLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(settingsLabel)
        view.addSubview(exitButton)
        view.addSubview(label)
        view.addSubview(settingsTableView)
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: exitButton.topAnchor, constant: -20),
            
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // - MARK: ExitTapped
    @objc private func exitTapped() {
        do {
            try Auth.auth().signOut()
            let startView = StartViewController()
            startView.modalPresentationStyle = .fullScreen
            self.present(startView, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: UITableViewDataSource
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
            // Handle selection
        let selectedOption = settingsOptions[indexPath.row]
        
        switch selectedOption {
            case "Change Password":
                print("TODO")
            
            case "Log Out":
                print("TODO")

            case "Privacy Settings":
                print("TODO")
            
            case "Notification Preferences":
                print("TODO")
            
            case "Help & Support":
                print("TODO")
            
            default:
                break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
