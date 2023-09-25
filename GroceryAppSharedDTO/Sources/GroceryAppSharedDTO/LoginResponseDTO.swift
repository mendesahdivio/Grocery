//
//  LoginResponseDTO.swift
//
//
//  Created by ahdivio mendes on 25/09/23.
//

import Foundation


public struct LoginResponseDTO: Codable {
  public let error: Bool
  public var Reason: String? = nil
  public var token: String? = nil
  public var userId: UUID? = nil
  
  public init(error: Bool, Reason: String? = nil, token: String? = nil, userId: UUID? = nil) {
    self.error = error
    self.Reason = Reason
    self.token = token
    self.userId = userId
  }
}
