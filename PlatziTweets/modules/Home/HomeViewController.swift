//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 21/02/22.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBanner

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource: [Post] = []

    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()
    }

    //MARK: - Private methods
    private func setupUI() {
        // 1. Asignar datasource y delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // 2. Registrar celda
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPosts() {
        // Iniciamos el progressbar
        SVProgressHUD.show()
        
        // Configuramos y consumimos el servicio
        SN.get(endpoint: Endpoints.posts) { (response: SNResultWithEntity<[Post], ErrorResponse>) in
            // Detenemos el progressbar
            SVProgressHUD.dismiss()
            
            // Analizamos la respuesta del servidor
            switch response {
            case .success(let posts):
                self.dataSource = posts
                self.tableView.reloadData()
            case .error(let error):
                print("ERROR: \(error.localizedDescription)")
                NotificationBanner(title: "ERROR",
                                   subtitle: "¡Lo sentimos!, Se presento un error: \(error.localizedDescription)",
                                   style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "ERROR",
                                   subtitle: entity.error,
                                   style: .warning).show()
            }
        }
    }
    
    private func deletePostAt(indexPath: IndexPath) {
        // Iniciamos el progressbar
        SVProgressHUD.show()
        
        // Obtenemos el ID del post que vamos a borrar
        let postId = dataSource[indexPath.row].id
        
        // Creamos el endPoint
        let endPoint = Endpoints.posts + postId
        
        //Configuramos y consumimos el servicio
        SN.delete(endpoint: endPoint) { (response: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            // Detenemos el progressbar
            SVProgressHUD.dismiss()
            
            switch response {
            case .success:
                self.dataSource.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            case .error(let error):
                NotificationBanner(title: "ERROR", subtitle: "¡Lo sentimos! Se presento un error: \(error.localizedDescription)", style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "ERROR", subtitle: entity.error, style: .warning).show()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Numero total de celdas de la tabla
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configuramos la celda de tipo Tweet
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        
        // Cargamos los datos en las celdas de la tabla
        cell.setupCellWith(post: dataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") { _, _ in
            self.deletePostAt(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let email = SessionManager().getEmailSession() else { return false }
        print("EMAIL: \(email)")
        return dataSource[indexPath.row].author.email == email
    }
}
