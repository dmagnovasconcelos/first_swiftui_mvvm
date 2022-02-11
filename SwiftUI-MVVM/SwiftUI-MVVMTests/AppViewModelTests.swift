//
//  AppViewModelTests.swift
//  SwiftUI-MVVMTests
//
//  Created by Danilo Magno de Oliveira Vasconcelos on 10/02/22.
//

import XCTest
@testable import SwiftUI_MVVM

enum AppVeiwState {
    case login
    case loggedArea
}

struct User {}

import Combine

protocol SessionSercive : LoginService {
    var user: User? { get }
    var userPublisher: AnyPublisher<User?, Never> { get }
    func logout()
}

final class AppViewModel {
    @Published private(set) var state: AppVeiwState
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionSercive) {
        state = sessionService.user == nil ? .login : .loggedArea
        userCancellable = sessionService.userPublisher.sink { [weak self] user in
            self?.state = user == nil ? .login : .loggedArea
        }
    }
}

final class AppViewModelTests: XCTestCase {
    func test_whenUserIsLoggedIn_showLoggedArea() {
        let (sut, _) = makeSut(isLoggedIn: true)
        
        XCTAssert(sut.state == .loggedArea)
    }
    
    func test_whenUserIsNotLoggedIn_showLogin() {
        let (sut, _) = makeSut(isLoggedIn: false)
        
        XCTAssert(sut.state == .login)
    }
    
    func test_whenUserLogsIn_showLoggedArea() {
        let (sut, service) = makeSut(isLoggedIn: false)
        
        service.login(email: "", password: "", completion: { _ in })
        
        XCTAssert(sut.state == .loggedArea)
    }
    
    func test_whenUserLogsOut_showLogin() {
        let (sut, service) = makeSut(isLoggedIn: true)
        
        service.logout()
        
        XCTAssert(sut.state == .login)
    }
}

private extension AppViewModelTests {
    class StubSessionService: SessionSercive {
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
