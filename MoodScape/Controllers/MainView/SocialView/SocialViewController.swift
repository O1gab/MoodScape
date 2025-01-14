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
    
    private let friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Friends"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let requestsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Your Friend Requests: 0", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .darkGray
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.layer.cornerRadius = 20
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    private var noFriends: Bool = true // :(
    
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
        button.layer.cornerRadius = 30
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var requestsView: FriendRequestsController = {
        let viewController = FriendRequestsController()
        viewController.loadViewIfNeeded()
        return viewController
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
        view.addSubview(requestsButton)
        addFriendsButton.addTarget(self, action: #selector(addFriendsButtonTapped), for: .touchUpInside)
        requestsButton.addTarget(self, action: #selector(requestsButtonTapped), for: .touchUpInside)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            friendsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            friendsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            requestsButton.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor, constant: 10),
            requestsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            requestsButton.heightAnchor.constraint(equalToConstant: 40),
            requestsButton.widthAnchor.constraint(equalToConstant: 220),
                    
            searchBar.topAnchor.constraint(equalTo: requestsButton.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
                    
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

    private func updateUIForNoFriends() {
        DispatchQueue.main.async {
            self.noFriendsLabel.text = "No friends now. Add them by their username!"
            self.noFriendsLabel.isHidden = false
            self.addFriendsButton.isHidden = false
            self.tableView.isHidden = true
        }
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
                    // Update request count
                    if let receivedRequests = data?["received_requests"] as? [String] {
                        let requestCount = receivedRequests.count
                        self.requestsButton.setTitle("Your Friend Requests: \(requestCount)", for: .normal)
                    }
                    // THERES FRIENDS
                    if let friends = data?["friends"] as? [String] {
                        self.noFriends = false
                        self.noFriendsLabel.isHidden = true
                        self.addFriendsButton.isHidden = true
                        self.searchBar.isHidden = false
                    } else {
                        // NO FRIENDS :(
                        self.noFriends = true
                        self.updateUIForNoFriends()
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

            if noFriends {
                updateUIForNoFriends()
            }
            return
        }
        
        noFriendsLabel.isHidden = true
        addFriendsButton.isHidden = true
        tableView.isHidden = false
        
        filteredUsers = allUsers.filter { user in
            user.username.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
        
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
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UserCell.cellHeight
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        let user = filteredUsers[indexPath.row]
        
        cell.configure(with: user.username)
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addFriendButtonTapped(_:)), for: .touchUpInside)
        
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.contentView.layer.shadowRadius = 4
        cell.contentView.layer.shadowOpacity = 0.2
        cell.contentView.layer.masksToBounds = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = filteredUsers[indexPath.row]
        
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("username", isEqualTo: user.username)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error finding user: \(error.localizedDescription)")
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    print("User not found")
                    return
                }
                
                let userId = document.documentID
                let userProfile = VisitorViewController(userId: userId)
                userProfile.modalPresentationStyle = .fullScreen
                self?.present(userProfile, animated: true)
            }
    }
    
    // MARK: - AddFriendButton
    @objc private func addFriendButtonTapped(_ sender: UIButton) {
        let user = filteredUsers[sender.tag]
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        print(currentUserId)    // debug
        let db = Firestore.firestore()
        
        // 1. Get the receiver's id
        db.collection("users")
            .whereField("username", isEqualTo: user.username)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    self?.showAlert(message: "Error finding user: \(error.localizedDescription)")
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    self?.showAlert(message: "User not found")
                    return
                }
                
                let receiverId = document.documentID
                print("receiver: ", receiverId) // debug
                
                // 2. Check if request already sent or it's already a friend
                db.collection("users").document(currentUserId).getDocument { [weak self] (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let sent_requests = (data?["sent_requests"] as? [String]) ?? []
                        let friends = (data?["friends"] as? [String]) ?? []
                        
                        if sent_requests.contains(receiverId) {
                            self?.showAlert(message: "Friend request already sent")
                            return
                        }
                        
                        if friends.contains(receiverId) {
                            self?.showAlert(message: "You are already friends")
                            return
                        }
                        
                        // 3. Add to receiver's received_requests
                        db.collection("users").document(receiverId).updateData([
                            "received_requests": FieldValue.arrayUnion([currentUserId])
                        ]) { error in
                            if let error = error {
                                self?.showAlert(message: "Error sending friend request: \(error.localizedDescription)")
                                return
                            }
                            
                            // 4. Add to sender's sent_requests
                            db.collection("users").document(currentUserId).updateData([
                                "sent_requests": FieldValue.arrayUnion([receiverId])
                            ]) { error in
                                if let error = error {
                                    self?.showAlert(message: "Error updating sent requests: \(error.localizedDescription)")
                                return
                            }
                            
                            self?.showAlert(message: "Friend request sent to \(user.username)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: RequestsButtonTapped
    @objc private func requestsButtonTapped() {
        // TODO: Navigate to friend requests screen
        requestsView.modalPresentationStyle = .fullScreen
        present(requestsView, animated: false)
    }

    // MARK: - ShowAlert
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
