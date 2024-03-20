//
//  RemotePokemonLoader.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import Foundation
import Network

public class RemotePokemonLoader: PokemonLoader {
    public let client: Network.HTTPClient
    
    public required init(client: Network.HTTPClient) {
        self.client = client
    }
    
    public func loadPokemonList(offset: Int, limit: Int, completion: @escaping (LoaderResult<PokemonList>) -> Void) {
        client.request(with: PokemonListRequest(offset: offset, limit: limit)) { result in
            switch result {
            case let .success(data, response):
                if let pokemonList = try? RemotePokemonListMapper.map(data, response) {
                    completion(.success(pokemonList.pokemonList))
                } else {
                    completion(.failure(LoaderError.invalidData))
                }
            case .failure:
                completion(.failure(LoaderError.connectivity))
            }
        }
    }
    
    public func loadPokemonDetail(url: URL, completion: @escaping (LoaderResult<PokemonDetail>) -> Void) {
        client.request(with: PokemonDetailRequest(url: url)) { result in
            switch result {
            case let .success(data, response):
                if let pokemonDetail = try? RemotePokemonDetailMapper.map(data, response) {
                    completion(.success(pokemonDetail.pokemonDetail))
                } else {
                    completion(.failure(LoaderError.invalidData))
                }
            case .failure:
                completion(.failure(LoaderError.connectivity))
            }
        }
    }
    
    public func loadPokemonSpecies(url: URL, completion: @escaping (LoaderResult<PokemonSpecies>) -> Void) {
        client.request(with: PokemonSpeciesRequest(url: url)) { result in
            switch result {
            case let .success(data, response):
                if let pokemonSpecies = try? PokemonSpeciesMapper.map(data, response) {
                    completion(.success(pokemonSpecies.species))
                } else {
                    completion(.failure(LoaderError.invalidData))
                }
            case .failure:
                completion(.failure(LoaderError.connectivity))
            }
        }
    }
}

private extension RemotePokemonList {
    var pokemonList: PokemonList {
        PokemonList(next: URL(string: next ?? ""),
                    previous: URL(string: previous ?? ""),
                    pokemonItems: results.map { PokemonItem(name: $0.name, url: $0.url) })
    }
}

private extension RemotePokemonDetail {
    var pokemonDetail: PokemonDetail {
        let stats = PokemonDetail.Stats(hp: stats.hp,
                                        attack: stats.attack,
                                        defense: stats.defense,
                                        specialAttack: stats.specialAttack,
                                        specialDefense: stats.specialDefense,
                                        speed: stats.speed)
        return PokemonDetail(id: id,
                             name: name,
                             types: types,
                             thumbnailImageURL: thumbnailImageURL,
                             stats: stats,
                             speciesURL: speciesURL)
    }
}

private extension RemotePokemonSpecies {
    var species: PokemonSpecies {
        return PokemonSpecies(id: id, description: description, evolutionChainURL: evolutionChainURL)
    }
}
