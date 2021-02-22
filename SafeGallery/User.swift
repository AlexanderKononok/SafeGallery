//
//  User.swift
//  SafeGallery
//
//  Created by Alexander Kononok on 12/7/20.
//

import Foundation

class User: Codable {
  var login: String?
  var password: String?

  init(login: String, password: String) {
    self.login = login
    self.password = password
  }
}
