//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 14/12/2021.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func briefOverview() -> String {
        if let range = self.range(of: "。") {
            let substring = self[...range.lowerBound]
            return String(substring)
        } else {
            return self
        }
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            return "即將在\(month)月\(day)日上線"
        } else {
            return self
        }
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            
            return "\(month)月"
        } else {
            return self
        }
    }
    
    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            
            return "\(day)"
        } else {
            return self
        }
    }

    /// Email Validation
    func emailValidation() -> Bool {
        // One or more characters followed by an "@",
        // then one or more characters followed by a ".",
        // and finishing with one or more characters
        let emailRegularExpression = #"^\S+@\S+\.\S+$"#
        
        // so result is a Range<String.Index>
        let result = self.range(
            of: emailRegularExpression,
            options: .regularExpression
        )

        return result != nil
    }
    
    /// Password Validation
    func passwordValidation() -> Bool {
        let passwordRegularExpression =
        // At least 8 characters
//        #"(?=.{8,})"# +
        #"(?=.{8,})"#
        
        // At least one digit
//        #"(?=.*\d)"#
        
        // so result is a Range<String.Index>
        let result = self.range(
            of: passwordRegularExpression,
            options: .regularExpression
        )
        
        return result != nil
    }
}
