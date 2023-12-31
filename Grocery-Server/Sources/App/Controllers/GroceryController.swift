//
//  GroceryController.swift
//
//
//  Created by ahdivio mendes on 27/09/23.
//

import Foundation
import Vapor
import GroceryAppSharedDTO
import Fluent

final class GroceryController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let api = routes.grouped("api", "users", ":userId")
    //post the grocery category to server to save it
    api.post("grocery-categories", use: saveGroceryCategory)
    
    
    //gets the grocery category from server
    api.get("grocery-categories", use: getSavedGRoceryCatergoryForUser)
    
     
    //delete route
    //where user can delete a grocery category
    api.delete("grocery-categories", ":groceryCategoryId", use: deleteGroceryCategory)
  }
  
  func getSavedGRoceryCatergoryForUser(req: Request) async throws -> [GroceryCategoryResponseDTO] {
    guard let userId = req.parameters.get("userId", as: UUID.self) else {
      throw Abort(.custom(code: 404, reasonPhrase: "user id not found in the request"))
    }
    let groceryCategoryResponseDTO =  try await GroceryCategory.query(on: req.db)
      .filter(\.$user.$id == userId)
      .all()
      .compactMap(GroceryCategoryResponseDTO.init)
    
    return groceryCategoryResponseDTO;
  }
  
  
  func saveGroceryCategory(req: Request) async throws -> GroceryCategoryResponseDTO {
    guard let userId = req.parameters.get("userId", as: UUID.self) else {
      throw Abort(.custom(code: 404, reasonPhrase: "user id not found in the request"))
    }
    
    let groceryCategoryRequestDTO = try req.content.decode(GroceryCategoryRequestDTO.self)
    
    let groceryCategory = GroceryCategory(title: groceryCategoryRequestDTO.title, colorCode: groceryCategoryRequestDTO.colorCode, userId: userId)
    
    try await groceryCategory.save(on: req.db)
    
    
    guard let groceryCategoryResponseDTO = GroceryCategoryResponseDTO(groceryCategory) else {
      throw Abort(.internalServerError)
    }
    
    return groceryCategoryResponseDTO
  }
  
  
  //delete grocery category
  func deleteGroceryCategory(req: Request) async throws -> GroceryCategoryResponseDTO {
    guard let userId = req.parameters.get("userId", as: UUID.self),
          let groceryCategoryId = req.parameters.get("groceryCategoryId", as: UUID.self) 
    else {
      throw Abort(.custom(code: 404, reasonPhrase: "user id not found in the request"))
    }
    
    guard let groceryCategory = try await GroceryCategory.query(on: req.db)
      .filter(\.$user.$id == userId)
      .filter(\.$id == groceryCategoryId)
      .first() 
    else {
      throw Abort(.notFound)
    }
    
    try await groceryCategory.delete(on: req.db)
    
    
    guard let groceryCategoryResponseDTO = GroceryCategoryResponseDTO(groceryCategory)
    else {
      throw Abort(.internalServerError)
    }
    
    return  groceryCategoryResponseDTO
  }
}
