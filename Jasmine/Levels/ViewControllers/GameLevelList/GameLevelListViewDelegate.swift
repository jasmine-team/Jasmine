import UIKit

protocol GameLevelListViewDelegate: class {

    /// Gets the number of levels.
    ///
    /// - Parameter isDefaultLevels: true if number of levels from default, false from custom.
    /// - Returns: the number of levels.
    func getNumberOfLevels(fromDefault isDefaultLevels: Bool) -> Int

    /// Gets a specific level data from the specific index in an ordered list.
    ///
    /// - Parameter isDefaultLevels: true if levels from default, false from custom.
    /// - Returns: the specific level data from the specified index.
    /// - Precondition: index should range from 0 to `getNumberOfLevels`.
    func getLevel(fromDefault isDefaultLevels: Bool, at index: Int) -> GameInfo

    /// Asks the user of this view controller if the level should be mark as selected.
    /// - Parameters:
    ///   - isDefaultLevels: true if the level comes from the default list, false from custom list.
    ///   - index: index of the level in the array.
    /// - Returns: true if the level should be marked.
    func shouldMarkAsSelected(fromDefault isDefaultLevels: Bool, at index: Int) -> Bool

    /// Notifies the user of this view controller that a level has been selected.
    /// - Parameters:
    ///   - isDefaultLevels: true if the level comes from the default list, false from custom list.
    ///   - index: index of the level in the array.
    func notifyLevelSelected(fromDefault isDefaultLevels: Bool, at index: Int)

    /// Notifies the user of this view controller to open the list of menu for the specified level.
    /// - Parameters:
    ///   - isDefaultLevels: true if the level comes from the default list, false from custom list.
    ///   - index: index of the level in the array.
    ///   - view: the associated view that opens this menu.
    func notifyOpenMenuForLevel(fromDefault isDefaultLevels: Bool, at index: Int, withView view: UIView)
}
