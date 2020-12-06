//
//  ViewController.swift
//  SafeGallery
//
//  Created by Alexander Kononok on 11/29/20.
//

import UIKit

class ViewController: UIViewController {

  private let pickerController = UIImagePickerController()
  
  private var loginTextField: UITextField?
  private var passwordTextField: UITextField?
  
  let loginAdmin = "alex"
  let passwordAdmin = "qwe"
  
  var successfulLogin = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // MARK: - Add button on the bottom main view
    let heightButton: CGFloat = 100
    let addImageButton = UIButton(frame: CGRect(x: view.frame.minX, y: view.frame.maxY - heightButton, width: view.frame.width, height: heightButton))
    addImageButton.backgroundColor = .cyan
    addImageButton.setTitleColor(.black, for: .normal)
    addImageButton.setTitle("Add image", for: .normal)
    addImageButton.addTarget(self, action: #selector(addImageButtonPressed), for: .touchUpInside)
    
    // MARK: - Add title for navigation controller
    self.title = "Gallery"
    
    // MARK: - Add Sign In alert
    let signInAlert = UIAlertController(title: "Sign in", message: nil, preferredStyle: .alert)
    let warningAlert = UIAlertController(title: "WARNING", message: "Your login or password is wrong.\nTry again.", preferredStyle: .alert)
    let okWarningAction = UIAlertAction(title: "OK", style: .default) { (_) in
      self.present(signInAlert, animated: true)
    }
    let okSignInAction = UIAlertAction(title: "OK", style: .default) { (_) in
      if (self.loginTextField?.text == self.loginAdmin) && (self.passwordTextField?.text == self.passwordAdmin) {
        self.view.addSubview(addImageButton)
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

  // MARK: - Open picker with images
  @objc func addImageButtonPressed(sender: UIButton!) {
    present(pickerController, animated: true)
  }
  
}

