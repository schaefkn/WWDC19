//
//  IntroductionViewController.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 19.03.19.
//

import ARKit
import PlaygroundSupport

public class IntroductionViewController: UIViewController {

    // MARK: - Properties
    let noteRange = NoteRange(lowerRange: try! Note(letter: .E, octave: 2), upperRange: try! Note(letter: .C, octave: 6))

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
        let config = Config()
        let pitchEngine = PitchEngine(config: config, delegate: self)
        pitchEngine.levelThreshold = -30.0
        return pitchEngine
    }()


    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true

        self.noteViewRenderer.presentScene(self.noteViewer)
        self.noteViewer.hideNewPitchesForShouldHitPitchGrapher()
        self.noteViewer.hideNewPitchesForCurrentPitchGrapher()
        self.noteViewer.changeLifetimeOfParticlesForCurrentPitch(newTime: 4.5)
        self.view.addSubview(noteViewRenderer)
    }

    public override func viewDidAppear(_ animated: Bool) {
        self.pitchEngine.start()

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            self.noteViewer.showNewPitchesForCurrentPitchGrapher()
        }

        Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true, block: { _ in
            self.noteViewer.addPitchPlayerShouldHit(try! Pitch(frequency: self.noteRange.getRandomNoteInRange().frequency))
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { _ in
                self.noteViewer.showNewPitchesForShouldHitPitchGrapher()
            })
            
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { _ in
                self.noteViewer.hideNewPitchesForShouldHitPitchGrapher()
            })
        })
    }

    public override func viewDidDisappear(_ animated: Bool) {
        self.pitchEngine.stop()
    }
}

extension IntroductionViewController: PitchEngineDelegate {
    public func pitchEngine(_ pitchEngine: PitchEngine, didReceivePitch pitch: Pitch) {
        self.noteViewer.addHittedPitch(pitch)
    }

    public func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print(error)
    }

    public func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine) {
        print("Below level threshold")
    }
}

