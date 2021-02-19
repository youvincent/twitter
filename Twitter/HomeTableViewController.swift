//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by suiyan he on 2/12/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberTweet: Int!
    let rControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        rControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = rControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweet()
    }
    
    @objc func loadTweet(){
        numberTweet = 20
        let myurl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myP = ["count": numberTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myurl, parameters: myP, success: {(tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.rControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Couldn't get tweet")
        })
    }
    
    func loadMoreTweets(){
        let myurl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberTweet = numberTweet + 20
        let myP = ["count": numberTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myurl, parameters: myP, success: {(tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Couldn't get tweet")
        })
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"tweetcell", for:indexPath) as!  TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContents.text = tweetArray[indexPath.row]["text"] as? String
        
        let iUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: iUrl!)
        
        if let iData = data{
            cell.profileImageView.image = UIImage(data: iData)
        }
        
        cell.setFavor(isFavorite: tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(isRetweeted: tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }



}
