//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Centro de Informática on 25/01/22.
//

import UIKit
import NotificationBanner
import Simple_Networking
import SVProgressHUD
import KeychainSwift

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
        
        // Creamos el request
        let request = RegisterRequest(email: email, password: password, names: names)
        
        // Iniciamos el progressbar
        SVProgressHUD.show()
        
        // Llamamos a la librería para la gestión de peticiones
        SN.post(endpoint: Endpoints.register, model: request) { (response: SNResultWithEntity<RegisterResponse, ErrorResponse>) in
            
            // Detenemos el progressbar
            SVProgressHUD.dismiss()
            
            // Analizamos la respuesta del servidor
            switch response {
            case .success(let user):
                
                // Creamos la session de usuario
                let session = SessionManager()
                let result = session.createSession(email, password, user.token)
                
                if result {
                    session.loadSessionData()
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
                else {
                    NotificationBanner(title: "ERROR", subtitle: "¡Lo sentimos! se presento un error: Error al crear la sesión.", style: .danger).show()
                }
                
                self.performSegue(withIdentifier: "showHome", sender: nil)
            case .error(let error):
                NotificationBanner(title: "ERROR", subtitle: "¡Lo sentimos! se presento un Error: \(error.localizedDescription)", style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "ERROR", subtitle: entity.error, style: .warning).show()
            }
        }
    }
}
