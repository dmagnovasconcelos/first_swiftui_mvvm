//
//  ContentView.swift
//  SwiftUI-MVVM
//
//  Created by Danilo Magno de Oliveira Vasconcelos on 08/02/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model: ContentViewModel
    private let sessionService: SessionService
    
    init(model: ContentViewModel, sessionService: SessionService) {
        self.model = model
        self.sessionService = sessionService
    }
    
    var body: some View {
        
        
        VStack {
            Text(model.state.isLoading ? "Loading..." : model.state.message)
                .padding()
                .onAppear(perform: model.loadData)
            
           
                
            
            Button(
                action: sessionService.logout,
                label: {
                    Text("Log out")
                }
            )
        }
    }
}

struct ContenteViewState {
    var isLoading = false
    var message = ""
    var messageUser = ""
}

class ContentViewModel: ObservableObject {
    @Published var state: ContenteViewState
    
    init(initialState: ContenteViewState = .init()) {
        state = initialState
    }
    
    func loadData() {
        state.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state.isLoading = false
            self.state.message = "Hello, world!"
            self.state.messageUser = "Welcome user"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            model: .init(),
            sessionService: FakeSessionService(user: .init())
        )
    }
}
