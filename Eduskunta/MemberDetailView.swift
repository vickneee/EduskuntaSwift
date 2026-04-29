//
//  MemberDetailView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

// Displays detailed information about a parliament member,
// including their photo, personal info, and user-written notes.
struct MemberDetailView: View {
    // The member whose details are displayed.
    let member: Member
    
    // SwiftData context used to insert and delete notes.
    @Environment(\.modelContext) private var modelContext
    // All notes in the database — filtered by member in `memberNotes`.
    @Query private var allNotes: [MemberNote]
    // The current text in the note input field.
    @State private var noteText = ""
    // The note currently being edited, or `nil` if creating a new one.
    @State private var editingNote: MemberNote? = nil
    // Whether the note being written is positive (`true`) or negative (`false`).
    @State private var isPositive = true
    
    // Notes belonging only to this member, filtered from all notes.
    var memberNotes: [MemberNote] {
        allNotes.filter { $0.memberPersonNumber == member.personNumber }
    }
    
    // Formats note dates as "yyyy-MM-dd" for display.
    var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    // Constructs the remote URL for the member's profile picture.
    // Returns `nil` if the URL string is malformed.
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
            
            // Member info section
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
            
            // Notes section — create, edit, and delete notes
            VStack(alignment: .leading, spacing: 12) {
                Text("Lisää muistiinpano")
                    .fontWeight(.bold)
                
                TextField("Muistiinpano", text: $noteText)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                
                HStack {
                    // Like button
                    Button {
                        isPositive = true
                    } label: {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(isPositive ? Color.green : Color.green.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    // Dislike button
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
                    
                    // Saves a new note or updates the note being edited.
                    Button(editingNote == nil ? "Tallenna" : "Päivitä") {
                        guard !noteText.isEmpty else { return }
                        
                        if let editing = editingNote {
                            // Update existing note in place
                            editing.text = noteText
                            editing.isPositive = isPositive
                            editingNote = nil
                        } else {
                            // Insert new note into SwiftData
                            let note = MemberNote(
                                memberPersonNumber: member.personNumber,
                                text: noteText,
                                isPositive: isPositive
                            )
                            modelContext.insert(note)
                        }
                        // Reset input fields after save
                        noteText = ""
                        isPositive = true
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.parliamentBlue)
                    .clipShape(Capsule())
                }
                
                // List of existing notes, sorted newest first
                if !memberNotes.isEmpty {
                    ForEach(memberNotes.sorted { $0.date > $1.date }) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: note.isPositive ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                                    .foregroundStyle(note.isPositive ? .green : .red)
                                
                                // Formatted creation date
                                Text(dateFormatter.string(from: note.date))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                // Loads note into input fields for editing
                                Button {
                                    editingNote = note
                                    noteText = note.text
                                    isPositive = note.isPositive
                                } label: {
                                    Image(systemName: "pencil")
                                        .foregroundStyle(.blue)
                                        .imageScale(.medium)
                                }
                                // Permanently deletes this note from SwiftData
                                Button(role: .destructive) {
                                    modelContext.delete(note)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                        .imageScale(.small)
                                }
                            }
                            Text(note.text)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        // Highlights the note currently being edited
                        .background(editingNote?.id == note.id ? Color.blue.opacity(0.1) : Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    // Swipe-to-delete support
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

// Preview extension
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
