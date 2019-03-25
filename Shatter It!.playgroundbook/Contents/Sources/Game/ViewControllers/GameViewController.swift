//
//  GameViewController.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 16.03.19.
//

import UIKit
import ARKit
import PlaygroundSupport

public class GameViewController: UIViewController {

    // MARK: - Properties
    private let voiceType: VoiceType
    private let gameType: GameType
    private let gameDifficulty: GameDifficulty
    private let gameObjects: [GameObject.Mapper]
    private let pitchHitChecker: PitchHitChecker
    private let maxGameRounds: Int
    private let isFreegame: Bool
    private var currentGameObject: GameObject?
    private var currentNoteToHit: Note?

    private var alreadyHitNote = true
    private var foundFirstPlane = false
    private var gameStarted = false
    private var currentGameRound = 0

    lazy var sceneView: ARSCNView = {
        let frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height * 2 / 3)
        let sv = ARSCNView(frame: frame)
        return sv
    }()

    lazy var noteViewRenderer: SKView = {
        let frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height * 2 / 3, width: self.view.frame.width, height: self.view.frame.height / 3)
        let view = SKView(frame: frame)
        return view
    }()

    lazy var noteViewer: NoteViewer = {
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height / 3)
        let noteViewer = NoteViewer(size: size, forNoteRange: NoteRangeCalculator.getNoteRangeFor(voiceType: self.voiceType))
        return noteViewer
    }()

    lazy var pitchEngine: PitchEngine = { [weak self] in
        let config = Config(estimationStrategy: GameConfiguration.estimationStrategy)
        let pitchEngine = PitchEngine(config: config, delegate: self)
        pitchEngine.levelThreshold = GameConfiguration.pitchDetectionThreshold
        return pitchEngine
    }()

    // MARK: - Initializer
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet!")
    }

    public init(withGameType gameType: GameType, gameObjects: [GameObject.Mapper], voiceType: VoiceType? = nil, difficulty: GameDifficulty, isFreegame: Bool = true) {
        self.gameType = gameType
        self.gameObjects = gameObjects

        if let voiceType = voiceType {
            self.voiceType = voiceType
        } else {
            if let voiceTypeRawValue = UserDefaults.standard.string(forKey: "voiceType") {
                if let voiceType = VoiceType(rawValue: voiceTypeRawValue) {
                    self.voiceType = voiceType
                } else {
                    PlaygroundPage.current.assessmentStatus = .fail(hints: GameConfiguration.failGameNotSetup, solution: nil)
                    self.voiceType = GameConfiguration.defaultVoiceType
                }
            } else {
                PlaygroundPage.current.assessmentStatus = .fail(hints: GameConfiguration.failGameNotSetup, solution: nil)
                self.voiceType = GameConfiguration.defaultVoiceType
            }
        }

        self.gameDifficulty = difficulty
        self.pitchHitChecker = PitchHitChecker(difficulty: gameDifficulty)
        self.isFreegame = isFreegame

        switch gameType {
        case .Harmonics:
            self.maxGameRounds = GameConfiguration.defaultMaxGameRoundsHarmonics
        case .SameNote:
            self.maxGameRounds = GameConfiguration.defaultMaxGameRoundsHitIt
        }

        super.init(nibName: nil, bundle: nil)

        PlaygroundPage.current.wantsFullScreenLiveView = true
        PlaygroundPage.current.needsIndefiniteExecution = true
    }

    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Add AR Scene View
        self.view.addSubview(sceneView)

        // Add NoteViewer to Pitch Graph Viewer
        self.noteViewRenderer.presentScene(self.noteViewer)
        self.view.addSubview(noteViewRenderer)

        // AR Scene Lighting
        self.configureLighting()

        // From FreegameViewController
        self.addTapGestureToSceneView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpSceneView()
        self.pitchEngine.start()

        self.noteViewer.hideNewPitchesForShouldHitPitchGrapher()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        self.pitchEngine.stop()
    }

    // MARK: - Helper Functions
    fileprivate func setUpSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.debugOptions = GameConfiguration.sceneDebugOptionsDevelopment
    }

    fileprivate func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }

    fileprivate func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.startGame(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    fileprivate func advanceToNextGameRound() {
        self.currentGameRound += 1

        if(currentGameRound < self.maxGameRounds) {
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                self.addRandomObjectToScene(withPosition: self.currentGameObject!.node.position)
            }
        } else {
            self.spawnConfetti()
            self.noteViewer.hideNewPitchesForCurrentPitchGrapher()
            self.noteViewer.hideNewPitchesForShouldHitPitchGrapher()

            if(self.isFreegame) {
                PlaygroundPage.current.assessmentStatus = .pass(message: GameConfiguration.successFreegameString)
            } else {
                switch gameType {
                case .Harmonics:
                    PlaygroundPage.current.assessmentStatus = .pass(message: GameConfiguration.successHarmonicsString)
                case .SameNote:
                    PlaygroundPage.current.assessmentStatus = .pass(message: GameConfiguration.successHitItString)
                }
            }
        }
    }

    fileprivate func toggleGameStarted() {
        self.gameStarted = !self.gameStarted
    }

    fileprivate func spawnConfetti() {
        guard let confetti = SCNParticleSystem(named: "confetti.scnp", inDirectory: nil) else { return }
        confetti.loops = false
        confetti.particleLifeSpan = 8
        confetti.birthRate = 2500
        confetti.emitterShape = currentGameObject?.node.geometry

        let confettiNode = SCNNode()
        confettiNode.addParticleSystem(confetti)
        confettiNode.position = currentGameObject!.node.position

        self.sceneView.scene.rootNode.addChildNode(confettiNode)
    }

    @objc func startGame(withGestureRecognizer recognizer: UIGestureRecognizer) {
        if(!gameStarted) {
            toggleGameStarted()
            PlaygroundPage.current.assessmentStatus = nil

            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)

            guard let hitTestResult = hitTestResults.first else { return }
            let translation = hitTestResult.worldTransform.translation

            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                if(node.name == "plane") {
                    node.removeFromParentNode()
                }
            }

            addRandomObjectToScene(withPosition: SCNVector3(translation.x, translation.y, translation.z))
        }
    }

    func addRandomObjectToScene(withPosition position: SCNVector3) {
        // TODO: Scale Object Down! -> "self.globeNode?.runAction(SCNAction.scale(by: 0.2, duration: 0.0))"
        let gameObject = GameObject.getRandomGameObject(from: self.gameObjects, withVoiceType: self.voiceType, andGameType: self.gameType)
        let node = gameObject.node
        node.position = position
        node.runAction(SCNAction.scale(by: 0.8, duration: 0.0))
        sceneView.scene.rootNode.addChildNode(node)

        addAudioSource(fromGameObject: gameObject, toNode: node)
        updateDependentProperties(fromGameObject: gameObject)
    }

    func addAudioSource(fromGameObject gameObject: GameObject, toNode node: SCNNode) {
        let audioSource = gameObject.getAudioSource()
        node.addAudioPlayer(SCNAudioPlayer(source: audioSource))
    }

    func updateDependentProperties(fromGameObject gameObject: GameObject) {
        self.currentGameObject = gameObject
        self.currentNoteToHit = gameObject.note
        self.noteViewer.addPitchPlayerShouldHit(try! Pitch(frequency: gameObject.note.frequency))
        self.noteViewer.showNewPitchesForShouldHitPitchGrapher()
        self.alreadyHitNote = false
    }

    func checkIfPitchIsHit(_ pitch: Pitch) {
        self.pitchHitChecker.add(pitch: pitch)
        self.noteViewer.addHittedPitch(pitch)
        self.currentGameObject?.handle(pitch: pitch)

        guard let noteToHit = self.currentNoteToHit else { return }

        if(pitchHitChecker.checkHitOf(note: noteToHit) && !alreadyHitNote) {
            self.currentGameObject?.handlePlayerHittedPitch()
            self.noteViewer.hideNewPitchesForShouldHitPitchGrapher()
            self.advanceToNextGameRound()
            self.alreadyHitNote = true
        }
    }
}

extension GameViewController: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if(!gameStarted) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            let plane = SCNPlane(width: width, height: height)

            plane.materials.first?.diffuse.contents = UIColor.transparentLightBlue

            let planeNode = SCNNode(geometry: plane)
            planeNode.name = "plane"

            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            planeNode.position = SCNVector3(x,y,z)
            planeNode.eulerAngles.x = -.pi / 2

            node.addChildNode(planeNode)
            if(!foundFirstPlane) {
                PlaygroundPage.current.assessmentStatus = .pass(message: "Found a plane! Tap it to start the game!")
                foundFirstPlane = true
            }
        }
    }

    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if(!gameStarted) {
            guard let planeAnchor = anchor as?  ARPlaneAnchor,
                let planeNode = node.childNodes.first,
                let plane = planeNode.geometry as? SCNPlane
                else { return }

            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            plane.width = width
            plane.height = height

            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            planeNode.position = SCNVector3(x, y, z)
        }
    }
}

extension GameViewController: PitchEngineDelegate {
    public func pitchEngine(_ pitchEngine: PitchEngine, didReceivePitch pitch: Pitch) {
        checkIfPitchIsHit(pitch)
    }

    public func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print(error)
    }

    public func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine) {
        print("Below level threshold")
    }
}
