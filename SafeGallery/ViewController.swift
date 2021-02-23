//
//  ViewController.swift
//  SafeGallery
//
//  Created by Alexander Kononok on 11/29/20.
//

import UIKit
import SwiftyKeychainKit

class ViewController: UIViewController {

    var loginTextField: UITextField!
    var passwordTextField: UITextField!
    var user: User!

    let keychain = Keychain(service: "alex.kononok.SafeGallery")
    let passwordKey = KeychainKey<String>(key: "keychainPassword123")

    override func viewDidLoad() {
        super.viewDidLoad()

        user = User(login: "", password: "")

        loadUserData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.title = "Gallery"

        addSignInAlert()
    }

    func loadUserData() {
        if let data = UserDefaults.standard.value(forKey: "UserKey") as? Data {
            let user = try? JSONDecoder().decode(User.self, from: data)
            self.user = user
        }
    }

    func addSignInAlert() {
        let signInAlert = UIAlertController(title: "Sign in", message: nil, preferredStyle: .alert)

        let warningAlert = UIAlertController(title: "WARNING",
                                             message: "Your login or password is wrong.\nTry again.",
                                             preferredStyle: .alert)
        let warningEmptyLogin = UIAlertController(title: "WARNING",
                                                  message: "Your login is empty!", preferredStyle: .alert)

        let okWarningAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.present(signInAlert, animated: true)
        }

        let okWarningEmptyLoginAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.present(signInAlert, animated: true)
        }

        let enterAction = UIAlertAction(title: "Enter", style: .default) { (_) in

            let safePassword = try? self.keychain.get(self.passwordKey)

            if (self.loginTextField?.text == self.user.login) && (self.passwordTextField?.text == safePassword) {

                let userImageStorageStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let userImageStorageViewController = userImageStorageStoryboard.instantiateViewController(
                    identifier: String(describing: UserImageStorageViewController.self))
                    as? UserImageStorageViewController

                self.navigationController?.pushViewController(userImageStorageViewController ??
                                                                UIViewController(), animated: true)
            } else {
                self.present(warningAlert, animated: true) {
                    self.present(signInAlert, animated: true)
                }
            }
        }

        let registrationAction = UIAlertAction(title: "Registration", style: .default) { (_) in
            if self.loginTextField.text == "" {
                self.present(warningEmptyLogin, animated: true) {
                    self.present(signInAlert, animated: true)
                }
            } else {
                self.user.login = String(self.loginTextField.text!)
            }

            try? self.keychain.set(self.passwordTextField?.text ?? "", for: self.passwordKey)

            let data = try? JSONEncoder().encode(self.user)
            UserDefaults.standard.setValue(data, forKey: "UserKey")

            self.present(signInAlert, animated: true)
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
        warningEmptyLogin.addAction(okWarningEmptyLoginAction)

        present(signInAlert, animated: true)
    }
}
