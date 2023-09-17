//
//  User.swift
//  
//
//  Created by ahdivio mendes on 17/09/23.
//

import Foundation
import Fluent
import Vapor


final class User: Model, Content {
  static let schema: String = "users"
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "username")
  var username: String
  
  @Field(key: "password")
  var password: String
  
  
  init(){}
  
  init(id: UUID? = nil, username: String, password: String) {
    self.id  = id
    self.username  = username
    self.password = password
  }
}


//MARK: validations for User
extension User : Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("username", as: String.self, is: !.empty, customFailureDescription: "username cannot be empty")
    validations.add("password", as: String.self, is: !.empty, customFailureDescription: "password cannot be empty")
    
    //adding more validation for password
    validations.add("password", as: String.self, is: .count(6...10), customFailureDescription: "password cannot be less then 6 characters and more than 10")
  }
}
