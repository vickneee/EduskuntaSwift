//
//  Rating.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftData

/*
A persistent SwiftData model representing a user's rating of a parliament member.

Each rating belongs to one `Member` via the `member` relationship.
The inverse relationship (`Member.ratings`) is managed automatically by SwiftData.
 */
@Model
class Rating {
    // Whether the rating is positive (`true`) or negative (`false`).
    var isPositive: Bool
    // An optional written comment accompanying the rating.
    var comment: String

    // The member this rating belongs to.
    // Optional because SwiftData may nullify this if the member is deleted.
    var member: Member?   // Relation back

    /* Creates a new rating linked to a parliament member.
    
     - Parameters:
        - isPositive: `true` for a positive rating, `false` for negative.
        - comment: A written comment about the member.
        - member: The member being rated, or `nil` if not yet assigned.
     */
    init(isPositive: Bool, comment: String, member: Member?) {
        self.isPositive = isPositive
        self.comment = comment
        self.member = member
    }
}
