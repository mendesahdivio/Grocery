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
  @EnvironmentObject private var appState: AppState
  
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
        appState.routes.append(.login)
        
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


//logic to run the code less on full simluator using container view
struct RegistrationScreenContainerView: View {
  @StateObject private var appState = AppState()
  @StateObject private var model = GroceryModel()
  var body: some View {
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

#Preview {
  RegistrationScreenContainerView()
}
