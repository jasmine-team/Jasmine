import Foundation
import UIKit

class PhrasesTableViewDelegate: NSObject, UITableViewDelegate {
    var viewModel: PhrasesExplorerViewModel!
    var tableView: UITableView!

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggle(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
