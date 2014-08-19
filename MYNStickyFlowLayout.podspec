Pod::Spec.new do |s|

  s.name         = "MYNStickyFlowLayout"
  s.version      = "0.0.1"
  s.summary      = "Drop-in sticky headers and footers for UICollectionView."

  s.description  = <<-DESC
                   UITableView-like sticky section headers and footers for UICollectionView.
                   Just install and set your FlowLayout Custom Class to MYNStickyFlowLayout
                   DESC

  s.homepage     = "https://github.com/paramaggarwal/MYNStickyFlowLayout"
  s.license      = "MIT"
  s.author       = { "Param Aggarwal" => "paramaggarwal@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/paramaggarwal/MYNStickyFlowLayout.git" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

end
