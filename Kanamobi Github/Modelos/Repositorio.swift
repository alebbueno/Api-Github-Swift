//
//  Repositorio.swift
//  Kanamobi Github
//
//  Created by Alessandro Bueno on 27/07/18.
//  Copyright © 2018 Alessandro Bueno. All rights reserved.
//

import UIKit
import Alamofire

class Repository {
    
    var _name: String!
    var _userAvatar: UIImage!
    var _userLoginName: String!
    var _userRealName: String!
    var _description: String!
    var _quantityOfForks: Int!
    var _quantityOfStargazers: Int!
    var _htmlUrl: String!
    var _userAvatarUrl: URL!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var userLoginName: String {
        if _userLoginName == nil {
            _userLoginName = ""
        }
        return _userLoginName
    }
    
    var userRealName: String {
        if _userRealName == nil {
            _userRealName = ""
        }
        return _userRealName
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var htmlUrl: String {
        if _htmlUrl == nil {
            _htmlUrl = ""
        }
        return _htmlUrl
    }
    
    var quantityOfForks: Int {
        if _quantityOfForks == nil {
            _quantityOfForks = 0
        }
        return _quantityOfForks
    }
    
    var quantityOfStargazers: Int {
        if _quantityOfStargazers == nil {
            _quantityOfStargazers = 0
        }
        return _quantityOfStargazers
    }
    
    var userAvatar: UIImage {
        if _userAvatarUrl == nil {
            _userAvatar = UIImage()
        }
        
        
        return _userAvatar
    }
    
    init() {
        
    }
    
    init(repositoryDictionary item: Dictionary<String, AnyObject>) {
        if let name = item["name"] as? String {
            self._name = name
        }
        if let ownerData = item["owner"] as? Dictionary<String, AnyObject> {
            if let loginName = ownerData["login"] as? String {
                self._userLoginName = loginName
            }
            if let avatarUrl = ownerData["avatar_url"] as? String {
                if let url = URL(string: avatarUrl) {
                    self._userAvatarUrl = url
                    
                    do {
                        let avatarImageData = try Data(contentsOf: _userAvatarUrl)
                        self._userAvatar = UIImage(data: avatarImageData)
                    } catch {
                        self._userAvatar = UIImage()
                    }
                }
            }
        }
        if let fullName = item["full_name"] as? String {
            self._userRealName = fullName
        }
        
        if let description = item["description"] as? String {
            self._description = description
        }
        if let forks = item["forks"] as? Int {
            self._quantityOfForks = forks
        }
        if let stars = item["stargazers_count"] as? Int {
            self._quantityOfStargazers = stars
        }
        if let htmlURL = item["html_url"] as? String {
            self._htmlUrl = htmlURL
        }
    }
    
    
    static func downloadRepositories(page: Int, completed: @escaping ([Repository]) -> ()) {
        let repositoriesURL = URL(string: "https://api.github.com/search/repositories?q=language:Swift&sort=stars&page=\(page)")
        var repos = [Repository]()
        
        Alamofire.request(repositoriesURL!).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let items = dict["items"] as? [Dictionary<String, AnyObject>]{
                    for item in items {
                        repos.append(Repository(repositoryDictionary: item))
                    }
                }
            }
            completed(repos)
        }
    }
}

