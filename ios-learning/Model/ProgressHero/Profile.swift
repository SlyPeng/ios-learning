//
//  Profile.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/9.
//

import SwiftUI

struct Profile: Identifiable{
    var id = UUID()
    var userNmae: String
    var profilePicture: String
    var lastMsg: String
}


var profiles = [
    Profile(userNmae: "Janme smith", profilePicture: "Pic1", lastMsg: "hello"),
    Profile(userNmae: "Ketty", profilePicture: "Pic2", lastMsg: "hello"),
    Profile(userNmae: "Steve", profilePicture: "Pic1", lastMsg: "hello"),
    Profile(userNmae: "Keviya", profilePicture: "Pic2", lastMsg: "hello"),
    
]
