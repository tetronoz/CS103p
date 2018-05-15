//
//  Card.swift
//  Concentration
//
//  Created by Sergey Tolmachev on 11/05/2018.
//  Copyright © 2018 Sergey Tolmachev. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var isSeen = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqIdentifier()
    }
}
