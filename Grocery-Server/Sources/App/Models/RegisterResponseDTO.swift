//
//  RegisterResponseDTO.swift
//
//
//  Created by ahdivio mendes on 17/09/23.
//

import Foundation
import Vapor

struct RegisterResponseDTO: Content {
  var error: Bool
  var reason: String?
}
