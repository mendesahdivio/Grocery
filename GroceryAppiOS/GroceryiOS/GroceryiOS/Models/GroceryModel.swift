//
//  GroceryModel.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation
import GroceryAppSharedDTO
//register
class GroceryModel: ObservableObject {
  let httpClient = HTTPClient()
  let userdefaults = UserDefaultsManager()
  final func register(username: String, password: String) async throws -> RegisterResponseDTO {
    let registerData = ["username": username, "password": password]
    let resource = try Resource(url: Constants.Urls.register, method: .post(JSONEncoder().encode(registerData)), modelType: RegisterResponseDTO.self)
    let registerResponseDTO = try await httpClient.load(resource)
    return registerResponseDTO
  }
}

//Login
extension GroceryModel {
  final func login(username: String, password: String) async throws -> LoginResponseDTO {
    let loginDataPost = ["username": username, "password": password]
    let resource = try Resource(url: Constants.Urls.login, method: .post(JSONEncoder().encode(loginDataPost)), modelType: LoginResponseDTO.self)
    let loginResponseDTO = try await httpClient.load(resource)
    if !loginResponseDTO.error && loginResponseDTO.token != nil && (loginResponseDTO.userId?.uuidString != nil) {
      //save the token in user defaults or key chains
      try userdefaults.setAuthKey(authKey: loginResponseDTO.token!)
      try userdefaults.setUserId(id: loginResponseDTO.userId!.uuidString)
    }
    return loginResponseDTO
  }
}


//save grocery Model
extension GroceryModel {
  final func saveGroceryModel(_ groceryCategoryRequestDTO: GroceryCategoryRequestDTO) async throws -> Bool {
    guard let userIdString = userdefaults.getUserId, let userId = UUID(uuidString: userIdString) else {
      throw UserDefaultsError.returnNull
    }
    let resource = try Resource(url: Constants.Urls.saveGroceryCategoryBy(userId: userId), method: .post(JSONEncoder().encode(groceryCategoryRequestDTO)), modelType: GroceryCategoryResponseDTO.self)
    
    let newGroceryCategory = try await httpClient.load(resource)
    
    return false
  }
}
