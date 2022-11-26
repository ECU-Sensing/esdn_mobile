//
//  MainViewController.swift
//  esdn_app
//
//  Created by Colby Sawyer on 11/23/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import InfluxDBSwift
import InfluxDBSwiftApis

class MainViewController: UIViewController{
    
    
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var ProjectListStackView: UIStackView!
    
    func loadUserInfo(){
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        // Get Bucket from Firestore
            // Get Projects from User Firestore
            // Get Project Information from Projects Firestore
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
            //Async Data Retrieval based around UID
            db.collection("users").whereField("uid", isEqualTo: uid)
                .addSnapshotListener { [self] querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    for document in documents{
                        let username: String = document.get("username") as! String
                        let projects:Array = document.get("projects") as! Array<Any>
                        // Print User Information
                        UsernameLabel.text = "Hello, " + username
                        //Load Projects
                        loadProjectList(projects:projects)
                    }
            }
        }

    }
    
    func loadProjectList(projects:Array<Any>){


        // Get Devices from Bucket
        
    }
    
    override func viewDidLoad(){
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        // Load User Information
         loadUserInfo()
    }
    
    
}
