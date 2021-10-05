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
    let userDefaults = UserDefaults.standard
    
    @IBAction func signInBtn(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        if userNameTextField.text == "" {
            present(alertFunction(message: "Mail adresi alanı boş bırakılamaz."), animated: true, completion: nil)
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        } else if passwordTextField.text == ""{
            present(alertFunction(message: "Şifre alanı boş bırakılamaz."), animated: true, completion: nil)
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        } else {
            Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                if error != nil {
                    self.present(self.alertFunction(message: "Giriş yapılırken bir hata oluştu."), animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    print(error ?? "An error occured while signing in")
                } else {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.dismiss(animated: true, completion: nil)
                    self.userDefaults.setValue(true, forKey: "userSignedIn")
                }
            }
        }
    }
    @IBAction func forgetPassword(_ sender: UIButton) {        
        Auth.auth().sendPasswordReset(withEmail: userNameTextField.text ?? "") { error in
            if let error = error {
                self.present(self.alertFunction(message: "Lütfen değiştirmek istediğiniz mail adresinizi yazınız."), animated: true, completion: nil)
                print(error)
            } else {
                self.present(self.alertFunction(message: "Şifre değiştirme isteğiniz alınmıştır."), animated: true, completion: nil)
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
        
        // Activity Indicator stuff
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
        
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
