//
//  Pull.swift
//  Kanamobi Github
//
//  Created by Alessandro Bueno on 27/07/18.
//  Copyright © 2018 Alessandro Bueno. All rights reserved.
//

import UIKit

class Pull {
    var _name: String! //repo.name
    var _image: UIImage! // repo.owner.avatar_url
    var _autorName: String! // repo.owner.login
    var _title: String! //title
    var _date: Date! // created_at
    var _body: String! //body
    var _URL: String! //url
    var _id: String!
    var _htmlURL: String!
    
    var pulls = [Pull]()
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var image: UIImage {
        if _image == nil {
            _image = UIImage()
        }
        
        return _image
    }
    
    var autorName: String {
        if _autorName == nil {
            _autorName = ""
        }
        
        return _autorName
    }
    
    var title: String {
        if _title == nil {
            _title = ""
        }
        
        return _title
    }
    
    var body: String {
        if _body == nil {
            _body = ""
        }
        
        return _body
    }
    
    var htmlURL: String {
        if _htmlURL == nil {
            _htmlURL = ""
        }
        
        return _htmlURL
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }

        return _date
    }
    
    init() {}
    
    init(name: String, autorName: String, autorImage: UIImage) {
        self._name = name
        self._autorName = autorName
        self._image = autorImage
    }
    
    init(pullDictionary dict: Dictionary<String, AnyObject>) {
        
        if let repo = dict["repo"] as? Dictionary<String, AnyObject> {
            if let name = repo["name"] as? String {
                self._name = name
            }
        }
        
        if let title = dict["title"] as? String {
            self._title = title
        }
        if let url = dict["url"] as? String {
            self._URL = url
            
        }
        if let htmlUrl = dict["html_url"] as? String {
            self._htmlURL = htmlUrl
        }
        if let id = dict["id"] as? Int {
            self._id = String(id)
        }
        if let body = dict["body"] as? String {
            self._body = body
        }

        if let date = dict["created_at"] as? String {
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"

            self._date = dateFormatterGet.date(from: date)
        }
        
        if let user = dict["user"] as? Dictionary<String, AnyObject> {
            if let imageURL = user["avatar_url"] as? String {
                do {
                    let avatarImageData = try Data(contentsOf: URL(string: imageURL)!)
                    self._image = UIImage(data: avatarImageData)
                } catch {
                    self._image = UIImage()
                }
            }
            
            if let userName = user["login"] as? String {
                self._name = userName
            }
            
        }
    }
    static func getPulls(pullArray array: [AnyObject]) -> [Pull]{
        var pulls = [Pull]()
        for item in array {
            if let dict = item as? Dictionary<String, AnyObject> {
                pulls.append(Pull(pullDictionary: dict))
            }
        }
        return pulls
    }
}

