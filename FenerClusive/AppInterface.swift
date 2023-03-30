//
//  AppInterface.swift
//  FenerClusive
//
//  Created by Seyfettin on 29/03/2023.
//

import UIKit

public class AppInterface {
    public static func startApp(_ viewController:UIViewController, token:String) {
        let targetVC = CampaignViewController(token: token)
        targetVC.modalPresentationStyle = .overFullScreen
        viewController.present(targetVC,animated: true, completion: nil)
    }
}
