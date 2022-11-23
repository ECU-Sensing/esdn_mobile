//
//  LoginViewController.swift
//  esdn_app
//
//  Created by Colby Sawyer on 11/23/22.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad(){
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
    }
    
    //================================================================================
    // transitionToDash() is used to transition to the SignUp View Controller.
    // Helper Function
    //================================================================================
    func transitionToSignUp(){
        let signupViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.signupViewController) as? SignUpViewController
        
        self.view.window?.rootViewController = signupViewController
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
        return nil
    }
    //================================================================================
    
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
    //================================================================================
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        // Validate Text Fields
        let error = validateFields()
        if error != nil{
            printError(error!)
        }else{
        // Get Field Values
        let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
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
    //================================================================================

    
    
    //================================================================================
    //================================================================================
    @IBAction func SignUpButtonClicked(_ sender: Any) {
        transitionToSignUp()
    }
    //================================================================================

    
    
}
