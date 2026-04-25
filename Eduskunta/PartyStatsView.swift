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
            VStack {
                Text(stat.party.capitalized)
                    .font(.headline)
                
                HStack {
                    HStack(spacing: 16) {
                        Label("\(stat.likes)", systemImage: "hand.thumbsup.fill")
                            .foregroundStyle(.green)
                        Label("\(stat.dislikes)", systemImage: "hand.thumbsdown.fill")
                            .foregroundStyle(.red)
                        Spacer()
                        let net = stat.net
                        Text(net >= 0 ? "+\(net)" : "\(net)")
                            .font(.headline)
                            .foregroundStyle(net > 0 ? .green : net < 0 ? .red : .secondary)
                    }
                    .font(.subheadline.bold())
                    // Progress bar
                    GeometryReader { geo in
                        let total = stat.likes + stat.dislikes
                        let likeWidth = total > 0 ? CGFloat(stat.likes) / CGFloat(total) * geo.size.width : 0
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red.opacity(0.3))
                                .frame(height: 8)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.green)
                                .frame(width: likeWidth, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.vertical, 6)
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
