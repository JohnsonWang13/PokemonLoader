//
//  HTTPURLResponse+StatusCode.swift
//  
//
//  Created by 王富生 on 2024/3/15.
//

import Foundation

public extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

