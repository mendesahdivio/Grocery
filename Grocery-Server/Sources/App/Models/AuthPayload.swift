//
//  AuthPayload.swift
//  
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation
import JWT


struct AuthPayload: JWTPayload {
  
  typealias Payload = AuthPayload
  
  var subject: SubjectClaim?
  var expiration: ExpirationClaim
  var userId: UUID
  
  
  enum CodingKeys: String, CodingKey {
    case subject = "sub"
    case expiration = "exp"
    case userId = "uid"
  }
  
  func verify(using signer: JWTSigner) throws {
    try self.expiration.verifyNotExpired()
  }
  
}
