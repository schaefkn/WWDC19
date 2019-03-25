//#-hidden-code
import PlaygroundSupport

PlaygroundPage.current.liveView = GameSetupViewController()
//#-end-hidden-code
/*:
 ## Game Informations & Setup
 ---

 ### Informations
 So what is this game all about ?

 Shatter It! is a game which is played partly in Augmented Reality (AR). You will spawn a ship on a flat plane (you first need o find a suitable plane, which will be displayed in the ARView) and it will emit a specif tone/note.

 * In the first game *Hit It!* your objective will be to sing the extact same note the ship will play. Here the Note View will help you find that note.
 * In the second game *Harmonics* you will need to sing a harmonic note to the one the ship is playing. The Note View will be really import in this part of the game, since it shows you the note you need to hit. So use it wisely!

 If you successfully hit the required note *long enough* (only hitting it once doesn't count) and *loud enough* the ship will sink and after some time a new ship with a new note you need to hit will spawn. You win the the game if you destroyed a specific amount of ships.


 **IMPORTANT: Since in the first game the tone you need to sing is played from the ship it is best to turn the volume down a little or use headphones. Otherwise the played note will be detected as note you sing and you win the game easier. So pls don't cheat. Otherwise you wouldn't learn that much.**

 ---
 ### Setup

 Before you can get started on your journey to becoming a better and better singer we first need to setup the game. 

 Every person has a distinct range he/she/\* can sing. These ranges are categorized in so called voice types. The following types exist:
 * Soprano (highest female voice)
 * Mezzo-Soprano
 * Contralto (lowest female voice)
 * [Countertenor] (Tenors can be trained to sing this high)
 * Tenor (highest male voice)
 * Baritone
 * Bass (lowest male voice)

 In order for the game to determine what notes it can present to you to sing we need to an estimation of your voice type. Pls press **Run My Code** and try to hold your normal saying voice as long as you can until you see the assesment status of the playground page change.
 */
