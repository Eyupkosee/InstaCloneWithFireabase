//
//  UploadViewController.swift
//  InstaClone
//
//  Created by eyüp köse on 9.05.2023.
//

import UIKit
import PhotosUI
import Firebase

class UploadViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Recognizers
        
        let addRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(addRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImageFromGallery))
        imageView.addGestureRecognizer(imageRecognizer)
    }
    
    @objc func selectImageFromGallery(_ sender: Any) {
           var configuration = PHPickerConfiguration()
           configuration.filter = .images
           configuration.selectionLimit = 1
           let picker = PHPickerViewController(configuration: configuration)
           picker.delegate = self
           present(picker, animated: true)
       }

       func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
           dismiss(animated: true, completion: nil)
           guard let result = results.first else { return }
           result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
               DispatchQueue.main.async {
                   guard let image = image as? UIImage else { return }
                   self.imageView.image = image
               }
           }
       }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let imageReference = mediaFolder.child("\(UUID()).jpg")
            imageReference.putData(data, metadata: nil) {(metadata , error) in
                if error != nil{
                    print(error?.localizedDescription ?? "default value")
                }else{
                    imageReference.downloadURL { (url, error) in
                        
                        if error == nil{
                            
                            let imageUrl = (url?.absoluteURL.absoluteString)
                            
                            // Database
                            
                            let firestoreDatabase = Firestore.firestore()
                            let firestoreReference : DocumentReference
                            
                            let firestorePost = ["PostedBy" : Auth.auth().currentUser!.email!, "imageUrl" : imageUrl!, "PostComment" : self.commentText.text!, "Date" : FieldValue.serverTimestamp() ,"Likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                
                                if error != nil{
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                                }else{
                                    
                                    self.imageView.image = UIImage(named: "addImage.jpg")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                            
                        }
                    }
                }
            }
            
        }
        
    }
    func makeAlert(titleInput:String,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}
