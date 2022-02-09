//
//  LoginView.swift
//  SwiftUI-MVVM
//
//  Created by Danilo Magno de Oliveira Vasconcelos on 09/02/22.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = false
    @State private var isShowingErrorAlert = false 
    
    var body: some View {
        Form {
            Section(footer: formFooter) {
                TextField("e-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("password", text: $password)
            }
        }
        .navigationBarItems(trailing: submitButton)
        .navigationBarTitle("Login")
        .disabled(isLoggingIn)
        .alert(isPresented: $isShowingErrorAlert) {
            Alert(
                title: Text("Error when logging in!"),
                message: Text("Check your email and password and try again."))
        }
    }
    
    private var submitButton: some View {
        Button(action: login) {
            Text("Sign in")
        }
        .disabled(email.isEmpty || password.isEmpty)
    }
    
    private var formFooter: some View {
        Group {
            if isLoggingIn {
                Text("Logging In...")
            }
        }
    }
    
    func login() {
        isLoggingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.isLoggingIn = false
            self.isShowingErrorAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
