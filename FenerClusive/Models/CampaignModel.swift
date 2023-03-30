//
//  CampaignModel.swift
//  FenerClusive
//
//  Created by Seyfettin on 29/03/2023.
//

import Foundation

struct Campaign : Codable {
    
    let campaignExtraDetailsImage : String?
    let campaignTypeQuota : Int?
    let categoryIds : [Int]
    let company : String?
    let companyLogo : String
    let companyName : String?
    let descriptionField : String?
    let documentPublishFrom : String?
    let documentPublishTo : String?
    let endDate : String?
    var favoriteCount : Int
    let id : Int?
    let image : String
    var isFavorite : Bool
    let isJoined : Bool?
    var isSoonOver = false
    let isSoonOverPrefix : String?
    let joinedCount : Int?
    let memberTypeId : String?
    let remainingTime : String?
    let spotDescription : String?
    let spotImage : String
    let spotTitle : String?
    let startDate : String?
    let title : String?
    let type : String?
    let webID : Int?
    let whereToUseFaq : [String]?
    let whereToUseList : [String]?
    let workerTypeId : String?
    let companyDistance: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case campaignExtraDetailsImage = "CampaignExtraDetailsImage"
        case campaignTypeQuota = "CampaignTypeQuota"
        case categoryIds = "CategoryIds"
        case company = "Company"
        case companyLogo = "CompanyLogo"
        case companyName = "CompanyName"
        case descriptionField = "Description"
        case documentPublishFrom = "DocumentPublishFrom"
        case documentPublishTo = "DocumentPublishTo"
        case endDate = "EndDate"
        case favoriteCount = "FavoriteCount"
        case id = "Id"
        case image = "Image"
        case isFavorite = "IsFavorite"
        case isJoined = "IsJoined"
        case isSoonOver = "IsSoonOver"
        case isSoonOverPrefix = "IsSoonOverPrefix"
        case joinedCount = "JoinedCount"
        case memberTypeId = "MemberTypeId"
        case remainingTime = "RemainingTime"
        case spotDescription = "SpotDescription"
        case spotImage = "SpotImage"
        case spotTitle = "SpotTitle"
        case startDate = "StartDate"
        case title = "Title"
        case type = "Type"
        case webID = "WebID"
        case whereToUseFaq = "WhereToUseFaq"
        case whereToUseList = "WhereToUseList"
        case workerTypeId = "WorkerTypeId"
        case companyDistance = "CompanyDistance"
    }
    
    var isUnlimitedDate: Bool {
        endDate == AppConstant.unLimitedDateFormat
    }
    
    var isTimeOut: Bool {
        if isUnlimitedDate {
            return false
        }
        return remainingTime == "0"
    }
    
    var isGetCodeDisabled: Bool {
        isShowCode && isTimeOut
    }
    
    var isShowCode: Bool {
        type == "code" || isVodafone
    }
    
    var isShowNumber: Bool {
        type == "no"
    }
    
    var isVodafone: Bool {
        type == "vodafoneCode"
    }
    
    var isLiked: Bool {
        get {
            isFavorite
        } set {
            isFavorite = newValue
        }
    }

    var likeCount: Int {
        get {
            favoriteCount
        } set {
            favoriteCount = newValue
        }
    }
}

public enum AppConstant {
    public static let unLimitedDateFormat = "0001-01-01T00:00:00"
}
