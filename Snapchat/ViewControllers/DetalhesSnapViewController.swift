//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by 5A Nucleo Desenvolvimento on 21/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class DetalhesSnapViewController: UIViewController {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    var snap:Snap!
    let database = Database.database().reference()
    var tempo = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.descricao.text = "Carregando..."
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { (imagem, error, cache, url) in
            if error == nil {
                self.descricao.text = self.snap.descricao
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    
                    self.timer.text = String(self.tempo)
                    self.tempo -= 1
                    
                    if self.tempo == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let snaps = database.child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps")
        snaps.child(snap.identificador).removeValue()
        
        Storage.storage().reference().child("imagens").child("\(snap.idImagem).jpg").delete { (error) in
            if error != nil {
                print("Sucesso ao excluir a imagem")
            } else {
                
                print("Erro ao excluir a imagem")
            }
        }
    }

}
