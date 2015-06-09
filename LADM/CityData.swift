//
//  CityData.swift
//  LADM
//
//  Created by Josh Carter on 5/12/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit


class CityData
{
    let city:String!
    var competitionSchedule = Dictionary<String,Dictionary<String,String>>()
    var dailySchedule = Dictionary<String,Dictionary<String,Dictionary<String,Dictionary<String,String>>>>()
    var competitionResults = Dictionary<String,Dictionary<String,Dictionary<String,String>>>()
    var specialtyAwards = Dictionary<String,Dictionary<String,Dictionary<String,String>>>()
    var favorites = [String]()
    var studios = [String]()
    var ages = [String]()
    var categories = [String]()
    let dataFetcher = DataFetcher()

    
    var x :AnyObject?
    
    init(city:String) {
        self.city = city.lowercaseString
        getCompetitionSchedule()
        getDailySchedule()
        getCompetitionResults()
        getSpecialtyAwards()
        getStudios()
        getCategories()
        getAges()
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
    
    func getCategories() {
        for (key,item) in competitionSchedule {
            var category = item["Category"]!
            if find(categories,category) == nil {
                categories.append(category)
            }
        }
        categories.sort { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
    }
    
    func getAges() {
        for (key,item) in competitionSchedule {
            var age = item["Age"]!
            if find(ages,age) == nil {
                ages.append(age)
            }
        }
        ages.sort { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
    }
    
    func filterDailySchedule(day:String, group:String) -> [ScheduleItem]{
        if group == "Group" {
            return [ScheduleItem]()
        }
       var data = [ScheduleItem](count: dailySchedule[day]![group]!.count, repeatedValue: ScheduleItem(group: "a", time: "b", faculty: "c", event: "c", info: "d", day: "e"))
        
        for (num,val) in dailySchedule[day]![group]! {
            let time = val["Time"]!
            let faculty = val["Faculty"]!
            let event = val["Event"]!
            let info = val["Extra Information"]!
            let item = ScheduleItem(group: group, time: time, faculty: faculty, event: event, info: info, day: day)
            data[num.toInt()!] = item
        }
        return data
    }
    
    func filterCompetitionSchedule(studio:String, age:String, category:String, day:String) -> Dictionary<String,Dictionary<String,String>> {
        var data = Dictionary<String,Dictionary<String,String>>()
        for (var i = 1; i <= competitionSchedule.count;i++) {
            
            let dataPoint = competitionSchedule[String(i)]!
            
            if studio != "Any Studio" {
                if dataPoint["Studio Name"] != studio {
                    continue
                }
            }
            if age != "Any Age" {
                if dataPoint["Age"] != age {
                    continue
                }
            }
            if category != "Any Category" {
                if dataPoint["Category"] != category {
                    continue
                }
            }
            if day != "Any Day" {
                if dataPoint["Day"] != day {
                    continue
                }
            }
            data[String(data.count + 1)] = ["Age": dataPoint["Age"]!, "Category": dataPoint["Category"]!, "Day":dataPoint["Day"]!, "Division": dataPoint["Division"]!, "Routine ID and Name": dataPoint["Routine ID and Name"]!, "Studio Name": dataPoint["Studio Name"]!, "Time": dataPoint["Time"]!]
        }
        return data
    }
    
    func saveFavorites(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(favorites, forKey: "favorites")
    }
    
    func loadFavorites(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedFavorites = defaults.arrayForKey("favorites") as? [String] {
        favorites = savedFavorites
        }
    }
    
}
