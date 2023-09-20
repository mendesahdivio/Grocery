//
//  String+Extension.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import Foundation


extension String {
  var isEmptyOrWhiteSpace: Bool {
    self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
