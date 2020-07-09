# ggHack Frontend
[TOC]

## Overview
Every one may access the Login and Create Account page. Afterwards, customers access the bottom-left pages, and service providers access the bottom-right pages.
![](https://i.imgur.com/iHrdbJG.png)

*From the users' points of views, 'Scan QR Code' functions like a page, so it is included above to lessen confusion. Indeed, it is not a page.  

### Method
- **Language**: [Dart](https://dart.dev/)
- **Framework**: [Flutter](https://flutter.dev/)
- **API**: [Imgur](https://apidocs.imgur.com/?version=latest) -- to host images for free

[Here](https://github.com/cidneyho/ggHack-frontend/) is the repository which this documentation is for.


## Implementation Details
To help people understand our code better, this document is organized by the directory structure, and only files in [gghack-frontend/lib](https://github.com/cidneyho/ggHack-frontend/tree/master/lib) are included, containing purely Dart code.

```
lib
+-- helpers
|   +-- Constants.dart
|   +-- Dialogue.dart
|   +-- Requester.dart
|   +-- RequesterUnitTest.dart
|   +-- Style.dart
|   +-- Tokens.dart
+-- models
|   +-- Reservation.dart
|   +-- ReservationList.dart
|   +-- Service.dart
|   +-- ServiceList.dart
|   +-- User.dart
+-- CreateAccountPage.dart
+-- CreateServicePage.dart
+-- CustomerHomePage.dart
+-- CustomerReservationListPage.dart
+-- LoginPage.dart
+-- main.dart
+-- ProviderHomePage.dart
+-- ProviderServiceListPage.dart
+-- ServiceDetailsPage.dart
```

### models
Conceptually, we model the data as follows, similar to what backend does. For simplicity, many attributes are omitted in the following diagram. 

![](https://i.imgur.com/eRXVwBg.png)
In English:
* Both `Customers` and `Service Providers` are `Users`.
* One `Customer` may make multiple `reservations`.
* One `Service Provider` may own multiple `Services`.
* Each `Reservation` is for exactly one `Customer` to use exactly one `Service`.

Practically, instead of defining `Customer` and `Service Provider` separately, we make `User` class contain an attribute `role`, indicating which role the user is. 

Hence, the files in `lib/models/` are:

| lib/models/          | Description                                          |
| -------------------- | -------------------------------------------------- |
| Reservation.dart     | comparable by time and status                      |
| ReservationList.dart | update status by id; sort by time / status         |
| Service.dart         | comparable by distance                             |
| ServiceList.dart     | sort by distance                                   |
| User.dart            | static object storing user's name, token, and role |


### pages
These pages corresponds to UI pages. Located at `lib/`:
| lib/                      | Description                  |
| -------------------------------- | ---------------------------- |
| CreateAccountPage.dart![](https://i.imgur.com/7NyOhyk.png =225x400)  | account creation            |
| CreateServicePage.dart ![](https://i.imgur.com/odHetwh.png =225x400)          | <ul><li>service creation</li><li> `Photo` field supports image picker and camera</li><li>`Place ID` field gives a button to open the [Google Place ID finder](https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/full/places-placeid-finder) in browser. </ul> Notes on Place ID Finder: <ul><li>As Place ID Finder has only javascript API now, there are no obvious ways to embed it in Flutter.</li><li> Finding Place ID is just a one-time procedure for every service.</li><li> Finding Place ID is not our core functionality</li></ul> Hence, we make it an external link instead of embedding it in our app.|
| CustomerHomePage.dart ![](https://i.imgur.com/198wiN4.png =225x400)           | <ul> <li>the list of all services</li><li> **sorted by distance to user** (from closest to furthest)</li><li> **search functionality** (partial string match) </li><li> distance from the user to the service is shown </li><ul>    |
| CustomerReservationListPage.dart ![](https://i.imgur.com/LzmTOiu.png  =225x400) </br>![](https://i.imgur.com/K5EE956.png =225x400)| <ul><li>the list of all reservations made by the customer</li><li>click the top-right corner to toggle between **sorted chronologically and by reservation status** (checked-in, pending, no-show)</li><li>click a reservtion to see its details and **QR code** (presented as a ticket-style dialogue card), which can be scanned **for fast check-in**</li><li>the status of the reservation: icons **visualized with both colors and shapes** for accessibility</li><li>supports searching (partial string match)</li><li>**swipe-left** to **cancel** a reservation</li></ul>                             |
| LoginPage.dart ![](https://i.imgur.com/VgZHJps.png =225x400) | toggle between *User* / *Service Provider* to switch the login role|
| main.dart                        | starting point of the project                               |
| ProviderHomePage.dart  ![](https://i.imgur.com/MInzGUZ.png =225x400) | <ul><li>the list of all reservations involving the service provider's services</li><li>click the top-right corner to toggle between sorted chronologically and by reservation status (checked-in, pending, no-show)</li><li>associated **QR code scanner** for **fast check-in**</li><li>the status of the reservation: icons visualized with both colors and shapes for accessibility</li><li>supports searching (string match)</li><li>swipe-left to mark a reservation as no-show ![](https://i.imgur.com/Czpd8NQ.png =225x65)</li></ul> |
| ProviderServiceListPage.dart     | <ul><li>the list of services created by the service provider</li><li>very similar to the customer's one.</li> </ul>               |
| ServiceDetailsPage.dart  ![](https://i.imgur.com/L3RuKVS.png =225x400) | <ul><li>image of the service: shown with transition animation from the previous page (i.e. CustomerHomePage)</li><li>may toggle between Popular Times (retrieved from Google API) and Available Slots (the remaining number of slots that can be still be booked)</br>![](https://i.imgur.com/Yad10Nn.png =225x184)</li></ul>                             |


### helpers
These helpers are reusable parts adopted across the project.
| lib/helpers/           | Description                                                                                          |
| ---------------------- | ------------------------------------------------------------------------------------------------------------ |
| Constants.dart         | stores colors, strings, and icons                                                                                                            |
| Dialogue.dart          | shortcuts for showing different dialogs                                                                          |
| Requester.dart         | handles all interactions with backend                                                                                   |
| RequesterUnitTest.dart | unit tests on Requester.dart                                                                           |
| Style.dart             | unified formatting                                                                                           |
| Tokens.dart            | <ul><li>contains an imgur token </li><li>to make it easier for judges to reproduce our demo</li><li> to be removed after the hackathon </li></ul>|

