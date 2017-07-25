//
//  MNCalendarTableViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 20/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNCalendarTableViewCell: UITableViewCell, FSCalendarDataSource, FSCalendarDelegate {
    public static let reuseIdentifier: String = "calendarCell"
    @IBOutlet weak var calendar: FSCalendar!

    var selectedDate: [Date] = [] {
        didSet {
            selectedDate.forEach { self.calendar.select($0, scrollToDate: false) }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
