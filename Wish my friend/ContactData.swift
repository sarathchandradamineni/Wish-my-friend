//
//  ContactData.swift
//  ContactsExtract
//
//  Created by Sarath Chandra Damineni on 2021-02-04.
//

import Foundation
import UIKit
import UserNotifications

public class ContactData
{
    var image: UIImage
    var first_name: String
    var last_name: String
    var day: Int
    var month: Int
    var year: Int
    var phone_num: String
    var days_remaining: Int = 0
    var today: Bool = false
    var notification_text: String
    
    //global variables for the date
    var cur_glb_date: Date? = nil
    var cur_glb_day: Int = 0
    var cur_glb_month: Int = 0
    var cur_glb_year: Int = 0
    var center: UNUserNotificationCenter? = nil
    
    init(image: UIImage, first_name: String, last_name: String, day: Int, month: Int, year: Int, phone_num: String)
    {
        self.image = image
        self.first_name = first_name
        self.last_name = last_name
        self.day = day
        self.month = month
        self.year = year
        self.phone_num = phone_num
        
        //creating the global current date and month variables
        cur_glb_date = Date()
        cur_glb_day = (cur_glb_date?.get(.day))!
        cur_glb_month = cur_glb_date!.get(.month)
        cur_glb_year = (cur_glb_date?.get(.year))!
        
        center = UNUserNotificationCenter.current()
        center!.requestAuthorization(options: [.alert, .sound])
            { (granted, error) in
        }
        
        if(year != 0)
        {
            let age_years = cur_glb_year - year
            notification_text = "\(first_name) is turning \(age_years) today"
        }
        else
        {
            notification_text = "\(first_name)`s birthday is today"
        }
//        registerNotification(month: self.month, date: self.day)
    }
    
    func registerNotification(month: Int, date: Int)
    {
        //create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Good friend"
        content.body = self.notification_text
                
        //create the trigger
        var dateComponent = DateComponents()
        dateComponent.hour = 13
        dateComponent.minute = 55
        dateComponent.second = 10
        dateComponent.month = self.month
        dateComponent.day = self.day
        
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
    
    func registerNotification(month: Int, date: Int, hour: Int, minute: Int, second: Int)
    {
        
    }
}

