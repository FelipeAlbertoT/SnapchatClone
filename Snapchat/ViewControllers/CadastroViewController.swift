//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by 5A Nucleo Desenvolvimento on 21/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import Firebase

class CadastroViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textNome: UITextField!
    @IBOutlet weak var textSenha: UITextField!
    @IBOutlet weak var textConfirmarSenha: UITextField!
    
    let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func cadastrar(_ sender: Any) {
        if validarFormulario() {
            
            Auth.auth().createUser(withEmail: textEmail.text!, password: textSenha.text!, completion: { (usuario, error) in
                if error == nil {
                    if usuario == nil {
                        self.exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação, tente novamente!")
                    } else {
                        let usuarios = self.database.child("usuarios")
                        
                        let usuarioDados = [ "nome": self.textNome.text!, "email": self.textEmail.text!]
                        usuarios.child(usuario!.uid).setValue(usuarioDados)
                        
                        self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                    }
                } else {
                    let erro = error! as NSError
                    if let errorName = erro.userInfo["error_name"] {
                        switch errorName as! String {
                        case "ERROR_INVALID_EMAIL":
                            self.exibirMensagem(titulo: "Dados inválidos", mensagem: "Informe um e-mail válido!")
                            break
                        case "ERROR_WEAK_PASSWORD":
                            self.exibirMensagem(titulo: "Dados inválidos", mensagem: "Informe uma senha mais forte!")
                            break
                        case "ERROR_EMAIL_ALREADY_IN_USE":
                            self.exibirMensagem(titulo: "Dados inválidos", mensagem: "O e-mail informado já está sendo utilizado!")
                            break
                        default:
                            self.exibirMensagem(titulo: "Dados inválidos", mensagem: "Ocorreu um erro ao cadastrar a conta!")
                            break
                        }
                    }
                }
            })
        }
    }
    
    func validarFormulario() -> Bool {
        if let nome = textNome.text {
            if nome != "" {
                if validarSenha() {
                    return true
                } else {
                    self.exibirMensagem(titulo: "Dados inválidos", mensagem: "As senhas não são iguais, digite novamente")
                    return false
                }
            } else {
                self.exibirMensagem(titulo: "Dados inválidos", mensagem: "Preencha o campo Nome Completo!")
                return false
            }
        } else {
            self.exibirMensagem(titulo: "Dados inválidos", mensagem: "Preencha o campo Nome Completo!")
            return false
        }
    }
    
    func validarSenha() -> Bool {
        guard let senha = textSenha.text else { return false }
        guard let confirmarSenha = textConfirmarSenha.text else { return false }
        
        if senha == confirmarSenha {
            return true
        }
        return false
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        let alerta = Alerta(titulo: titulo, mensagem: mensagem)
        
        self.present(alerta.getAlerta(), animated: true, completion: nil)
    }
}
