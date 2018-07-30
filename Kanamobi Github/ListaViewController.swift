//
//  ListaViewController.swift
//  Kanamobi Github
//
//  Created by Alessandro Bueno on 27/07/18.
//  Copyright © 2018 Alessandro Bueno. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import MBProgressHUD

class ListaViewController: UITableViewController {
    
    var loadingNotifications: MBProgressHUD?
    var repos = [Repository]()
    var loadedPages = 0
    
    private let indicatorFooter = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Repositórios Swift"
        
        navigationController?.navigationBar.barTintColor = UIColor (red:0.05, green:0.02, blue:0.15, alpha:1.0)
        
        indicatorFooter.frame.size.height = 100
        indicatorFooter.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicatorFooter.startAnimating()
        
        getData()
        
    }
    
    func getData(){
        self.loadingNotifications = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.loadingNotifications?.mode = MBProgressHUDMode.indeterminate
        self.loadingNotifications?.label.text = "Carregando"
        self.loadingNotifications?.show(animated: true)
        
        self.loadedPages += 1
        
        Repository.downloadRepositories(page: self.loadedPages) { repos in
            self.repos += repos
            self.loadingNotifications?.hide(animated: true)
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let imgUser = cell?.viewWithTag(10) as! UIImageView
        let tituloLb = cell?.viewWithTag(1) as! UILabel
        let descrLb = cell?.viewWithTag(2) as! UILabel
        let userLb = cell?.viewWithTag(3) as! UILabel
        let forkLb = cell?.viewWithTag(6) as! UILabel
        let starLb = cell?.viewWithTag(7) as! UILabel

        
        let imgFork = cell?.viewWithTag(4) as! UIImageView
        let imgStar = cell?.viewWithTag(5) as! UIImageView
        
        imgFork.setFAIconWithName(icon: .FACodeFork,textColor: #colorLiteral(red: 0.2823529412, green: 0.4666666667, blue: 0.2745098039, alpha: 1), backgroundColor: .clear)
        imgStar.setFAIconWithName(icon: .FAStar, textColor: #colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1), backgroundColor: .clear)
        
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2

        imgUser.layer.borderWidth = 1.5
        imgUser.layer.borderColor = UIColor(red:0.05, green:0.02, blue:0.15, alpha:1.0).cgColor
        imgUser.clipsToBounds = true
        
        let repo = self.repos[indexPath.row]
        
        imgUser.image = repo.userAvatar
        tituloLb.text = repo.name
        
        descrLb.text = repo.description
        descrLb.numberOfLines = 0
        
        userLb.text = repo.userLoginName
        forkLb.text = String(repo.quantityOfForks)
        starLb.text = String(repo.quantityOfStargazers)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == repos.count {
            tableView.tableFooterView = indicatorFooter
            self.getData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! ListaPullController
        let repo = self.repos[indexPath!]
        vc.repo = repo
    }
    
}
