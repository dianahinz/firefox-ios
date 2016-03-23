/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit
import Storage

class HistoryTableViewHeader: SiteTableViewHeader {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        topBorder.backgroundColor = UIColor.whiteColor()
        bottomBorder.backgroundColor = SiteTableViewControllerUX.HeaderBorderColor

        titleLabel.font = DynamicFontHelper.defaultHelper.DeviceFontSmallLight
        contentView.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HistoryTableViewController: SiteTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(HistoryTableViewCell.self, forCellReuseIdentifier: super.CellIdentifier)
        tableView.registerClass(HistoryTableViewHeader.self, forHeaderFooterViewReuseIdentifier: super.HeaderIdentifier)
    }
}