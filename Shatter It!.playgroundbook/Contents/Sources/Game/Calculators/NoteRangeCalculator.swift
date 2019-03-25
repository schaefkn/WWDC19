//
//  NoteRangeCalculator.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 17.03.19.
//

import Foundation

public class NoteRangeCalculator {
    private struct VoiceTypeMapper {
        // MARK: - Properties
        let noteRange: NoteRange

        // MARK: - Voice Types Mapped
        static var soprano: VoiceTypeMapper {
            let lowerNote = try! Note(letter: .C, octave: 4)
            let upperNote = try! Note(letter: .C, octave: 6)

            return VoiceTypeMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }

        static var mezzoSoprano: VoiceTypeMapper {
            let lowerNote = try! Note(letter: .A, octave: 3)
            let upperNote = try! Note(letter: .A, octave: 5)

            return VoiceTypeMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }

        static var contralto: VoiceTypeMapper {
            let lowerNote = try! Note(letter: .F, octave: 3)
            let upperNote = try! Note(letter: .F, octave: 5)

            return VoiceTypeMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }

        static var countertenor: VoiceTypeMapper {
            let lowerNote = try! Note(letter: .E, octave: 3)
            let upperNote = try! Note(letter: .E, octave: 5)

            return VoiceTypeMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }

        static var tenor: VoiceTypeMapper {
            let lowerNote = try! Note(letter: .C, octave: 3)
            let upperNote = try! Note(letter: .C, octave: 5)

            return VoiceTypeMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }

        static var baritone: VoiceTypeMapper {
            let lowerNote = try! Note(letter: .A, octave: 2)
            let upperNote = try! Note(letter: .A, octave: 4)

            return VoiceTypeMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }

        static var bass: VoiceTypeMapper {
            let lowerNote = try! Note(letter: .E, octave: 2)
            let upperNote = try! Note(letter: .E, octave: 4)

            return VoiceTypeMapper(noteRange: NoteRange(lowerRange: lowerNote, upperRange: upperNote))
        }
    }

    private init() { }

    public static func getNoteRangeFor(voiceType: VoiceType) -> NoteRange {
        switch voiceType {
        case .Soprano:
            return VoiceTypeMapper.soprano.noteRange
        case .MezzoSoprano:
            return VoiceTypeMapper.mezzoSoprano.noteRange
        case .Contralto:
            return VoiceTypeMapper.contralto.noteRange
        case .Countertenor:
            return VoiceTypeMapper.countertenor.noteRange
        case .Tenor:
            return VoiceTypeMapper.tenor.noteRange
        case .Baritone:
            return VoiceTypeMapper.baritone.noteRange
        case .Bass:
            return VoiceTypeMapper.baritone.noteRange
        }
    }
}
