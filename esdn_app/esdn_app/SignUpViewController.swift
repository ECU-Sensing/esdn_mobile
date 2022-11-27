//
//  SignUpViewController.swift
//  esdn_app
//
//  Created by Colby Sawyer on 11/23/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var ActivityIndicatorView: UIActivityIndicatorView!
    
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
    // isPasswordValid() checks that the password text field follows the standard
    // requirements for passwords: 9 chars, 1 capital letter, 1 number, no specials
    //================================================================================
    func isPasswordValid(_ password: String) -> Bool {
        //Password validation in Swift (Regular Expression copied)
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
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
        if PasswordTextField.text? .trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter a valid Password"
        }
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(!(isPasswordValid(cleanedPassword))){
            //Password does not follow requirements
            return "Please verify that your password contains 8+ characters, a special character and a number"
        }
        return nil
    }
    //================================================================================
    
    //================================================================================
    // transitionToDash() is used to transition to the SignUp View Controller.
    // Helper Function
    //================================================================================
    func transitionToLogin(){
        let loginViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    //================================================================================
    
    //================================================================================
    // transitionToMain() is used to transition to the Main View Controller.
    // Helper Function
    //================================================================================
    func transitionToMain(){
        let mainViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? MainViewController
        
        self.view.window?.rootViewController = mainViewController
        self.view.window?.makeKeyAndVisible()
    }
    //================================================================================
    
    @IBAction func SubmitButtonClicked(_ sender: Any) {
        ActivityIndicatorView.startAnimating()
        //Validate the fields
        let error = validateFields()
        if error != nil{
            printError(error!)
        }
        else{
            ActivityIndicatorView.alpha = 1
            //Create the user
            let first_name = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let last_name = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = UsernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let link = "f"
            let projects = [String]()
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Error Check for User Creation
                if let err = err{
                    self.printError(err.localizedDescription)
                }else{
                    // Grab reference to db
                    let db = Firestore.firestore()
                    let uid = result!.user.uid
                    // Add a new document in collection "users"
                    db.collection("users").document(uid).setData(["username":username, "uid":uid, "email":email, "link":link, "projects":projects, "first_name":first_name, "last_name":last_name], completion: { (err) in
                        // Error Check for Doc Creation
                        if let err = err {
                            print("Error writing document: \(err.localizedDescription)")
                            } else {
                                print("Document successfully written!")
                            }
                    })
                }
            }
            //Allow Time to user to written to Firebase
            sleep(10)
            
            // Login User
            Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
                if error != nil{ // Error Occured
                    self.printError(error!.localizedDescription)
                } else{
                    self.transitionToMain()
                }
            }
        }
    }
    
    @IBAction func LoginButtonClicked(_ sender: Any) {
        transitionToLogin()
    }
}
