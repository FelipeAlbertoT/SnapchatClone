//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by 5A Nucleo Desenvolvimento on 21/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let database = Database.database().reference()
    
    var snaps: [Snap] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uidUsuarioLogado = Auth.auth().currentUser?.uid {
            
            let usuarios = database.child("usuarios")
            let snapsNode = usuarios.child(uidUsuarioLogado).child("snaps")
            
            snapsNode.observe(.childAdded, with: { (snapshot) in
                let dados = snapshot.value as? NSDictionary
                
                let de = dados?["de"] as! String
                let descricao = dados?["descricao"] as! String
                let idImagem = dados?["idImagem"] as! String
                let nome = dados?["nome"] as! String
                let urlImagem = dados?["urlImagem"] as! String
                
                let snap = Snap(identificador: snapshot.key, de: de, descricao: descricao, idImagem: idImagem, nome: nome, urlImagem: urlImagem)
                
                self.snaps.append(snap)
                self.tableView.reloadData()
            })
            
            snapsNode.observe(.childRemoved, with: { (snapshot) in
                
                var indice = 0
                for snap in self.snaps {
                    if snap.identificador == snapshot.key {
                        self.snaps.remove(at: indice)
                    }
                    indice += 1
                }
                
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func sair(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Erro ao deslogar usuario")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.snaps.count == 0 {
            return 1
        }
        return self.snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        if self.snaps.count == 0 {
            cell.textLabel?.text = "Nenhum snap para vocÊ :) "
        } else {
            let snap = self.snaps[indexPath.row]
            cell.textLabel?.text = snap.nome
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.snaps.count > 0 {
            let snapSelecionado = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "detalhesSnapSegue", sender: snapSelecionado)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesSnapSegue" {
            let detalhesSnapViewController = segue.destination as! DetalhesSnapViewController
            
            detalhesSnapViewController.snap = sender as! Snap
        }
    }
    
}
