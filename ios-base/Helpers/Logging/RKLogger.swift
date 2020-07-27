import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

public class RKLogger: NSObject {
    public enum Level: String {
        case info = "ℹ️"
        case verbose = "🤫"
        case warning = "⚠️"
        case error = "❌"
        case debug = "😁"
    }
    
    static let shared = RKLogger()
    private override init() {}
    
     func setupLogging(appID: String, appSecret: String, encryptionKey: String) {
    
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        let cloud = SBPlatformDestination(appID: appID, appSecret: appSecret, encryptionKey: encryptionKey) // to cloud

        console.format = "$DHH:mm:ss$d $L $M"
        
        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)
        
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    private static var time: String {
        dateFormatter.string(from: Date())
    }
    
    public static func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logging(level: .info, message: message, file: file, function: function, line: line)
    }
    
    public static func verbose(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logging(level: .verbose, message: message, file: file, function: function, line: line)
    }
    
    public static func warn(_ message: Any, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        logging(
            level: .warning,
            message: error != nil ? "\(message) ❗\(String(describing: error!.localizedDescription))❗" : message,
            file: file,
            function: function,
            line: line
        )
    }
    
    public static func error(_ message: Any, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        logging(
            level: .error,
            message: error != nil ? "\(message) ❗\(String(describing: error!.localizedDescription))❗" : message,
            file: file,
            function: function,
            line: line
        )
    }
    
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.last?.components(separatedBy: ".").first ?? ""
    }
    
    private static func logging(level: Level = .debug, message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let completeMsg = "\(level.rawValue) \(message) - (\(sourceFileName(filePath: file)).\(function):\(line))"
        
        switch level {
        case .info:
            log.info(completeMsg)
        case .verbose:
            log.verbose(completeMsg)
        case .warning:
            log.warning(completeMsg)
        case .error:
            log.error(completeMsg)
        default:
            log.debug(completeMsg)
        }
        
        #if DEBUG
//            print(completeMsg)
        #endif
        
    }
}
