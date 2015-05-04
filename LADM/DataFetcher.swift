//
//  DataFetcher.swift
//  LADM
//
//  Created by Josh Carter on 5/3/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//


import UIKit

class DataFetcher
{
    let baseURL = "http:localhost:8080/LADM/"
    
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
    
    private func requestData(city:String, element:String) -> Dictionary<String,AnyObject> {
        return (parseJSON(getJSON(baseURL + city + "/" + element)) as? Dictionary<String,AnyObject>)!
    }
    
    func getCitiesAndDates() -> Dictionary<String,Dictionary<String,String>> {
        return (parseJSON(getJSON(baseURL + "cities_dates")) as? Dictionary<String,Dictionary<String,String>>)!
    }
    
    func getCities() -> [String] {
        var citiesAndDates = getCitiesAndDates()
        var cities = [String]()
        
        for (key,obj) in citiesAndDates {
            cities.append(key)
        }
        return cities.sorted{ $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    }
    
    
}

class CityData
{
    let city:String!
    var competitionSchedule = Dictionary<String,Dictionary<String,String>>()
    var dailySchedule = Dictionary<String,Dictionary<String,Dictionary<String,Dictionary<String,String>>>>()
    var competitionResults = Dictionary<String,Dictionary<String,Dictionary<String,String>>>()
    var specialtyAwards = Dictionary<String,Dictionary<String,Dictionary<String,String>>>()
    let dataFetcher = DataFetcher()
    
    init(city:String) {
        self.city = city.lowercaseString
        getCompetitionSchedule()
        getDailySchedule()
        getCompetitionSchedule()
        getSpecialtyAwards()
        print(dailySchedule.count)
    }
    
    func refresh() {
        getCompetitionSchedule()
        getDailySchedule()
        getCompetitionSchedule()
        getSpecialtyAwards()
    }
    
    func getCompetitionSchedule() -> Dictionary<String,Dictionary<String,String>> {
        if competitionSchedule.count == 0 {
            if let data = dataFetcher.requestData(city,element: "competition_schedule") as? Dictionary<String,Dictionary<String,String>> {
                competitionSchedule = data
            }
        }
        return competitionSchedule
        
    }
    
    func getDailySchedule() -> Dictionary<String,Dictionary<String,Dictionary<String,Dictionary<String,String>>>> {
        if dailySchedule.count == 0 {
            if let data = dataFetcher.requestData(city, element: "daily_schedule") as? Dictionary<String,Dictionary<String,Dictionary<String,Dictionary<String,String>>>> {
                dailySchedule = data
            }
        }
        return dailySchedule
    }
    
    func getCompetitionResults() -> Dictionary<String,Dictionary<String,Dictionary<String,String>>> {
        if competitionResults.count == 0 {
            if let data = dataFetcher.requestData(city, element: "competition_results") as? Dictionary<String,Dictionary<String,Dictionary<String,String>>> {
                competitionResults = data
            }
        }
        return competitionResults
    }
    
    func getSpecialtyAwards() -> Dictionary<String,Dictionary<String,Dictionary<String,String>>> {
        if specialtyAwards.count == 0 {
            if let data = dataFetcher.requestData(city, element: "specialty_awards") as? Dictionary<String,Dictionary<String,Dictionary<String,String>>> {
                specialtyAwards = data
            }
        }
        return specialtyAwards
    }
    
    
}













