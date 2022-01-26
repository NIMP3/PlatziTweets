//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Centro de Informática on 25/01/22.
//

import UIKit
import NotificationBanner

class LoginViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Actions
    @IBAction func loginAction() { performLogin() }
    
    //MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        
    }

    private func performLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "ERROR", subtitle: "El correo y la contraseña son obligatorios", style: .warning).show()
            
            return
        }
        
        performSegue(withIdentifier: "showHome", sender: nil)
    }
}
