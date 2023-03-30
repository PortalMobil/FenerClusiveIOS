//
//  Extensions.swift
//  FenerClusive
//
//  Created by Seyfettin on 30/03/2023.
//

import UIKit

extension Int? {
    var intValue: Int {
        self ?? 0
    }
}

extension Bool? {
    var trueValue: Bool {
        self ?? true
    }
    
    var falseValue: Bool {
        self ?? false
    }
}

extension UIImage {
    convenience init?(namedInModule named: String) {
        self.init(named: named, in: Bundle.module)
    }
    
    convenience init?(named: String, in bundle: Bundle) {
        if #available(iOS 13.0, *) {
            self.init(named: named, in: bundle, compatibleWith: .current)
        } else {
            self.init(named: named, in: bundle, compatibleWith: nil)
        }
    }
}

extension String {
    func getShortenNumber() -> String {
        if let value = Int(self), value >= 10000 {
            return "+\(value / 1000)k"
        }
        return self
    }
}
extension Bundle {
    static var module: Bundle = .init(for: CampaignViewController.self)
}

extension UIImageView {
    func load(url: URL?, completion:@escaping (UIImage?)->()) {
        DispatchQueue.global().async { [weak self] in
            if let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data)  {
                DispatchQueue.main.async {
                    self?.image = image
                    completion(image)
                }
            }else {
                DispatchQueue.main.async {
                    self?.image = UIImage(namedInModule: "no_image")
                    completion(nil)
                }
            }
        }
    }
}

extension UIView {
    func addShadowToView(
        shadowLayer: CAShapeLayer,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 0,
        spread: CGFloat = 0,
        fillColor: UIColor = UIColor.white,
        color: UIColor,
        opacity: Float,
        radius: CGFloat = 20
    ) {
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: x, height: y)
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = blur
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
        if layer.sublayers == nil || !layer.sublayers!.contains(shadowLayer) {
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    static var nib:UINib{
        get{
            UINib(nibName: identifier, bundle: Bundle.module)
        }
    }
    
    static var identifier: String {
        String(describing: self)
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
