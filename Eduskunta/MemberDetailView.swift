//
//  MemberDetailView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

struct MemberDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allNotes: [MemberNote]
    @State private var noteText = ""
    @State private var isPositive = true
    let member: Member
    
    var memberNotes: [MemberNote] {
        allNotes.filter { $0.memberPersonNumber == member.personNumber }
    }
    
    // Date formatter
    var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    var pictureURL: URL? {
        URL(string: "https://users.metropolia.fi/~peterh/edustajakuvat/\(member.last)-\(member.first)-web-\(member.personNumber).jpg")
    }
    
    var body: some View {
        ScrollView {
            // Image stays centered
            AsyncImage(url: pictureURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 225, height: 350)
            .clipShape(Rectangle())
            .frame(maxWidth: .infinity) // ← centers the image
            
            // Info section — same width as notes
            VStack(alignment: .leading, spacing: 10) {
                Text("\(member.first) \(member.last)")
                    .font(.title)
                Text("Istumapaikka: \(member.seatNumber)")
                Text("Puolue: \(member.party.capitalized)")
                Text("Vaalipiiri: \(member.constituency)")
                Text("Syntynyt: \(String(member.bornYear))")
                HStack {
                    Text("Ministeri:")
                    Image(systemName: member.minister ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(member.minister ? .green : .red)
                }
                if !member.twitter.isEmpty {
                    Text("Twitter: \(member.twitter)")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // ← left-aligned, full width
            .padding(.horizontal, 50)
            .padding(.bottom, 20)
            .navigationTitle("\(member.first) \(member.last)")
            
            // Notes section
            VStack(alignment: .leading, spacing: 12) {
                Text("Lisää muistiinpano")
                    .fontWeight(.bold)
                
                TextField("Muistiinpano", text: $noteText)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                
                HStack {
                    // + button
                    Button {
                        isPositive = true
                    } label: {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(isPositive ? Color.green : Color.green.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    // - button
                    Button {
                        isPositive = false
                    } label: {
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(!isPositive ? Color.red : Color.red.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Save button
                    Button("Tallenna") {
                        guard !noteText.isEmpty else { return }
                        let note = MemberNote(
                            memberPersonNumber: member.personNumber,
                            text: noteText,
                            isPositive: isPositive
                        )
                        modelContext.insert(note)
                        noteText = ""
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.parliamentBlue)
                    .clipShape(Capsule())
                }
                
                if !memberNotes.isEmpty {
                    ForEach(memberNotes.sorted { $0.date > $1.date }) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: note.isPositive ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                                    .foregroundStyle(note.isPositive ? .green : .red)
                                Text(dateFormatter.string(from: note.date))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                // Delete button
                                Button(role: .destructive) {
                                    modelContext.delete(note)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                            }
                            Text(note.text)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(memberNotes[index])
                        }
                    }
                }
            }
            .padding(.leading, 50)
            .padding(.trailing, 50)
            .padding(.bottom, 30)
        }
    }
}

extension Member {
    static var preview: Member {
        Member(
            personNumber: 1,
            seatNumber: 10,
            last: "Puu",
            first: "Anna",
            party: "ABC",
            minister: false,
            twitter: "",
            bornYear: 1985,
            constituency: "Uusimaa"
        )
    }
}

#Preview {
    MemberDetailView(member: Member.preview)
        .modelContainer(for: [Member.self, MemberNote.self], inMemory: true)
}
