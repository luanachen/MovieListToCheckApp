//
//  Review.swift
//  MoviesToCheckApp
//
//  Created by Luana Chen Chih Jun on 16/09/20.
//  Copyright © 2020 Chen. All rights reserved.
//

import Foundation

struct Review: Codable {
    var id: UUID?
    var title: String
    var body: String
    var movie: Movie?
}
