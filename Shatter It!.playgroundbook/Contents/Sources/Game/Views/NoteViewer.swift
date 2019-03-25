//
//  NoteViewer.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 18.03.19.
//

import Foundation
import SpriteKit

public class NoteViewer: SKScene {

    let initDelay = 5.0
    let starEmitter = SKEmitterNode(fileNamed: "stars")!
    var scaleWhenNoteHitted = true

    let currentPitchGrapher: PitchGrapher
    let shouldHitPitchGrapher: PitchGrapher

    // MARK: - Initializer
    public init(size: CGSize, forNoteRange: NoteRange) {
        self.currentPitchGrapher = PitchGrapher(.current, withRange: forNoteRange, andSize: size)
        self.shouldHitPitchGrapher = PitchGrapher(.toHit, withRange: forNoteRange, andSize: size)
        super.init(size: size)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("Not implemented!")
    }

    // MARK: - Lifetime Cycle
    public override func didMove(to view: SKView) {
        self.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2862745098, blue: 0.3098039216, alpha: 1)
        self.anchorPoint = CGPoint(x: 0.9, y: 0.5)
        self.setupStarEmitter()
        self.setupPitchGrapher()
    }

    // MARK: - Private Helper Functions
    fileprivate func setupStarEmitter() {
        self.starEmitter.alpha = 0.0
        self.starEmitter.position.x += 200
        self.starEmitter.advanceSimulationTime(20)
        self.addChild(self.starEmitter)
        self.starEmitter.run(SKAction.fadeIn(withDuration: 5.0))
    }

    fileprivate func setupPitchGrapher() {
        self.addChild(currentPitchGrapher)
        self.addChild(shouldHitPitchGrapher)
        self.currentPitchGrapher.start()
        self.shouldHitPitchGrapher.start()
    }

    // MARK: - Public Functions - Particle Emmiters
    public func changeLifetimeOfParticlesForCurrentPitch(newTime: CGFloat) {
        self.currentPitchGrapher.changeLifeTimeOfParticles(newTime: newTime)
    }

    // MARK: - Public Functions - Current Pitch
    public func addHittedPitch(_ pitch: Pitch) {
        self.currentPitchGrapher.add(pitch: pitch)

        if(self.scaleWhenNoteHitted) {
            if(self.currentPitchGrapher.particleEmitter.particlePosition.y == self.shouldHitPitchGrapher.particleEmitter.particlePosition.y) {
                self.currentPitchGrapher.particleEmitter.particleScale = 1.5
            } else {
                self.currentPitchGrapher.particleEmitter.particleScale = 1.0
            }
        }
    }

    public func disableScaleWhenHoteHitted() {
        self.scaleWhenNoteHitted = false
    }

    public func activateScaleWhenNoteHitted() {
        self.scaleWhenNoteHitted = true
    }

    public func hideNewPitchesForCurrentPitchGrapher() {
        self.currentPitchGrapher.hideNewParticles()
    }

    public func showNewPitchesForCurrentPitchGrapher() {
        self.currentPitchGrapher.showNewParticles()
    }

    // MARK: - Public Functions - Should Hit Pitch
    public func hideNewPitchesForShouldHitPitchGrapher() {
        self.shouldHitPitchGrapher.hideNewParticles()
    }

    public func showNewPitchesForShouldHitPitchGrapher() {
        self.shouldHitPitchGrapher.showNewParticles()
    }

    public func addPitchPlayerShouldHit(_ pitch: Pitch) {
        self.shouldHitPitchGrapher.add(pitch: pitch)
    }

    public func hidePitchPlayerShouldHit() {
        self.shouldHitPitchGrapher.hidePitch()
    }

    public func showPitchPlayerShouldHit() {
        self.shouldHitPitchGrapher.showPitch()
    }

    public func stopShouldHitPitchGrapher() {
        self.shouldHitPitchGrapher.stop()
    }

    public func startShouldHitPitchGrapher() {
        self.shouldHitPitchGrapher.start()
    }
}
