//
//  GroceryCategory.swift
//
//
//  Created by ahdivio mendes on 27/09/23.
//

import Foundation
import Vapor
import Fluent

final class GroceryCategory: Model, Content {
  static var schema: String = "grocery_categories"
  
  /*
   try await database.schema("grocery_categories")
   .id()
   .field("title", .string, .required)
   .field("color_code", .string, .required)
   .field("user_id", .uuid, .required, .references("users", "id"))
   */
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "title")
  var title: String
  
  @Field(key: "color_code")
  var colorCode: String
  
  @Parent(key: "user_id")
  var user: User
  
  init() {}
  
  init(id: UUID? = nil, title: String, colorCode: String, userId: UUID) {
    self.id = id
    self.title = title
    self.colorCode = colorCode
//    self.user = user
    self.$user.id = userId
  }
  
}


extension GroceryCategory: Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("title", as: String.self, is: !.empty, customFailureDescription: "title cannot be empty")
    validations.add("colorCode", as: String.self, is: !.empty, customFailureDescription: "color code cannot be empty")
  }
}
