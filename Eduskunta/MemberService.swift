//
//  MemberService.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import Foundation

/*
Fetches the list of parliament members from the remote JSON endpoint.
 
- Returns: An array of `MemberDTO` objects decoded from the JSON response.
- Throws: `URLError(.badURL)` if the URL is invalid,
    or a decoding error if the JSON doesn't match `MemberDTO`.
*/
func fetchMembers() async throws -> [MemberDTO] {
    guard let url = URL(string: "https://users.metropolia.fi/~peterh/mps.json") else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoded = try JSONDecoder().decode([MemberDTO].self, from: data)

    return decoded
}
