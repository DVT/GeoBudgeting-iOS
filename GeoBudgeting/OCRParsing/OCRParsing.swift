//
//  OCRParsing.swift
//  GeoBudgeting
//
//  Created by Meir Rosendorff on 2019/05/09.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

//Checks for double in a string and returns it if there is one
extension StringProtocol {
    var double: Double? {
        return Double(self)
    }
}

//Fancy Magical shit I found online that lets me check for a date in a string
//Not sure how it works...
extension String {
    var nsString: NSString { return self as NSString }
    var length: Int { return nsString.length }
    var nsRange: NSRange { return NSRange(location: 0, length: length) }
    var detectDates: Date? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        let matches = detector?.matches(in: self, options: [], range: NSMakeRange(0, self.utf16.count))
        return matches?.last?.date
    }
}

extension Collection where Iterator.Element == String {
    var dates: [Date] {
        return compactMap{$0.detectDates}.compactMap{$0}
    }
}

//Extracts matches for regex statement from a text
//Source https://stackoverflow.com/questions/27880650/swift-extract-regex-matches
func matches(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

//Returns the total spent from the recveipt, takes in an array of lines
func getTotal(lines: [String]) -> Double{
    //Unit of currency
    let unit: String  = "r"
    
    //totalSpent is -1 so that if there is a return of a total of -1 we know no total was found
    var totalSpent: Double = -1.0
    for line in lines{
        if line.contains("total"){
            //when a line containing total is found
            //split on spaces
            //check each section if it contains a number
            let totalLine: [String] = line.components(separatedBy: " ")
            for curr in totalLine{
                //get rid of the currency unit
                let section = curr.replacingOccurrences(of: unit, with: "")
                if let value = section.double{
                    //Only use the bigest number incase there are multiple
                    //lines containing total or multiple numbers in the total line
                    if value > totalSpent{
                        totalSpent = value
                    }
                }
            }
        }
    }
    
    return totalSpent
}

func cleanTel(tel: String) -> String{
    
    let toRemove: [String] = ["-", "(", ")", " "]
    
    let prefix = "+27"
    
    var output = tel
    for char in toRemove{
        output = output.replacingOccurrences(of: char, with: "")
    }
    
    //removes the 0 at the begining before adding prefix
    output.remove(at: output.startIndex)
    
    output = prefix + output
    
    return output
}

//Returns the total spent from the recveipt,
//takes in an array of lines and the full text of the receipt
func getTel(lines: [String], receiptText: String) -> String {
    var tels: [String] = []
    var tel: String = ""
    
    if receiptText.contains("tel"){
        for line in lines{
            if line.contains("tel"){
                tels = matches(for: #"\(?\d{3,4}\)?[-, ]\d{3}[-, ]\d{4}"#, in: line)
            }
        }
    }else{
        tels = matches(for: #"\(?\d{3,4}\)?[-, ]\d{3}[-, ]\d{4}"#, in: receiptText)
    }
    
    if tels.isEmpty{
        tel = ""
    }else{
        tel = cleanTel(tel: tels[0])
    }
    
    return tel
}

//Checks for the date and time in an array
//Returns and ?Date object cocomntaimning these
func getDate(lines: [String]) -> Date?{
    //String contains all the times and dates found in the text
    var dateString: String = ""
    
    
    for line in lines{
        
        //split the line on spacess
        let lineSections: [String] = line.components(separatedBy: " ")
        for section in lineSections{
            
            //if there is a date or time in the sectopn
            if section.detectDates != nil{
                //This is really ugly but it takes into account the fact that we are using an emperical
                //date format and the date converter is using an american this is relevant for dd/mm/yyyy and dd-mm-yyyy
                //so I read in the date in an american format and then write it to my date string in an emperical format
                //this swaps around the month and day so next time it is read it reads it correctly
                let formatterSlash = DateFormatter()
                formatterSlash.dateFormat = "MM/dd/yyyy"
                if let date = formatterSlash.date(from: section) {
                    formatterSlash.dateStyle = .short
                    formatterSlash.locale = Locale(identifier: "en_GB")
                    dateString = dateString + " " + formatterSlash.string(from: date)
                    continue;
                }
                
                let formatterDash = DateFormatter()
                formatterDash.dateFormat = "MM-dd-yyyy"
                if let date = formatterDash.date(from: section){
                    formatterDash.dateStyle = .short
                    formatterDash.locale = Locale(identifier: "en_GB")
                    dateString = dateString + " " + formatterDash.string(from: date)
                    continue;
                }
                //it only reaches this point if neither of the previous if statements evaluated True
                dateString = dateString + " " + section
            }
        }
    }
    
    //if a date is detected include the date in retrun else return null
    if let date: Date = dateString.detectDates{
        return date
    }else{
        return nil
    }
}

/*
 readReceiptText(receiptText : String) -> (name: String, total: Double, date: Date?)
 
 This function takes in a receipt and returns data about the receipt.
 
 -Parameters:
 recieptText: A string made up of the text from a reciept
 
 -Returns: Tuple containing (name, total, date)
 name:   the name of the venue as a String
 total:  the ammount that was spent as a double,
 date:   the date the transaction was made on as an optional Date
 tel: String containing phone number
 
 -Logic:
 It is assumed that the first line in the receipt is the venue.
 If no total is found -1 is returned.
 if no date is found then nul is returned
 
 */
func readReceiptText(receiptText : String) -> (name: String, total: Double, date: Date?, tel: String){
    
    //if no input return an empty output
    if (receiptText.isEmpty){
        return ("", -1, nil, "")
    }
    
    //Set the entire text to lowercase to avoid issues with case sensitivity
    let receipt: String = receiptText.lowercased()
    
    //Split Receipt into an array of lines
    var lines: [String] = []
    receipt.enumerateLines {
        line, _ in
        lines.append(line)
    }
    //Assume storename is the first line in the list
    let storeName: String = lines[0]
    
    let totalSpent: Double = getTotal(lines: lines)
    
    let tel: String = getTel(lines: lines, receiptText: receiptText)
    
    if let date: Date = getDate(lines: lines){
        return (storeName, totalSpent, date, tel)
    }else{
        return (storeName, totalSpent, nil, tel)
    }
    
}

