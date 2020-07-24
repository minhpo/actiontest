# Example code for Action

## Introduction
This project was written in 6 weeks time as a MVP. Design and functional specification was worked as the project progresses. The current result is a working prototype which you can interact with (without connection to any backend). One of the requirements/focus was animations as eye candy for the end-users. For this reason the projects contains lots of (interactive) animations/transitions.

## Scope
The scope of the MVP in it's current form only considers the front-end. So no connection to back-end is yet implemented as this was not available at the time of development. Testing (Unit and Snapshots) are not included as UI and UX was worked out as project progresses. Due to time and budget constraints it was left out of scope.

## Installation

Install dependencies
```sh
$ carthage bootstrap --platform iOS --cache-builds
```

When the dependencies are installed, you should be able to build and run the project.

## Technical details

### Dependencies
The code uses carthage for dependency management and has included the following frameworks:
* EasyPeasy - for setting constraints using a cleaner api
* Kingfisher - for downloading and caching retrieved image
* SwiftKeychainWrapper - to persist values between installations

### Implementation

#### Architecture
The project follows the [Clean Swift (VIP)](https://clean-swift.com/) architecture. In my opinion this architecture separates components with clear boundaries of scope.

#### Testing
While testing was left out, the code is still written as if it was included. 

For unit testing, dependency injection (mainly constructor injection) is supported to facilitate testing whenever it is desired. In addition protocol oriented programming is used enables injection of test doubles.

For snapshot testing, the views are implemented programmatically. While this is not strictly required for this kind of testing, it is easier to see how a view is setup and easier to keep track of changes. This is also the main reason why Storyboards and Xib files are not considered as the resulting xml-files are difficult to read and prone to conflicts when working on it with a team and using version control.

#### Futher points of interests
* Use of generics to construct a reusable `CardView` with different content
* Heavy use of `UIViewControllerAnimatedTransitioning` for both interactive animations and custom animated transitions (both in modal presentation as well as pop/push) 