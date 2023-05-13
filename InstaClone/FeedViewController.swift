//
//  FeedViewController.swift
//  InstaClone
//
//  Created by eyüp köse on 9.05.2023.
//

import UIKit
import Firebase
import SDWebImage


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userMail = [String]()
    var userComment = [String]()
    var userImage = [String]()
    var likeCount = [Int]()
    var documentIdArray = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "Date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil{
                print(error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.userImage.removeAll(keepingCapacity: false)
                    self.likeCount.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.userMail.removeAll(keepingCapacity: false)
                    self.userComment.removeAll(keepingCapacity: false)
                    
                    
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("PostedBy") as? String {
                            self.userMail.append(postedBy)
                            
                        }
                        if let postComment = document.get("PostComment") as? String {
                            self.userComment.append(postComment)
                            
                        }
                        if let likes = document.get("Likes") as? Int {
                            self.likeCount.append(likes)
                            
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImage.append(imageUrl)
                            
                        }
                        
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        
        // Verileri atama
        cell.userMail.text = userMail[indexPath.row]
        cell.commentLabel.text = userComment[indexPath.row]
        cell.likeLabel.text = String(likeCount[indexPath.row])
        cell.ımageView.sd_setImage(with: URL(string: self.userImage[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        return cell
    }

    

}
