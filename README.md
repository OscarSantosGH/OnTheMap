#  On The Map

This is a networked app that pull data from a [**Udacity**](https://www.udacity.com/) web service to create a map with pins representing student locations. Tapping a pin will display a custom URL posted by a student at that location.

## Usage

To use the app you need a [**Udacity**](https://www.udacity.com/) account in order to login.

![login screen](https://github.com/OscarSantosGH/OnTheMap/blob/master/Images/login.jpg?raw=true "Login Screen")

## APIs

* [URLSession](https://developer.apple.com/documentation/foundation/urlsession) for networking.
* [Map Kit](https://developer.apple.com/documentation/mapkit) to show the map and pins.
* [CLGeocoder](https://developer.apple.com/documentation/corelocation/clgeocoder) for converting place names to geographic coordinates.

## Home Screen

Here you can see all the pins posted by others Udacity student in a maps view or in a table view. you can logout and reload the pins on screen and post your own pin with a location and a link.

![home screen](https://github.com/OscarSantosGH/OnTheMap/blob/master/Images/home.jpg?raw=true "Home Screen")
![pin list screen](https://github.com/OscarSantosGH/OnTheMap/blob/master/Images/pinList.jpg?raw=true "Pin List Screen")

## Add Location

Here you can add a location and a link to share with the other students. the app use **CLGeocoder** to get a location from the string.

![add location screen 1](https://github.com/OscarSantosGH/OnTheMap/blob/master/Images/addLocation1.jpg?raw=true "Add Location Screen 1")

![add location screen 2](https://github.com/OscarSantosGH/OnTheMap/blob/master/Images/addLocation2.jpg?raw=true "Add Location Screen 2")
