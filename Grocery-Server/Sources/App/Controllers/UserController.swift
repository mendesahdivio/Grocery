//
//  UserController.swift
//
//
//  Created by ahdivio mendes on 17/09/23.
//

import Foundation
import Vapor
import Fluent

final class UserController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let api = routes.grouped("api")
    //api/register
    api.post("register", use: register)
    
    //api/login
    api.post("login", use: login)
  }
  
  
  func login(req: Request) async throws -> LoginResponseDTO {
    let user = try req.content.decode(User.self)
    
    //find if the user already exist in the database
    guard let exsitingUser = try await User.query(on: req.db).filter(\.$username == user.username).first() else {
      return LoginResponseDTO(error: true, Reason: "User doesnt exist in Datbase please register before logining in !!!")
    }
    
    //validate the password
    let isVerified = try await req.password.async.verify(user.password, created: exsitingUser.password)
    
    if !isVerified {
      return LoginResponseDTO(error: true, Reason: "Incorect Password! Please enter correct password")
    }
    
    //generate the jwt token
    let authPayload = try AuthPayload(expiration: .init(value: .distantFuture), userId: exsitingUser.requireID())
    return try LoginResponseDTO(error: false, token: req.jwt.sign(authPayload), userId: exsitingUser.requireID())
  }
  
  
  func register(req: Request) async throws -> RegisterResponseDTO {
    //validate the user
    try User.validate(content: req)
    
    let user = try req.content.decode(User.self)
  
    //find if the user already exist in the database
    if let _ = try await User.query(on: req.db).filter(\.$username == user.username).first() {
      throw Abort(.conflict, reason: "username already exists")
    }
    
    //hash the password to store in db
    user.password = try await req.password.async.hash(user.password)
    
    //now saving the user to db
    try await user.save(on: req.db)
    
    return RegisterResponseDTO(error: false)
  }
}
