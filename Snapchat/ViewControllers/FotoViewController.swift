//
//  FotoViewController.swift
//  Snapchat
//
//  Created by 5A Nucleo Desenvolvimento on 21/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import Firebase

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var textDescricao: UITextField!
    @IBOutlet weak var botaoProximo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        botaoProximo.isEnabled = false
//        botaoProximo.backgroundColor = UIColor.gray
        botaoProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 0.4)
    }

    @IBAction func selecionarImagem(_ sender: Any) {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imagemEscolhida = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imagem.image = imagemEscolhida
        
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proximoPasso(_ sender: Any) {
        self.botaoProximo.isEnabled = false
        self.botaoProximo.setTitle("Carregando...", for: .normal)
        
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        
        if let imagemSelecionada = imagem.image {
            if let imagemDados = UIImageJPEGRepresentation(imagemSelecionada, 0.1) {
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil, completion: { (metaDados, error) in
                    
                    if error == nil {
                        
                        let url = metaDados?.downloadURL()?.absoluteString
                        self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: url)
                        
                        self.botaoProximo.isEnabled = true
                        self.botaoProximo.setTitle("Próximo", for: .normal)
                        
                    } else {
                        print("Erro ao fazer o upload do arquivo")
                        let alerta = Alerta(titulo: "Upload falhou", mensagem: "Erro ao salvar o arquivo, tente novamente!")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                    
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue"{
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            
            usuarioViewController.descricao = self.textDescricao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = idImagem
        }
    }
    
}
