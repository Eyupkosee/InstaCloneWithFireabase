//
//  FeedCell.swift
//  InstaClone
//
//  Created by eyüp köse on 12.05.2023.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    var isLike = false
    
    @IBOutlet weak var ımageView: UIImageView!
    @IBOutlet weak var userMail: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            
            if isLike == false{
                    
                
                let likeStore = ["Likes" : likeCount + 1] as [String : Any]
                
                firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
                
                
                print(likeStore)
            }
            
        }
        
    }
    
}
