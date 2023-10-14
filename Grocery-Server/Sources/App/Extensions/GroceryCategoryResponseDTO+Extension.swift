//
//  File.swift
//  
//
//  Created by ahdivio mendes on 13/10/23.
//

import Foundation
import Vapor
import GroceryAppSharedDTO

extension GroceryCategoryResponseDTO: Content {
  
  init?(_ groceryCategory: GroceryCategory) {
    
    guard let id = groceryCategory.id
    else {
      return nil
    }
    
    self.init(id: id, title: groceryCategory.title, colorCode: groceryCategory.colorCode)
  }
  
}
