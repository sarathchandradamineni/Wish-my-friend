//
//  WishesLoader.swift
//  Good Friend
//
//  Created by Sarath Chandra Damineni on 05/03/2021.
//

import Foundation

public class WishesLoader
{
    @Published var wishes = [WishesStructure]()
    
    init() {
        load()
    }
    
    func load()
    {
        print("load fun of wishes loader")
        if let file_location = Bundle.main.url(forResource: "wishes", withExtension: "json")
        {
            do{
                let data = try Data(contentsOf: file_location)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([WishesStructure].self, from: data)
                
                self.wishes = dataFromJson
            }
            catch{
                print("error reading JSON")
            }
        }
        else
        {
            print("JSON file not opened")
        }
    }
    
}
