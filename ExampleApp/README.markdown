= Example App

This app is a simplistic implementation of the features of WFInstagramAPI. It is intended to be both a testing ground for API features as they are developed & as a reference for new users of the library to understand how to use it.

== Getting Started

You are required to provide your own Instagram OAuth client information to use this example app. You should set one up at http://instagram.com/developer/manage. Your callback URL *MUST* be `egwfapi://auth`, but you may use whatever you wish for other fields.

Next, copy the `APIClient.plist.example` file under `Supporting Files` to `APIClient.plist`. Open the new plist, and set the id & secret fields to be the Client ID & Client Secret listed for the Instagram client you just created.

You should now be able to build & run the example app.