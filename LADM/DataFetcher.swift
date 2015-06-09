//
//  DataFetcher.swift
//  LADM
//
//  Created by Josh Carter on 5/3/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//


import UIKit
import Alamofire

class DataFetcher: UIDevice
{
    var baseURL: String!
    let device = UIDevice.currentDevice()

    override init(){
        if device.model == "iPhone Simulator" {
//            baseURL = "http:localhost:5000/LADM/"
            baseURL = "http://ladm-chanceofthat.rhcloud.com/LADM/"

        }
        else{
//            baseURL = "http://ladmtest.com/LADM/"
            baseURL = "http://ladm-chanceofthat.rhcloud.com/LADM/"
        }
    }

    
    private func getJSON(urlToRequest: String) -> NSData? {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)
    }
    
    private func parseJSON(inputData: NSData?) -> NSDictionary {
        var error: NSError?
        if(inputData == nil) {
            return NSDictionary()
        }
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData!, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
        
        return boardsDictionary
    }
    
    func requestData(city:String, element:String) -> Dictionary<String,AnyObject> {
        return (parseJSON(getJSON(baseURL + city + "/" + element)) as? Dictionary<String,AnyObject>)!
    }
    
    func getCitiesAndDates() -> Dictionary<String,AnyObject> {
        var citesAndDates = Dictionary<String,AnyObject>()
        citesAndDates = (parseJSON(getJSON(baseURL + "cities_dates")) as? [String: AnyObject])!
        return citesAndDates
    }
    
    func getCities() -> [String] {
        var citiesAndDates = getCitiesAndDates()
        var cities = [String]()
        
        for (key,obj) in citiesAndDates {
            cities.append(key)
        }
        return cities.sorted{ $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    }
    
    func postFavorite(city:String, routine:String, action:String) {
        Alamofire.request(.POST, baseURL + "favorites/" + city, parameters: ["user_id": UIDevice.currentDevice().identifierForVendor.UUIDString, "routine_id": routine,"action":action])
    }
    
    func getFavorites(id:String, city:String) {
        var data:[String]
        
        Alamofire.request(.GET, baseURL + "favorites/" + city + "/" + id)
    }
    
    
}














