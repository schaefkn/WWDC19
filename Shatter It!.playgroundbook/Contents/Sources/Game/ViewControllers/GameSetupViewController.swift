//
//  GameSetupViewController.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 22.03.19.
//

import UIKit
import ARKit
import PlaygroundSupport

public class GameSetupViewController: UIViewController {

    // MARK: - Properties
    lazy var noteViewRenderer: SKView = {
        let frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width / 2, height: self.view.frame.height)
        let view = SKView(frame: frame)
        return view
    }()

    lazy var noteViewer: NoteViewer = {
        let size = CGSize(width: self.view.frame.width / 2, height: self.view.frame.height)
        let noteViewer = NoteViewer(size: size, forNoteRange: self.noteRange)
        return noteViewer
    }()

    lazy var pitchEngine: PitchEngine = { [weak self] in
        let config = Config(estimationStrategy: GameConfiguration.estimationStrategy)
        let pitchEngine = PitchEngine(config: config, delegate: self)
        pitchEngine.levelThreshold = GameConfiguration.pitchDetectionThreshold
        return pitchEngine
    }()

    private let pitchHitChecker: PitchHitChecker
    private let noteRange = NoteRange(lowerRange: try! Note(letter: .E, octave: 2), upperRange: try! Note(letter: .C, octave: 6))

    // MARK: - Initializer
    public init() {
        self.pitchHitChecker = PitchHitChecker(difficulty: .Easy)
        super.init(nibName: nil, bundle: nil)

        PlaygroundPage.current.needsIndefiniteExecution = true
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("Not implemented!")
    }

    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true

        self.noteViewRenderer.presentScene(self.noteViewer)
        self.noteViewer.stopShouldHitPitchGrapher()
        self.noteViewer.hideNewPitchesForCurrentPitchGrapher()
        self.noteViewer.changeLifetimeOfParticlesForCurrentPitch(newTime: 4.5)
        self.noteViewer.disableScaleWhenHoteHitted()
        self.view.addSubview(self.noteViewRenderer)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pitchEngine.start()

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            self.noteViewer.showNewPitchesForCurrentPitchGrapher()
        }
    }

    public override func viewDidDisappear(_ animated: Bool) {
        self.pitchEngine.stop()
    }

    // MARK: - Private Helper Functions
    private func configureGameFor(voiceType: VoiceType) {
        pitchEngine.stop()
        UserDefaults.standard.set(voiceType.rawValue, forKey: "voiceType")

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if let savedVoiceType = UserDefaults.standard.string(forKey: "voiceType") {
                if(savedVoiceType == voiceType.rawValue) {
                    PlaygroundPage.current.assessmentStatus = .pass(message: GameConfiguration.successSetupString)
                    timer.invalidate()
                }
            }
        }
    }

    private func checkVoiceInput(_ pitch: Pitch) {
        self.pitchHitChecker.add(pitch: pitch)
        self.noteViewer.addHittedPitch(pitch)

        guard let note = self.pitchHitChecker.getCurrentHittedNote() else { return }
        let voiceType = VoiceTypeCalculator.getVoiceTypeFrom(note: note)
        self.configureGameFor(voiceType: voiceType)
    }
}

extension GameSetupViewController: PitchEngineDelegate {
    public func pitchEngine(_ pitchEngine: PitchEngine, didReceivePitch pitch: Pitch) {
        checkVoiceInput(pitch)
    }

    public func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print(error)
    }

    public func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine) {
        print("Below level threshold")
    }
}
