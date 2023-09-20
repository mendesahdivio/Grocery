//
//  RegistrationScreen.swift
//  GroceryiOS
//
//  Created by ahdivio mendes on 19/09/23.
//

import SwiftUI

struct RegistrationScreen: View {
  @State private var username: String = ""
  @State private var password: String = ""
  @State private var errorMessage: String = ""
  @State private var isAlertShowing: Bool = false

  
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
                  await register()
                }
              }, label: {
                Text("Register")
                  .font(.system(size: 24, weight: .bold, design: .default))
                  .frame(maxWidth: .infinity, maxHeight: 60)
                  .foregroundColor(Color.white)
                  .background(Color(isInputValid ? ThemeColour.secondary : .systemRed))
                  .cornerRadius(10)
              }
            ).disabled(!isInputValid)

          }.padding(30)
    
    
        }.background(Color.white)
      .navigationTitle("Register")
      .alert(isPresented: $isAlertShowing) {
        Alert(title: Text(errorMessage), dismissButton: .destructive(Text("OK"), action: {
          errorMessage = "";
          isAlertShowing = false;
        }))
      }
        
  }
}

//MARK: register function
extension RegistrationScreen {
  private func register() async {
    do {
      let register = try await model.register(username: username, password: password)
      
      if !register.error {
        //send user to other screen
        
      } else {
        errorMessage = register.reason ?? "opps somehting went wrong"
        isAlertShowing =  true
      }
    }catch {
      print(error.localizedDescription)
      errorMessage = error.localizedDescription
      isAlertShowing = true
    }
    
  }
}

#Preview {
  NavigationStack {
    RegistrationScreen().environmentObject(GroceryModel())
  }
}
