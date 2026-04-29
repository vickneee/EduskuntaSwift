//
//  PartiesView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

/*
Displays all parliament parties as a navigable list.

On first load, fetches members from the remote API and saves
 any new entries to the local SwiftData database.
*/
struct PartiesView: View {
    // SwiftData context used to insert new members into the database.
    @Environment(\.modelContext) private var modelContext
    // All members stored in the local SwiftData database.
    @Query var members: [Member]
    // Prevents re-fetching data on every view appearance.
    @State private var didLoad = false
    
    var body: some View {
        NavigationStack {
            // One row per party, navigates to that party's member list
            List {
                ForEach(groupedParties.keys.sorted(), id: \.self) { party in
                    NavigationLink(party.capitalized) {
                        MemberListView(
                            members: groupedParties[party] ?? [],
                            party: party.capitalized
                        )
                    }
                }
            }
            
            .navigationTitle("Puolueet")
            // Fetch from API once when the view first appears
            .task {
                if !didLoad {
                        await loadData()
                        didLoad = true
                }
            }
        }
    }
    // Members grouped by their party name.
    var groupedParties: [String: [Member]] {
        Dictionary(grouping: members, by: { $0.party })
    }
    // Fetches members from the remote JSON API and inserts any new ones into SwiftData.
    //
    // Skips members that already exist in the database (checked by `personNumber`)
    // to avoid duplicates on subsequent launches.
    func loadData() async {
        do {
            let dtos = try await fetchMembers()
            for dto in dtos {
                let exists = members.contains { $0.personNumber == dto.personNumber }
                if !exists {
                    modelContext.insert(dto.toModel())
                }
            }
        } catch {
            print("Error:", error)
        }
    }
}

#Preview {
    PartiesView()
        .modelContainer(for: Member.self, inMemory: true)
}
