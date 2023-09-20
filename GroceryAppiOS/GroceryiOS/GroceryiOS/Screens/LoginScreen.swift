//
//  LoginScreen.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import SwiftUI

struct LoginScreen: View {
  @State private var username: String = ""
  @State private var password: String = ""
  @State private var errorMessage: String = ""
  @EnvironmentObject private var model: GroceryModel
  
  private var isInputValid: Bool {
    !username.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && (password.count >= 6 && password.count <= 10)
  }
  
  var body: some View {
    
    VStack {
      Spacer()
      
      VStack {
        TextField(
          "",
          text: $username,
          prompt: Text("Username").foregroundColor(Color(ThemeColour.textColour))
        )
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .foregroundColor(Color(ThemeColour.textColour))
        .padding(.top, 20)
        .cornerRadius(10)
        
        
        Divider()
        
        SecureField(
          "",
          text: $password,
          prompt: Text("Password").foregroundColor(Color(ThemeColour.textColour))
        )
        .padding(.top, 20)
        .foregroundColor(Color(ThemeColour.textColour))
        .cornerRadius(10)
        
        Divider()
      }.padding(30)
      
      Spacer()
      
      VStack {
        Button(
          action: {
            Task{
              await login()
            }
          }, label: {
            Text("Login")
              .font(.system(size: 24, weight: .bold, design: .default))
              .frame(maxWidth: .infinity, maxHeight: 60)
              .foregroundColor(Color.white)
              .background(Color(isInputValid ? ThemeColour.secondary : .systemRed))
              .cornerRadius(10)
          }
        ).disabled(!isInputValid)
        
      }.padding(30)
      
      Text(errorMessage)
      
    }.background(Color.white)
      .navigationTitle("Login")
    
    
  }
}



extension LoginScreen {
  private func login() async {
    do {
      let isLogedIn = try await model.login(username: username, password: password)
      if isLogedIn {
        //move to the grocery view
      }
    }catch {
      errorMessage = error.localizedDescription
    }
  }
}

#Preview {
  NavigationStack {
    LoginScreen().environmentObject(GroceryModel())
  }
}
