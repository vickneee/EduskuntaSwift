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
    
    // All unique constituencies derived from the member list
    private var constituencies: [String] {
        Array(Set(members.map { $0.constituency })).sorted()
    }
    
    @State private var selectedConstituency: String = "All"
    
    private var filteredMembers: [Member] {
        guard selectedConstituency != "All" else { return members }
        return members.filter { $0.constituency == selectedConstituency }
    }
    
    var body: some View {
        List(filteredMembers) { member in
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Constituency", selection: $selectedConstituency) {
                        Text("All").tag("All")
                        ForEach(constituencies, id: \.self) { constituency in
                            Text(constituency).tag(constituency)
                        }
                    }
                } label: {
                    Label("Filter", systemImage: selectedConstituency == "All"
                          ? "line.3.horizontal.decrease.circle"
                          : "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
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
