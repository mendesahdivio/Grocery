//
//  GroceryController.swift
//
//
//  Created by ahdivio mendes on 27/09/23.
//

import Foundation
import Vapor
import GroceryAppSharedDTO

final class GroceryController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let api = routes.grouped("api", "users", ":userId")
    api.post("grocery-categories", use: saveGroceryCategory)
  }
  
  
  func saveGroceryCategory(req: Request) async throws -> GroceryCategoryResponseDTO {
    guard let userId = req.parameters.get("userId", as: UUID.self) else {
      throw Abort(.custom(code: 404, reasonPhrase: "user id not found in the request"))
    }
    
    let groceryCategoryRequestDTO = try req.content.decode(GroceryCategoryRequestDTO.self)
    
    let gorceryCategory = GroceryCategory(title: groceryCategoryRequestDTO.title, colorCode: groceryCategoryRequestDTO.colorCode, userId: userId)
    
    try await gorceryCategory.save(on: req.db)
    
    
    guard let groceryCategoryResponseDTO = GroceryCategoryResponseDTO(gorceryCategory) else {
      throw Abort(.internalServerError)
    }
    
    return groceryCategoryResponseDTO
  }
}
