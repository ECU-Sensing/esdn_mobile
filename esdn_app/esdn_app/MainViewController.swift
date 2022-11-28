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
                        let first_name: String = document.get("first_name") as! String
                        let email : String = document.get("email") as! String
                        //let projects:Array = document.get("projects") as! Array<Any>
                        // Print User Information
                        UsernameLabel.text = "Hello, " + first_name
                        //Load Projects
                        //loadProjectList(projects:projects)
                        if email == "sawyerco21@ecu.edu"{
                            showExampleProjectList()
                        }
                        if email == "colby@iotei.org"{
                            showExample2ProjectList()
                        }
                    }
                }
        }
        
    }
    
    override func viewDidLoad(){
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        // Load User Information
        loadUserInfo()
        loadProjectList()
    }
    
    //================================================================================
    // transitionToProfile() is used to transition to the Profile View Controller.
    // Helper Function
    //================================================================================
    func transitionToProfile(){
        let profileViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileViewController) as? ProfileViewController
        
        self.view.window?.rootViewController = profileViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    //================================================================================
    
    @IBAction func ProfileButtonClicked(_ sender: Any) {
        transitionToProfile()
    }
    
    //================================================================================
    // Lazy Implementation of Project List
    // This should be replaced with real implementation
    //================================================================================
    
    @IBOutlet weak var Project1View: UIView!
    @IBOutlet weak var Project2View: UIView!
    @IBOutlet weak var Project3View: UIView!
    @IBOutlet weak var Project4View: UIView!
    @IBOutlet weak var Project5View: UIView!

    
    @IBOutlet weak var Project1ImageView: UIImageView!
    @IBOutlet weak var Project1Label: UILabel!
    @IBOutlet weak var Project2ImageView: UIImageView!
    @IBOutlet weak var Project2Label: UILabel!
    @IBOutlet weak var Project3ImageView: UIImageView!
    @IBOutlet weak var Project3Label: UILabel!
    @IBOutlet weak var Project4ImageView: UIImageView!
    @IBOutlet weak var Project4Label: UILabel!
    @IBOutlet weak var Project5ImageView: UIImageView!
    @IBOutlet weak var Project5Label: UILabel!
        
    func FillProject1(project_name:String){
        Project1Label.text = project_name
        Project1ImageView.image = UIImage(named: "wind")
        Project1View.alpha = 1
    }
    
    func FillProject2(project_name:String){
        Project2Label.text = project_name
        Project2ImageView.image = UIImage(named: "water")
        Project2View.alpha = 1
    }
    
    func FillProject3(project_name:String){
        Project3Label.text = project_name
        Project3ImageView.image = UIImage(named: "water")
        Project3View.alpha = 1
    }
    
    func FillProject4(project_name:String){
        Project4Label.text = project_name
        Project4ImageView.image = UIImage(named: "water")
        Project4View.alpha = 1
    }
    
    func FillProject5(project_name:String){
        Project5Label.text = project_name
        Project5ImageView.image = UIImage(named: "water")
        Project5View.alpha = 1
    }
    
    func showExampleProjectList(){
        FillProject1(project_name: "Air Quality")
        FillProject2(project_name: "Zentra")
        FillProject3(project_name: "CoPe")
        
    }
    func showExample2ProjectList(){
        FillProject1(project_name: "Air Quality")
        FillProject2(project_name: "Green Mill Run")
    }
    
    func loadProjectList(){
        var radius = 15 as CGFloat
        Project1View.layer.cornerRadius = radius
        Project2View.layer.cornerRadius = radius
        Project3View.layer.cornerRadius = radius
        Project4View.layer.cornerRadius = radius
        Project5View.layer.cornerRadius = radius
    }
}
