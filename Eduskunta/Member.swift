//
//  Member.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftData

@Model
class Member {
    @Attribute(.unique) var personNumber: Int
    var seatNumber: Int
    var last: String
    var first: String
    var party: String
    var minister: Bool
    var twitter: String
    var bornYear: Int
    var constituency: String

    var ratings: [Rating] = []   // Relationship

    init(personNumber: Int,
         seatNumber: Int,
         last: String,
         first: String,
         party: String,
         minister: Bool,
         twitter: String,
         bornYear: Int,
         constituency: String) {

        self.personNumber = personNumber
        self.seatNumber = seatNumber
        self.last = last
        self.first = first
        self.party = party
        self.minister = minister
        self.twitter = twitter
        self.bornYear = bornYear
        self.constituency = constituency
    }
}
