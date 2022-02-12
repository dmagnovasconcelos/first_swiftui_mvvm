import Combine

class AppViewModel : ObservableObject {
    @Published private(set) var state: AppVeiwState?
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService) {
        userCancellable = sessionService.userPublisher.sink { [weak self] user in
            self?.state = user == nil
            ? .login(LoginViewModel(service: sessionService, loginDidSucceed: { }))
            : .loggedArea(sessionService)
        }
    }
}
