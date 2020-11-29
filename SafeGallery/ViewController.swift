//
//  ViewController.swift
//  SafeGallery
//
//  Created by Alexander Kononok on 11/29/20.
//

import UIKit

class ViewController: UIViewController {

  private var loginTextField: UITextField?
  private var passwordTextField: UITextField?
  
  let loginAdmin = "alex"
  let passwordAdmin = "qwe"
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let signInAlert = UIAlertController(title: "Sign in", message: nil, preferredStyle: .alert)
    let warningAlert = UIAlertController(title: "WARNING", message: "Your login or password is wrong.\nTry again.", preferredStyle: .alert)
    let okWarningAction = UIAlertAction(title: "OK", style: .default) { (_) in
      self.present(signInAlert, animated: true)
    }
    let okSignInAction = UIAlertAction(title: "OK", style: .default) { (_) in
      if (self.loginTextField?.text == self.loginAdmin) ?? (self.passwordTextField?.text == self.passwordAdmin) {
        print("CONGRATULATION!!!")
      } else {
        self.present(warningAlert, animated: true) {
          self.present(signInAlert, animated: true)
        }
      }
    }
    
    signInAlert.addTextField { (loginTextField) in
      loginTextField.placeholder = "login"
      self.loginTextField = loginTextField
    }
    
    signInAlert.addTextField { (passwordTextField) in
      passwordTextField.placeholder = "password"
      self.passwordTextField = passwordTextField
    }
    
    signInAlert.addAction(okSignInAction)
    warningAlert.addAction(okWarningAction)
    
    present(signInAlert, animated: true)
  }

}

