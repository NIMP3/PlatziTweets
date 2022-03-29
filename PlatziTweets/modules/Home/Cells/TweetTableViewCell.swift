//
//  TweetTableViewCell.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 21/02/22.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
    
    //MARK: - Public methods
    func setupCellWith(post: Post) {
        nameLabel.text = post.author.names
        nicknameLabel.text = post.author.nickname
        
        messageLabel.text = post.text
        
        videoButton.isHidden = !post.hasVideo
        tweetImageView.isHidden = !post.hasImage
        
        if post.hasImage {
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
        }
    }
    
}
