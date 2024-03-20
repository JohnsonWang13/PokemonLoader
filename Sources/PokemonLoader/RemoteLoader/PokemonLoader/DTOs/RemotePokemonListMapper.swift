//
//  RemotePokemonListMapper.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import Foundation

class RemotePokemonListMapper {
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> RemotePokemonList {
        guard response.statusCode == 200 else {
            throw LoaderError.invalidData
        }
        
        return try JSONDecoder().decode(RemotePokemonList.self, from: data)
    }
}
