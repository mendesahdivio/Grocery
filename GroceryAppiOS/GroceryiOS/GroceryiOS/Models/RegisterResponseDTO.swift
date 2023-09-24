//
//  RegisterResponseDTO.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation

struct RegisterResponseDTO: Codable {
  var error: Bool
  var reason: String?
}


struct LoginResponseDTO: Codable {
  let error: Bool
  var Reason: String? = nil
  var token: String? = nil
  var userId: UUID? = nil
}

