//
//  WishWithTextController.swift
//  Good Friend
//
//  Created by Sarath Chandra Damineni on 2021-05-11.
//

import UIKit

class WishWithTextController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var family_button: UIButton!
    @IBOutlet weak var love_button: UIButton!
    @IBOutlet weak var friends_button: UIButton!
    @IBOutlet weak var profession_button: UIButton!
    @IBOutlet weak var wishTableView2: UITableView!
    
    
    var result_wishes = [WishesStructure]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json_wishes = WishesLoader().wishes
        result_wishes = json_wishes
        
        family_button.layer.masksToBounds = true
        family_button.layer.cornerRadius = 15
        
        love_button.layer.masksToBounds = true
        love_button.layer.cornerRadius = 15
        
        friends_button.layer.masksToBounds = true
        friends_button.layer.cornerRadius = 15
        
        profession_button.layer.masksToBounds = true
        profession_button.layer.cornerRadius = 15
        
        wishTableView2.dataSource = self
        wishTableView2.delegate = self
        
        for wish in result_wishes
        {
            print(wish.text)
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result_wishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let wish_cell = wishTableView2.dequeueReusableCell(withIdentifier: "eachWishCell2") as! EachWishCell2
        wish_cell.wishLabelText.text = result_wishes[indexPath.row].text
        return wish_cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(result_wishes[indexPath.row].text)
    }
}
