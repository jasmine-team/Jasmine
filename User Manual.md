### User Manual
This game is built as a native iOS application. The app has been submitted to the app store and is currently undergoing review by Apple. A link to the app will be added as soon as the app is successfully published.

#### How To Use The App

##### Launching The App
1. At the device home screen, tap our app icon <img src="https://i.imgur.com/z8OgkHF.png" width=20>.
2. You will be presented with the home screen of our app. 
Press "PLAY" to choose a level.
3. On the level selection screen, tap on the level that you wish to play.
4. Tap on the "TAP TO START" banner. The game will be started.

#### Overview of game play
There are 2 game types: 
- Cheng Yu  
A Cheng Yu is a Chinese idiom comprising 4 chinese characters.
- Ci Hui
A Ci Hui is a Chinese phrase comprising 2 chinese characters. 

Each game type has 3 different game modes:
- Tetris Game
- Swapping Game 
- Sliding Game.

The objective of the games is to form valid phrases (either Cheng Yu or Ci Hui) from top to bottom or from left to right.

For the Ci Hui game type for swapping and sliding game mode, we combine the Ci Hui with its associated Pin Yin (a romanization of the Chinese characters for pronounciation) to form a 4-character phrase for the game play.

#### General instructions for Swapping game
1. Drag a tile and drop it on another tile to swap them.
2. Score will be computed based on time remaining and number of swaps performed.

##### Cheng Yu (成语) Swapping Game
<img src="https://i.imgur.com/SSmkxY7.jpg" width=450>

Form 4 rows or columns of Cheng Yu.

##### Ci Hui (词汇) Swapping Game 
<img src="https://i.imgur.com/P7jER7p.png" width=450>

Form 4 rows or columns of phrases containing a Ci Hui on one side and its associated Pin Yin on the other side.

#### General instructions for Sliding game
1. Slide any neighbouring tile onto the empty tile.
2. There are 15 characters on the grid, of which 3 phrases will be formed at any 3 rows or columns from 12 of these characters.
3. Score will be computed based on time remaining and number of slides performed.

##### Cheng Yu (成语) Sliding Game
Form 3 rows or columns of Cheng Yu.

##### Ci Hui (词汇) Sliding Game
Form 3 rows or columns of Ci Hui and Pin Yin pair.

#### General instructions for Tetris game
1. The game mechanics are similar to the commonly known Tetris game.
2. Form a Cheng Yu or Ci Hui by arranging the tiles from left to right, or top to bottom. 
Any other direction will not work!
Correctly formed tiles will be destroyed and all the tiles above them will be shifted down accordingly. If the shifted tiles happen to form valid phrases in their new positions, a chain effect will be activated, destroying the tiles with the matching phrases and shifting tiles above them downwards again accordingly, until no more destruction gets triggered by shifting down of the tiles. 
3. You may shift a falling tile leftwards/rightwards by swiping leftwards/rightwards or tapping the left/right side of the falling tile.
3. You may land a tile instantly by swiping downwards or tapping underneath the falling tile.
4. The game ends if the time runs out or if a tile landed on the top of the screen (first row) without triggering any destruction.
5. You will score points for every destruction of tiles.
> Hint 1: You may swap the falling tile with any of the upcoming tiles by tapping on the upcoming tiles!
> Hint 2: After clearing a phrase, all other tiles with characters contained in the phrase will disappear too! (You will not score additional points for additional tiles destroyed in this manner though)

##### Cheng Yu (成语) Tetris Game
Form a row or column of Cheng Yu to destroy the tiles.

##### Ci Hui (词汇) Tetris Game
Form a row or column of Ci Hui to destroy the tiles.

#### Game Over
<img src="https://i.imgur.com/NzLZFqu.png" width=380>
1. Each game has a timer. Game ends when the time runs out or when the winning condition is achieved.
2. For the Tetris game, there is no winning condition. Score as many points as you can before the time runs out!
3. On the Game Over screen, you can review the list of phrases that you have encountered.
4. Tapping on the phrases will bring you to the dictionary explaining the phrases in greater detail.

#### Custom Levels
1. You may create a custom level by pressing "+" on the level selection screen.
2. You may clone a level by pressing the menu icon from each level > "Clone".
3. You may modify a custom level by pressing the menu icon from each level > "Edit".
4. You may also delete a custom level by pressing the menu icon from each level > "Delete".

#### Creating Custom Levels
1. In the level designer view, you can specify a unique name, the type of the game (Cheng Yu, Ci Hui), and the mode of the game (Swapping, Sliding, Tetris).
2. You may select a list of desired phrases by pressing "SELECT PHRASES"
3. You may also import phrases from other levels by pressing "IMPORT PHRASES FROM LEVELS".
> Hint 1: If the level name is not specified, a default level name starting with "Untitled Level" and ending the next available number will be assigned to it.
> Hint 2: Your custom level names can be the same as any of the default level names.
> Hint 3: If your custom level name already exists, there will be a warning dialog to overwrite.

#### Phrases selection screen
1. You can toggle phrase selection by tapping on the phrases.
2. You can look through the list of phrases by panning to scroll.
3. Pressing the back button will only trigger an "exit without saving" warning if there are changes to selected phrases.

#### Settings screen
Tap on "SETTINGS" on home screen to go to the settings.
You can adjust the background music and sound effect volumes by sliding the volume bar.
You can sign in to the game center here.
> Hint: You will have to sign in through your device Settings > Game Center if you cancel the sign in. Instructions are provided on the view when this is triggered.
This is a restriction imposed by the iOS. See https://github.com/jasmine-team/Jasmine/issues/100 for more information.

#### Import level screen
Tap on the levels to toggle selection. You can also switch between custom level and default level for selection. The union of phrases from all selected levels will be merged into the currently selected phrases.

#### User Profile and Streaks
1. Tap on the "Profile" tab on the home screen to go to the profile screen.
2. This is where you get to see your user activities:
- Your daily streak (out of 7 days) as flower petals.
You will gain a petal by playing at least one game on each day. Petal count resets on first day (Monday) of every week.
- Your weekly streaks (out of 52 weeks) as green squares.
The color intensity (alpha) of the grid indicates how close you were to achieving the full 7 day streak for a given week.
The idea is inspired from Github's contribution graph on the user profile.
3. Note that Apple Game Center is enabled for this app, so your high scores and game achievements are linked to the Game Center.
