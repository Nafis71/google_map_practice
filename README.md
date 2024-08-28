# Notice for API

> This app loads api key from android's local.properties file so that the google map api doesn't get exposed.

Go to android/local.properties <br />
1. Run pub get to generate local.properties
```
flutter pub get
```
2. Add this key inside the local.properties
```
MAPS_API_KEY=addApiKey
```
