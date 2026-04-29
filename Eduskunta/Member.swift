//
//  Member.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftData

/*
A persistent SwiftData model representing a Finnish parliament member.

Members are fetched from the remote API, converted from `MemberDTO`,
and stored locally for offline access.
 */
@Model
class Member {
    // Unique identifier for the member. Prevents duplicate entries in the database.
    @Attribute(.unique) var personNumber: Int
    var seatNumber: Int
    var last: String
    var first: String
    var party: String
    var minister: Bool
    var twitter: String
    var bornYear: Int
    var constituency: String

    // The member's ratings given by the user.
    // SwiftData manages this one-to-many relationship automatically.
    var ratings: [Rating] = []

    /*
     Creates a new `Member` and stores it in the SwiftData database.

         - Parameters:
           - personNumber: Unique identifier. Must not duplicate an existing member.
           - seatNumber: Parliament seat number.
           - last: Last name.
           - first: First name.
           - party: Political party abbreviation.
           - minister: `true` if the member is currently a minister.
           - twitter: Twitter/X handle, or empty string if none.
           - bornYear: Year of birth.
           - constituency: Electoral constituency name.
     */
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
