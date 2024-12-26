//
//  SocialViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SocialViewController: MainBaseView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Properties
    private var allUsers: [User] = []
    private var filteredUsers: [User] = []
    
    let friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Friends"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search friends"
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "No friends now. Add them by their username!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addFriendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add friends", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        fetchFriends()
        setupTableView()
        fetchAllUsers()
    }
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupView
    private func setupView() {
        searchBar.delegate = self
        searchBar.target(forAction: #selector(searchBarSearchButtonClicked), withSender: .none)
        view.addSubview(friendsLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(noFriendsLabel)
        view.addSubview(addFriendsButton)
        addFriendsButton.addTarget(self, action: #selector(addFriendsButtonTapped), for: .touchUpInside)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            friendsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            friendsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    
            searchBar.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15), ///?
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
            noFriendsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFriendsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    
            addFriendsButton.topAnchor.constraint(equalTo: noFriendsLabel.bottomAnchor, constant: 20),
            addFriendsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addFriendsButton.widthAnchor.constraint(equalToConstant: 160),
            addFriendsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - FetchFriends
    private func fetchFriends() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    // THERES FRIENDS
                    if let friends = data?["friends_ids"] as? [String] {
                        self.noFriendsLabel.isHidden = true
                        self.addFriendsButton.isHidden = true
                        self.searchBar.isHidden = false
                    } else {
                        // NO FRIENDS :(
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: - FetchAllUsers
    private func fetchAllUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            if let documents = querySnapshot?.documents {
                self?.allUsers = documents.compactMap { User(data: $0.data()) }
                self?.filteredUsers = self?.allUsers ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    // - MARK: AddFriend
    private func addFriend(user: User) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)
        let friendRef = db.collection("users").document(user.id)
        
        userRef.updateData([
            "friends": FieldValue.arrayUnion([user.id])
        ]) { error in
            if let error = error {
                print("Error adding friend: \(error.localizedDescription)")
                return
            }
            
            friendRef.updateData([
                "friends": FieldValue.arrayUnion([currentUserId])
            ]) { error in
                if let error = error {
                    print("Error updating friend list: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - AddFriendsButtonTapped Method
    @objc private func addFriendsButtonTapped() {
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - SearchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          searchBar.resignFirstResponder()
      }
    
    // MARK: UISearchBarDelegate  <- MAIN SEARCH BAR FUNCTIONALITY
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = []
            tableView.isHidden = true
            return
        }
        
        // Show table view when searching
        tableView.isHidden = false
        
        // Filter users based on search text
        filteredUsers = allUsers.filter { user in
            user.username.lowercased().contains(searchText.lowercased())
        }
        
        // Update UI
        tableView.reloadData()
        
        // Show/hide no results message
        if filteredUsers.isEmpty {
            noFriendsLabel.text = "No users found"
            noFriendsLabel.isHidden = false
        } else {
            noFriendsLabel.isHidden = true
        }
    }
    
    // MARK: - SetupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.5)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = filteredUsers[indexPath.row]
        
        // Configure cell
        cell.textLabel?.text = user.username
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        // Add "Add Friend" button
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0), for: .normal)
        addButton.tag = indexPath.row
        addButton.addTarget(self, action: #selector(addFriendButtonTapped(_:)), for: .touchUpInside)
        
        cell.accessoryView = addButton
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        //addFriend(user: user) -> ERROR HERE
    }
    
    // Add method to handle add friend button tap
    @objc private func addFriendButtonTapped(_ sender: UIButton) {
        let user = filteredUsers[sender.tag]
        addFriend(user: user)
    }
}
