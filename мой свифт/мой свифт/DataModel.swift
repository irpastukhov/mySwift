//
//  dataModel.swift
//  мой свифт
//
//  Created by Ivan Pastukhov on 06.10.2022.
//

import Foundation

struct DataModel: Codable {
    let date: String
    var time = [String]()
    var hours = [String]()
    var hoursSum: Float
}
