//
//  UsuariosTableViewController.swift
//  Snapchat
//
//  Created by 5A Nucleo Desenvolvimento on 21/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import Firebase

class UsuariosTableViewController: UITableViewController {

    let database = Database.database().reference()
    
    var usuarios: [Usuario] = []
    var urlImagem = ""
    var descricao = ""
    var idImagem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let usuarios = database.child("usuarios")
        
        usuarios.observe(DataEventType.childAdded) { (snapshot) in
            
            let dados = snapshot.value as? NSDictionary
            
            let usuario = Usuario(email: dados?["email"] as! String, nome: dados?["nome"] as! String, uid: snapshot.key)
            
            if Auth.auth().currentUser?.uid  != usuario.uid {
                self.usuarios.append(usuario)
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let usuario = self.usuarios[indexPath.row]
        
        cell.textLabel?.text = usuario.nome
        cell.detailTextLabel?.text = usuario.email

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let usuarioDestino = self.usuarios[indexPath.row]
        
        let usuarios = database.child("usuarios")
        let snaps = usuarios.child(usuarioDestino.uid).child("snaps")
        
        
        if let uidUsuarioLogado = Auth.auth().currentUser?.uid {
            let usuarioLogado = usuarios.child(uidUsuarioLogado)
            usuarioLogado.observeSingleEvent(of: .value, with: { (snapshot) in
                let dados = snapshot.value as? NSDictionary
                
                let snap = [
                    "de": dados?["email"] as! String,
                    "nome": dados?["nome"] as! String,
                    "descricao": self.descricao,
                    "urlImagem": self.urlImagem,
                    "idImagem": self.idImagem
                ]
                
                snaps.childByAutoId().setValue(snap)
                
                self.navigationController?.popToRootViewController(animated: true)
            })
            
        }
        
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
