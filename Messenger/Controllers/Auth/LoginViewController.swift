//
//  LoginViewController.swift
//  Messenger
//
//  Created by Hanif Fadillah Amrynudin on 13/01/23.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .systemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .systemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let googleSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SignIn"), for: .normal)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let fbLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "FbLogIn"), for: .normal)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Log In"
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        emailField.delegate = self
        passwordField.delegate = self
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        googleSignInButton.addTarget(self,
                                     action: #selector(signinButtonTapped),
                                     for: .touchUpInside)
        
        fbLoginButton.addTarget(self,
                                      action: #selector(fbButtonTapped),
                                      for: .touchUpInside)
        
        //Add Sub View
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(fbLoginButton)
        scrollView.addSubview(googleSignInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/4
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+30,
                                  width: scrollView.width-60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: imageView.bottom+92,
                                     width: scrollView.width-60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                   y: imageView.bottom+154,
                                   width: scrollView.width-60,
                                   height: 52)
        
        fbLoginButton.frame = CGRect(x: 30,
                                     y: imageView.bottom+226,
                                     width: scrollView.width-60,
                                     height: 52)
        
        googleSignInButton.frame = CGRect(x: 30,
                                          y: imageView.bottom+298,
                                          width: scrollView.width-60,
                                          height: 52)
    }
    
    //MARK: - Register
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create New Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Login with Email
    
    @objc private func loginButtonTapped() {
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty else {
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
        
        //Firebase Log In
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            if let e = error {
                print(e.localizedDescription)
                let alertContoller = UIAlertController (title: e.localizedDescription, message: "" , preferredStyle:UIAlertController.Style.alert)
                alertContoller.addAction(UIAlertAction(title: "OK", style:UIAlertAction.Style.default , handler: nil))
                self?.present(alertContoller, animated: true)
            } else {
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to Log in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //MARK: - SignIn with Google
    
    @objc private func signinButtonTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] user, error in
            
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print(error)
                return
            }
            
            guard
                let authentication = user?.user,
                let idToken = authentication.idToken?.tokenString
            else {
                return
            }
            
            var getLastName: String? = user?.user.profile?.familyName
            
            if getLastName == nil {
                getLastName = " "
            }
            
            guard let email = user?.user.profile?.email,
                  let firstName = user?.user.profile?.givenName,
                  let lastName = getLastName else {
                return
            }
            
            DatabaseManager.shared.userExists(with: email, completion: {exist in
                if !exist {
                    DatabaseManager.shared.insertUser(with: chatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
            })
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken.tokenString)
            
            strongSelf.spinner.show(in: strongSelf.view)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
                
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Google credential login failed, MFA may be needed \(error)")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                }
                
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    //MARK: - Continue with Facebook
    
    @objc private func fbButtonTapped() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions:  ["public_profile", "email"], from: self) { result, error in
            guard let token = result?.token?.tokenString else {
                print("User failed to log in with facebook")
                return
            }
            
            let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil ,httpMethod: .get)
            
            facebookRequest.start(completion: {_, result, error in
                guard let result = result as? [String: Any], error == nil else {
                    print("Failed to make facebook graph request")
                    return
                }
                
                print("\(result)")
                guard let userName = result["name"] as? String,
                      let email = result["email"] as? String else {
                    print("Failed to get email and name from fb result")
                    return
                }
                
                let nameComponents = userName.components(separatedBy: " ")
                let getForFirstName = nameComponents.dropLast()
                
                let firstName = getForFirstName.joined(separator: " ")
                let lastName = nameComponents.last
                
                
                DatabaseManager.shared.userExists(with: email, completion: {exist in
                    if !exist {
                        DatabaseManager.shared.insertUser(with: chatAppUser(firstName: firstName, lastName: lastName!, emailAddress: email))
                    }
                })
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                
                self.spinner.show(in: self.view)
                
                FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        strongSelf.spinner.dismiss()
                    }
                    
                    guard authResult != nil, error == nil else {
                        if let error = error {
                            print("Facebook credential login failed, MFA may be needed \(error)")
                        }
                        return
                    }
                    
                    print("Successfully logged user in")
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                })
            })
            
        }
    }
}


//MARK: - Focus Textfield
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}

//MARK: - Facbook Login
extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        // no operation
    }
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil ,httpMethod: .get)
        
        facebookRequest.start(completion: {_, result, error in
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            
            print("\(result)")
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                print("Failed to get email and name from fb result")
                return
            }
            
            let nameComponents = userName.components(separatedBy: " ")
            let getForFirstName = nameComponents.dropLast()
            
            let firstName = getForFirstName.joined(separator: " ")
            let lastName = nameComponents.last
            
            
            DatabaseManager.shared.userExists(with: email, completion: {exist in
                if !exist {
                    DatabaseManager.shared.insertUser(with: chatAppUser(firstName: firstName, lastName: lastName!, emailAddress: email))
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed \(error)")
                    }
                    return
                }
                
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}
