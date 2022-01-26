//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Centro de Informática on 25/01/22.
//

import UIKit
import NotificationBanner

class RegisterViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var namesTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    //MARK: - Actions
    @IBAction func registerAction() {
        view.endEditing(true)
        performRegister()
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        
    }
    
    private func performRegister() {
        guard let names = namesTextField.text, !names.isEmpty,
        let email = emailTextField.text, !email.isEmpty,
        let password = passwordTextField.text, !password.isEmpty,
        let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            
            NotificationBanner(title: "ERROR EN EL FORMULARIO", subtitle: "Por favor complete todos los campos en el formulario", style: .warning).show()
                
            return
        }
        
        performSegue(withIdentifier: "showHome", sender: nil)
    }
}
