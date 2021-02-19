//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by suiyan he on 2/12/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var tweetContents: UILabel!
    
    @IBOutlet weak var fButton: UIButton!
    
    @IBOutlet weak var rbutton: UIButton!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetId:Int = -1
    
    @IBAction func FavorButton(_ sender: Any) {
        let tobeFavor = !favorited
        if(tobeFavor){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {self.setFavor(isFavorite: true)}, failure: {
                (error) in
                print("Favorite didn't succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavor(isFavorite: false)
            }, failure: {
                (error) in
                print("Unfavorite didn't succeed: \(error)")
            })
        }
    }
    
    @IBAction func RetweetButton(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(isRetweeted: true)
        }, failure: {
            (error) in
            print("Retweet didn't succeed: \(error)")
        })
    }
    
    func setFavor( isFavorite:Bool){
        favorited = isFavorite
        if(favorited){
            fButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            fButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
        
    }
    func setRetweeted( isRetweeted:Bool){
        if (isRetweeted){
            rbutton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            rbutton.isEnabled = false
        } else{
            rbutton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            rbutton.isEnabled = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
