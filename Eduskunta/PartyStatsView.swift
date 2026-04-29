//
//  PartyStatsView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 25.4.2026.
//

import SwiftUI
import SwiftData

// Displays aggregated like/dislike statistics per party,
// sorted by net rating (likes minus dislikes).
struct PartyStatsView: View {
    // All parliament members passed in from the parent view.
    let allMembers: [Member]
    
    // All notes from SwiftData, used to calculate per-party ratings.
    // Automatically updates the view when notes are added or deleted.
    @Query private var allNotes: [MemberNote]
    
    // A computed summary of likes, dislikes, and net rating for a single party.
    private struct PartyStat: Identifiable {
        let id = UUID()
        let party: String
        let likes: Int
        let dislikes: Int
        var net: Int { likes - dislikes }
    }
    
    // Computes stats for each party, sorted by net rating descending.
    private var stats: [PartyStat] {
        let parties = Array(Set(allMembers.map { $0.party })).sorted()
        return parties.map { party in
            // Get all members belonging to this party
            let partyMembers = allMembers.filter { $0.party == party }
            // Get all notes written for this party's members
            let partyNotes = allNotes.filter { note in
                partyMembers.contains { $0.personNumber == note.memberPersonNumber }
            }
            return PartyStat(
                party: party,
                likes: partyNotes.filter { $0.isPositive }.count,
                dislikes: partyNotes.filter { !$0.isPositive }.count
            )
            
        }
        .sorted { $0.net > $1.net } // Best rated party first
    }
    
    var body: some View {
        List(stats) { stat in
            // Tapping a party navigates to its member list
            NavigationLink {
                MemberListView(
                    members: allMembers.filter { $0.party == stat.party },
                    party: stat.party.capitalized
                )
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    // Party name
                    Text(stat.party.capitalized)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    HStack {
                        // Like count
                        HStack(spacing: 2) {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundStyle(.green)
                                .imageScale(.small)
                            Text("\(stat.likes)")
                                .foregroundStyle(.green)
                        }
                        .font(.caption.bold())
                        
                        HStack(spacing: 2) {
                            // Dislike count
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundStyle(.red)
                                .imageScale(.small)
                            Text("\(stat.dislikes)")
                                .foregroundStyle(.red)
                        }
                        .font(.caption.bold())
                        
                        Spacer()
                        // Net score — green if positive, red if negative, gray if zero
                        let net = stat.net
                        Text(net >= 0 ? "+\(net)" : "\(net)")
                            .font(.headline)
                            .foregroundStyle(net > 0 ? .green : net < 0 ? .red : .secondary)
                    }
                    // Like/dislike proportion bar
                    // Green fills proportionally based on likes vs total
                    GeometryReader { geo in
                        let total = stat.likes + stat.dislikes
                        let likeWidth = total > 0 ? CGFloat(stat.likes) / CGFloat(total) * geo.size.width : 0
                        
                        ZStack(alignment: .leading) {
                            // Background — red tint or gray if no ratings
                            RoundedRectangle(cornerRadius: 4)
                                .fill(total == 0 ? Color.gray.opacity(0.3) : Color.red.opacity(0.3))
                                .frame(height: 8)
                            // Foreground — green fill proportional to likes
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
            // Shown when no notes exist yet
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
