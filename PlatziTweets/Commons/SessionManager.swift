//
//  Constants.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 25/02/22.
//

import Foundation
import KeychainSwift
import Simple_Networking

class SessionManager {
    
    let keychain = KeychainSwift()
    
    func createSession(_ email: String, _ password: String, _ token: String) -> Bool {
        // Almacenamos las credenciales del usuario en  memoria
        var flag = true
        
        // Limpiamos la sesion actual
        keychain.clear()
        
        // Preparamos los datos a guardar
        let data = [
            Keys.emailKey : email,
            Keys.passwordKey : password,
            Keys.tokenKey : token
        ]
        
        // Guardamos las credenciales en memoria
        for item in data {
            flag = keychain.set(item.value, forKey: item.key)
            
            // Verificamos que no se presente ningun error
            if !flag {
                keychain.clear()
                break
            }
        }
        
        return flag
    }
    
    func checkSession() -> Bool {
        return (keychain.get(Keys.emailKey) != nil && keychain.get(Keys.tokenKey) != nil)
    }
    
    func signOut() {
        keychain.clear()
    }
    
    func loadSessionData() {
        if let token: String = keychain.get(Keys.tokenKey), checkSession() {
            SimpleNetworking.setAuthenticationHeader(prefix: "", token: token)
        }
    }
}
