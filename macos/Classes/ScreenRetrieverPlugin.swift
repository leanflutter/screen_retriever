import Cocoa
import FlutterMacOS

extension NSScreen {
  var displayID: CGDirectDisplayID {
    return deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? CGDirectDisplayID ?? 0
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
        let size: NSDictionary = [
            "width": screen.frame.width,
            "height": screen.frame.height,
        ]
        
        var name: String = "";
        if #available(macOS 10.15, *) {
            name = screen.localizedName
        }
        let dict: NSDictionary = [
            "id": screen.displayID,
            "name": name,
            "size": size,
        ]
        return dict;
    }
    
    public func getCursorScreenPoint(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let screenFrame = NSScreen.main!.frame
        let mouseLocation: NSPoint = NSEvent.mouseLocation;
        
        let resultData: NSDictionary = [
            "x": mouseLocation.x,
            "y": screenFrame.size.height - mouseLocation.y,
        ]
        result(resultData)
    }
    
    public func getPrimaryDisplay(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let resultData: NSDictionary = _screenToDict(NSScreen.main!)
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
