//
//  Concentration.swift
//  Concentration
//
//  Created by Sergey Tolmachev on 11/05/2018.
//  Copyright © 2018 Sergey Tolmachev. All rights reserved.
//

import Foundation

public extension Collection {
    func shuffled() -> [Iterator.Element] {
        var array = Array(self)
        array.shuffle()
        return array
    }
}

public extension MutableCollection {
    mutating func shuffle() {
        var i = startIndex
        var n = count
        
        while n > 1 {
            let j = index(i, offsetBy: Int(arc4random_uniform(UInt32(n))))
            swapAt(i, j)
            formIndex(after: &i)
            n -= 1
        }
    }
}

class Concentration {
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    var flipCount = 0
    var scoreCount = 0
    
    //let allAvailableThemes = ["Halloween", "Faces", "Animals"]
    
    func chooseCard(at index: Int) {
        self.flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    self.scoreCount += 2
                } else {
                    if cards[index].isSeen {
                        self.scoreCount -= 1
                    }
                    if cards[matchIndex].isSeen {
                        self.scoreCount -= 1
                    }
                }
                
                cards[index].isFaceUp = true
                cards[index].isSeen = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                //either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                //cards[index].isSeen = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
