//
//  GroceryModel.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation

class GroceryModel: ObservableObject {
  let httpClient = HTTPClient()
  final func register(username: String, password: String) async throws -> RegisterResponseDTO {
    let registerData = ["username": username, "password": password]
    let resource = try Resource(url: Constants.Urls.register, method: .post(JSONEncoder().encode(registerData)), modelType: RegisterResponseDTO.self)
    let registerResponseDTO = try await httpClient.load(resource)
    return registerResponseDTO
  }
}

extension GroceryModel {
  final func login(username: String, password: String) async throws -> LoginResponseDTO {
    let loginDataPost = ["username": username, "password": password]
    let resource = try Resource(url: Constants.Urls.login, method: .post(JSONEncoder().encode(loginDataPost)), modelType: LoginResponseDTO.self)
    let loginResponseDTO = try await httpClient.load(resource)
    if !loginResponseDTO.error && loginResponseDTO.token != nil && (loginResponseDTO.userId?.uuidString != nil) {
      //save the token in user defaults or key chains
      let userDefaults = UserDefaults.standard
      userDefaults.setValue(loginResponseDTO.token!, forKey: Constants.userDefaultKeys.authKey.rawValue)
      userDefaults.setValue(loginResponseDTO.userId!.uuidString, forKey: Constants.userDefaultKeys.userId.rawValue)
    }
    return loginResponseDTO
  }
}
