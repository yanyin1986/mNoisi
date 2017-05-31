//
//  MNCalendarTableViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 20/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import FSCalendar

class MNCalendarTableViewCell: UITableViewCell, FSCalendarDataSource, FSCalendarDelegate {
    public static let reuseIdentifier: String = "calendarCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
