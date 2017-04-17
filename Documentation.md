# [CS3217 Jasmine] Documentation
![](https://i.imgur.com/QwTvlh3.png "Jasmine" =500x)
Team members: Herbert Ilhan Tanujaya, Li Kai, Wang Riwu, Wang Xien Dong

## Requirements

### Overview

#### Introduction
We aim to help English speakers improve their command of Chinese through a gamified educational app, making their learning experience fun and engaging. 

Our app includes various features such as weekly leaderboards and achievements that encourage the users to practise consistently, which is crucial in maintaining language proficiency.

#### Why Chinese
With over 1.2 billion Chinese speakers in the world and the emergence of China as a global economic superpower, bringing along a huge potential market comprising 18% of the world population, mastering the Chinese language has become more vital than ever. 

In Singapore, our founding father has long recognized the importance of the Chinese language and hence enforced bilingualism in our education policy. However, despite government initiatives such as the Speak Mandarin Campaign, Chinese language proficiency among Singaporean Chinese continue to deteriorate rapidly. Apart from the pragmatic economic concerns, the lack of proficiency in one’s own mother tongue also erodes one’s cultural identity, dignity and self-confidence.

As such, it is imperative for new strategies to be adopted to improve Chinese proficiency among Singaporean Chinese. Furthermore, there has been a growing interest in the Chinese language among non-Chinese ethnic groups. 

Our app therefore seeks to make the arduous journey of learning the Chinese language fun and enjoyable.

While our focus is on Chinese, we aim to make the project architecture flexible so that support for other languages can be easily implemented in the future.

#### Existing applications
While there are many existing applications for learning Chinese, they are not fun and engaging in general. For instance, an app named “Learn Chinese the Fun Way” comprise mainly dictionary definitions and penmanship exercises with barely any elements of fun. Another app named “Chinese Idioms Game” merely provides a picture hint and scrambled words for the user to guess the idiom. Lastly, an app named “ChineseSkill” consists of multiple choice questions requiring the user to pick the correct picture matching the given word. As can be seen, these apps are dull and boring in nature despite claiming to be game-based.

#### Why our app
The gamification of learning has long be proven to be beneficial in various aspects, such as providing the users autonomy in their learning, making learning visible and the freedom to fail and retry without consequences. Most importantly, it makes the learning experience fun and enjoyable, motivating the users to improve continuously and practise frequently, which is crucial to maintain language proficiency. For instance, a gamified platform known as Coursemology is well received by students and has been proven in be effective. 

As such, in our application, we plan to couple learning with fun games so that users are motivated to consistently enhance their Chinese proficiency in a fun way. We also plan to target users at all levels of proficiency, spanning from the beginners to the experts, by including a wide spectrum of  difficulty levels. 

### Revised Specification
We are adding a new game type called "Sliding Game". Similar to the [15-puzzle sliding puzzle](https://en.wikipedia.org/wiki/15_puzzle), there will a grid with an empty cell in it. The player must swap the empty cell with neighbouring cells to form 3 valid phrases either vertically or horizontally. Given that there is an empty cell, there will be an incomplete phrase with 1 missing word, which can act as a diversion to confuse the player.

We are also changing the swapping game to allow valid phrases to be formed either horizontally or vertically (previously only horizontally). This is to standardize the gameplay for all 3 games (swapping, sliding, tetris), by allowing both horizontal and vertical arrangement of valid phrases. 

The scores for swapping and sliding games will be changed to account for the time taken and number of moves (swaps/slides) performed (number of moves not used previously). Since valid phrases are allowed either vertically or horizontally, players will have to consider whether horizontal or vertical arrangement for that game instance is better to minimize the number of swaps.

We are also adding more customizability to the game. In particular, we now allow users to create custom levels with their custom set of phrases. This gives the users more control over the phrases they want to practise on. Users can also import phrases from other levels and merge them to their custom levels.

For the tetris game, to improve the difficulty of the game, the upcoming tiles will not include the entire phrase. Instead, a certain number of phrases (currently set at 2) will be generated to populate the upcoming tiles randomly, so that the phrases to be tested are only revealed fully after a few turns.

For the tetris game, we also implemented an innovative way to get rid of tiles that the user did not manage to solve successfully and has become indestrutible due to their positionings. A phrase containing the words on these tiles will be added to the upcoming tiles pool. Upon successfully forming the phrase and destroying it, all tiles with words that are contained in the destroyed tiles will also be instantly destroyed, and tiles above all the destroyed tiles will be shifted down accordingly. Additional tiles destroyed in this manner will not give additional scores.

### User Manual
This game is built as a native iOS application. The app has been submitted to the app store and is currently undergoing review by Apple. A link to the app will be added as soon as the app is successfully published.

#### How To Use The App

##### Launching The App
1. At the device home screen, tap our app icon ![](https://i.imgur.com/z8OgkHF.png =20x).
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
![](https://i.imgur.com/SSmkxY7.jpg =450x)

Form 4 rows or columns of Cheng Yu.

##### Ci Hui (词汇) Swapping Game 
![](https://i.imgur.com/P7jER7p.png =450x)

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
![](https://i.imgur.com/NzLZFqu.png =380x)
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

### Performance
We can achieve 60 FPS on both the iPhone and the iPad, as the game animation and physics are simple enough.

#### Tetris game type
- Number of tiles in the grid are currently set at 12x8, which is unlikely to go much higher due to screen size limit
- There will only be 1 falling tile at a time
- There will at most be 12x8 tiles being animated (shifted down or destroyed)

#### Swapping game type
- At most 16 cells in the Swapping game type, where at any instance only 2 cells will be shifted.

#### Sliding game type
- At most 16 cells in the sliding game type, where at any instance only 1 cell will be shifted.

Also, we target our game to run with less than 150 MB of memory, and with more than 70% CPU usage for only 10% of the time.

## Testing

### Strategy

#### Models
Models should have their own unit tests ensuring that their defaults variables are set correctly, as well as the correct implementation of any computed properties and functions. Tests will be devised for the normal case as well as the failure case. There will be tests for every branching in the code, such as if and guard statements.

#### View Models
ViewModels are disjoint from the View, and hence can be easily testable. The non-private methods should be tested to ensure correct behaviour, and a mock that fulfills certain delegate protocols should be implemented to ensure that the delegates are called as they should have.

#### View Controllers
For ViewControllers, they are highly reliant on black box testing due to the large variability of GUI testing. Since views do not contain any significant logic, if the Models and ViewModels are tested well, views can then be tested with black box testing.

#### Performance Tests 
We use the Mac's in-built `Instruments` application to measure the FPS. We conducted a few typical game runs and recorded the mean and range of the FPS. Also, we can measure the performance via CPU and memory usage, ensuring that they are within reasonable level.

#### Stress Tests
We have also performed some basic stress test on the tetris game such as rapidly tapping the grid to shift the falling tile left, right, or down, and rapid swapping of the tiles in the swapping game. Multiple simutaneous tap gestures are also tested.

For the Tetris game, we will stack up multiple full columns then destroy the bottom most row to stress test the shifting down of multiple full columns of tiles.

For swapping and sliding grid game, we have stress test it by spamming touch gestures right onto the view, ensuring that the game area does not break.

Other stress tests may include having the application to handle a huge database of Chinese vocabulary (~20000 words), and ensure that the performance of the app is still acceptable.

#### Regression Tests
We protected the master branch on our github repository (https://github.com/jasmine-team/Jasmine) and set up the Travis CI to require every test cases to pass before the pull request can be merged to the master branch. We also repeat the black-box testing of related UI components for every major build or UI changes.

### Results
As our project implements Travis CI service, our `master` branch build is passing with ~60% code coverage. Do note that some code paths such as private functions, singletons and game center related code are largely untestable. Do note that if the project has yet to implement some of the tests described in the Appendix (including the black box testing), they are replaced by black-box tests.

The performance tests showed that we can achieve our targeted FPS of 60 for our Tetris and Swapping games, even with animations.

The stress tests helped us find certain bugs that can only happen in extreme conditions such as moving tiles in the Swapping game that hasn't landed yet. Now that we have fixed them, these tests showed that the UI remains responsive and we can maintain the desired performance at the current level of animation.

## Designs

### Overview

![Class Diagram](https://i.imgur.com/O3d0pQq.png)

Our application adopts the MVVM (Model - View - ViewModel) pattern. This is the pattern adopted in most iOS applications; even Apple’s “MVC” framework is closer to MVVM than actual MVC. The model contains the main objects of the app, the ViewModel contains game logic and the View (consisting of ViewControllers and the UIViews) displays the representation of the game on the screen. 

We choose the MVVM design over the MVC design to avoid having a disproportionately large VC. A separation between the view and model also allows the models to be changed without the need to change the view. The separation also improves readability, maintainability, scalability, as well as the testability of the view model.

We have 3 game modes (Swapping, Tetris, Sliding) and 2 game types (Cheng Yu and Ci Hui). In our games, we aim to achieve a clean partition between the game _types_ and the respective game _modes_, so that different game modes can be added for each game type in the future. Hence, there is a ViewController corresponding to each game type and a ViewModel corresponding to each (game mode, game type) pair that extends the base ViewModel/ViewController for the game type to provide specific functionalities for the different game mode. Each ViewController handles how each game type is displayed on the screen, and returning the user inputs to the ViewModel. ViewModel then governs the rules of the game, and handles the logic of the game, and then tells the ViewController what to be displayed on screen. 

While each ViewController holds the corresponding ViewModel object, each ViewModel also holds communication pathways to the VC in the form of delegates. The delegates are separated based on their functionality; for example, `TimeUpdateDelegate` provides the ViewModel means to update the time stored in the ViewController, and `ScoreUpdateDelegate` lets the VM update the score in VC. This ensures that a 2-way connection between VM and VC is established. We implemented `ViewModelProtocol`s to be adopted by ViewModels, and the delegates to be adopted by ViewControllers. The protocol acts as a facade and makes the communication between the ViewModels and ViewControllers clear and explicit. This reduces the constant need for communication between the VC and the VM developers and eliminates any potential misunderstanding of the interface between the VM and VC. Furthermore, if we were to create a new game mode, all we need is to create a ViewModel that corresponds to the game mode, that conforms to the specific game type's view model protocol. This allows for simple and clear extensions to our games.

We also created a `CountDownTimer` class. ViewModels that use a timer in their games will have this `CountDownTimer` inside the VMs. There was an interesting discussion about this timer; we had three options to choose from:
- Use a `TimedViewModel` class, and ViewModels that need a timer subclass from that class
- Use a `TimedViewModel` protocol, and ViewModels that need a timer implements that protocol
- The current approach (an independent class that is contained in the ViewModels)

After discussion, we decided to stick to our current implementation. Using a class doesn't sound right in a protocol-oriented framework; besides, every class can only subclass once, and if more features are to be implemented, there will be more classes like this that the VMs need to implement. We tried to use a protocol with default implementations inside protocol extensions ("abstract class"). However, that does not work quite well as stored properties cannot be set or declared in an extension. As a result, we need to set each of the stored properties in each of the main view model classes, which clusters up the view model classes, especially when other functionalities such as sound are introduced. Furthermore, certain initializations, such as setting `timeRemaining` to `totalTimeAllowed` would have to be done in the init of the main view model classes even though such logic should be handled by the timer class. Hence the current implementation is chosen to avoid these problems and provide a cleaner solution.

For our Tetris game, we debated whether to let the view model control the falling tile and constantly update the view controller to redisplay the falling tile on its new position, or to simply let the view controller control the falling tile and notify the view model when the falling tile has landed. We decided to go with the latter as it allows the view controller greater control over how the falling tile is animated, such as whether it should fall discretely, row by row, or continously. Also, the view models (for three game mode) can focus on implementing the game mechanics without worrying about how the tiles fall in each game mode, as this is a UI component. What is only required from the view model is for the view controller to ask the view model whether the tile can be moved to a particular coordinate or to land, which maintains the encapsulation, and avoids processing of the view model's data.

Another interesting design issue is on code duplication. Apparently, there are some code duplication, as assessed by Codebeat. In particular, there are some duplication between the Grid ViewModels (`SlidingCiHui`, `SwappingCiHui`, `SlidingChengYu`, `SwappingChengYu`). Indeed, since we decided to split the `GridViewModel` into `SlidingViewModel` and `SwappingViewModel`, there are some duplication between the `CiHui` view models and `ChengYu` view models. If Swift supports multiple inheritance in some cases, this could have been solved more gracefully.

However, since Swift doesn't support multiple inheritance, we had the choice of either putting the code in the `BaseViewModel`, or splitting and duplicating them into the corresponding ViewModels. In the end, we decided to combine some into the Base VM, while still duplicating some of them. Indeed, there is a choice here between writing it in one place and making it DRY, or decoupling them and increasing extensibility. For example, we decided to decouple the scoring system in both games (`checkGameWon`) since the grid games should be flexible in how the game decides how to score, which tiles to highlight, and how to win. (What if the entire grid needs to be in a certain position?)

For the models, we are using `Realm`, for these reasons:
- Realm handles migrations much more cleanly than iOS's CoreData
- There is no need to deal with Objective-C type limitations with Realm as compared to CoreData
- Queries can be chained easily without performance issues
- Realm makes the classes more testable through ability to set Realm instances through dependency injection. 
- Realm performance is much better, and does not load all data immediately into memory.
- There is an app that allows you to edit Realm databases like an excel sheet.

We are also using a shared grid model called `TextGrid`, as an abstraction over grids containing Strings. These grids map `Coordinate` to `String`, and is used in our swapping, tetris, and sliding game modes.

Some libraries that we use in our CocoaPods are:
| Library    | Purpose                                    |
|------------|--------------------------------------------|
| Realm      | a mobile database and ORM                  |
| SwiftLint  | a linter for Swift to enforce coding style |
| Chameleon  | a color framework                          |
| SnapKit    | programatically fit constraints onto views |
| SwiftDate  | clean and easy date operations             |

Some other third-party things that we use include:
| Tool      | Purpose                                                                                             |
|-----------|-----------------------------------------------------------------------------------------------------|
| Travis CI | to ensure compilation works and tests pass                                                          |
| CodeCov   | for code coverage report                                                                            |
| Synx      | a tool that automatically matches the file directory structure with the grouping structure in XCode |
| CodeBeat  | a tool that assesses the codebase and reports lower-quality code                                    |

#### Trade-Off
One of the tradeoffs of this design (overall architecture) is that there will be more ViewModels to work with, which if not carefully managed, may result in more code and duplication. This is slightly mitigated due to CodeBeat coverage which looks out for duplication in code.

In addition, since many kinds of ViewModels are expected to work with ViewControllers, the design of ViewControllers is crucial. If not designed well where methods are extensible, additional ViewControllers may need to be introduced, defeating the point of this pattern.

Lastly, MVVM may be quite a new architecture pattern for people to get used to, and thus may introduce code where responsibility is not cleanly separated. Ensuring that the team understands the pattern is thus essential.

### Runtime Structure

The models consist of `Phrase`, the most important data component. It encapsulates one or more words in many different languages, such as Chinese and English (for the time being). A single data type keeps data persisting easy to manage since there's only one "table" to be copied. For the internal variables for Realm, a string is used to represent the Pin Yin with a space as the delimiter. An array of String would be more appropriate as it'd allow the extensibility of having spaces in a word, and other classes using the class will not need to be aware of the magical space delimiter. However, Realm does not support storing an array of primitives, hence the String is used for the internal representation for Realm, and a wrapper that turns the String into [String] is created for public access from other classes.
`Phrases` encapsulates the realm results object returned through a query, and hides away Realm implementation details behind functions exposed to ViewModels. 
Initially, we thought that `Phrases` just have to store the list of phrases tested in a level. However, we realized there could be situations where the user form a phrase that is valid and in the database but not in the list of phrases tested for that level. Hence to avoid false negative `Phrases` would contain the entire database of phrases to check against, and hence the need for Realm to store the list lazily as the database would be enormous to be stored in memory. 

Another model is the `Level`, which is a representation of a game level, and contains necessary information to create such a level to play a game. All `Level` objects can be found via `Levels`, which is retrievable through `Storage` singleton.

Every ViewModel would hold `GameData` which represents data necessary, such as Phrases for a game, all of which is created by a `GameDataManager`. This keeps the Model layer clean and simple, separated from the other responsibilities. Since all models (`Phrase` and `PlayerData`) are direct Realm objects, performance co-relates to Realm's amazing performance.

The grid data across all games are represented by the `TextGrid` model. We represent the content to be displayed on each tile as String instead of Character as this would allow multiple characters to be displayed on the tile, which would be needed to display Pin Yin. `Coordinate` is a struct containing 2 integers representing the column and row number on the grid. However, we decided to represent the `TextGrid` with a 2D array of `String?`, which is `[[String?]]`, as it provides a more natural way in our methods in `TextGrid` such as getting a row. It also retains efficient O(1) time complexity for read/write to the grid.

The `UICollectionView` will be implemented with every row on the grid belonging to 1 section. Hence `IndexPath.row` will correspond to the column number while `IndexPath.section` will correspond to the row number on the grid. As this is unintuitive and hard to visualise, we choose to use the Coordinate struct instead of IndexPath to represent the tile location on the grid for our data model. A mapping between `IndexPath` and `Coordinate` has been done via an extension in `IndexPath`.

### Module Structure
Refer to above class diagram under "overview" for an overview of our module structure.

#### General Component: View Model - Model Interaction
Models are generally all Realm objects, with their governing objects (e.g. `Phrases` for `Phrase` realm object) exposed for use to view models. View models will query for information through these governing objects as needed.

All GameData object are created through`GameManager` which holds the spawned level object. GameData acts as a token to be passed throughout stages of the game play. Information can be stored and obtained as needed through this generic GameData object.

Due to the efficiency of Realm only recalling data in which it is needed, certain choices between converting realm collections to native swift arrays are considered between performance and convenience.

Realm is never exposed to the View Models and thus dependency on realm is largely contained within the models layer. Should a change in storage library be needed, view model will not need a large refactoring to do so.

#### Game Component: View Controller - View Model Interaction
As illustrated above, our game component consists of the game view controller and its accompanying view model.

The MVVM pattern, the 2-way communication between VM-VC through a pre-agreed set of view model protocols and view controller delegates (in that VC contains VM protocol and VM contains a delegate protocol that goes to VC), and the VM class that implements each (game type, game mode) pair allows the project to be decoupled enough. Each class has its own responsibility and this allows us to have a better division of work, since the use of protocols allows people working on the VC does not need to wait until the people working on the VM to be done, and vice versa. This also allows the testability of view controllers and the view models by means of dependency injection.

##### Game Component
For the ViewModels, there is a `BaseViewModelProtocol` that is adopted by all game engines. This base VM adopts the `GameDescriptorProtocol` (describes the game). We included `TimeDescriptorProtocol` (describes the timing of the game) and `ScoreDescriptorProtocol` (describes the score of the game) that the implementing game view model can adopt only when they need it, which also explains why we subdivide it in this manner. Each of the above protocols comes with a corresponding `XDescriptorDelegate` that the implementing view controller can implement for the view model to call, and the view controller to listen for data updates. This interactions reduces copuling to a single direction between the view controller and view model.

Subsequently, we have `TetrisViewModelProtocol` that extends the `BaseViewModelProtocol` directly, while the protocols `SlidingGameViewModelProtocol` and `SwappingGameViewModelProtocol` extend the `GridViewModelProtocol` that extends the Base protocol, since there are so many similarities between the two games. For each of these game type specific protocols (except Tetris), 2 classes will extend them, corresponding to the 2 game modes.

##### Other View Components
Likewise, similar principles are applied to other view components, such as `LevelSelector`, `LevelDesigner`, and `PhraseExplorer` views.

#### View Controllers

##### Square Grid View Controller Family
In the view controller, we aimed to achieve having high flexibility for the view components to be reused. Specifically, a generic `SquareGridViewController` and `GameStatisticsViewController` is used to display a m-by-n square grid, and in-game statistics such as time remaining and game score. This keeps the main view controllers such as `SwappingGameViewController`, `SwipingGameViewController` and `TetrisGameViewController` small as most of the operations are done inside the generic controllers itself. There is no need to recode la collection view controller for `SwappingGameVC`, `SlidingGameVC` and `TetrisGameVC` respectively. 

To allow greater customisability to the `SquareGridViewController`, we have establised an hierarical system for this view controller. Along with a trivial display of tiles, `DraggableSquareGridVC`, `DiscreteFallingSquareGridVC` and `SelectableSquareGridViewController` are built upon with the ability of dragging and dropping of tiles, the falling of tiles, and the selectability of tiles. 

These implementation keeps each class/file size small while at the same time provides sophiscated functionalities to each game type. For example, Tetris game can now rely on `DiscreteFallingSquareGridVC` to display its main falling grid, and a simple `SquareGridViewController` to display the upcoming tiles. By designing the game view controller to be higly modularised with various embedded view controllers, we have improved code reuse and reduces the coupling between the view controllers and the native `UICollectionView`. 

In fact, `GameOverViewController` is able to reuse `SelectableSquareGridViewController` without having to recode the entire collection view to display a simple list of phrases. Also, the weekly streak in the `ProfileViewController` is made up of `SquareGridViewController` as well.

With this regard, we have applied this similar pricinple to other reusable view controllers such as  `GameStatisticsViewController` and  `SimpleStartGameViewController`.

##### View Controller Inheritance
We understand that traditional view of inheritance cannot be apply to view controllers, simply because there exist a one to one mapping and view attachment between view controllers and the layout in the storyboard. However, there are avenues where there are overlaps in code (e.g. `SwappingGridGameViewController` and `SwipingGameViewController`), so we created a `BaseGameViewController` class between the three game VCs, and have the children classes to pass their shared view element up to the parent class. 

Similar implementation has been done between the grid games through `BaseGridGameViewController`, and all view controllers in general via `JasmineViewController`. In particular, having a general `JasmineViewController` allows for a central control over the themeing of the views, such as controlling the colour the navigation bar, and the status bar colour.

Although this reduces code duplication between various view controllers and improve sharing of properties between VCs (e.g. themeing), one significant trade-off is that it increases coupling between the hierarchy, simply because both the parent VC class and the children VC class has to know whether the actual view in storyboard is attached.

## Reflection

### Evaluation
The architecture of the code is something that we are proud of. A very good separability between the components are achieved. This made our development very conformtable.

As a tradeoff, though, our development speed is quite slow. We are quite particular about minor things. As time progresses, though, we are slowly becoming more lenient, trading off code quality with development speed.

Also, since the design keeps on changing, the tests need to be changed as well. Some parts of the application are harder to test, making it more time-consuming in writing tests. In particular, the Grid games are still quite hard to test until now, since the movement of tiles is limited. It's as if we are creating an artificial intelligence to play the game.

Setting up tools such as CODEBEAT to assess the quality of our code has been really helpful, as automatic code review allows us to catch ugly codes and improve our code quality early on. As a result of our efforts, we have achieve grade B on the code quality rating provided by CODEBEAT.

One might wonder why we achieved a B and not an A. We looked into it and most of them are caused by code duplication. There is always a tradeoff between code duplication and extensibility though, as described above in the "Designs" section. Do note that CODEBEAT standards are also quite strict, (e.g. having only 6 properties would be deducted for having too many instance properties)

### Lessons
Previously, we felt that our work is progressing very slowly; at this pace, we will not be able to complete the app in 6 weeks. The main problem we found out is in our collaboration flow.

Originally, we wanted all four people to review every pull request so that everyone knows exactly what is going to be pushed to `master`. This does not work so well, though, since not everyone is always active. Some trivial pull requests, such as the addition of a library, can require hours or even days to be merged.

Also, we realized that we are too picky in our guidelines. Sometimes we ask the author of a PR to just change variable names or even comments. This resulted in the PR taking even longer time to be merged, because we ask the author of the PR to make these trivial changes again and again. We also spent so much time debating trivial things such as line length (maximum number of characters in a length).

To solve these problems, we decided on these things:
1. A PR needs to be reviewed by only one reviewer before being merged
2. Anyone can push trivial changes to anyone's branches, as long as the author of the branch is being notified
3. We will try to meet every Monday 4pm-6pm and Friday 12pm-2pm. We will require at least 2 people to be present in every timeslot. This allows face-to-face pair programming which allows us to make faster and better decisions.

We have adopted these changes since last Friday and our work has been much more productive ever since.

Also, our general architecture has slight changes compared to the design outlined in the first document. We think this is natural; designs are bound to changed if they are found unsuitable for the app.

Sometimes we have a hard time deciding how certain things should be implemented (some of which are mentioned above). To save time, we decided to simply go with the one that is simplest to implement, and change it accordingly should the need arise.

We think that Prof. Ben is right by saying that there was an issue with team dynamics. A way to solve this would probably be choosing someone to be the team leader and let him/her be the team arbiter.

### Known Bugs and Limitations
1. Sometimes the sound fails blackbox testing (likely due to inconsistency of timers).
2. There might be instances where sound effects continue to play after a game gesture is spammed.
3. Audio levels do not persist between app restarts.
4. Clearing and drag-gesture multi-selecting of all checkmarkable views (`PhraseExplorerVC`, `LevelImporterVC`) are not supported at this point.


## Appendix

### Formats
No user format is exposed.

Local requirements need `prebundled.realm` file to seed the information in the database.

In the directory, we have a Python3 script that scraps phrases from an API and stores it in a Realm file. To generate the phrases, we have a set of instructions written in the `README.md` file, reproduced here:

1. First copy the secrets file: `cd scripts && cp secrets.example.py secrets.py `
2. Set up environment variables by changing the file `secrets.py`
3. Run `python3 api.py` to populate the CSV file
4. Download [Realm browser](https://itunes.apple.com/sg/app/realm-browser/id1007457278?mt=12) and import CSV to turn it into Realm file
5. Replace the Realm file in `Jasmine/Common/prebundled.realm` with the produced Realm file

We also have a Python script that generates the metadata necessary for game center and creates and achievements and leaderboards from the `Level.csv` file. Instructions are reproduced here:

1. Find iTMS, usually in `/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/itms`
2. Run `iTMSTransporter -m upload -u <user> -p <password> -f <path>/Jasmine/scripts` to upload
3. Run `iTMSTransporter -m lookupMetadata -u <user> -p <password> -apple_id 1223383989 -destination <path>/Jasmine/scripts` to download metadata

### Module Specifications

#### Phrase
This is an encapsulation of a sequence of words that contain meaning, thus having various properties that are labeled with information.

Properties:
- `english: String`. The english representation of this word
- `chinese: String`. The chinese representation of this word
- `chineseMeaning: String`. The chinese meaning of this word
- `englishMeaning: String`. The english meaning of this word

#### Phrases
This is a collection of phrases for usage. Access is fast due to consideration of performance and number of phrases in the final database.

#### TextGrid
This is an encapsulation of a grid of Strings, mapping a Coordinate to a String.

Properties and methods:
- `numRows: Int`. The number of rows in the grid
- `numColumns: Int`. The number of columns in the grid
- `count: Int`. Total number of cells in the grid
- `texts: Set<String>`. Set of all texts in the grid
- `init(fromInitialGrid: [[String?]])`, `init(fromInitialRow: [String?])`, `init(fromInitialColumn: [String?])`. Initializer functions given a grid. Creates a 2D grid, a one-row grid and a one-column grid respectively.
- `init(numRows: Int, numColumns: Int)`. Creates a 2D grid initialized with all nils.
- `subscript(coordinate: Coordinate) -> String?`. Gets and sets the element in the given coordinate, just like an array.
- `swap(_: Coordinate, _: Coordinate)`. Swaps two elements in the specified coordinates.
- `hasText(at: Coordinate) -> Bool`. Returns true if and only if the text in the coordinate is not nil.
- `removeTexts(at: Set<Coordinate>)`. Sets the text in the given coordinates to nil.
- `getTexts(at: [Coordinate]) -> [String]?`. Gets the texts of the given coordinates. Returns nil if any of the texts is nil.
- `getConcatenatedTexts(at: [Coordinate], separatedBy: String) -> String?`. Gets the texts of the given coordinates, concatenated optionally by a given separator. Returs nil if any of the texts is nil.
- `isInBounds(coordinate: Coordinate) -> Bool`. Returns true if and only if the coordinate is in bounds of the text grid. In other words, the coordinate's row is in 0 to the last row of the text grid, and the coordinate's column is in 0 to the last column of the text grid.
- `getCoordinates(containing: Set<String>) -> Set<Coordinate>`. Returns the set of coordinates in the text grid containing the given texts.

This grid needs to have a constant number of cells in every row, and a constant number of cells in every column. In other words, there cannot be rows with different number of cells.

#### CountDownTimer
This is a simple countdown timer.

Properties and methods:
- `totalTimeAllowed: TimeInterval`. The total time in this timer.
- `timeRemaining: TimeInterval`. The time remaining.
- `timerListener: ((TimerStatus) -> Void)`. A listener that allows functions to be executed at certain events of the timer, depending on the `TimerStatus`.
- `init(totalTimeAllowed: TimeInterval)`. Initializes the timer with the given total time allowed.
- `startTimer(timerInterval: TimeInterval)`. Starts the timer with the given timer interval. The timer interval tells how fast the timer ticks. The time will still be decremented according to the number of seconds, though.
- `stopTimer()` stops the timer.

For this timer, the time remaining and the timer interval must be numbers greater than 0.

#### Coordinate
This defines a coordinate system of discrete integers. In this coordinate system, the top-left tile is indexed as `Coordinate(row: 0, col: 0)`. The row number and the column number gets bigger as one goes down or right, respectively.

Properties and methods:
- `row: Int`. Returns the row number of the given coordinate.
- `col: Int`. Returns the column number of the given coordinate.
- `init(row: Int, col: Int)`. Initializes a coordinate, given the row and column number.
- `nextRow: Coordinate`. Returns the coordinate of one row down.
- `nextCol: Coordinate`. Returns the coordinate of one column right.
- `prevRow: Coordinate`. Returns the coordinate of one row up.
- `prevCol: Coordinate`. Returns the coordinate of one column left.
- `toIndexPath: IndexPath`. Gets the index path representation of the given coordinate.
- `isWithin(numRows: Int, numCols: Int) -> Bool`. Returns true if and only if the coordinate given is in the bounds of the number of rows and columns.

For this coordinate system, the row and column number must both be non-negative.

#### ScoreDescriptorProtocol
ViewModels conforming to this protocol has a score component in it.

Properties and methods:
- `currentScore: Int`. The current score of the game.
- `scoreDelegate: ScoreUpdateDelegate?`. A delegate that the viewmodel notifies when the score is updated.

#### TimeDescriptorProtocol
ViewModels conforming to this protocol has a time component in it.

Properties and methods:
- `timeRemaining: TimeInterval`. The time remaining of this game.
- `totalTimeAllowed: TimeInterval`. The total time allowed in this game.
- `timeDelegate: TimeUpdateDelegate?`. A delegate that the viewmodel notifies when the time is updated.

#### GameDescriptorProtocol
This protocol contains properties that describe a game. This protocol also conforms to `ScoreDescriptorProtocol` and `TimeDescriptorProtocol`

Properties and methods:
- `levelName: String`. The name of the level. Used to display the title of the game.
- `gameInstruction: String`. Brief instructions for the game.
- `phraseTested: Set<Phrase>`. A set of phrases tested in this game.
- `gameStatus: GameStatus`. Current status of the game. Can be `notStarted`, `inProgress`, `endedWithWon`, `endedWithLost`.
- `gameStatusDelegate: GameStatusUpdateDelegate?`. A delegate that the viewmodel notifies when the game status is updated.

#### BaseViewModelProtocol
This protocol sets the shared functionalities across all game view models. This protocol conforms to `GameDescriptorProtocol`.

Properties and methods:
- `gridData: TextGrid`. The grid contained in the game.
- `startGame()`. Starts the game.

#### GridViewModelProtocol
This protocol defines a grid game (the Swapping and Sliding games). This protocol conforms to `BaseViewModelProtocol`.

Properties and methods:
- `highlightedCoordinates: Set<Coordinate>`. The coordinates in the grid that are highlighted.
- `highlightedDelegate: HighlightedUpdateDelegate?`. A delegate that the viewmodel notifies when the set of highlighted coordinates are updated.

### Test Cases

#### Black-box testing

##### Test functionalities shared across all views
- Top bar
- in most of the views, the top bar should be green
- All except home screen should have white status bar font and images.
- the title should be placed at the middle
- Ensure that the name of the view is sensible.
- Back button
- If there is a "BACK" button, should be placed at the top left
- should dismiss current view and return to the previous screen on click
- Auto-rotation
- Only available in portrait mode.
- Background music
- Should be played while in the app.
- Stops playing when the background music is muted in settings or when the app is minimised.

##### Test implementation of Swapping game
- Test drag and drop
- drag corners (top-left, top-right, bottom-left, bottom-right) to neighbouring cells, should swap positions
- drag center to neighbour, should swap positions
- drag random cell to other cells, should swap positions
- drag cell to out of bounds, should go back to original positions
- Test forming a phrase
- correct answer should provide feedback (highlighted cells)
- wrong answer should not provide feedback
- Test solving game before time out
- game should end with presentation of victory screen
- game should be in correct solved positions
- Test not solving game before time out
- game should end with presentation of lose screen
- game should not be solved

##### Test implementation of Tetris game
- On loaded
- tile should appear at random place (on the top row) and starts falling in a discrete manner.
- Test swipe left and right while tile is falling OR tapping left and right of the falling tile
- tile should move left and right once per swipe
- tile should remain within bounds of screen
- tile should not move if the target direction is obstructed by another tile
- Test swipe down OR tapping underneath the falling tile.
- Tile should fall to the bottom and locked to the screen, subsequent landing operation should occur
- Test placing the tile
- tile should stop moving when it reaches the bottom of the grid, or if there is a tile beneath it.
- tile should not move once locked into place
- Test forming a phrase
- tile should trigger deletion if it forms a valid answer
- tile should not trigger deletion if it is not a valid answer
- if triggered deletion, tiles on top should fall down to fill remaining space
- When deletion is triggered
- deleted tiles should explode with a pop sound
- other tiles that has a hole underneath should fall subsequently.
- chain effect should take place if there are matching tiles that formed from the falling action.
- tiles with characters that matches with the exploded tile should explode as well.
- Test losing game conditions
- game should end when reaching top of screen with tiles
- game should end when not enough answers were cleared within time limit
- losing game screen should appear
- Test victory game conditions
- game should end when finishing game within time limit and with required combinations
- victory game screen should appear
- Test upcoming tile
- the view should show a list of upcoming tiles in order.
- the latest upcoming tile should be visually distinct from the rest (highlighted)

##### Test implementation of Sliding game
- Test drag and drop
- tiles can only be dragged horizontally/vertically
- when a tile is moved to an empty space, the tile should be placed to the empty space
- when a tile is about to be moved to a non-empty space, the tile should be blocked from proceeding further
- Test forming a phrase
- correct answer should provide feedback (highlighted)
- wrong answer should not provide feedback
- Test solving game before time out
- game should end with presentation of victory screen
- game should be in correct solved positions
- Test not solving game before time out
- game should end with presentation of lose screen
- game should not be solved

##### In all the game plays
- Test score updated:
- score label (below) should grow and shrink with gold font.
- score label should reflect the correct score.
- Test timer updated:
- time label should update on its own.
- grow and shrink animation with red font is only applicable if timer reaches remaining 10 seconds.
- Test press "BACK" button:
- ends the game and dismisses the screen. 
- Check:
- that the title matches the title in the level that was selected.

##### Test Game Over screen
- Verify view elements:
- Check that final score is correct.
- Check that "CONGRATULATIONS" or "GAME OVER" is shown as appropriate to the outcome of the game.
- Check that phrases displayed are the ones played in the game.
- Test press "BACK" button:
- dismisses both the game over screen and the previous game screen.
- Test press the phrases
- should open the Phrase view.

##### Test home screen
- Test Jasmine flowers
- the flowers should follow the gravity, i.e. the accelerometer of the phone.
- Test buttons
- the Play button should bring the levels screen
- the Help button should bring the help screen
- the About button should bring the about screen
- the Settings button should bring the settings page
- the Levels button at the bottom should bring the levels screen
- the Profile button at the button should bring the user's profile screen

##### Test level selection screen
- Test view
- it should show all levels, divided by default and custom levels
- every level should show the level name, game mode, game type, and a menu icon
- Test info icon
- clicking the info icon should bring up a menu
- the menu should consist of "View Phrases" and "Clone" for default levels
- the menu should consist of "View Phrases", "Clone", "Edit", and "Delete" for custom levels
- Test pressing delete
- Only available to custom levels, that level should disappear.
- Test pressing edit
- Opens level designer with the specified custom level preloaded.
- Test pressing clone
- Opens level designer with the specified custom level preloaded.
- Should be able to save it as a new level.

##### Test Phrases Explorer screen
- Test view
- it should show all phrases: their Chinese characters (hanzi) and their English meaning
- there should be a search bar on top
- Test search bar
- clicking on it should give first responder (show keyboard)
- searching should show the phrases that match the hanzi, pinyin, or the English meaning, as it is typed
- clicking Cancel should resign first responder (remove keyboard)
- Test transition to Phrase view
- if on view-only mode: clicking on a phrase should segue to phrase view directly
- if on selection mode: long press on a phrase should segue to phrase view

###### Phrase Explorer Selection Mode
Note: This view is ususally opened from level designer view.
- Verify after opening:
- "SAVE" and "BACK" button are visible
- Global list of phrases should appear, depending if it is Ci Hui or Cheng Yu (specified by level designer).
- Test selecting an entry:
- Check mark should appear

##### Test Phrase screen
- Test view
- it should show the Chinese characters, pinyin, and English meaning of the phrase
- it should show a sound icon
- Test sound
- clicking on the sound icon should play the pronounciation of the phrase clearly
- while the sound is being played, the game music volume should be reduced, and returned after the TTS ends.

##### Test Settings screen
- Test opening the view
- Audio knob should reflect actual audio level.
- Test dragging background and sound fx track bar:
- Audio's loudness should be adjusted according to the specified level.
- Level should persist when the screen reopens.
- Test tapping sign in/out button:
- Should provide instructions of logging in to game center.

##### Test Level Editor screen
- Test opening "SELECT PRHASES" when ci hui or cheng yu is selected
- list of phrases in phrases explorer should match ci hui or cheng yu
- should display the global list of phrases
- Upon completion, the number of selected phrases should be reflected on the button.
- Subsequent re-entry to the view should still have the same phrases selected.
- Test opening "IMPORT PHRASES FROM LEVELS" when ci hui or cheng yu is selected
- list of levels in level importer should contain only ci hui or cheng yu levels as appropriate.
- Upon completion, the number of selected phrases should be reflected on the button.
- Entering the phrases explorer should see what are the selected view.
- Switching between cihui and cheng yu
- The list of phrases should switch according to cihui and cheng yu.
- If a selection has been made earlier, it should be preserved after switching back.
- Test pressing "BACK"
- A warning dialog should show, where:
- Cancel should dismiss it
- Pressing "Yes" should dismiss the view
- Test pressing "SAVE"
- Without a name, and all other fields filled
- Saves with name: "Untitled Level x"
- With a duplicated name, and all other fields filled
- Shows an overwrite dialog box, where:
- Pressing cancel dismisses it
- Pressing "Overwrite" replaces existing level with the specified name.
- With a unique name, but no phrases selected
- Shows an error dialog box prompting to select a phrase or more.

##### Test Level Import screen
- Verify on open
- View should display the list of levels, switchable between default and custom levels
- Selecting a level
- Presents a checkmark
- Press done
- dismisses and pass back the level selected to previous view
- Press back
- dismisses the view

#### Glass-box testing

##### Test implementation of models
- Test `GameData`
- `score` should be zero at start
- `phrases` must be results from realm query
- Test `GameManager`
- `createGame` creates GameData
- `createGame` sets properties `difficulty` and `phrases` correctly
- `saveGame` saves the level result into realm
- Test `Coordinate`
- `Hashable` is implemented correctly
- `Equatable` is implemented correctly - different objects must not equate to each other
- Test `Phrases`
- `contains` returns true if and only if the phrase is in the phrases list
- `first` returns the first Phrase that satisfies the given Chinese correctly
- Test `Levels`
- `original` should return original levels
- `custom` should return custom levels
- `adding` should add to custom levels
- `delete` should delete from custom levels
- `resetAll` should delete all custom levels
- Test realm integration
- `phrases` loads the phrases properly
- Test `TextGrid`
- `init` loads the grid properly
- `numRows` and `numColumns` detect the number of grid rows and columns properly
- `coordinateDictionary` gives the Coordinate dictionary representation of the grid
- `init(numRows:numCols:)` creates an empty grid with the given rows and columns
- The subscript get and set is returns and sets the grid cell correctly
- `swap` swaps the two tiles located in the given coordinates
- `hasText` returns true if and only if the tile in the coordinate is not nil
- `removeTexts` sets the given texts in the given Coordinates to nil
- `getTexts` returns the texts in the given coordinates
- `getConcatenatedTexts` returns the texts in the given coordinates and concatenates them

##### Test implementation of helpers and extensions
- Test `Array+Extensions`
- `[T] == [T?]`, `[T?] == [T]`, `[T] != [T?]`, and `[T?] != [T]` compares the arrays element-by-element
- Test `CGRect+Arithmetic`
- `init(center, size)` and `center`: the conversion between center and origin should be correct.
- `init(minX:maxX:minY:maxY:)` should create the rectangle given the bounds of the coordinates.
- Test `IndexPath+Coordinate`
- `init(coordinate)` and `toCoordinate`: converts between `IndexPath` and `Coordinate` structs correctly.
- Test `Matrix+Equatable`
- 2D arrays should be equal if and only if their elements are equal pairwise
- Test `MutableCollection+Extensions`
- `shuffle` randomizes the array uniforml
- Test `Sequences+Extensions`
- `hasNoDuplicate` returns true if and only if the sequence has no duplicate (all are unique)
- `isAllTrue` returns true if and only if all the elements in the array satisfy the given predicate
- Test `UIApplication`
- `firstLaunch` is true if and only if the application is launched on the first time
- Test `UISwipeGestureRecognizerDirection+Directions`
- `up`, `down`, `left`, and `right` should be mapped to `northwards`, `southwards`, `westwards`, `eastwards`
- Test `CountDownTimer`
- `init` initializes the timer with the correct time allowed
- `startTimer` starts the timer, ticks the timer according to the timer interval supplied, and sends timer updates to the `timerListener` function
- `stopTimer` stops the ticking of the timer and sends timer stop update to the `timerListener` function
- Test `LevelError`
- `duplicateLevelName` error should show "Duplicate level name: \(levelName)"
- `noPhraseSelected` error should show "No phrase selected"
- Test `RandomGenerator`
- `next` should return the next random element from the remaining iterator, and should reset if the iterator is empty
- `next(count:)` should call `next` a few times according to the the number supplied in the count
- Test `Random`
- `integer(from:toInclusive:)` should return an integer uniformly random from `from` to `toInclusive`
- `integer(from:toExclusive:)` should return an integer uniformly random from `from` to `toExclusive - 1`
- `double(from:toInclusive:)` should return a double uniformly random from `from` to `toInclusive`

##### Test implementation of viewmodels
- Test `PhraseViewModel`
- Test `PhraseExplorerViewModel`
- Test `GridViewModel`
- On `init`, all properties should be set properly:
- `gridData` contains the tiles, shuffled. The size should be the number of rows and columns given
- `currentScore` should be 0
- `highlightedCoordinates` should be empty
- `phrasesTested` should be empty
- `timer` should be the countdown timer initialized according to the total time given
- `timeRemaining` and `totalTimeAllowed` should read from `timer`
- `gameStatus` should start with `.notStarted`
- `gameData` should be the `gameData` supplied in `init`
- `levelName` should equal to the name from the `gameData`
- `gameType` should be the game type supplied in `init`
- `startGame` should start the timer
- `lineIsCorrect(_:)` should check the coordinates given in the grid, concatenates them, and checks with the database. This is done in the default case. For special cases (that is read from `gameType`, such as `.ciHui`), it is handled accordingly. For `ciHui` the game should split the coordinates into half and check if the first half matches the text in second half (hanzi - pinyin or pinyin - hanzi).
- Test `BaseSlidingViewModel`
- `slideTile` should slide the tile from the start coordinate to the end coordinate, if allowed. It should only be allowed if the distance between them is 1, and both are valid coordinates
- `canTileSlide(start:)` returns all the coordinates in which the tile can be slided into, which are the adjacent tiles that are still inside the grid
- `checkCorrectTiles` should highlight the tiles if the rows/columns form a valid line according to `lineIsCorrect`. If 3 rows or columns are done, the game should be declared won.
- Test `ChengYuSlidingViewModel` and `CiHuiSlidingViewModel`
- `init` should set the total time given, the phrases taken from the `gameData` and the number of rows given
- `slideTile` should run `checkCorrectTiles` if the tile slide is successful
- Test `BaseSwappingViewModel`
- `swapTiles` should swap the tile from the start coordinate to the end coordinate and it should always allow that
- `checkCorrectTiles` should highlight the tiles if the rows/columns form a valid line according to `lineIsCorrect`. If 3 rows or columns are done, the game should be declared won.
- Test `ChengYuSwappingViewModel` and `CiHuiSwappingViewModel`
- `init` should set the total time given, the phrases taken from the `gameData` and the number of rows given
- `swapTiles` should run `checkCorrectTiles` if the tile slide is successful

##### Test implementations of view controllers

- Test `SquareGridViewController`
- `allTiles`:
Should return all the tiles that are currently stored in this view.

- `allDisplayedTiles`:
Should return all the tiles that are currently displayed in this view.

- `allCoordinates`:
Should return all the coordinates that are used for this collection view.

- `segueWith(initialData, numRows, numCols, space)`:
correct number of rows and columns is displayed in the square tiles grid along with the initial data being displayed. If space is supplied, the grid should be presented with space between each tile.

- `update(collectionData)` and `reload(cellsAt ...)`:
by calling update, the stored data in this view controller is updated, but not displayed. Upon calling reload should display the data.

- `getCoordinate(at position/from tile)`:
gets the correct cell coordinate at the appropriate view coordinates.
If invalid position/tile is supplied, should return nil.

- `getCell(at coordinate)`:
gets the correct viewcell at the specifed coordinate.
If invalid coordinate is supplied, should return nil.

- `getFrame(at coordinate)`:
gets the cell frame at the specified coordinate.
If invalid coordinate is supplied, should return nil.

- `getCenter(from coordinate)`:
gets the cell center point at the specified coordinate.
If invalid coordinate is supplied, should return nil.

- `addTileOntoCollectionView(...)`:
Should attach a tile view onto the collection view controller.

- `bringTileToFront(...)`:
If tile is found in the collection view, should bring this view to the front.

- Test `DraggableSquareGridViewController`:
- `detachedTiles`:
Should be tested with other methods. When any detached method is called, the supplied view should be included here.
When any reattach method is called, the supplied view should be removed from here.

- `allTiles/DisplayedTiles`:
Verify that it includes `detachedTiles`.

- `canRepositionDetachedTileToCoord/Position`:
Verify that when any move/snap/reattach method is called, this method is being called.

- `detach` methods:
Should only cause the tiles to be removed from the cell (if needed) and placed right on the collection view. 

- `move/snapDetachedTile(...)`:
by calling detached, move and then snap, grid tiles on the screen is able to move freely in the view controller at the specified position, and then gets snapped into the grid.
- Should not be reattached to a particular cell in the grid.
- If detach method is not called, the view should not be movable with this method.
- If a callback is specified, should be called when the action is done.

- `reattachDetachedTile(...)`:
the specified tile should be removed from the grid collection view and place inside the view cell at specified coordinate.
- If detach method is not called, should result in no-op.

- Test `DiscreteFallableSquareGridViewController`:
- `onFallingTileRepositioned/Landed`:
verify that these two methods are called when the tile repositions/ completes landing.

- `fallingTile`, `fallingTileCoord`, `hasFallingTile`:
if there is a falling tile on display, should return that tile, along with the associated information about it's coordinate, and whether is it present.

- `startFallingTiles(interval)`:
when called, the falling tile (if any) in the view should start falling with the specified interval.

- `pauseFallingTile()`:
when called, verify that all tiles should stop falling.

- `setFallingTile(...)`:
verify that it creates and places a falling tile at the specified coordinate.
if there is a falling tile that has yet to land, should throw an assertion error.

- `shiftFallingTile(...)`:
the falling tile (if any) should shift one step to the specifed direction described in the `Direction` enum.

- `landFallingTile(...)`:
lands the falling tile by attaching to the grid in the specified coordinat, and vacate the `fallingTile` property (set to nil).

- Test `GameStatisticsViewController`:
- `currentScore` should be reflected on the view when initialised and updated.
- `timeLeft` should be reflected on the view when initialised and updated.

- Test `SwappingGameViewController`:
- `segueWith(viewModel)`:
assuming that a mock view model associated with this view controller is instantiated, this view should display the appropriate chinese characters on the grid with the time remaining and starting score.

- `onBackPressed`: 
this view should be dismissed. Warning dialog may be added in the future.

- `onTilesDragged`:
should correctly emulate the drag and drop action of the tiles. Starts game when necessary. Specifically:
- if the tile lands on another tile, both tiles should switch position (integration test with VM).
- if the tile lands on nowhere else, and itself, returns to original position.

- Test `update` and `redisplay` via `GridGameViewControllerDelegate`:
This is tested together with VM via integration testing, where a command by the VM to update and subsequently redisplay the data should be reflected on the view controller's screen. For example, grid data, score and time remaining.

- Test `TetrisGameViewController`:
- `segueWith(viewModel)`:
assuming that a mock view model associated with this view controller is instantiated, this view should display the appropriate chinese characters on the tetris grid with upcoming tiles, time remaining and starting score.

- `tapHandler(recogniser)`:
When user interacted, if there is a falling tile and not obstructed, shifts to the left or the right. This also causes the game to start if not done so.

- `onBackPressed`: 
this view should be dismissed. Warning dialog may be added in the future.

- Test `update` and `redisplay` via `TetrisGameViewControllerDelegate`:
This is tested together with VM via integration testing, where a command by the VM to update and subsequently redisplay the data should be reflected on the view controller's screen. For example, tetris grid data, score and time remaining.

- Test `SlidingGameViewController`:
- `segueWith(viewModel)`:
assuming that a mock view model associated with this view controller is instantiated, this view should display the appropriate characters on the grid, with one or more empty cells (no tiles).

- `onBackPressed`: 
this view should be dismissed. Warning dialog may be added in the future.

- `onTileDragged`:
should emulate the process of tiles dragging and dropping to the cells without any tiles. Note that it should be locked to only horizontal and vertical directions, and should not proceed further if it is blocked by other tiles.

- Test `update` and `redisplay` via `SlidingGameViewControllerDelegate`:
This is tested together with VM via integration testing, where a command by the VM to update and subsequently redisplay the data should be reflected on the view controller's screen. For example, grid data, score and time remaining.

- Test `animateTiles([(coordToExplode, coordToShift)])`:
Should animate the tiles being exploded and tiles being shifted to the specified coordinates in sequential order governed by the array.

- Across the three view controllers:
- Test end game state: When the view model declares a win/lost to the game via delegate callback, the view controller should display it as appropriate.
