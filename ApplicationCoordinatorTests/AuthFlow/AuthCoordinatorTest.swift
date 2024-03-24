//
//  AuthCoordinatorTest.swift
//  ApplicationCoordinatorTests
//
//  Created by LoganMacMini on 2024/3/20.
//

import XCTest
@testable import PocketTube

class AuthCoordinatorTest: XCTestCase {
    
    private var coordinator: AuthCoordinator!
    private var mockAuthSceneFactory: MockAuthSceneFactory!
    private var mockCoordinatorFactory: MockCoordinatorFactory!
    private var mockRouter: MockRouter!
    
    override func setUp() {
        super.setUp()
                
        mockAuthSceneFactory = MockAuthSceneFactory()
        mockCoordinatorFactory = MockCoordinatorFactory()
        mockRouter = MockRouter()
        coordinator = AuthCoordinator(factory: mockAuthSceneFactory, coordinatorFactory: mockCoordinatorFactory, router: mockRouter)
    }
    
    override func tearDown() {
        coordinator = nil
        mockRouter = nil
        
        super.tearDown()
    }
    
    func testShowLandingScreenView() {
        // 1. Arrange
        coordinator.start()
        
        // Assert
        XCTAssertTrue(mockAuthSceneFactory.makeLandingScreenViewCalled, "Expected to create LandingScreenView")
        XCTAssertTrue(mockRouter.navigationStack.first is LandingScreenViewController, "Expected to push LandingScreenView")
        XCTAssertTrue(mockRouter.navigationStack.count == 1)
        XCTAssertTrue(mockRouter.setRootModuleCalled, "Expected to set landing screen view as root module")
    }
    
    func testShowLandingScreenView_then_TapLogInButton_then_showLoginView() {
        // 1. Arrange
        coordinator.start()
        let landingScreenOutput = mockRouter.navigationStack.first as! LandingScreenViewController
        
        // 2. Action
        landingScreenOutput.onLogInButtonTap?()
        
        // 3. Assert
        XCTAssertTrue(mockAuthSceneFactory.makeLoginViewCalled, "Expected to create LoginViewController")
        XCTAssertTrue(mockRouter.navigationStack.last is LoginViewController, "Expected to push LoginViewController")
    }
    
    func testShowLoginView_then_TapForgotPWD_then_showForgotPWDView() {
        // 1. Arrange
        coordinator.showLoginView()
        let loginOutput = mockRouter.navigationStack.first as! LoginViewController
        
        // 2. Action
        loginOutput.onTransitToForgotPWD?()
        
        // 3. Assert
        XCTAssertTrue(mockAuthSceneFactory.makeForgotPasswordViewCalled, "Expected to create ForgotPasswordView")
        XCTAssertTrue(mockRouter.navigationStack.last is ForgotPasswordViewController, "Expected to push ForgotPasswordViewController")
        XCTAssertTrue(mockRouter.navigationStack.count == 2)
    }
    
    func testLoginSuccess_butCanNotGetUsername_then_showPersonalInfoView() {
        // 1. Arrange
        coordinator.showLoginView()
        let loginOutput = mockRouter.navigationStack.first as! LoginViewController
        
        // 2. Action
        loginOutput.onTransitToPersonal?("test@gmail.com", "test")
        
        // 3. Assert
        XCTAssertTrue(mockAuthSceneFactory.makePersonalInfoViewCalled, "Expected to create PersonalInfoView")
        XCTAssertTrue(mockRouter.navigationStack.last is PersonalInfoViewController, "Expected to push PersonalInfoViewController")
        XCTAssertTrue(mockRouter.navigationStack.count == 2)
    }
    
    func testLoginSuccess_then_showHomeViewController() {
        
        // 1. Arrange
        coordinator.showLoginView()
        
        coordinator.finishFlow = { [unowned self] in
            self.mockRouter.push(HomeViewController())
        }
        
        let loginOutput = mockRouter.navigationStack.first as! LoginViewController
        
        // 2. Action
        loginOutput.onCompleteAuth?("test@example.com", "Tester", nil)
        
        // 3. Assert
        XCTAssertTrue(self.mockRouter.navigationStack.last is HomeViewController, "Expected to switch to HomeViewController")
    }
    
    func testShowSignUpView() {
        // Arrange
        coordinator.runSignUpFlow()
                
        // Assert
        XCTAssertTrue(mockAuthSceneFactory.makeSignUpViewCalled, "Expected to create SignUpView")        
    }
    
    func testRusnSignUpFlow() {
        // Arrange
        coordinator.runSignUpFlow()
        
        coordinator.finishFlow = { [unowned self] in
            self.mockRouter.push(LoginViewController())
        }
        
        let signUpOutput = mockRouter.navigationStack.last as! SignUpViewController
        
        // Action
        signUpOutput.onCompleteSignUp?()
        
        // Assert
        XCTAssertTrue(self.mockRouter.navigationStack.last is LoginViewController, "Expected to switch to LoginViewController")
        
    }
    
}
