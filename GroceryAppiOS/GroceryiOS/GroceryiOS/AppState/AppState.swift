//
//  AppState.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 24/09/23.
//

import Foundation

enum Route: Hashable {
  case login
  case register
  case groceryCategoryList
}


class AppState: ObservableObject {
  @Published var routes: [Route] = []
}
