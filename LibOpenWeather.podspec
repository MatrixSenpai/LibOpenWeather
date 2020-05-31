Pod::Spec.new do |spec|
    spec.name     = 'LibOpenWeather'
    spec.version  = '1.0.1'
    spec.license  = { :type => 'MIT', :file => 'LICENSE.md' }
    spec.homepage = 'https://github.com/MatrixSenpai/LibOpenWeather'
    spec.authors  = { 'MatrixSenpai' => 'math.matrix@icloud.com' }
    spec.summary  = 'A small lib for the OpenWeatherMap API'
    spec.source   = { :git => 'https://github.com/MatrixSenpai/LibOpenWeather.git', :tag => spec.version.to_s }
    
    spec.ios.deployment_target = '13.0'
    
    spec.source_files = 'Sources/api/*.swift'
    
    spec.dependency 'RxSwift'
end
