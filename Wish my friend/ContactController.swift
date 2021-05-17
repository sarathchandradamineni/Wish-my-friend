import UIKit
import Contacts

struct Section
{
    let title: String
    let contactList: [ContactOption]
}
struct ContactOption
{
    let name: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
}
class ContactController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var contacts = [Section]()
    var contactManager:ContactManager? = nil
    let store = CNContactStore()
    var all_contacts_extracted: [ContactData] = []
    var sectionArray: [String] = []
    var contactsInSectionDict = [String: [ContactOption]]()
    let randomColor: [UIColor] = [.systemBlue, .systemRed, .systemPink, .systemGray, .systemGreen, .systemYellow]
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        getContactsList()
        arrangeSections()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsInSectionDict[sectionArray[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        let each_contact = contacts[indexPath.section].contactList[indexPath.row]
        let each_contact = contactsInSectionDict[sectionArray[indexPath.section]]![indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath
        ) as? ContactTableViewCell else{
            return UITableViewCell()
        }
        cell.configure(with: each_contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sectionArray[section]
        return section
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let eachContact = contacts[indexPath.section].contactList[indexPath.row]
    }
    
    func configure()
    {
        contacts.append(Section(title: "A", contactList:[
            ContactOption(name: "Sarath", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink),
        ContactOption(name: "Chandra", icon: UIImage(systemName: "cloud"), iconBackgroundColor: .systemRed),
        ContactOption(name: "Damineni", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemBlue),
        ContactOption(name: "Wolfgang", icon: UIImage(systemName: "contact"), iconBackgroundColor: .systemGray),
        ]))
        
        contacts.append(Section(title: "B", contactList:[
            ContactOption(name: "Sarath", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink),
        ContactOption(name: "Chandra", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemRed),
        ContactOption(name: "Damineni", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemBlue),
        ContactOption(name: "Wolfgang", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemGray),
        ]))
        
        contacts.append(Section(title: "C", contactList:[
            ContactOption(name: "Sarath", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink),
        ContactOption(name: "Chandra", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemRed),
        ContactOption(name: "Damineni", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemBlue),
        ContactOption(name: "Wolfgang", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemGray),
        ]))
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
        
        for con in contact
        {
            
            var contact_image = UIImage(systemName: "person")
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
            
            let each_contact = ContactData(image: contact_image!, first_name: con.givenName, last_name: "", day: 0, month: 0, year: 0, phone_num: phone_num)
            
            all_contacts_extracted.append(each_contact)
        }
    }
    
    func arrangeSections()
    {
        print("arrange sections method")
        for con in all_contacts_extracted
        {
            let firstLetter = con.first_name.prefix(1).lowercased()
            if !sectionArray.contains(firstLetter)
            {
                sectionArray.append(firstLetter)
            }
        }
        sectionArray.sort()
        print(sectionArray)
        
        for val in sectionArray
        {
            contactsInSectionDict[val] = []
        }
        
        for con in all_contacts_extracted
        {
            let firstLetter: String = con.first_name.prefix(1).lowercased()
            contactsInSectionDict[firstLetter]?.append(ContactOption(name: con.first_name, icon: con.image, iconBackgroundColor: randomColor[Int.random(in: 0..<6)]))
        }
    }
}
