//#-hidden-code
import PlaygroundSupport

PlaygroundPage.current.liveView = GameViewController(withGameType: .SameNote, gameObjects: [.ship], difficulty: .Easy, isFreegame: false)
//#-end-hidden-code
/*:
 ## Hit It!
 ---

 ### Informations
 One of the first things one learns while beginning learning to sing is holding a specific tone/note which is played from his coach. Normally this is done with a the piano. In this game you also will hear a note from a piano. Your objective will be to sing the exact same note that the ship will play. To help you get started with this and make it a little bit easier you can see the current note your sining in the Note View in the lower part of the screen.

 ### Game Cycle
 When the game starts you first need to find a a flat plane. To assist you in this you will see a blue plane drawn at places where ARKit detected such a plane.

 To get the game started simply press the plane on the touchscreen and the first ship will spawn.

 So let's get started with your first challenge! Press **Run My Code** to start the game.
 */
