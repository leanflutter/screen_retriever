import Cocoa
import FlutterMacOS

extension NSScreen {
  var displayID: CGDirectDisplayID {
    return deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? CGDirectDisplayID ?? 0
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

public class ScreenRetrieverPlugin: NSObject, FlutterPlugin {
    var registrar: FlutterPluginRegistrar!;
    var channel: FlutterMethodChannel!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "screen_retriever", binaryMessenger: registrar.messenger)
        let instance = ScreenRetrieverPlugin()
        instance.registrar = registrar
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
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
    
    public func _screenToDict(_ screen: NSScreen) -> NSDictionary {
        var name: String = "";
        if #available(macOS 10.15, *) {
            name = screen.localizedName
        }
        let size: NSDictionary = [
            "width": screen.frame.width,
            "height": screen.frame.height,
        ]
        let visiblePosition: NSDictionary = [
            "x": screen.visibleFrame.topLeft.x,
            "y": screen.visibleFrame.topLeft.y,
        ]
        let visibleSize: NSDictionary = [
            "width": screen.visibleFrame.width,
            "height": screen.visibleFrame.height,
        ]
        let dict: NSDictionary = [
            "id": screen.displayID,
            "name": name,
            "size": size,
            "visiblePosition": visiblePosition,
            "visibleSize": visibleSize,
        ]
        return dict;
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
        let resultData: NSDictionary = [
            "x": mouseLocation.x,
            "y": visibleHeight - mouseLocation.y,
        ]
        result(resultData)
    }
    
    public func getPrimaryDisplay(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let resultData: NSDictionary = _screenToDict(NSScreen.screens[0])
        result(resultData)
    }
    
    public func getAllDisplays(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let resultData: NSDictionary = [
            "displays": NSScreen.screens.map({ screen in
                return _screenToDict(screen)
            }),
        ]
        result(resultData)
    }
    
    public func _emitEvent(_ eventName: String) {
        let args: NSDictionary = [
            "eventName": eventName,
        ]
        channel.invokeMethod("onEvent", arguments: args, result: nil)
    }
}
