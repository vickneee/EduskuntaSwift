//
//  MemberListView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

// Displays a filterable, searchable, and sortable list of parliament members
// belonging to a specific party.
struct MemberListView: View {
    // The members to display — pre-filtered by party from the parent view.
    let members: [Member]
    // The party name shown as the navigation title.
    let party: String
    
    // The currently selected constituency filter. Defaults to showing all.
    @State private var selectedConstituency: String = "Kaikki"
    // The active sort order. Defaults to sorting by net rating.
    @State private var sortOrder: SortOrder? = .rating
    // The current search query for filtering members by name.
    @State private var searchText: String = ""
    // All notes in the database, used to calculate per-member net ratings.
    @Query private var allNotes: [MemberNote]
    
    // All unique constituencies from the current member list, sorted alphabetically.
    private var constituencies: [String] {
        Array(Set(members.map { $0.constituency })).sorted()
    }
    
    // Calculates the net rating (likes minus dislikes) for a given member.
    // - Parameter member: The member to calculate the rating for.
    // - Returns: A positive or negative integer representing net value.
    private func netRating(for member: Member) -> Int {
        let notes = allNotes.filter { $0.memberPersonNumber == member.personNumber }
        let likes = notes.filter { $0.isPositive }.count
        let dislikes = notes.filter { !$0.isPositive }.count
        return likes - dislikes
    }
    
    // Members filtered by constituency and search text, then sorted by `sortOrder`.
    private var filteredMembers: [Member] {
        // Filter by selected constituency
        let filtered = selectedConstituency == "Kaikki"
        ? members
        : members.filter { $0.constituency == selectedConstituency }
        
        // Filter by search text (first or last name)
        let searched = searchText.isEmpty
        ? filtered
        : filtered.filter {
            $0.first.localizedCaseInsensitiveContains(searchText) ||
            $0.last.localizedCaseInsensitiveContains(searchText)
        }
        
        // Apply sort order
        switch sortOrder {
        case .rating:     return searched.sorted { netRating(for: $0) > netRating(for: $1) }
        case .firstName:  return searched.sorted { $0.first < $1.first }
        case .lastName:   return searched.sorted { $0.last < $1.last }
        case nil:         return searched
        }
    }
    
    var body: some View {
        // Filtered members
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
                    // Net rating badge — green for positive, red for negative
                    let net = netRating(for: member)
                    Label("\(net)", systemImage: net >= 0 ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                        .font(.caption.bold())
                        .foregroundStyle(net >= 0 ? .green : .red)
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Hae edustajaa")
        .navigationTitle(party)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Filter/sort menu — icon fills when a constituency filter is active
                Menu {
                    // Sort order options
                    Section("Järjestys") {
                        // Toggle rating sort — deselects if already active
                        Button {
                            sortOrder = sortOrder == .rating ? nil : .rating
                        } label: {
                            HStack {
                                Text("Paras arvio ensin")
                                Spacer()
                                if sortOrder == .rating {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        // Toggle first name sort
                        Button {
                            sortOrder = sortOrder == .firstName ? nil : .firstName
                        } label: {
                            HStack {
                                Text("Etunimi")
                                Spacer()
                                if sortOrder == .firstName {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        // Toggle last name sort
                        Button {
                            sortOrder = sortOrder == .lastName ? nil : .lastName
                        } label: {
                            HStack {
                                Text("Sukunimi")
                                Spacer()
                                if sortOrder == .lastName {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    
                    // Constituency filter options
                    Section("Vaalipiiri") {
                        // Reset to show all constituencies
                        Button { selectedConstituency = "Kaikki" } label: {
                            HStack {
                                Text("Kaikki")
                                Spacer()
                                if selectedConstituency == "Kaikki" {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        // One button per unique constituency
                        ForEach(constituencies, id: \.self) { constituency in
                            Button {
                                selectedConstituency = constituency
                            } label: {
                                HStack {
                                    Text(constituency)
                                    Spacer()
                                    if selectedConstituency == constituency {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    // Filled icon indicates an active constituency filter
                    Image(systemName: selectedConstituency != "Kaikki"
                          ? "line.3.horizontal.decrease.circle.fill"
                          : "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
}

// Defines the available sort orders for the member list.
enum SortOrder {
    case rating, firstName, lastName
}

// Preview extension
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
