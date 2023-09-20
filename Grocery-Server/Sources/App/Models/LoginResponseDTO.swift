//
//  LoginResponseDTO.swift
//
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation
import Vapor

struct LoginResponseDTO: Content {
  let error: Bool
  var Reason: String? = nil
  let token: String?
  let userId: UUID
}
