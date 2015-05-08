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
    var studios = [String]()
    let dataFetcher = DataFetcher()
    
    init(city:String) {
        self.city = city.lowercaseString
        getCompetitionSchedule()
        getDailySchedule()
        getCompetitionResults()
        getSpecialtyAwards()
        getStudios()
        
        var x = filterCompetitionSchedule("Any Studio",age: "JR",category: "Any Category",day: "Any Day")
        println(x)
        println(x.count)
    }
    
    func getCompetitionSchedule() {
        if competitionSchedule.count == 0 {
            if let data = dataFetcher.requestData(city,element: "competition_schedule") as? Dictionary<String,Dictionary<String,String>> {
                competitionSchedule = data
            }
        }
    }
    
    func getDailySchedule()  {
        if dailySchedule.count == 0 {
            if let data = dataFetcher.requestData(city, element: "daily_schedule") as? Dictionary<String,Dictionary<String,Dictionary<String,Dictionary<String,String>>>> {
                dailySchedule = data
            }
        }
    }
    
    func getCompetitionResults() {
        if competitionResults.count == 0 {
            if let data = dataFetcher.requestData(city, element: "competition_results") as? Dictionary<String,Dictionary<String,Dictionary<String,String>>> {
                competitionResults = data
            }
        }
    }
    
    func getSpecialtyAwards() {
        if specialtyAwards.count == 0 {
            if let data = dataFetcher.requestData(city, element: "specialty_awards") as? Dictionary<String,Dictionary<String,Dictionary<String,String>>> {
                specialtyAwards = data
            }
        }
    }
    
    func getStudios() {
        for (key,item) in competitionSchedule {
            var studio = item["Studio Name"]!
            if find(studios,studio) == nil {
                studios.append(studio)
            }
        }
        studios.sort { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    }
    
    func filterCompetitionSchedule(studio:String, age:String, category:String, day:String) -> Dictionary<String,Dictionary<String,String>> {
        var data = Dictionary<String,Dictionary<String,String>>()
        for (var i = 1; i <= competitionSchedule.count;i++) {
            
            let selector = competitionSchedule[String(i)]!
            
            if studio != "Any Studio" {
                if selector["Studio Name"] != studio {
                    continue
                }
            }
            if age != "Any Age" {
                if selector["Age"] != age {
                    continue
                }
            }
            if category != "Any Category" {
                if selector["Category"] != category {
                    continue
                }
            }
            if day != "Any Day" {
                if selector["Day"] != day {
                    continue
                }
            }
            data[String(data.count)] = ["Age": selector["Age"]!, "Category": selector["Category"]!, "Day":selector["Day"]!, "Division": selector["Division"]!, "Routine ID and Name": selector["Routine ID and Name"]!, "Studio Name": selector["Studio Name"]!, "Time": selector["Time"]!]
        }
        
        return data
        
    }
    
}













