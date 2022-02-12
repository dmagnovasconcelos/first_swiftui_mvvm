import XCTest
import Combine
@testable import SwiftUI_MVVM

final class AppViewModelTests: XCTestCase {
    func test_whenUserIsLoggedIn_showLoggedArea() {
        let (sut, _) = makeSut(isLoggedIn: true)
        
        XCTAssert(sut.state?.isLoggedArea == true)
    }
    
    func test_whenUserIsNotLoggedIn_showLogin() {
        let (sut, _) = makeSut(isLoggedIn: false)
        
        XCTAssert(sut.state?.isLogin == true)
    }
    
    func test_whenUserLogsIn_showLoggedArea() {
        let (sut, service) = makeSut(isLoggedIn: false)
        
        service.login(email: "", password: "", completion: { _ in })
        
        XCTAssert(sut.state?.isLoggedArea == true)
    }
    
    func test_whenUserLogsOut_showLogin() {
        let (sut, service) = makeSut(isLoggedIn: true)
        
        service.logout()
        
        XCTAssert(sut.state?.isLogin == true )
    }
}

// MARK: HELPS

private extension AppViewModelTests {
    class StubSessionService: SessionService {
        private let userSubject: CurrentValueSubject<User?, Never>
        
        private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
        
        var user: User? { userSubject.value }
        
        init(user: User?) {
            self.userSubject = .init(user)
        }
        
        func login(
            email: String,
            password: String,
            completion: @escaping (Error?) -> Void) {
                userSubject.send(.init())
         }
        
        func logout() {
            userSubject.send(nil)
        }
    }
    
    func makeSut(isLoggedIn: Bool) -> (AppViewModel, StubSessionService) {
        let sessionService = StubSessionService(user: isLoggedIn ? .init() : nil)
        return (AppViewModel(sessionService: sessionService), sessionService)
    }
}

private extension AppVeiwState {
    var isLogin: Bool {
        guard case .login = self else { return false }
        return true
    }
    
    var isLoggedArea: Bool {
        guard case .loggedArea = self else { return false }
        return true
    }
}
