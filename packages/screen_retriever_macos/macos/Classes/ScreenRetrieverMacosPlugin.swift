import Cocoa
import FlutterMacOS

extension NSScreen {
    var displayID: CGDirectDisplayID {
        return deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? CGDirectDisplayID ?? 0
    }
    
    public func toDictionary() -> NSDictionary {
        var name: String = "";
        if #available(macOS 10.15, *) {
            name = self.localizedName
        }
        let size: NSDictionary = [
            "width": self.frame.width,
            "height": self.frame.height,
        ]
        let visiblePosition: NSDictionary = [
            "dx": self.visibleFrame.topLeft.x,
            "dy": self.visibleFrame.topLeft.y,
        ]
        let visibleSize: NSDictionary = [
            "width": self.visibleFrame.width,
            "height": self.visibleFrame.height,
        ]
        let dict: NSDictionary = [
            "id": self.displayID,
            "name": name,
            "size": size,
            "visiblePosition": visiblePosition,
            "visibleSize": visibleSize,
        ]
        return dict;
    }
}

extension NSRect {
    var topLeft: CGPoint {
        set {
            let screenFrameRect = NSScreen.screens[0].frame
            origin.x = newValue.x
            origin.y = screenFrameRect.height - newValue.y - size.height
        }
        get {
            let screenFrameRect = NSScreen.screens[0].frame
            return CGPoint(x: origin.x, y: screenFrameRect.height - origin.y - size.height)
        }
    }
}

public class ScreenRetrieverMacosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dev.leanflutter.plugins/screen_retriever", binaryMessenger: registrar.messenger)
        let instance = ScreenRetrieverMacosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getCursorScreenPoint":
            getCursorScreenPoint(call, result: result)
            break
        case "getPrimaryDisplay":
            getPrimaryDisplay(call, result: result)
            break
        case "getAllDisplays":
            getAllDisplays(call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func getCursorScreenPoint(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let currentScreen = NSScreen.main!
        let mouseLocation: NSPoint = NSEvent.mouseLocation;
        
        var visibleHeight = currentScreen.frame.maxY
        for screen in NSScreen.screens {
            if (visibleHeight > screen.frame.maxY) {
                visibleHeight = screen.frame.maxY
            }
        }
        let data: NSDictionary = [
            "dx": mouseLocation.x,
            "dy": visibleHeight - mouseLocation.y,
        ]
        result(data)
    }
    
    public func getPrimaryDisplay(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(NSScreen.screens[0].toDictionary())
    }
    
    public func getAllDisplays(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let data: NSDictionary = [
            "displays": NSScreen.screens.map({ screen in
                return screen.toDictionary()
            }),
        ]
        result(data)
    }
}
