//
//  SignInViewController.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 1.10.2021.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let activityIndicator = UIActivityIndicatorView()
    
    @IBAction func signInBtn(_ sender: UIButton) {
        if userNameTextField.text == "" {
            print("empty username")
        } else if passwordTextField.text == ""{
            print("empty password")
        } else {
            Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                if error != nil {
                    print(error ?? "An error occured while signing in")
                }
            }
        }
    }
    @IBAction func mailToUsBtn(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        // These methods are added to move the view up to the keyboard size.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Functions
    @objc func keyboardWillShow(notification: NSNotification) {
        //These methods are added to move the view up.
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 50
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        //These methods are added to move the view up to the keyboard size.
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            view.endEditing(true)
        }
        return true
    }
    func alertFunction(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Uyarı!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
        self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        return alert
    }
}
