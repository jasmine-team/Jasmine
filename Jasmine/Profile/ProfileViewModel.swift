import SwiftDate

class ProfileViewModel {

    /// the minimum number of game plays needed per day to count for the streak
    private static let minGamesPerDay = 1

    /// The number of days in a week for the current calendar
    let numOfDaysInAWeek: Int

    private let resultsQuery: ResultsQueryContainer

    /// Number of weeks to count for the weekly streak
    private let numWeeksToCount: Int

    /// Stores the current date to use across the functions
    private let currentDate: Date
    /// Stores the start date (Monday 12:00:00 AM) of the week 
    private let startOfWeek: Date

    init(numWeeksToCount: Int) throws {
        resultsQuery = try ResultsQueryContainer()
        self.numWeeksToCount = numWeeksToCount

        currentDate = Date()
        // Compute the start of the week
        // Not refactored into separate function to allow `startOfWeek` as `let` constant  
        let calendar = Calendar(identifier: .iso8601)
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
        guard let startOfWeek = calendar.date(from: dateComponents) else {
            fatalError("Unable to get start of the week")
        }
        self.startOfWeek = startOfWeek

        numOfDaysInAWeek = calendar.weekdaySymbols.count
    }

    /// Returns the number of days since the start of the week that has games played count >= `minGamesPerDay`
    var dailyStreakCount: Int {
        return getDailyStreakCount(startOfTheWeek: startOfWeek)
    }

    /// Returns an array containing the dailyStreakCount for the past `numWeeksToCount` weeks excluding the current week
    /// The array is ordered ascendingly from the count for the oldest week to the most recent week
    var weeklyStreakCounts: [Int] {
        return (1...numWeeksToCount).reversed().map { weekCount in
            getDailyStreakCount(startOfTheWeek: startOfWeek - weekCount.week)
        }
    }

    /// Returns the number of days from `startOfTheWeek` to 1 week from `startOfTheWeek` 
    /// that has games played count >= `minGamesPerDay`
    ///
    /// - Parameter startOfTheWeek: the date for the start of the week to start counting from
    /// - Returns: The number of days within 1 week of `startOfTheWeek` that has games played count >= `minGamesPerDay`
    private func getDailyStreakCount(startOfTheWeek: Date) -> Int {
        return (0..<numOfDaysInAWeek).filter { dayCount in
            let startDate = startOfTheWeek + dayCount.day
            let timesPlayed = resultsQuery.timesPlayed(from: startDate, toExclusive: startDate + 1.day)
            return timesPlayed >= ProfileViewModel.minGamesPerDay
        }.count
    }
}
