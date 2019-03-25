//
//  NoteRange.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 17.03.19.
//

import Foundation

public struct NoteRange {

    let lowerRange: Note
    let upperRange: Note
    let lowerIndex: Int
    let upperIndex: Int

    public init(lowerRange: Note, upperRange: Note) {
        self.lowerRange = lowerRange
        self.upperRange = upperRange
        self.lowerIndex = lowerRange.index
        self.upperIndex = upperRange.index
    }

    public func getRandomNoteInRange() -> Note {
        let random = Int.random(in: lowerIndex + 2...upperIndex - 3)
        return try! Note.init(index: random)
    }

    public func getRandomNoteForHarmonicInRange() -> Note {
        // TODO: Implement!
        let random = Int.random(in: lowerIndex + 2...upperIndex - 7)
        return try! Note.init(index: random)
    }

    public func getRandomSequenceInRange() -> [Note] {
        let random = Int.random(in: lowerIndex + 3...upperIndex - 4)

        let firstNote = try! Note(index: random)
        let secondNote = try! firstNote.higher()
        let thirdNote = try! secondNote.lower()

        return [firstNote, secondNote, thirdNote]
    }

    public func getRandomMusicScale() -> [Note] {
        let random = Int.random(in: lowerIndex + 4...upperIndex - 4 )

        let firstNote = try! Note(index: random)
        let secondNote = try! firstNote.higher()
        let thirdNote = try! secondNote.higher()

        return [firstNote, secondNote, thirdNote]
    }

    public func getMiddleNoteFromRange() -> Note {
        let castLowerIndex = Double(self.lowerIndex)
        let caseUpperIndex = Double(self.upperIndex)

        let mean = ((castLowerIndex + caseUpperIndex) / 2).rounded()
        let note = try! Note(index: Int(mean))

        return note
    }

    public func contains(note: Note) -> Bool {
        if(note.index > self.upperIndex || note.index < self.lowerIndex) {
            return false
        }

        return true
    }
}
