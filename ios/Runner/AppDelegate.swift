import UIKit
import Flutter
import GoogleMaps
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCzMPZfxelEok5_OOB0_vi-APCdVHp2PBI")
    GeneratedPluginRegistrant.register(with: self)
    let locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
