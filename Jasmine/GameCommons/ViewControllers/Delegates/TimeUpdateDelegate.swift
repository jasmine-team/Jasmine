protocol TimeUpdateDelegate: class {

    /// Tells the implementor of the delegate that the time has been updated.
    /// - Note: This method can be used to update the remaining time that is displayed on views.
    func timeDidUpdate()
}
