//
//  LoginSceneFactoryProtocol.swift
//  Ptt
//
//  Created by You Gang Kuo on 2021/1/2.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

protocol AuthSceneFactoryProtocol {
    func makeLoginView() -> LoginView
    func makeSignUpView() -> SignUpView
    func makeLandingScreenView() -> LandingScreenView
    func makeLandingScreenViewController() -> UIViewController
    func makePersonalInfoView(name: String?, email: String?) -> PersonalInfoView
}
