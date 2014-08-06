Pod::Spec.new do |s|

  git_tag         = '1.1.0'

  s.name          = "BlurryModal"
  s.version       = git_tag
  s.summary       = "A custom segue for providing a blurred overlay effect."
  s.description   = <<-DESC
                   BlurryModalSegue is a UIStoryboardSegue subclass that provides a blur effect for Modal storyboard segues.
                   DESC
  s.homepage      = "https://github.com/Citrrus/BlurryModalSegue"
  s.screenshots   = "https://raw.github.com/Citrrus/BlurryModalSegue/#{git_tag}/blurry_modal.gif"
  s.license       = 'MIT'
  s.author        = { "Matt Hupman" => "mhupman@citrrus.com" }
  s.platform      = :ios, '6.1'
  s.source        = { :git => "https://github.com/lammertw/BlurryModalSegue.git", :tag => git_tag }
  s.source_files  = 'BlurryModal'
  s.framework     = 'QuartzCore'
  s.requires_arc  = true
  s.dependency 'UIImage+BlurredFrame', '~> 0.0.4'
  s.dependency 'MZAppearance', '~>1.1.1'

end