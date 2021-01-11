//
//  Date+Extension.swift
//  NUTEE
//
//  Created by 오준현 on 2020/07/29.
//  Copyright © 2020 Nutee. All rights reserved.
//

import Foundation

extension Date {
    
    func timeAgoSince(_ date: Date) -> String {
       
        let calendar = Calendar.current
        let now = Date() - (60 * 60 * 9) // 서버시간이 9시간 밀려서 뺌
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 1 {
            return "\(year)년 전"
        }
                
        if let month = components.month, month >= 1 {
            return "\(month)달 전"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)주 전"
        }
                
        if let day = components.day, day >= 2 {
            return "\(day)일 전"
        }
        
        if let day = components.day, day >= 1 {
            return "어제"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)시간 전"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "한 시간 전"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second)초 전"
        }
        
        return "지금"

    }
    
}
