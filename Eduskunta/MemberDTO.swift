//
//  MemberDTO.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import Foundation

// Decodable is a Swift protocol that lets a type be automatically decoded from external data (like JSON).
/*
 {
   "personNumber": 42,
   "seatNumber": 7,
   "last": "Smith",
   "first": "John",
   "party": "Example",
   "minister": false,
   "twitter": null,
   "bornYear": 1975,
   "constituency": "Helsinki"
 }
 */
struct MemberDTO: Decodable {
    let personNumber: Int
    let seatNumber: Int
    let last: String
    let first: String
    let party: String
    let minister: Bool
    let twitter: String?
    let bornYear: Int
    let constituency: String
}

// Converts this DTO into a domain `Member` model.

// Use this after decoding JSON to get a type suitable for use in the app's business logic.
// - Returns: A `Member` instance populated with the receiver's properties.
// - Note: `twitter` defaults to an empty string when `nil`, as the model requires a non-optional value.
// JSON → MemberDTO (Decodable) → .toModel() → Member (used in app)
extension MemberDTO {
    func toModel() -> Member {
        Member(
            personNumber: personNumber,
            seatNumber: seatNumber,
            last: last,
            first: first,
            party: party,
            minister: minister,
            twitter: twitter ?? "", // Can be nil empty
            bornYear: bornYear,
            constituency: constituency
        )
    }
}
