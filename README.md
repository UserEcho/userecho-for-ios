UserEcho-for-ios
================

UserEcho for iOS allows you to embed UserEcho community directly in your iPhone application.

![](https://www.userecho.com/s/assets/img/ios/userecho-for-ios-1.png)

* Full support for iOS 6.0+
* The library will detect and display in the language the device is set to provided that language is supported by the SDK.
Currently we support (EN,RU)

Requirements
------------

* You must have UserEcho account. Get it [here](http://userecho.com/project/new/) if you don't already have one.
* Obtain Key And Secret. Go to the admin console API section (https://feedback.userecho.com/settings/features/api/) of your UserEcho account. Create API client & token with read permission. Copy the generated 'Key','Secret' and 'Token'.



Installation
------------

* Clone the latest version of library.
* Drag `UserEcho` into your project.
* When adding the folders, make sure you have "Create groups for any added folders" selected rather than "Create folder references for any added folders".
* Add Security and SystemConfiguration frameworks to your project.
* Open Project->Target->Built phases->Compile sources and add -fno-objc-arc to the files beginning with GTM*

Once you have completed these steps, you are ready to launch the UserEcho UI
from your code.

Launching
---------

Import `UserEcho.h`

    [UserEcho presentUserEchoCommunity:self config:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                @"YOUR_KEY",@"key",
                @"YOUR_SECRET",@"secret",
                @"YOUR_TOKEN",@"access_token",
                nil]];

Feedback
--------

You can share feedback on the [UserEcho support forum](http://feedback.userecho.com).

License
-------

Copyright 2013 UserEcho, LLC. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
