//
//  KeyManager.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 12/10/23.
//

import Foundation

//protocol to get stored keys from app
protocol getKeys {
  associatedtype anyDataType
  func getAuthKey() throws -> anyDataType
  func getUserId() throws -> anyDataType
}

//protocol to store keys from server
protocol setKeys {
  associatedtype anyDataType
  func setUserId(data: anyDataType) throws
  func setAuthKey(data: anyDataType) throws
}


//protocol composition for KeyManager
typealias KeyManagerProtocol = getKeys & setKeys



//error sets for KeyManager
enum keyErrors: Error {
  case settingEmpty
  case fetchedEmtpy
}
extension keyErrors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .settingEmpty:
      return NSLocalizedString("Failed to set the key as the passed value is Empty", comment: "settingEmpty")
    case .fetchedEmtpy:
      return NSLocalizedString("Failed to fetch key value", comment: "fetchedEmtpy")
    }
  }
}


//Since we are using userdefaults for now i have userd UserdefaultsManager
struct UserDefaultsManager: KeyManagerProtocol {
  private var userDefaults: UserDefaults?
  
  init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }
  
}

extension UserDefaultsManager {
  
  typealias anyDataType = String
  
  func getAuthKey() throws -> String {
    guard let authKey = userDefaults?.string(forKey: Constants.userDefaultKeys.authKey.rawValue) else {
      throw keyErrors.fetchedEmtpy
    }
    return authKey
  }
  
  func getUserId() throws -> String {
    guard let userId = userDefaults?.string(forKey: Constants.userDefaultKeys.userId.rawValue) else {
      throw keyErrors.fetchedEmtpy
    }
    return userId
  }
  
  func setUserId(data: String) throws {
    guard !data.isEmpty else {
      throw keyErrors.settingEmpty
    }
    userDefaults?.setValue(Constants.userDefaultKeys.userId.rawValue, forKey: data)
  }
  
  func setAuthKey(data: String) throws {
    guard !data.isEmpty else {
      throw keyErrors.settingEmpty
    }
    userDefaults?.setValue(Constants.userDefaultKeys.authKey.rawValue, forKey: data)
  }
}





/*
 this implementation of KeyManager is to make the core capable to user any variant of KeyManagerProtocol
 there by making it modular
 
 Reason:
 I couldnt use the KeyManagerProtocol with the groceryModel since the class is an Enviromental object in many views
 
 Result:
 with this implementation you can use the KeyManagerProtocol anywhere by passing any type of instance of class or struct conforming to KeyManagerProtocol
 */
struct KeyManager<keyManager: KeyManagerProtocol> where keyManager.anyDataType == String {
  
  private let subManager: keyManager?
  
  var core: keyManager? {
    return subManager
  }
  
  init(manager: keyManager) {
    subManager = manager
  }
  
}
