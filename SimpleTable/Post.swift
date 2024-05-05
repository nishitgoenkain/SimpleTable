//
//  Product.swift
//  SimpleTable
//
//  Created by Nishit Goenka on 05/05/24.
//

import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
