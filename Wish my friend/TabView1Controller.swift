//
//  ViewController.swift
//  Wish my friend
//
//  Created by Sarath Chandra Damineni on 2021-02-05.
//

import UIKit
import Contacts
import UserNotifications

class TabView1Controller: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var notification_text = ""
    @IBOutlet weak var contactTableView: UITableView!
    
    let store = CNContactStore()
    public var contacts_extracted: [ContactData] = []
    var contacts_sorted: [ContactData] = []
    var contact_selected: ContactData!
    var birthdays_today = 0
    var center: UNUserNotificationCenter? = nil
    
    //global variables for the date
    var cur_glb_date: Date? = nil
    var cur_glb_day: Int = 0
    var cur_glb_month: Int = 0
    var cur_glb_year: Int = 0
    
    var sections = [MonthSection]()
//    private let database = Database.database().reference()
    
    let object: [String: Any] = ["name": "Sarath" as NSObject,
                                 "Company": "Bosch"]
    
//    database.child("something").setValue(object)
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //creating the global current date and month variables
        cur_glb_date = Date()
        cur_glb_day = (cur_glb_date?.get(.day))!
        cur_glb_month = cur_glb_date!.get(.month)
        cur_glb_year = (cur_glb_date?.get(.year))!
        
        contactTableView.dataSource = self
        contactTableView.delegate = self
        
        let authorize = CNContactStore.authorizationStatus(for: .contacts)
        birthdays_today = 0
        
        if authorize == .notDetermined
        {
            store.requestAccess(for: .contacts)
            { (chk, error) in
                if error == nil
                {
                    self.getContactsList()
                }
            }
        }
        else if authorize == .authorized
        {
            print("contacts permission authorized")
            getContactsList()
        }
        
        contacts_sorted = sortDOB()
        
        sortDatesWithRespectToCurDay()
        
        calculateRemainingDays()
        
        todayBirthdayCount()
        
//      requesting for the notification
        center = UNUserNotificationCenter.current()
        center!.requestAuthorization(options: [.alert, .sound])
            { (granted, error) in
        }
        
        print("birthday count is ", (birthdays_today))
        
        for each_contact in contacts_sorted
        {
            if(each_contact.today)
            {
                throwNotification(each_contact: each_contact)
            }
        }
        createSections()
    }
    
//    to create the sections of months for the contacts sorted
    func createSections()
    {
        var prev_month = contacts_sorted[0].month
        var temp_section_contacts:[ContactData] = []
        
        for each_contact in contacts_sorted
        {
            var new_month = each_contact.month
            
            if(new_month != prev_month)
            {
                sections.append(MonthSection(month: prev_month, cells: temp_section_contacts))
                temp_section_contacts = []
                temp_section_contacts.append(each_contact)
                prev_month = new_month
            }
            else
            {
                temp_section_contacts.append(each_contact)
            }
        }
        
        if(temp_section_contacts.count != 0)
        {
            sections.append(MonthSection(month: temp_section_contacts[0].month, cells: temp_section_contacts))
        }
        
        for each_section in sections
        {
            print("\(each_section.month) lenght is \(each_section.cells.count)")
        }
    }
    
//    Calculate the remaining days for the birthday when compared to today
    func calculateRemainingDays()
    {
        //creating object for current day and month
        let to_day = NSDateComponents()
        to_day.day = cur_glb_day
        to_day.month = cur_glb_month
        to_day.year = cur_glb_year
        
        for each_contact in contacts_sorted
        {
            //creating the birthday components
            var birthday_components = NSDateComponents()
            birthday_components.day = each_contact.day
            birthday_components.month = each_contact.month
            //give the birthday year as current year since we are calculating the difference of days
            birthday_components.year = cur_glb_year
            
            //calculating the number of days remained
            let calender = Calendar.current
            var components = calender.dateComponents([.day], from: to_day as DateComponents, to: birthday_components as DateComponents)
            
            if(components.day ?? 0 < 0)
            {
                birthday_components.year = cur_glb_year + 1
                components = calender.dateComponents([.day], from: to_day as DateComponents, to: birthday_components as DateComponents)
            }
            
            each_contact.days_remaining = components.day!
        }
    }
    
//    Function to throw the notification
    func throwNotification(each_contact: ContactData)
    {
        //prepare the notification text
        prepareNotificationText(each_contact: each_contact)
        
        //create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Good friend"
        content.body = notification_text
                
        //create the trigger
        var dateComponent = DateComponents()
        dateComponent.hour = 15
        dateComponent.minute = 56
        dateComponent.second = 45
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                
        //creation of request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
        //register the request
        center?.add(request)
        {
            (error) in print("error in notification")
        }
    }
    
    func prepareNotificationText(each_contact: ContactData)
    {
        if(each_contact.year != 0)
        {
            let years = cur_glb_year - each_contact.year
            notification_text = "\(each_contact.first_name) is turning \(years) today"
        }
        else
        {
            notification_text = "\(each_contact.first_name)`s birthday is today"
        }
        
    }
    
    //counts the number of people celebrating the birthday today
    func todayBirthdayCount()
    {
        let date = Date()
        let cur_day = date.get(.day)
        let cur_month = date.get(.month)
        
        for each_contact in contacts_sorted
        {
            if(each_contact.month == cur_month && each_contact.day == cur_day)
            {
                each_contact.today = true
                birthdays_today = birthdays_today + 1
                notification_text = "\(notification_text) \(each_contact.first_name), "
            }
            else
            {
                each_contact.today = false
            }
        }
    }
    
//    Sorting the dates with respect to the current dates
    func sortDatesWithRespectToCurDay()
    {
        let date = Date()
        let cur_day = date.get(.day)
        let cur_month = date.get(.month)
        var number_of_days_removed:Int = 0
        let temp_contacts_sorted = contacts_sorted
        for each_contact in temp_contacts_sorted
        {
            if((each_contact.month < cur_month) || each_contact.month == cur_month && each_contact.day < cur_day)
            {
                contacts_sorted.append(each_contact)
                number_of_days_removed = number_of_days_removed+1
            }
        }
        
        for i in 0..<number_of_days_removed
        {
            contacts_sorted.remove(at: 0)
        }
    }
    
    //get months text from number
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
    
    // sort all the dae of births here
    func sortDOB() -> [ContactData]
    {
        let contact_unsorted = contacts_extracted
        var contact_sorted_temp: [ContactData] = []
        
        for month in 1...12
        {
            for day in 1...31
            {
                for each_contact in contact_unsorted
                {
                    if(each_contact.month == month)
                    {
                        if(each_contact.day == day)
                        {
                            contact_sorted_temp.append(each_contact)
                        }
                    }
                }
            }
        }
        
        return contact_sorted_temp
    }
    
    //display of contatcs
    func displayExtractedContacts()
    {
        print("display function\n")
        for each_contact in contacts_extracted
        {
            print("Fisrt name is \(each_contact.first_name)")
            print("Second name is \(each_contact.last_name)")
            print("Day is \(each_contact.day)")
            print("Month is \(each_contact.month)")
            print("Year is \(each_contact.year)")
            print("Phone number is \(each_contact.phone_num) \n")
        }
    }
    
    func getContactsList()
    {
        
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
        let contact = try! store.unifiedContacts(matching: predicate,
                                                 keysToFetch: [
                                                    CNContactBirthdayKey as CNKeyDescriptor,
                                                    CNContactFamilyNameKey as CNKeyDescriptor,
                                                    CNContactGivenNameKey as CNKeyDescriptor,
                                                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                                                    CNContactDatesKey as CNKeyDescriptor,
                                                    CNContactImageDataAvailableKey as CNKeyDescriptor,
                                                    CNContactImageDataKey as CNKeyDescriptor
                                                 ])
        let dat = DateFormatter()
        dat.dateFormat = "MM/dd/yyyy"
        
        for con in contact
        {
            
            var contact_image = UIImage(named: "no_pic")
            var phone_num = ""
            if con.imageDataAvailable
            {
                contact_image = UIImage(data: con.imageData!)
            }
            if(con.phoneNumbers.count != 0)
            {
                phone_num = con.phoneNumbers[0].value.stringValue
            }
            else
            {
                phone_num = "not available"
            }
            if(con.birthday != nil)
            {
                let day: Int = con.birthday?.day ?? 0
                let month: Int = con.birthday?.month ?? 0
                let year: Int = con.birthday?.year ?? 0
                let dobDt = Calendar.current.date(from: con.birthday!)
                
                
                let each_contact = ContactData(image: contact_image!,
                                               first_name: con.givenName,
                                               last_name: con.familyName,
                                               day: day,
                                               month: month,
                                               year: year,
                                               phone_num: phone_num)
                
                contacts_extracted.append(each_contact)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = contactTableView.dequeueReusableCell(withIdentifier: "eachContactCell") as! EachContactCell
        //setting the first and last name on the screen
        cell.contactNameLabel.text = sections[indexPath.section].cells[indexPath.row].first_name + " " + sections[indexPath.section].cells[indexPath.row].last_name
        //setting the date of birth on the screen
        
        //prepare the text for each cell
        let years = cur_glb_year - sections[indexPath.section].cells[indexPath.row].year
        if ( (cur_glb_month == sections[indexPath.section].cells[indexPath.row].month) && (cur_glb_day == sections[indexPath.section].cells[indexPath.row].day) )
        {
            if(sections[indexPath.section].cells[indexPath.row].year != 0)
            {
                cell.contactDOBLabel.text = "turns "+String(years)+" today"
            }
            else
            {
                cell.contactDOBLabel.text = "celebrates birthday today"
            }
            cell.contactDOBLabel.textColor = UIColor.orange
        }
        else
        {
            if(sections[indexPath.section].cells[indexPath.row].year != 0)
            {
                cell.contactDOBLabel.text = "turns "+String(years)+" on "+getMonth(date: sections[indexPath.section].cells[indexPath.row].month)+" "+String(sections[indexPath.section].cells[indexPath.row].day)
            }
            else
            {
                cell.contactDOBLabel.text = "birthday on "+getMonth(date: sections[indexPath.section].cells[indexPath.row].month)+" "+String(sections[indexPath.section].cells[indexPath.row].day)
            }
            cell.contactDOBLabel.textColor = UIColor.black

        }
        cell.contactImage.image = sections[indexPath.section].cells[indexPath.row].image
        cell.contactImage.layer.masksToBounds = true
        cell.contactImage.layer.cornerRadius = cell.contactImage.bounds.width / 2
        
        if((sections[indexPath.section].cells[indexPath.row].days_remaining) == 0)
        {
            cell.numberOfDays.text = "today"
            cell.daysText.text = ""
        }
        else
        {
            cell.numberOfDays.text = "\(sections[indexPath.section].cells[indexPath.row].days_remaining)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return getMonth(date: sections[section].month)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor(red: 0.811, green: 0.811, blue: 0.811, alpha: 1.00)
        
        let headerTitle = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width-20, height: 30))
        headerTitle.text = getMonth(date:  sections[section].month)
        headerView.addSubview(headerTitle)
        return headerView
    }
    
    @objc func wishButtonAction(sender: UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = contacts_sorted[indexPath.row]
        print("Please change myself " + cell.first_name)
        contact_selected = contacts_sorted[indexPath.row]
//        performSegue(withIdentifier: "segue_contact", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! SecondViewController
        vc.contact = contact_selected
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("button is pressed " + sections[indexPath.section].cells[indexPath.row].first_name)
        contact_selected = sections[indexPath.section].cells[indexPath.row]
        performSegue(withIdentifier: "segue_contact", sender: self)
    }
}
