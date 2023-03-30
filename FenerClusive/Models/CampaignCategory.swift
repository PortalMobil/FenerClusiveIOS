//
//  CampaignCategory.swift
//  FenerClusive
//
//  Created by Seyfettin on 29/03/2023.
//

import Foundation

struct CampaignCategory : Codable {

    let id : Int
    let icon : String
    let name : String
    let status : Bool
    var isChecked = false


    enum CodingKeys: String, CodingKey {
        case id = "CampaignCategoriesID"
        case icon = "CampaignCategoryIcon"
        case name = "CampaignCategoryName"
        case status = "CampaignCategoryStatus"
    }
}
