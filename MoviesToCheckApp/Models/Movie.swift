//
//  Movie.swift
//  MoviesToCheckApp
//
//  Created by Luana Chen Chih Jun on 16/09/20.
//  Copyright © 2020 Chen. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: UUID?
    var title: String
    
    private enum MovieKeys: String, CodingKey {
        case id
        case title
    }
}

extension Movie {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }
}
