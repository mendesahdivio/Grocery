//
//  AddGroceryCategoryScreen.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 01/10/23.
//

import SwiftUI
import GroceryAppSharedDTO

struct AddGroceryCategoryScreen: View {
  @State private var title: String = ""
  @State private var colorSelector: String = "#00ff00"
  @EnvironmentObject private var model: GroceryModel
  @Environment(\.dismiss) private var dismiss
  
  private var isValidToSave: Bool {
    return !title.isEmptyOrWhiteSpace
  }
    var body: some View {
      Form{
        TextField("Title", text: $title)
        ColorSelector(colorCode: $colorSelector)
      }.navigationTitle("New Category")
        .toolbar{
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Close") {
              dismiss()
            }
          }
          
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
              Task {
                await saveGroceryCategory()
              }
            }.disabled(!isValidToSave)
          }
        }
    }
}

//saving grocery category funtion
extension AddGroceryCategoryScreen {
  private func saveGroceryCategory() async {
    let groceryCategoryRequest = GroceryCategoryRequestDTO(
      title: title,
      colorCode: colorSelector
    )
    do {
       try await model.saveGroceryModel(groceryCategoryRequest)
    }catch {
      print("Error detected", error.localizedDescription)
    }
    
  }
}



#Preview {
  NavigationStack {
    AddGroceryCategoryScreen()
      .environmentObject(GroceryModel())
  }
}
