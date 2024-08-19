//
//  SocialViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SocialViewController: MainBaseView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var friends: [User] = []
    private var filteredFriends: [User] = []
    
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
        searchBar.barTintColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupTableView()
        searchBar.delegate = self
        fetchFriends()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(friendsLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(noFriendsLabel)
        view.addSubview(addFriendsButton)
        
        addFriendsButton.addTarget(self, action: #selector(handleAddFriends), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            friendsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            friendsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    
            searchBar.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
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
    
    // - MARK: SetupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
    }
    
    // - MARK: FetchFriends
    private func fetchFriends() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
            
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let user = User(data: data ?? [:])
                self?.friends = user.friends?.compactMap { friendId in
                    var friend: User?
                    let group = DispatchGroup()
                    group.enter()
                    db.collection("users").document(friendId).getDocument { (friendDocument, error) in
                        if let friendDocument = friendDocument, friendDocument.exists {
                            friend = User(data: friendDocument.data() ?? [:])
                        }
                        group.leave()
                    }
                    group.wait()
                    return friend
                } ?? []
                self?.filteredFriends = self?.friends ?? []
                self?.checkFriendsList()
                self?.tableView.reloadData()
            }
        }
    }
    
    // - MARK: CheckFriendsList
    private func checkFriendsList() {
        if filteredFriends.isEmpty {
            noFriendsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noFriendsLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    // - MARK: HandleAddFriends
    @objc private func handleAddFriends() {
        
    }
       
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        let friend = filteredFriends[indexPath.row]
        cell.textLabel?.text = friend.username
        return cell
    }
       
    // UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFriends = friends
        } else {
            filteredFriends = friends.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
