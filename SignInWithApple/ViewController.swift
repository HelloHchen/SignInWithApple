//
//  ViewController.swift
//  SignInWithApple
//
//  Created by Anni on 2019/12/10.
//  Copyright © 2019 hellohchen. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            let sign1 = signSystemButton_Black()
            sign1.frame = CGRect(x: 100, y: 300, width: 120, height: 40)
            let sign2 = signSystemButton_White()
            sign2.frame = CGRect(x: 100, y: 400, width: 100, height: 40)
            let sign3 = signSystemButton_WhiteOutline()
            sign3.frame = CGRect(x: 100, y: 500, width: 120, height: 40)
            let sign4 = signCustomButton()
            sign4.frame = CGRect(x: 100, y: 600, width: 40, height: 40)
            
            view.addSubview(sign1)
            view.addSubview(sign2)
            view.addSubview(sign3)
            view.addSubview(sign4)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            performExistingAccountSetupFlows()
        }
    }


}

@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    /// 系统白色
    private func signSystemButton_White() -> UIView {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        return authorizationButton
    }
    /// 系统黑色
    private func signSystemButton_Black() -> UIView {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        return authorizationButton
    }
    /// 系统白色带边框
    private func signSystemButton_WhiteOutline() -> UIView {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        return authorizationButton
    }
    /// 自定义
    private func signCustomButton() -> UIView {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "login-apple"), for: .normal)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        return button
    }
    
    /// 登陆授权
    @objc private func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// 如果找到现有的iCloud钥匙串凭证或Apple ID凭证，则提示用户。
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let user = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let identityToken = appleIDCredential.identityToken
            let authorizationCode = appleIDCredential.authorizationCode
            
            // TODO: Create an account in your system.
            
            print("user:\(user)")
            print("fullName:\(String(describing: fullName))")
            print("email:\(String(describing: email))")
            print("identityToken:\(String(describing: identityToken))")
            print("authorizationCode:\(String(describing: authorizationCode))")
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username:\(username)")
            print("password:\(password)")
            
        }
    }
}

