//
//  PartyStatsView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 25.4.2026.
//

import SwiftUI
import SwiftData

struct PartyStatsView: View {
    let allMembers: [Member]
    
    @Query private var allNotes: [MemberNote]
    
    // PartyStat Identifiable
    private struct PartyStat: Identifiable {
        let id = UUID()
        let party: String
        let likes: Int
        let dislikes: Int
        var net: Int { likes - dislikes }
    }
    
    private var stats: [PartyStat] {
        let parties = Array(Set(allMembers.map { $0.party })).sorted()
        return parties.map { party in
            let partyMembers = allMembers.filter { $0.party == party }
            let partyNotes = allNotes.filter { note in
                partyMembers.contains { $0.personNumber == note.memberPersonNumber }
            }
            return PartyStat(
                party: party,
                likes: partyNotes.filter { $0.isPositive }.count,
                dislikes: partyNotes.filter { !$0.isPositive }.count
            )
            
        }
        .sorted { $0.net > $1.net }
    }
    
    var body: some View {
        List(stats) { stat in
            NavigationLink {
                MemberListView(
                    members: allMembers.filter { $0.party == stat.party },
                    party: stat.party.capitalized
                )
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(stat.party.capitalized)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    HStack {
                        HStack(spacing: 2) {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundStyle(.green)
                                .imageScale(.small)
                            Text("\(stat.likes)")
                                .foregroundStyle(.green)
                        }
                        .font(.caption.bold())
                        
                        HStack(spacing: 2) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundStyle(.red)
                                .imageScale(.small)
                            Text("\(stat.dislikes)")
                                .foregroundStyle(.red)
                        }
                        .font(.caption.bold())
                        Spacer()
                        let net = stat.net
                        Text(net >= 0 ? "+\(net)" : "\(net)")
                            .font(.headline)
                            .foregroundStyle(net > 0 ? .green : net < 0 ? .red : .secondary)
                    }
                    // Progress bar
                    GeometryReader { geo in
                        let total = stat.likes + stat.dislikes
                        let likeWidth = total > 0 ? CGFloat(stat.likes) / CGFloat(total) * geo.size.width : 0
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(total == 0 ? Color.gray.opacity(0.3) : Color.red.opacity(0.3))
                                .frame(height: 8)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.green)
                                .frame(width: likeWidth, height: 8)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(.vertical, 2)
            }
            .navigationTitle("Puoluetilastot")
            .overlay {
                if allNotes.isEmpty {
                    ContentUnavailableView(
                        "Ei arvioita vielä",
                        systemImage: "chart.bar",
                        description: Text("Lisää muistiinpanoja edustajille nähdäksesi tilastot")
                    )
                }
            }
        }
    }
}


#Preview {
    PartyStatsView(allMembers: Member.previewList)
        .modelContainer(for: [Member.self, MemberNote.self], inMemory: true)
}
