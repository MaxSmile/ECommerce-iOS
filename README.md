ECommerce-iOS
=============

ECommerce example For iOS (Xcode project with KIF integration tests). The [KIF Integration Framework](https://github.com/kif-framework/KIF) tests can be used to run repeated randomized simulations of an e-commerce shopping cart checkout scenario.

Pre-Requisites
--------------
1. Xcode
2. [Cocoapods](http://cocoapods.org/): use `sudo gem install cocoapods`
3. (Optional) iOS Developer Program membership - only required to run on actual iOS devices instead of the simulator

Importing the Project
---------------------
1. Clone a local copy of this project with `git clone https://github.com/Appdynamics/ECommerce-iOS`
2. Open Xcode, File -> Open and select "Acme Mobile Shopping".
3. Add the CocoaPods project ("Add Files to Ecommerce Mobile Application" and select "Pods")

Running with the iOS Simulator
------------------------------
1. Select an appropriate simulator target, e.g. iPhone 5s (8.0)
2. To run the application manually: select Product -> Run
3. To run the automated test simulation: select Product -> Test

Running with your own iOS Device
--------------------------------
1. For both targets ('Ecommerce Mobile Application' and 'UI Tests'), under Build Settings -> Code Signing set Code Signing Identity to use your iPhone Developer identity from the Keychain and set Provisioning Profile to 'Automatic'
2. If running on an older, pre-iOS 8.0 device: for the 'Ecommerce Mobile Application' target, under General -> Deployment Info set Deployment Target to the iOS version for your device and set Devices to 'Universal'
3. To run the application manually: select Product -> Run
4. To run the automated test simulation: select Product -> Test
