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
    private var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let okWarningAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.present(signInAlert, animated: true)
        }

        let enterAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            if (self.loginTextField?.text == self.user.login) && (self.passwordTextField?.text == self.user.password) {

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
            self.user.login = self.loginTextField?.text ?? "alex"
            self.user.password = self.passwordTextField?.text ?? "qwe"

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

        present(signInAlert, animated: true)
    }
}
