//
//  VoiceTypeCalculator.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 23.03.19.
//

import Foundation

public class VoiceTypeCalculator {
    private struct NoteMapper {
        let noteRange: NoteRange

        static var soprano: NoteMapper {
            let lowerNote = try! Note(letter: .G, octave: 5)
            let higherNote = try! Note(letter: .C, octave: 6)

            return NoteMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: higherNote))
        }

        static var mezzoSoprano: NoteMapper {
            let lowerNote = try! Note(letter: .CSharp, octave: 5)
            let higherNote = try! Note(letter: .FSharp, octave: 5)

            return NoteMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: higherNote))
        }

        static var contralto: NoteMapper {
            let lowerNote = try! Note(letter: .G, octave: 4)
            let higherNote = try! Note(letter: .C, octave: 5)

            return NoteMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: higherNote))
        }

        static var countertenor: NoteMapper {
            let lowerNote = try! Note(letter: .CSharp, octave: 4)
            let higherNote = try! Note(letter: .FSharp, octave: 4)

            return NoteMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: higherNote))
        }

        static var tenor: NoteMapper {
            let lowerNote = try! Note(letter: .D, octave: 3)
            let higherNote = try! Note(letter: .C, octave: 4)

            return NoteMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: higherNote))
        }

        static var baritone: NoteMapper {
            let lowerNote = try! Note(letter: .DSharp, octave: 2)
            let higherNote = try! Note(letter: .CSharp, octave: 3)

            return NoteMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: higherNote))
        }

        static var bass: NoteMapper {
            let lowerNote = try! Note(letter: .E, octave: 2)
            let upperNote = try! Note(letter: .D, octave: 2)

            return NoteMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }
    }


    private init() { }

    public static func getVoiceTypeFrom(note: Note) -> VoiceType {
        if (NoteMapper.bass.noteRange.contains(note: note)) {
            return .Bass
        } else if (NoteMapper.baritone.noteRange.contains(note: note)) {
            return .Baritone
        } else if (NoteMapper.tenor.noteRange.contains(note: note)) {
            return .Tenor
        } else if (NoteMapper.contralto.noteRange.contains(note: note)) {
            return .Contralto
        } else if (NoteMapper.mezzoSoprano.noteRange.contains(note: note)) {
            return .MezzoSoprano
        } else if (NoteMapper.soprano.noteRange.contains(note: note)) {
            return .Soprano
        }

        return GameConfiguration.defaultVoiceType
    }
}
