//
//  PitchGraph.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 18.03.19.
//

import Foundation
import SpriteKit
import PlaygroundSupport

public class PitchGrapher: SKNode {

    // Initzializer Helper
    public enum Helper: String {
        case current
        case toHit
        case particle

        var particleEmitter: SKEmitterNode {
            return SKEmitterNode(fileNamed: self.rawValue)!
        }
    }

    // MARK: - Properties
    public let particleEmitter: SKEmitterNode
    private let range: NoteRange
    private let middleNote: Note
    private let size: CGSize
    private var heightForSingleNote: CGFloat

    // MARK: - Initializer
    public init(_ helper: Helper, withRange range: NoteRange, andSize size: CGSize) {
        self.range = range
        self.middleNote = range.getMiddleNoteFromRange()
        self.particleEmitter = helper.particleEmitter
        self.particleEmitter.name = "particleEmitter"
        self.size = size
        self.heightForSingleNote = CGFloat(((self.size.height * 4 / 5) - self.size.height / 20) / CGFloat(self.range.upperIndex - self.range.lowerIndex))

        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("Not implemented! - Should not be called!")
    }

    // MARK: - Functions
    public func start() {
        if(self.childNode(withName: "particleEmitter")) == nil {
            self.addChild(self.particleEmitter)
        }
    }

    public func stop() {
        self.removeAllChildren()
    }

    public func add(pitch: Pitch) {
        let note = pitch.note
        guard self.range.contains(note: note) else {
            return
        }

        let dY = CGFloat(note.index - middleNote.index)
        self.particleEmitter.particlePosition.y = CGFloat(dY * self.heightForSingleNote + self.size.height / 10)
    }

    public func hidePitch() {
        self.particleEmitter.alpha = 0.0
    }

    public func showPitch() {
        self.particleEmitter.alpha = 1.0
    }

    public func hideNewParticles() {
        self.particleEmitter.particleAlpha = 0.0
    }

    public func showNewParticles() {
        self.particleEmitter.particleAlpha = 1.0
    }

    public func changeLifeTimeOfParticles(newTime: CGFloat) {
        self.particleEmitter.particleLifetime = newTime
    }
}
