//
//  EachContactCell.swift
//  Wish my friend
//
//  Created by Sarath Chandra Damineni on 2021-02-05.
//

import UIKit


class EachContactCell: UITableViewCell {
    
    weak var delegate: EachContactCell?
    var contact_cell: ContactData? = nil
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactDOBLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var numberOfDays: UILabel!
    @IBOutlet weak var daysText: UILabel!
    
    //    @IBAction func wishButtonClick(_ sender: Any)
//    {
//        print("wish button click")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
