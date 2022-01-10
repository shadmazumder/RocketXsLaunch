# RocketXsLaunch
This app will list and show small details of successful SpaceX launches.

The first screen will contain all the successful SpaceX launches. Users can filter this list based on three categories: All, 2020, 2021.

The second screen will provide the details of a selected rocket.

**Installation**
1. Clone the reporisitory.
2. From the parent directory move to the _RocketXsLaunch_ directory, `cd RocketXsLaunch`
3. `pod install`

**Used API**
1. [Launch list](https://api.spacexdata.com/v4/launches)
2. [Rocket details](https://api.spacexdata.com/v4/rockets/:id)

**Note**
1. Till this project, I had not used Reactive Programming before on the iOS ecosystem. I did a single project on RN(React Native), which was my reactive programming experience. So this project will also help me know more about reactive programming in the iOS ecosystem.
2. Also, I never used Alamofire before this project. I always built my HTTPClient.

**Used library**
1. [Alamofier](https://github.com/Alamofire/Alamofire) as HTTPClient
2. [AlamofireImage](https://github.com/Alamofire/AlamofireImage) as Remote iamge downloader
3. [RxSwift](https://github.com/ReactiveX/RxSwift) & RxCocoa for data binding.

**Requirements**
1. Swift-based app.
2. Usage of MVVM architecture.
3. Storyboard and auto layout for UI stuff.
4. Unit tests for App logic.
5. RxSwift for Data binding between View and ViewModel.
6. Dependency Injection.
