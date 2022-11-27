//
//  ProfileViewController.swift
//  esdn_app
//
//  Created by Colby Sawyer on 11/27/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var SavedStateTextField: UILabel!
    
    //================================================================================
    // transitionToMain is used to transition to the Main View Controller.
    // Helper Function
    //================================================================================
    func transitionToMain(){
        let mainViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? MainViewController
        
        self.view.window?.rootViewController = mainViewController
        self.view.window?.makeKeyAndVisible()
    }
    //================================================================================
    
    @IBAction func BackButtonClicked(_ sender: Any) {
        transitionToMain()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showSaveSuccessful(){
        SavedStateTextField.text = "Save Successful"
        SavedStateTextField.alpha = 1
        ActivityIndicator.stopAnimating()
        ActivityIndicator.alpha = 0
    }
    
    func showSaveFeatures(){
        SaveButton.alpha = 1
        SavedStateTextField.text = "Changes not saved"
        SavedStateTextField.alpha = 1
    }
    
    func hideSaveFeatures(){
        SaveButton.alpha = 0
        SavedStateTextField.alpha = 0
    }
    
    @IBAction func FirstNameEditingStarted(_ sender: Any) {
        showSaveFeatures()
    }
    
    @IBAction func LastNameEditingStarted(_ sender: Any) {
        showSaveFeatures()
    }
    
    @IBAction func UsernameEditingStarted(_ sender: Any) {
        showSaveFeatures()
    }
    
    @IBAction func EmailEditingStarted(_ sender: Any) {
        showSaveFeatures()
    }
    
    //================================================================================
    // transitionToLogin is used to transition to the Login View Controller.
    // Helper Function
    //================================================================================
    func transitionToLogin(){
        let loginViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
    }
    //================================================================================
    
    func forceReauthentication(){
        //Logout
        transitionToLogin()
    }
    

    
    //================================================================================
    // printError is a helper function to help display error messages with the error
    //   label
    //================================================================================
    func printError(_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    //================================================================================
    
    //================================================================================
    // validateFields() checks for the validity of the email and password. Mainly it
    // verifies that there is not an empty text field being submitted.
    // Helper function
    //================================================================================
    func validateFields() -> String? {
        //Check all fields are filled in
        if EmailTextField.text? .trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter a valid Email "
        }
        return nil
    }
    //================================================================================
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSaveFeatures()
        displayCurrentUser()
    }
    
    //================================================================================
    // displayCurrentUser() fetches the current authenticated user information.
    // Primarily this is used to present the text fields with their real-time value.
    //================================================================================
    func displayCurrentUser(){
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
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
                        let firstName: String = document.get("first_name") as! String
                        let lastName:String  = document.get("last_name") as! String
                        let email:String = document.get("email") as! String
                        let username:String = document.get("username") as! String
                        FirstNameTextField.text = firstName
                        LastNameTextField.text = lastName
                        EmailTextField.text = email
                        UsernameTextField.text = username
                    }
                    
            }
        }

    }
    //================================================================================

    
    @IBAction func ResetPasswordButtonClicked(_ sender: Any) {
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
                        let email: String = document.get("email") as! String
                        // Print User Information
                        Auth.auth().sendPasswordReset(withEmail: email) { error in
                          // ...
                        }
                    }
            }
        }
        

    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        ActivityIndicator.startAnimating()
        //Validate the fields
        let error = validateFields()
        if error != nil{
            printError(error!)
        }
        else{
            ActivityIndicator.alpha = 1
            // Save Changes in Firestore
            let user = Auth.auth().currentUser
            let db = Firestore.firestore()
            // Get Bucket from Firestore
                // Get Projects from User Firestore
                // Get Project Information from Projects Firestore
            if let user = user {
                let first_name = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let last_name = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let username = UsernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
              let uid = user.uid
                db.collection("users").document(uid).updateData(["first_name":first_name, "last_name":last_name, "username":username, "email":email], completion: { (err) in
                        // Error Check for Doc Creation
                        if let err = err {
                            print("Error writing document: \(err.localizedDescription)")
                            self.printError(err.localizedDescription)
                            } else {
                                self.hideSaveFeatures()
                                self.showSaveSuccessful()
                                print("Document successfully written!")
                            }
                    })
                }
        }
    }
    
    @IBAction func SignOutClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          printError("Sign out error")
        }
        transitionToLogin()
    }
}
