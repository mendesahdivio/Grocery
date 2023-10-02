//
//  CreateGroceryCategoryTabelMigration.swift
//
//
//  Created by ahdivio mendes on 26/09/23.
//

import Foundation
import Fluent

struct CreateGroceryCategoryTabelMigration: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("grocery_categories")
      .id()
      .field("title", .string, .required)
      .field("color_code", .string, .required)
      .field("user_id", .uuid, .required, .references("users", "id"))
      .create()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("GroceryCategory").delete()
  }
  
}
