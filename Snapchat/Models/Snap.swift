//
//  Snap.swift
//  Snapchat
//
//  Created by 5A Nucleo Desenvolvimento on 21/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import Foundation

class Snap {
    
    let identificador: String
    let de: String
    let descricao: String
    let idImagem: String
    let nome: String
    let urlImagem: String
    
    init(identificador: String, de: String, descricao: String, idImagem: String, nome: String, urlImagem: String) {
        self.identificador = identificador
        self.de = de
        self.descricao = descricao
        self.idImagem = idImagem
        self.nome = nome
        self.urlImagem = urlImagem
    }
    
}
