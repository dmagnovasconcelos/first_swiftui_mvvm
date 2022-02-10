//
//  SwiftUI_MVVMApp.swift
//  SwiftUI-MVVM
//
//  Created by Danilo Magno de Oliveira Vasconcelos on 08/02/22.
//

import SwiftUI

@main
struct SwiftUI_MVVMApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView(
                    model: .init(
                        initialState: .init(),
                        service: EmptyLoginservice(),
                        loginDidSucceed: {}
                    )
                )
            }
        }
    }
}
