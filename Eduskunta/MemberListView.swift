//
//  MemberListView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

struct MemberListView: View {
    let members: [Member]
    let party: String
    
    var body: some View {
        List(members) { member in
            NavigationLink {
                MemberDetailView(member: member)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(member.first) \(member.last)")
                    Text("\(member.constituency)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(party)
    }
}

extension Member {
    static var previewList: [Member] {
        [
            Member(
                personNumber: 1,
                seatNumber: 10,
                last: "Sarkomaa",
                first: "Sari",
                party: "Kok",
                minister: false,
                twitter: "",
                bornYear: 1980,
                constituency: "Helsinki"
            ),
            
            Member(
                personNumber: 2,
                seatNumber: 20,
                last: "Pekka",
                first: "Haavisto",
                party: "Vihr",
                minister: false,
                twitter: "",
                bornYear: 1990,
                constituency: "Uusimaa"
            )
        ]
    }
}

#Preview {
    MemberListView(members: Member.previewList, party:  "Kok")
}
