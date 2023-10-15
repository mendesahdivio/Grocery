//
//  Constants.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation


struct Constants {
  private static let baseApi = "http://127.0.0.1:8080/api"
  
  struct Urls {
    static let register = URL(string: "\(baseApi)/register")!
    
    static let login = URL(string: "\(baseApi)/login")!
    
    //api to save grocery category
    static func saveGroceryCategoryBy(userId: UUID) ->URL {
      return URL(string: "\(baseApi)/users/\(userId)/grocery-categories")!
    }
    
    //api to get grocery category
    static func groceryCategoryBy(userId: UUID) ->URL {
      return URL(string: "\(baseApi)/users/\(userId)/grocery-categories")!
    }
    
    //api to delete grocery category
    static func deleteGroceryCategoryBy(userId: UUID, groceryCategoryId: UUID) ->URL {
      return URL(string: "\(baseApi)/users/\(userId)/grocery-categories/\(groceryCategoryId)")!
    }
  }
  
  
  enum userDefaultKeys: String {
    case authKey
    case userId
  }
}
