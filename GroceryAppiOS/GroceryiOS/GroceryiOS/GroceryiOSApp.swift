//
//  GroceryiOSApp.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 17/09/23.
//

import SwiftUI

@main
struct GroceryiOSApp: App {
  @StateObject private var model = GroceryModel()
    var body: some Scene {
        WindowGroup {
          RegistrationScreen().environmentObject(model)
        }
    }
}
