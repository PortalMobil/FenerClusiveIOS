Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "FenerClusive"
s.summary = "FenerClusive module."
s.requires_arc = true

# 2
s.version = "1.0.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Seyfettin" => "mobilops@portalgrup.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/PortalMobil/FenerClusiveIOS"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/PortalMobil/FenerClusiveIOS.git", 
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "FenerClusive/**/*.{swift}"

# 9
s.resources = "FenerClusive/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "5"

end
