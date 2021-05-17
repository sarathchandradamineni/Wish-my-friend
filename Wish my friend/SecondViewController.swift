//
//  SecondViewController.swift
//  Wish my friend
//
//  Created by Sarath Chandra Damineni on 2021-02-08.
//

import UIKit


class SecondViewController: UIViewController
{
    var name: String = ""
    var last_name: String = ""
    var wishes: [String] = []
    var contact: ContactData!
    var app_selected: String = ""
    var phone_num: String = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var wishes_items: [Wishes]?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var secondViewLabel: UILabel!
    @IBOutlet weak var secondViewImage: UIImageView!
    let defaults = UserDefaults.standard
    var json_wishes = [WishesStructure]()
    var family_wishes = [WishesStructure]()
    var love_wishes = [WishesStructure]()
    var profession_wishes = [WishesStructure]()
    var friends_wishes = [WishesStructure]()
    var result_wishes = [WishesStructure]()
    
    @IBOutlet weak var usEuZodiac: UIImageView!
    @IBOutlet weak var usEuZodiacLabel: UILabel!
    
    @IBOutlet weak var chineseZodiac: UIImageView!
    @IBOutlet weak var chineseZodiacLabel: UILabel!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Wish"
        self.hideKeyboardWhenTappedAround()
    
        setUsEuZodiac(date: contact.day, month: contact.month)
        setChineseZodiac(year: contact.year)
    
        name = contact.first_name
        last_name = contact.last_name
        secondViewLabel.text = contact.first_name
        secondViewImage.image = contact.image
        phone_num = contact.phone_num
        dateLabel.text = "Celebrating birthday on " + String(contact.day) + " " + getMonth(date: contact.month)
        secondViewImage.layer.masksToBounds = true
        secondViewImage.layer.cornerRadius = secondViewImage.bounds.width / 2
        
        
        json_wishes = WishesLoader().wishes
        result_wishes = json_wishes
        
        wishes = [
            "Dear Mr. " + last_name + " Happy Birthday! Kind regards, " + NSFullUserName(),
            "Dear Ms. " + last_name + " Happy Birthday! Kind regards, " + NSFullUserName(),
            "Dear Mr. " + last_name + " congratulations to your birthday. I wish you all the best for the new year in your life. Kind regards, " + NSFullUserName(),
            "Dear Ms. " + last_name + " congratulations to your birthday. I wish you all the best for the new year in your life. Kind regards, " + NSFullUserName(),
            "Hello Boss, Happy Birthday to you. I hope you have a great party today.  -" + NSFullUserName(),
            "Hi Baby, Happy Birthday to you. I hope you have lots of fun today…CU later for the party. Love " + NSFullUserName(),
            "Hi " + name + " Happy Birthday my friend. I hope you are doing great and have a wonderful celebration today. I hope to hear from you soon. All the best " + NSFullUserName()
        ]
    }
    
    
    func getMonth(date: Int) -> String
    {
        switch date
        {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return "Month"
        }
    }
    
    func setUsEuZodiac(date: Int, month: Int)
    {
        print("set us eu zodiac date is \(date) and month is \(month)")
        if((month == 1 && date >= 20) || (month == 2 && date <= 18))
        {
            usEuZodiac.image = UIImage(named: "aquariusZodiac")
            usEuZodiacLabel.text = "Aquarius(Jan 20 - Feb 18)"
        }
        else if((month == 2 && date >= 19) || (month == 3 && date <= 20))
        {
            usEuZodiac.image = UIImage(named: "piscesZodiac")
            usEuZodiacLabel.text = "Pisces(Feb 19 - Mar 20)"
        }
        else if((month == 3 && date >= 21) || (month == 4 && date <= 19))
        {
            usEuZodiac.image = UIImage(named: "ariesZodiac")
            usEuZodiacLabel.text = "Aries(Mar 21 - Apr 19)"
        }
        else if((month == 4 && date >= 20) || (month == 5 && date <= 20))
        {
            usEuZodiac.image = UIImage(named: "taurusZodiac")
            usEuZodiacLabel.text = "Taurus(Apr 20 - May 20)"
        }
        else if((month == 5 && date >= 21) || (month == 6 && date <= 20))
        {
            usEuZodiac.image = UIImage(named: "geminiZodiac")
            usEuZodiacLabel.text = "Gemini(May 21 - Jun 20)"
        }
        else if((month == 6 && date >= 21) || (month == 7 && date <= 22))
        {
            usEuZodiac.image = UIImage(named: "cancerZodiac")
            usEuZodiacLabel.text = "Cancer(Jun 21 - Jul 22)"
        }
        else if((month == 7 && date >= 22) || (month == 8 && date <= 22))
        {
            usEuZodiac.image = UIImage(named: "leo")
            usEuZodiacLabel.text = "Leo(Jul 23 - Aug 22)"
        }
        else if((month == 8 && date >= 23) || (month == 9 && date <= 22))
        {
            usEuZodiac.image = UIImage(named: "virgoZodiac")
            usEuZodiacLabel.text = "Virgo(Aug 23 - Sept 22)"
        }
        else if((month == 9 && date >= 23) || (month == 11 && date <= 22))
        {
            usEuZodiac.image = UIImage(named: "libraZodiac")
            usEuZodiacLabel.text = "Libra(Sept 23 - Oct 22)"
        }
        else if((month == 10 && date >= 23) || (month == 11 && date <= 21))
        {
            usEuZodiac.image = UIImage(named: "scorpioZodiac")
            usEuZodiacLabel.text = "Scorpio(Oct 23 - Nov 21)"
        }
        else if((month == 11 && date >= 21) || (month == 12 && date <= 21))
        {
            usEuZodiac.image = UIImage(named: "sagittariusZodiac")
            usEuZodiacLabel.text = "Sagittarius(Nov 22 - Dec 21)"
        }
        else if((month == 12 && date >= 22) || (month == 1 && date <= 19))
        {
            usEuZodiac.image = UIImage(named: "capricornZodiac")
            usEuZodiacLabel.text = "Capricorn(Dec 22 - Jan 19)"
        }
    }
    
    func setChineseZodiac(year: Int)
    {
        if(year == 0)
        {
            chineseZodiacLabel.text = "Year not availabale"
            chineseZodiac.image = UIImage(named: "notAvailable")
        }
        else if(year % 12 == 0)
        {
            chineseZodiac.image = UIImage(named: "monkeyChineseZodiac")
            chineseZodiacLabel.text = "Year of Monkey - \(year)"
        }
        else if(year % 12 == 1)
        {
            chineseZodiac.image = UIImage(named: "roosterChineseZodiac")
            chineseZodiacLabel.text = "Year of Rooster - \(year)"
        }
        else if(year % 12 == 2)
        {
            chineseZodiac.image = UIImage(named: "dogChineseZodiac")
            chineseZodiacLabel.text = "Year of Dog - \(year)"
        }
        else if(year % 12 == 3)
        {
            chineseZodiac.image = UIImage(named: "pigChineseZodiac")
            chineseZodiacLabel.text = "Year of Pig - \(year)"
        }
        else if(year % 12 == 4)
        {
            chineseZodiac.image = UIImage(named: "ratChineseZodiac")
            chineseZodiacLabel.text = "Year of Rat - \(year)"
        }
        else if(year % 12 == 5)
        {
            chineseZodiac.image = UIImage(named: "oxChineseZodiac")
            chineseZodiacLabel.text = "Year of Ox - \(year)"
        }
        else if(year % 12 == 6)
        {
            chineseZodiac.image = UIImage(named: "tigerChineseZodiac")
            chineseZodiacLabel.text = "Year of Tiger - \(year)"
        }
        else if(year % 12 == 7)
        {
            chineseZodiac.image = UIImage(named: "rabbitChineseZodiac")
            chineseZodiacLabel.text = "Year of rabbit - \(year)"
        }
        else if(year % 12 == 8)
        {
            chineseZodiac.image = UIImage(named: "dragonChineseZodiac")
            chineseZodiacLabel.text = "Year of dragon - \(year)"
        }
        else if(year % 12 == 9)
        {
            chineseZodiac.image = UIImage(named: "snakeChineseZodiac")
            chineseZodiacLabel.text = "Year of Snake - \(year)"
        }
        else if(year % 12 == 10)
        {
            chineseZodiac.image = UIImage(named: "horseChineseZodiac")
            chineseZodiacLabel.text = "Year of Horse - \(year)"
        }
        else if(year % 12 == 11)
        {
            chineseZodiac.image = UIImage(named: "sheepChineseZodiac")
            chineseZodiacLabel.text = "Year of Sheep(Ram) - \(year)"
        }
        print("setChineseZodiac \(year)")
    }
}
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

