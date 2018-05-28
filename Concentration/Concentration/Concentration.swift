//
//  Concentration.swift
//  Concentration
//
//  Created by Sergey Tolmachev on 11/05/2018.
//  Copyright © 2018 Sergey Tolmachev. All rights reserved.
//

import Foundation


// Copied extensions from https://github.com/apple/example-package-fisheryates

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
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            //return faceUpCardIndicies.count == 1 ? faceUpCardIndicies.first : nil
//            var indexOfFaceUpCard: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if indexOfFaceUpCard == nil {
//                        indexOfFaceUpCard = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return indexOfFaceUpCard
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    private(set) var scoreCount = 0
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concenration.chooseCard(at: \(index)): chosen index is not in the cards")
        self.flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex] == cards[index] {
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
                    cards[index].isSeen = true
                }
                
                cards[index].isFaceUp = true
                
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concenration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
