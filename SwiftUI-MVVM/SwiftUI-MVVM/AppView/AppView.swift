import SwiftUI

struct AppView: View {
    @ObservedObject var viewModel: AppViewModel
    var sessionService =  FakeSessionService(user: .init())
    
    var body: some View {
        switch viewModel.state {
            case let .login(viewModel):
                return AnyView(
                    NavigationView {
                        LoginView(model: viewModel)
                    }
                )
            case let .loggedArea(sessionService):
                return AnyView(
                    ContentView(
                        model: .init(),
                        sessionService: sessionService
                    )
                )
//                return AnyView(
//                    VStack {
//                        Text("Welcome user")
//                        Button(
//                            action: sessionService.logout,
//                            label: {
//                                Text("Log out")
//                            }
//                        )
//                    }
//                )
             
                
            case .none:
                return AnyView(EmptyView())
        }
    }
}


struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(viewModel:  .init(sessionService: FakeSessionService(user: nil)))
    }
}
