//
//  GroceryModel.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation
import GroceryAppSharedDTO

//properties
@MainActor
class GroceryModel: ObservableObject {
  @Published var groceryCategories: [GroceryCategoryResponseDTO] = []
  let httpClient = HTTPClient()
  let keyStore: KeyManager = KeyManager(manager: UserDefaultsManager(userDefaults: UserDefaults.standard))
}


//register
extension GroceryModel {
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
      try keyStore.core?.setAuthKey(data: loginResponseDTO.token!)
      try keyStore.core?.setUserId(data: loginResponseDTO.userId!.uuidString)
    }
    return loginResponseDTO
  }
}


//save grocery Model
extension GroceryModel {
  final func saveGroceryModel(_ groceryCategoryRequestDTO: GroceryCategoryRequestDTO) async throws  {
    
    guard let userIdString = try keyStore.core?.getUserId(),
    let userId = UUID(uuidString: userIdString)
    else {
      throw keyErrors.fetchedEmtpy
    }
    
    let resource = try Resource(url: Constants.Urls.saveGroceryCategoryBy(userId: userId), method: .post(JSONEncoder().encode(groceryCategoryRequestDTO)), modelType: GroceryCategoryResponseDTO.self)
    
    let newGroceryCategory = try await httpClient.load(resource)
    
    //adds this new category to the list
    groceryCategories.append(newGroceryCategory)
  }
}


//get Grocery Categories
extension GroceryModel {
  final func populateGroceryCategories() async throws {
    guard let userIdString = try keyStore.core?.getUserId(),
          let userId = UUID(uuidString: userIdString)
    else {
      throw keyErrors.fetchedEmtpy
    }
    
    let resource = Resource(
      url: Constants.Urls.groceryCategoryBy(userId: userId),
      modelType: [GroceryCategoryResponseDTO].self
    )
    
    groceryCategories =  try await httpClient.load(resource)
    
  }
}


//delete GroceryCategory
extension GroceryModel {
  func deleteGroceryCategory(groceryCategoryId: UUID) async throws {
    guard let userIdString = try keyStore.core?.getUserId(),
          let userId = UUID(uuidString: userIdString)
    else {
      throw keyErrors.fetchedEmtpy
    }
    
    let resource = Resource(url: Constants.Urls.deleteGroceryCategoryBy(userId: userId, groceryCategoryId: groceryCategoryId), method: .delete , modelType: GroceryCategoryResponseDTO.self )
    
    let deletedGroceryCategory = try await httpClient.load(resource)
    
    //remove the delete item from the list
    groceryCategories = groceryCategories.filter{ $0.id != groceryCategoryId }
    
  }
}
