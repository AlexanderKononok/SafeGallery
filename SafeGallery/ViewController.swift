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
  
  var user: User!
  
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  let fileManager = FileManager.default
  lazy var imagesPath = documentsPath.appendingPathComponent("Images")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let data = UserDefaults.standard.value(forKey: "UserKey") as? Data {
      let user = try? JSONDecoder().decode(User.self, from: data)
      self.user = user
    }
    
    // MARK: - DELETE THIS PRINT!!!
    print(documentsPath.path)
    
    if fileManager.fileExists(atPath: imagesPath.path) == false {
      do {
        try fileManager.createDirectory(atPath: imagesPath.path, withIntermediateDirectories: true, attributes: nil)
      } catch {
        print(error.localizedDescription)
      }
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // MARK: - Add title for navigation controller
    self.title = "Gallery"
    
    // MARK: - Add button on the bottom main view
    let heightButton: CGFloat = 100
    let addImageButton = UIButton(frame: CGRect(x: view.frame.minX, y: view.frame.maxY - heightButton, width: view.frame.width, height: heightButton))
    addImageButton.backgroundColor = .cyan
    addImageButton.setTitleColor(.black, for: .normal)
    addImageButton.setTitle("Add image", for: .normal)
    addImageButton.addTarget(self, action: #selector(addImageButtonPressed), for: .touchUpInside)
    
    pickerController.sourceType = .photoLibrary
    pickerController.delegate = self
    
    // MARK: - Add "Sign In" ant other alerts
    let signInAlert = UIAlertController(title: "Sign in", message: nil, preferredStyle: .alert)
    let warningAlert = UIAlertController(title: "WARNING", message: "Your login or password is wrong.\nTry again.", preferredStyle: .alert)
    let okWarningAction = UIAlertAction(title: "OK", style: .default) { (_) in
      self.present(signInAlert, animated: true)
    }
    
    let enterAction = UIAlertAction(title: "Enter", style: .default) { (_) in
      if (self.loginTextField?.text == self.user.login) && (self.passwordTextField?.text == self.user.password) {
        self.view.addSubview(addImageButton)
      } else {
        self.present(warningAlert, animated: true) {
          self.present(signInAlert, animated: true)
        }
      }
    }
    
    let registrationAction = UIAlertAction(title: "Registration", style: .default) { (_) in
      self.user.login = self.loginTextField?.text ?? "alex"
      self.user.password = self.passwordTextField?.text ?? "qwe"
      
      let data = try? JSONEncoder().encode(self.user)
      UserDefaults.standard.setValue(data, forKey: "UserKey")
    }
    
    signInAlert.addTextField { (loginTextField) in
      loginTextField.placeholder = "login"
      self.loginTextField = loginTextField
    }
    
    signInAlert.addTextField { (passwordTextField) in
      passwordTextField.placeholder = "password"
      self.passwordTextField = passwordTextField
    }
    
    signInAlert.addAction(enterAction)
    signInAlert.addAction(registrationAction)
    warningAlert.addAction(okWarningAction)
    
    present(signInAlert, animated: true)
  }

  @objc func addImageButtonPressed(sender: UIButton!) {
    present(pickerController, animated: true)
  }
  
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true) {
      if let chosenImage = info[.originalImage] as? UIImage {
        let imageView = UIImageView(image: chosenImage)
        imageView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY + 90, width: self.view.frame.width, height: self.view.frame.width)
        self.view.addSubview(imageView)
      }
    }
  }
}
