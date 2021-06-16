# CryptoWatch
An iOS app that saves crypto the user is watching. Users can choose to be notified when a coin reaches a certain price.
## Demo
### Loading
![](static/loading.gif)
### Add crypto to watch list
![](static/adding.gif)
### Watch List & Notifications & Websocket in action
![](static/notification.gif)
## How It Works
* Network calls are made to [CoinAPI](https://www.coinapi.io/) to pull data on current cryptocurrencies
* Websocket calls are made to [FinnhubAPI](https://finnhub.io/) to pull price of crypto users are watching in real time
* The CoinCollectionController will have a collectionview populated by the list of crypto available from CoinAPI
* Users can save a coin they are watching into their watch list using Core Data
* Users can set a price point for each coin they are watching and the app will notify them when the coin reaches that price
## Installation
* Clone/Download the repo
* Install all dependencies using pod install
* Obtain an API key from [CoinAPI](https://www.coinapi.io/) and replace every "apiKey" variable with it
* Obtain an API key from [FinnhubAPI](https://finnhub.io/) and replace every "webSocketAPIKey" variable with it
## Tools
* Core Data
* [CoinAPI](https://www.coinapi.io/)
* [FinnhubAPI](https://finnhub.io/)
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [Snapkit](https://github.com/SnapKit/SnapKit)
