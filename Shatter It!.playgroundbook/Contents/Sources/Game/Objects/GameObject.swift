//
//  GameObject.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 16.03.19.
//

import UIKit
import ARKit
import SceneKit.ModelIO

public class GameObject {
    public enum GameObjectType {
        case scn
        case usdz
    }

    public struct Mapper {
        // MARK: - Properties
        let name: String
        let type: GameObjectType

        // MARK: - Game Objects
        public static var ship: Mapper {
            return Mapper(name: "ship", type: .scn)
        }

//        public static var glass: Mapper {
//            return Mapper(name: "glass", type: .usdz)
//        }
//
//        public static var trump: Mapper {
//            return Mapper(name: "trump", type: .usdz)
//        }
    }

    // MARK: - Properties
    let node: SCNNode
    let note: Note
    let string: String
    let gameType: GameType

    // MARK: - Initializer
    public convenience init(_ mapper: Mapper, withVoiceType voiceType: VoiceType, andGameType gameType: GameType) {
        let noteRange = NoteRangeCalculator.getNoteRangeFor(voiceType: voiceType)
        let note: Note

        switch gameType {
        case .Harmonics:
            note = noteRange.getRandomNoteForHarmonicInRange()
        case .SameNote:
            note = noteRange.getRandomNoteInRange()
        }

        self.init(mapper, withNote: note, andGameType: gameType)
    }

    public convenience init(_ mapper: Mapper, withNote note: Note, andGameType gameType: GameType) {
        self.init(name: mapper.name, type: mapper.type, withNote: note, andGameType: gameType)
    }

    public init(name: String, type: GameObjectType, withNote note: Note, andGameType gameType: GameType, position: SCNVector3 = SCNVector3(0,0,0)) {
        var scnNode: SCNNode

        switch type {
        case .scn:
            guard let scene = SCNScene(named: name + ".scn"),
                  let node = scene.rootNode.childNode(withName: name, recursively: false) else { fatalError("Object not found!") }
            scnNode = node  
        case .usdz:
            guard let url = Bundle.main.url(forResource: name, withExtension: "usdz"), let rf = SCNReferenceNode(url: url) else { fatalError("Object not found!") }
            scnNode = rf
        }

        scnNode.position = position
        self.node = scnNode
        self.note = note
        self.string = name
        self.gameType = gameType
    }

    // MARK: - Public Helper Methods
    public func getAudioSource() -> SCNAudioSource {
        let note: Note
        switch self.gameType {
        case .Harmonics:
            note = try! Note(index: self.note.index + 3)
        case .SameNote:
            note = self.note
        }

        let audioSource = SCNAudioSource(fileNamed: note.string + ".mp3")!
        audioSource.loops = true
        audioSource.load()
        
        return audioSource
    }

    public func handle(pitch: Pitch) {
        // TODO: Implement
    }

    public func handlePlayerHittedPitch() {
        let random = Bool.random()

        if(random) {
            self.node.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 1.0, duration: 2))
        } else {
            self.node.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -1.0, duration: 2))
        }

        self.node.runAction(SCNAction.fadeOpacity(to: 0.1, duration: 2))
        //self.node.runAction(SCNAction.moveBy(x: 0, y: -10, z: 0, duration: 2))
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.node.removeFromParentNode()
        }
    }

    // MARK: - Static Public Helper Methods
    public static func getRandomGameObject(from mappers: [Mapper], withVoiceType voiceType: VoiceType, andGameType gameType: GameType) -> GameObject {
        let random = Int.random(in: 0..<mappers.count)
        return GameObject(mappers[random], withVoiceType: voiceType, andGameType: gameType)
    }
}
