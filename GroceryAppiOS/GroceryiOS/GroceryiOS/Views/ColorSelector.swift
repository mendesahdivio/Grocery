//
//  ColorSelector.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 01/10/23.
//

import SwiftUI

enum Colors: String, CaseIterable {
  case green = "#00ff00"
  case red = "#FF0000"
  case blue = "#0000ff"
  case purple = "#ff00ff"
  case yellow = "#ffff00"
}

struct ColorSelector: View {
  @Binding var colorCode: String
    var body: some View {
      HStack {
        ForEach(Colors.allCases, id: \.rawValue) { color in
          VStack {
            Image(systemName: colorCode == color.rawValue ? "record.circle.fill" : "circle.fill")
              .font(.title)
              .foregroundColor(Color(UIColor.init(hexString: color.rawValue)))
              .clipShape(Circle())
              .onTapGesture {
                colorCode = color.rawValue
              }
          }
          
        }
      }
    }
}

#Preview {
  ColorSelector(colorCode: .constant("#00ff00"))
}
