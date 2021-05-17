//
//  ContactManager.swift
//  Good Friend
//
//  Created by Sarath Chandra Damineni on 2021-04-29.
//
import UIKit
import Contacts
import Foundation
class ContactManager
{
    let store = CNContactStore()
    public var all_contacts_extracted: [ContactData] = []
    
    init()
    {
        let authorize = CNContactStore.authorizationStatus(for: .contacts)
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
                
                all_contacts_extracted.append(each_contact)
            }
        }
    }
}
