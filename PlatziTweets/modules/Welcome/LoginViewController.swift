//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Centro de Informática on 25/01/22.
//

import UIKit
import NotificationBanner
import Simple_Networking
import SVProgressHUD

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
        
        // Creamos request
        let request = LoginRequest(email: email, password: password)
        
        // Iniciamos el progressbar
        SVProgressHUD.show()
        
        // Llamamos a la librería para la gestión de peticiones
        SN.post(endpoint: Endpoints.login, model: request) {(response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            // Detenemos el progressbar
            SVProgressHUD.dismiss()
            
            // Analizamos la respuesta del servidor
            switch response {
            case .success:
                self.performSegue(withIdentifier: "showHome", sender: nil)
            case .error(let error):
                NotificationBanner(title: "ERROR", subtitle: "¡Lo sentimos! se presento un error: \(error.localizedDescription)", style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "ERROR", subtitle: entity.error, style: .warning).show()
            }
        }
        
    }
}
