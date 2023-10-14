//
//  GroceryCategoriesListScreen.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 14/10/23.
//

import SwiftUI

struct GroceryCategoriesListScreen: View {
  @EnvironmentObject private var model: GroceryModel
  
    var body: some View {
      List(model.groceryCategories) { groceryCategory in
        Text(groceryCategory.title)
      }.task {
        await fetchGroceryCategories()
      }
      .navigationTitle("Categories")
    }
}

//calls grocery categories from server to populate the view
extension GroceryCategoriesListScreen {
  private func fetchGroceryCategories() async {
    do {
      try await model.populateGroceryCategories()
      
    }catch {
      print(error.localizedDescription)
    }
  }
}


#Preview {
  NavigationStack {
    GroceryCategoriesListScreen()
      .environmentObject(GroceryModel())
  }
}
