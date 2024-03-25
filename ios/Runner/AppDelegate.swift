
import DeviceActivity
import FamilyControls
import Flutter
import ManagedSettings
import SwiftUI
import UIKit

var globalMethodCall = ""

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let METHOD_CHANNEL_NAME = "flutter_ios_trial_area"
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller as! FlutterBinaryMessenger)

        methodChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            Task {
                print("Task")
                do {
                    if #available(iOS 16.0, *) {
                        print("try requestAuthorization")
                        try await AuthorizationCenter.shared.requestAuthorization(for: FamilyControlsMember.individual)
                        print("requestAuthorization success")
                        switch AuthorizationCenter.shared.authorizationStatus {
                        case .notDetermined:
                            print("not determined")
                        case .denied:
                            print("denied")
                        case .approved:
                            print("approved")
                        @unknown default:
                            break
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                } catch {
                    print("Error requestAuthorization: ", error)
                }
            }
            switch call.method {

            case "getTotalActivity":
                globalMethodCall = "getTotalActivity"
                let vc = UIHostingController(rootView: TotalActivityView())


                controller.present(vc, animated: false, completion: nil)

                print("getTotalActivity")
                result(nil)
            default:
                print("no method")
                result(FlutterMethodNotImplemented)
            }
        }
















































    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
