//
//  GridGameViewController.swift
//  Jasmine
//
//  Created by Xien Dong on 11/3/17.
//  Copyright © 2017 nus.cs3217. All rights reserved.
//

import UIKit

class GridGameViewController: UIViewController {

    /* Constants */
    fileprivate static let characterCellIdentifier = "Grid Game Character Cell"

    /// Provides a tolerance (via a factor of the expected size) so that 4 cells can fit in one row.
    fileprivate static let cellSizeFactor = CGFloat(0.9)

    /* Layouts */
    /// Keeps a 4 x 4 of chinese characters as individual cells.
    @IBOutlet fileprivate weak var charactersCollectionView: UICollectionView!

    /* Properties */
    /// Stores a list of Chinese characters, which serves as the data source for  
    /// `charactersCollectionView`.
    fileprivate var chineseChars: [Character]
        = ["天", "翻", "地", "覆", "天", "翻", "地", "覆"]

    /* View Controller Lifecycles */
    /// Readjusts layout (such as cell size) upon auto-rotate.
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        charactersCollectionView.performBatchUpdates(charactersCollectionView.reloadData,
                                                     completion: nil)
    }
}

// MARK: - Data Source for Characters Collection View
extension GridGameViewController: UICollectionViewDataSource {

    /// Tells the charactersCollectionView the number of cells to display.
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return chineseChars.count
    }

    /// Feeds the data (chinese characters) to the charactersCollectionView.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reusableCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GridGameViewController.characterCellIdentifier, for: indexPath)

        guard let characterCell = reusableCell as? GridCharacterViewCell else {
            fatalError("View Cell that extends from GridChrarcterViewCell is required.")
        }
        characterCell.chineseCharacter = chineseChars[indexPath.item]
        return characterCell
    }
}

// MARK: - Size of each Character View Cell
extension GridGameViewController: UICollectionViewDelegateFlowLayout {

    /// Sets the size of each cell in charactersCollectionView such that we have a 4x4 grid.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = charactersCollectionView.bounds.width / CGFloat(Constants.BoardGamePlay.columns)
            * GridGameViewController.cellSizeFactor

        return CGSize(width: length, height: length)
    }
}
