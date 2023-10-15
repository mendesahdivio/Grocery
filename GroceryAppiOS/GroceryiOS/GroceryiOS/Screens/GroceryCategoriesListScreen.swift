//
//  GroceryCategoriesListScreen.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 14/10/23.
//

import SwiftUI

struct GroceryCategoriesListScreen: View {
  @EnvironmentObject private var model: GroceryModel
  @State private var isPresented: Bool = false
  
    var body: some View {
      List {
        
        ForEach(model.groceryCategories) { groceryCategory in
          HStack {
            Circle()
              .fill(Color(UIColor.init(hexString: groceryCategory.colorCode)))
              .frame(width: 25, height: 25)
            Text(groceryCategory.title)
          }
          
        }.onDelete(perform: deleteGroceryCategotry)
      
      }.task {
        await fetchGroceryCategories()
      }
      .navigationTitle("Categories")
      .toolbar{
        ToolbarItem(placement: .topBarLeading) {
          Button("Logout") {
            
          }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          Button{
            isPresented = true
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .sheet(isPresented: $isPresented) {
        NavigationStack {
          AddGroceryCategoryScreen()
        }
      }
      
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

//Handles swipe to delete grocery category
extension GroceryCategoriesListScreen {
  private func deleteGroceryCategotry(at offsets: IndexSet) {
    offsets.forEach { index in
      let groceryCategory = model.groceryCategories[index]
      Task {
        do {
          try await model.deleteGroceryCategory(groceryCategoryId: groceryCategory.id)
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
}


#Preview {
  NavigationStack {
    GroceryCategoriesListScreen()
      .environmentObject(GroceryModel())
  }
}
