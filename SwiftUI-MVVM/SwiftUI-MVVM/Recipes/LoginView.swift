//
//  LoginView.swift
//  SwiftUI-MVVM
//
//  Created by Danilo Magno de Oliveira Vasconcelos on 09/02/22.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var model: LoginViewModel
    
    init(model: LoginViewModel) {
        self.model = model
    }
    
    var body: some View {
        Form {
            Section(footer: formFooter) {
                TextField("e-mail", text: model.bindings.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("password", text: model.bindings.password)
            }
        }
        .navigationBarItems(trailing: submitButton)
        .navigationBarTitle("Login")
        .disabled(model.state.isLoggingIn)
        .alert(isPresented: model.bindings.isShowingErrorAlert) {
            Alert(
                title: Text("Error when logging in"),
                message: Text("Check your email and password and try again."))
        }
    }
    
    private var submitButton: some View {
        Button(action: model.login) {
            Text("Sign in")
        }
        .disabled(model.state.canSubmit == false)
    }
    
    private var formFooter: some View {
        Text(model.state.footerMessage)
    }
}

struct LoginViewState {
    var email = ""
    var password = ""
    var isLoggingIn = false
    var isShowingErrorAlert = false
}

extension LoginViewState {
    var canSubmit: Bool {
        email.isEmpty == false && password.isEmpty == false
    }
    
    var footerMessage: String {
        isLoggingIn ? "Logging In..." : ""
    }
}

final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginViewState

    var bindings: (
        email: Binding<String>,
        password: Binding<String>,
        isShowingErrorAlert: Binding<Bool>
    ) {
        (
            email: Binding(to: \.state.email, on: self),
            password: Binding(to: \.state.password, on: self),
            isShowingErrorAlert: Binding(to: \.state.isShowingErrorAlert, on: self)
        )
    }
    
    init(initialState: LoginViewState) {
        state = initialState
    }
    
    func login() {
        state.isLoggingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state.isLoggingIn = false
            self.state.isShowingErrorAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(model: .init(initialState: .init()))
        }
    }
}
