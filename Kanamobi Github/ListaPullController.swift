//
//  ListaPullController.swift
//  Kanamobi Github
//
//  Created by Alessandro Bueno on 27/07/18.
//  Copyright © 2018 Alessandro Bueno. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ListaPullController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lbSemResultado: UILabel!
    @IBOutlet var backButton: UIBarButtonItem?
    
    var loadingNotifications: MBProgressHUD!
    var repo: Repository!
    var urlRepository = "https://api.github.com/repos/"
    var pulls = [Pull]()
    
    typealias DownloadCompleted = () -> ()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor (red:0.05, green:0.02, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = self.repo.userLoginName
        
        imgThumb.image = self.repo.userAvatar
        imgThumb.layer.cornerRadius = imgThumb.frame.size.width / 2
        imgThumb.layer.borderWidth = 2.5
        imgThumb.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        imgThumb.clipsToBounds = true
        
        self.tableview.delegate = self
        self.setViewData()
        
        urlRepository += "\(repo.userLoginName)/\(repo.name)/pulls"
        
        self.getData(url: self.urlRepository) {
            
            if self.pulls.count == 0 {
                self.tableview.isHidden = true
            }else {
                self.lbSemResultado.isHidden = true
            }
            
            self.tableview.reloadData()
            self.loadingNotifications?.hide(animated: true)
        }

    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pulls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let tituloLb = cell.viewWithTag(3) as! UILabel
        let bodyLb = cell.viewWithTag(5) as! UILabel
        let userLb = cell.viewWithTag(2) as! UILabel
        let imgUser = cell.viewWithTag(1) as! UIImageView
        let prData = cell.viewWithTag(4) as! UILabel
        
        
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        
        let pull = self.pulls[indexPath.row]
        
        tituloLb.text = pull.title
        bodyLb.text = pull.body
        userLb.text = pull.name
        
        imgUser.image = pull.image
        
        //Converter Data para String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        
        prData.text = dateFormatterPrint.string(from: pull.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let url = URL(string: pulls[indexPath.row].htmlURL)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    func getData(url: String, completed: @escaping DownloadCompleted){
        
        Alamofire.request(url).responseJSON { response in
            let result = response.result
            
            if let array = result.value as? Array<AnyObject> {
                self.pulls = Pull.getPulls(pullArray: array)
            }
            completed()
        }

    }
    
    func setViewData() {
        self.startLoading()
    }
    
    func startLoading() {
        loadingNotifications = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotifications?.mode = MBProgressHUDMode.indeterminate
        loadingNotifications?.label.text = "Carregando"
    }

}
