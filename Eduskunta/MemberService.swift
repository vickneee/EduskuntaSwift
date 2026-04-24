//
//  MemberService.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import Foundation

func fetchMembers() async throws -> [MemberDTO] {
    guard let url = URL(string: "https://users.metropolia.fi/~peterh/mps.json") else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoded = try JSONDecoder().decode([MemberDTO].self, from: data)

    return decoded
}
