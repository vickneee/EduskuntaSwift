//
//  PartiesView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

struct PartiesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var members: [Member]
    @State private var didLoad = false
    
    var body: some View {
        NavigationStack {
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
            .task {
                if !didLoad {
                        await loadData()
                        didLoad = true
                }
            }
        }
    }
    // group by party
    var groupedParties: [String: [Member]] {
        Dictionary(grouping: members, by: { $0.party })
    }
    // load JSON → save to SwiftData
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
