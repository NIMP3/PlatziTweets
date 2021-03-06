//
//  AppDelegate.swift
//  PlatziTweets
//
//  Created by Centro de Informática on 17/01/22.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        loadUI()
        
        return true
    }
    
    private func loadUI() {
        let session = SessionManager()
        session.loadSessionData()
        let nameViewController = session.checkSession() ? "Home" : "Welcome"
        
        let viewController = UIStoryboard(name: nameViewController, bundle: Bundle.main).instantiateInitialViewController()
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

