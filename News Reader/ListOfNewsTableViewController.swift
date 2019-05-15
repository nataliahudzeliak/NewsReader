//
//  ListOfNewsTableViewController.swift
//  News Reader
//
//  Created by MacOS on 4/2/19.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import SafariServices

class ListOfNewsTableViewController: UITableViewController ,UISearchBarDelegate{
    var newsArticles = [News]()
    var newsInTable = [News]()
    
    @IBAction func unwindMySelectedCountry (segue : UIStoryboardSegue){
        
        guard segue.identifier == "segueForCountry" else {return}
        let fromViewC = segue.source as! CountryOfNewsViewController
        myCountry = fromViewC.selectedCountry
        refreshList()
    }
    
    let locationOfUsser = Locale.current
    var totalResults : Int?
    var typeNews = "category=general"
    var myCountry = "ua"
    let newsFromRequest = Request()
    var currentPageOfNews = 1
    
    @IBOutlet weak var searchNewsBar: UISearchBar!
    var refrushForTable: UIRefreshControl?
    func addRefreshControl() {
        
        refrushForTable = UIRefreshControl()
        refrushForTable?.tintColor = UIColor.red
        refrushForTable?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refrushForTable!)
    }
    
    @objc func refreshList() {
        searchNewsBar.delegate = self
        newsFromRequest.newsRequest(name : 1,country: myCountry , typeOfNews: typeNews ) { (data, error) in
            if let data = data , data.status == "ok" {
        
                self.totalResults = data.totalResults
                self.newsArticles = data.articles
                self.newsArticles.sort { $0.publishedAt > $1.publishedAt }
                self.newsInTable = self.newsArticles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{print(error)}
        }
        self.refrushForTable?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 360.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        searchNewsBar.delegate = self
        myCountry = locationOfUsser.regionCode?.lowercased() ?? "ua"
        newsFromRequest.newsRequest (name : 1,country: myCountry, typeOfNews: typeNews) { (data, error) in
            if let data = data , data.status == "ok" {
            
                self.totalResults = data.totalResults
                self.newsArticles += data.articles
                self.newsArticles.sort { $0.publishedAt > $1.publishedAt }
                self.newsInTable = self.newsArticles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{print(error)}
        }
        
    }
    var activitySearchBar = false
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if activitySearchBar == false {
            if indexPath.row == newsInTable.count - 1{
                guard let totalResults = totalResults else {
                    return
                }
                if newsInTable.count < totalResults {
                    currentPageOfNews += 1
                    
                    newsFromRequest.newsRequest(name : currentPageOfNews,country: myCountry, typeOfNews: typeNews) { (data, error) in
                        if let data = data , data.status == "ok" {
                            
                            self.totalResults = data.totalResults
                            self.newsArticles += data.articles
                            self.newsArticles.sort { $0.publishedAt > $1.publishedAt }
                            self.newsInTable = self.newsArticles
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    self.perform(#selector(updateTable), with: nil, afterDelay: 0)
                }
            }
        }
    }
    
    @objc func updateTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlForSafari = URL(string: newsInTable[indexPath.row].url )
        { let safariViewController = SFSafariViewController(url: urlForSafari)
            present(safariViewController, animated: true,completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsInTable.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCellTableViewCell
        
        let newNewsArticle = newsInTable[indexPath.row]
        cell.titleOfNews.text = newNewsArticle.title
        cell.authorOfNews.text = newNewsArticle.author
        cell.sourceOfNews.text = newNewsArticle.source.name
        cell.newsDescription.text = newNewsArticle.description
        
        if newNewsArticle.urlToImage != nil {
            if let imageUrl = URL(string: newNewsArticle.urlToImage!) {
                do{
                    let imageData = try Data(contentsOf: imageUrl)
                    let image = UIImage(data: imageData)
                    cell.NewsImage.image = image
                }catch{print("error")}
            }}
        else {print("nil")}
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        newsInTable = newsArticles.filter({ article -> Bool in
            if searchText.isEmpty  { activitySearchBar = false
                return true }
            
            if let titleOfNews = article.title {
                activitySearchBar = true
                return titleOfNews.lowercased().contains(searchText.lowercased())}
            else{return false}
            
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            typeNews = "category=general"
        case 1:
            typeNews = "category=business"
        case 2:
            typeNews = "category=entertainment"
        case 3:
            typeNews = "category=health"
        case 4:
            typeNews = "category=science"
        case 5:
            typeNews = "category=sport"
        case 6:
            typeNews = "category=technology"
        default:
            break
        }
        
        newsFromRequest.newsRequest (name : 1, country: myCountry, typeOfNews: typeNews) { (data, error) in
            if let data = data , data.status == "ok" {
                self.totalResults = data.totalResults
                self.newsArticles = data.articles
                self.newsArticles.sort { $0.publishedAt > $1.publishedAt }

                DispatchQueue.main.async {
                    self.newsInTable = self.newsArticles
                    self.tableView.reloadData()
                }
            }else{print(error)}
            
        }
    }
}
