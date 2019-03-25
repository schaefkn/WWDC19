//
//  GameConfiguration.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 16.03.19.
//

import UIKit
import ARKit

public struct GameConfiguration {
    // MARK: - Options SCN
    public static var sceneDebugOptionsDevelopment = ARSCNDebugOptions.showFeaturePoints
    public static var sceneDebugOptionsDeployed: ARSCNDebugOptions = []

    // MARK: - Pitch Detection Settings
    public static var estimationStrategy = EstimationStrategy.yin
    public static var pitchDetectionThreshold = Float(-33.0)

    // MARK: - Default Game Properties
    public static var defaultVoiceType = VoiceType.Tenor
    public static var defaultGameType = GameType.SameNote
    public static var defaultGameDiffculty = GameDifficulty.Easy
    public static var defaultGameObjects = [GameObject.Mapper.ship]
    public static var defaultMaxGameRounds = 8
    public static var defaultMaxGameRoundsHitIt = 6
    public static var defaultMaxGameRoundsHarmonics = 4

    // MARK: - PitchHitCheck Settings
    public static var pitchHitExtraEasy = 3
    public static var pitchHitEasy = 6
    public static var pitchHitMedium = 12
    public static var pitchHitHard = 18
    public static var pitchHitImpossible = 36

    // MARK: - Assesment Success Strings
    public static let successIntroductionString = "### Let's get started with the setup of the game! \n\n[**Next Page**](@next)"
    public static let successSetupString = "### Game has been setup! Let's get started! :) \n\n[**Next Page**](@next)"
    public static let successHitItString = "### Perfect, you've hit the notes! \nUp for the next challenge ? \n\n[**Next Page**](@next)"
    public static let successHarmonicsString = "### Perfect, you now can sing harmonics! \nUp for the last challenge ? \n\n[**Next Page**](@next)"
    public static let successFreegameString = "### You've finished the Playbook! \nThanks again for trying it out :)"

    // MARK: - Assesment Fail Strings
    public static let failGameNotSetup = ["### Game Setup has not been run! Defaulting to VoiceType: \(GameConfiguration.defaultVoiceType.rawValue)! \nPlease setup game first and reset this playground page!"]

    // MARK: - Default Games
    public static var defaultGameHitIt = GameViewController(withGameType: .SameNote, gameObjects: [.ship], voiceType: .Tenor, difficulty: .Easy)
    public static var defaultGameHarmonics = GameViewController(withGameType: .Harmonics, gameObjects: [.ship], voiceType: .Tenor, difficulty: .Easy)
}
