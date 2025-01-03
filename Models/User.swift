//
//  User.swift
//  MoodScape
//
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    var firstName: String?
    var lastName: String?
    var profileImageUrl: String?
    var location: String?
    var musicPreferences: String?
    //var registrationDate: Date
    var friends: [String]?
    
    init(data: [String: Any]) {
        self.id = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.firstName = data["firstName"] as? String
        self.lastName = data["lastName"] as? String
        self.profileImageUrl = data["profileImageUrl"] as? String
        self.location = data["location"] as? String
        self.musicPreferences = data["musicPreferences"] as? String
        //self.registrationDate = data["registrationDate"] as? Date ?? <#default value#>
        self.friends = data["registrationDate"] as? [String]
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": id,
            "email": email,
            "username": username,
            "firstName": firstName ?? "",
            "lastName": lastName ?? "",
            "profileImageUrl": profileImageUrl ?? "",
            "location": location ?? "",
            "musicPreferences": musicPreferences ?? ""
        ]
    }
}
