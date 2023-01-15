//
//  ViewController.swift
//  Messenger
//
//  Created by Hanif Fadillah Amrynudin on 13/01/23.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        logOutButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        
        view.addSubview(logOutButton)
    }
    
    
    @objc private func registerButtonTapped() {
        print("tap")
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLayoutSubviews() {
        logOutButton.frame = CGRect(x: 30,
                                      y: 80,
                                      width: view.width-60,
                                      height: 52)
    }
    
    @objc private func didTapLogOut() {
        do {
            try Auth.auth().signOut()
            let vc = LoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }

    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}

