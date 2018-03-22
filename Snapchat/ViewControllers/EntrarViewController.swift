//
//  EntrarViewController.swift
//  Snapchat
//
//  Created by 5A Nucleo Desenvolvimento on 21/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import Firebase

class EntrarViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textSenha: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func entrar(_ sender: Any) {
        guard let email = textEmail.text else { return }
        guard let senha = textSenha.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: senha) { (usuario, error) in
            if error == nil {
                if usuario == nil {
                   self.exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação, tente novamente")
                } else {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            } else {
                self.exibirMensagem(titulo: "Dados incorretos", mensagem: "Verifique os dados  digitados e tente novamente")
            }
        }
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        let alerta = Alerta(titulo: titulo, mensagem: mensagem)
        
        self.present(alerta.getAlerta(), animated: true, completion: nil)
    }
}
