//
//  PokemonLoader.swift
//  
//
//  Created by 王富生 on 2024/3/17.
//

import Foundation

public protocol PokemonLoader {
    func loadPokemonList(offset: Int, limit: Int, completion: @escaping (LoaderResult<PokemonList>) -> Void)
    func loadPokemonDetail(url: URL, completion: @escaping (LoaderResult<PokemonDetail>) -> Void)
    func loadPokemonSpecies(url: URL, completion: @escaping (LoaderResult<PokemonSpecies>) -> Void)
}
