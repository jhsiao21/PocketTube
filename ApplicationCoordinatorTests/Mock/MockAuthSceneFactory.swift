//
//  MockAuthSceneFactory.swift
//  ApplicationCoordinatorTests
//
//  Created by LoganMacMini on 2024/3/21.
//

import UIKit
@testable import PocketTube

final class MockAuthSceneFactory: AuthSceneFactoryProtocol {
    var makeLoginViewCalled = false
    var makeSignUpViewCalled = false
    var makeLandingScreenViewCalled = false
    var makeForgotPasswordViewCalled = false
    var makePersonalInfoViewCalled = false
    
    func makeLoginView() -> PocketTube.LoginView {
        makeLoginViewCalled = true
        return LoginViewController()
    }
    
    func makeSignUpView() -> PocketTube.SignUpView {
        makeSignUpViewCalled = true
        return SignUpViewController()
    }
    
    func makeLandingScreenView() -> PocketTube.LandingScreenView {
        makeLandingScreenViewCalled = true
        return LandingScreenViewController()
    }
    
    func makePersonalInfoView(email: String?, name: String?) -> PocketTube.PersonalInfoView {
        makePersonalInfoViewCalled = true
        return PersonalInfoViewController(name: nil, email: nil)
    }
    
    func makeForgotPasswordView() -> PocketTube.ForgotPasswordView {
        makeForgotPasswordViewCalled = true
        return ForgotPasswordViewController()
    }
}
