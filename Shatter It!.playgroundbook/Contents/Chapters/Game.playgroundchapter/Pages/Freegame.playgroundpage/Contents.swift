//#-hidden-code
import PlaygroundSupport
//#-end-hidden-code
/*:
 ## Freegame & Thank You!
 ---

 **Thank you for trying out my playground. You're now on your way to becoming a better singer!**

 I hope you had as much fun trying out this playground as I had making it. Hopefully you didn't had that of a hard time making the ship sink. The beginning of learning something new is always hard. But you are on the best way to becoming a better and better singer! Maybe we will see us in person at WWDC 2019! I would be pleased.

 You've already come to the last part of Shatter It! This is a Freegame mode where you have the ability to customize the settings of the game. This includes:
 1) What Game you want to play: *Hit It! (SameNote)* or *Harmonics*
 2) What range the notes should be from: e.g. *Tenor* or *Baritone*
 3) What difficulty you want to try the game in (if it was really easy for you to hit and hold the notes maybe you should try medium or even hard): *ExtraEasy*, *Easy*, *Medium*, *Hard* or *Impossible*

 Have fun with it! And once again thanks for trying out my playground. I wish you a happy day!
 */

let gameType: GameType = /*#-editable-code*/.SameNote/*#-end-editable-code*/
let voiceType: VoiceType = /*#-editable-code*/.Tenor/*#-end-editable-code*/
let difficulty: GameDifficulty = /*#-editable-code*/.Easy/*#-end-editable-code*/

let gameViewController = GameViewController(withGameType: gameType, gameObjects: [.ship], voiceType: voiceType, difficulty: difficulty)
PlaygroundPage.current.liveView = gameViewController
