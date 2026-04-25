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
    
    @State private var selectedConstituency: String = "Kaikki"
    @State private var sortOrder: SortOrder? = .rating
    @Query private var allNotes: [MemberNote]  // fetch all notes
    @State private var searchText: String = ""
    
    // All unique constituencies derived from the member list
    private var constituencies: [String] {
        Array(Set(members.map { $0.constituency })).sorted()
    }
    
    private func netRating(for member: Member) -> Int {
        let notes = allNotes.filter { $0.memberPersonNumber == member.personNumber }
        let likes = notes.filter { $0.isPositive }.count
        let dislikes = notes.filter { !$0.isPositive }.count
        return likes - dislikes
    }
    
    private var filteredMembers: [Member] {
        let filtered = selectedConstituency == "Kaikki"
        ? members
        : members.filter { $0.constituency == selectedConstituency }
        
        let searched = searchText.isEmpty
                ? filtered
                : filtered.filter {
                    $0.first.localizedCaseInsensitiveContains(searchText) ||
                    $0.last.localizedCaseInsensitiveContains(searchText)
                }
        
        switch sortOrder {
        case .rating:     return searched.sorted { netRating(for: $0) > netRating(for: $1) }
        case .firstName:  return searched.sorted { $0.first < $1.first }
        case .lastName:   return searched.sorted { $0.last < $1.last }
        case nil:         return searched
        }
    }
    
    var body: some View {
        List(filteredMembers) { member in
            NavigationLink {
                MemberDetailView(member: member)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(member.first) \(member.last)")
                        Text("\(member.constituency)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    
                    // Show net rating
                    let net = netRating(for: member)
                    Label("\(net)", systemImage: net >= 0 ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                        .font(.caption.bold())
                        .foregroundStyle(net >= 0 ? .green : .red)
                    
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Hae edustajaa")
        .navigationTitle(party)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    // Sort section
                    Section("Järjestys") {
                        Button {
                            sortOrder = sortOrder == .rating ? nil : .rating
                        } label: {
                            Label("Paras arvio ensin", systemImage: sortOrder == .rating ? "checkmark" : "")
                        }
                        Button {
                            sortOrder = sortOrder == .firstName ? nil : .firstName
                        } label: {
                            Label("Etunimi", systemImage: sortOrder == .firstName ? "checkmark" : "")
                        }
                        Button {
                            sortOrder = sortOrder == .lastName ? nil : .lastName
                        } label: {
                            Label("Sukunimi", systemImage: sortOrder == .lastName ? "checkmark" : "")
                        }
                    }
                    Section("Vaalipiiri") {
                        Button { selectedConstituency = "Kaikki" } label: {
                                Label("Kaikki", systemImage: selectedConstituency == "Kaikki" ? "checkmark" : "")
                            }
                            ForEach(constituencies, id: \.self) { constituency in
                                Button {
                                    selectedConstituency = constituency
                                } label: {
                                    Label(constituency, systemImage: selectedConstituency == constituency ? "checkmark" : "")
                                }
                            }
                    }
                } label: {
                    Image(systemName: selectedConstituency != "Kaikki"
                          ? "line.3.horizontal.decrease.circle.fill"
                          : "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
}

enum SortOrder {
    case rating, firstName, lastName
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
