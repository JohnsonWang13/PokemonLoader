//
//  PokemonDetailMapper.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import Foundation

class RemotePokemonDetailMapper {
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> RemotePokemonDetail {
        guard response.statusCode == 200 else {
            throw LoaderError.invalidData
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw LoaderError.invalidData
        }
        
        return RemotePokemonDetail(json: json)
    }
}
