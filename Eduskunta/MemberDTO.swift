//
//  MemberDTO.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import Foundation

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
