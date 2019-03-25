//#-hidden-code
import PlaygroundSupport

PlaygroundPage.current.liveView = GameViewController(withGameType: .Harmonics, gameObjects: [.ship], difficulty: .ExtraEasy, isFreegame: false)
//#-end-hidden-code
/*:
 ## Harmonics
 ---

 ### Informations
 Another thing one learns on his journey becoming a better and better singer is so sing harmonics. In this game you will learn exactly this! You will hear a note from a piano when a ship spawns. Your objective will be to sing a a specific note that is harmonic to the one played by the ship. Especially in this part of the game the Note View will come in handy! As always you will see the note you need to hit and the current note you're singing.

 ### Game Cycle
 When the game starts you first need to find a flat plane. To assist you in this you will see a blue plane drawna at places where ARKit detected such a plane.

 To get the game started simpy press the plane in the touchscreen and the first ship will spawn. You will hear a note to which you need to sing a harmonic one.

 So let's get started with your second challenge! Press **Run My Code** to start the game.
 */
