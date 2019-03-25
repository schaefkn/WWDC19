//
//  PitchHitChecker.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 17.03.19.
//

import Foundation

public class PitchHitChecker {

    // MARK: - Properties
    private var notesHit = [Note]()
    private var countToHit = 0

    // MARK: - Initializers
    public init(difficulty: GameDifficulty) {
        self.countToHit = getCountToHit(from: difficulty)
    }

    // MARK: - Public Functions
    public func add(pitch: Pitch) {
        if(notesHit.count > countToHit) {
            notesHit.remove(at: 0)
        }
        notesHit.append(pitch.note)
    }

    public func checkHitOf(note: Note) -> Bool {
        if(notesHit.count < countToHit) {
            return false
        }

        for hittedNote in notesHit {
            if hittedNote.string != note.string {
                return false
            }
        }

        return true
    }

    public func getCurrentHittedNote() -> Note? {
        if(notesHit.count < countToHit) {
            return nil
        }

        for i in 1..<notesHit.count {
            if notesHit[i-1].index != notesHit[i].index {
                return nil
            }
        }

        return notesHit[1]
    }

    // MARK: - Private Helper Functions
    fileprivate func getCountToHit(from: GameDifficulty) -> Int {
        switch from {
        case .ExtraEasy:
            return GameConfiguration.pitchHitExtraEasy
        case .Easy:
            return GameConfiguration.pitchHitEasy
        case .Medium:
            return GameConfiguration.pitchHitMedium
        case .Hard:
            return GameConfiguration.pitchHitHard
        case .Impossible:
            return GameConfiguration.pitchHitImpossible
        }
    }
}
