Pod::Spec.new do |s|

  s.name         = "MYNStickyFlowLayout"
  s.version      = "0.1.2"
  s.summary      = "Drop-in sticky headers and footers for UICollectionView."

  s.description  = <<-DESC
                   UITableView-like sticky section headers and footers for UICollectionView.
                   Just install and set your FlowLayout Custom Class to MYNStickyFlowLayout
                   DESC

  s.homepage     = "http://github.com/sprylab/MYNStickyFlowLayout"
  s.screenshot   = "https://raw.githubusercontent.com/sprylab/MYNStickyFlowLayout/master/Images/Screenshot.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Param Aggarwal" => "paramaggarwal@gmail.com" }
  s.platform     = :ios
  s.requires_arc = true
  s.source       = { :git => "https://github.com/sprylab/MYNStickyFlowLayout.git", :tag => "v0.1.2" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

end
