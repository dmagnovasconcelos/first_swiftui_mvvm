//
//  ContentView.swift
//  SwiftUI-MVVM
//
//  Created by Danilo Magno de Oliveira Vasconcelos on 08/02/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model: ContentViewModel
    
    init(model: ContentViewModel) {
        self.model = model
    }
    
    var body: some View {
        Text(model.state.isLoading ? "Loading..." : model.state.message)
            .padding()
            .onAppear(perform: model.loadData)
    }
}

struct ContenteViewState {
    var isLoading = false
    var message = ""
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .init())
    }
}
