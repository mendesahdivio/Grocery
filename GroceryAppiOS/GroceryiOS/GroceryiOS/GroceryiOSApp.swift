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
  @StateObject private var appState = AppState()
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $appState.routes) {
        RegistrationScreen().navigationDestination(for: Route.self) { route in
          switch route {
          case .register:
            RegistrationScreen()
          case .login:
            LoginScreen()
          case .groceryCategoryList:
            Text("GroceryCategorList")
          }
        }
      }.environmentObject(model).environmentObject(appState)
    }
  }
}
