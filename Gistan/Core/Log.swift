//
//  Log.swift
//  monokit
//
//  Created by mono on 2017/02/11.
//  Copyright © 2017 mono. All rights reserved.
//
import Foundation
import os.log

extension OSLogType: CustomStringConvertible {
    public var description: String {
        switch self {
        case OSLogType.info:
            return "ℹ️(info)"
        case OSLogType.debug:
            return "🔹(debug)"
        case OSLogType.error:
            return "‼️(error)"
        case OSLogType.fault:
            return "💣(fault)"
        default:
            return "DEFAULT"
        }
    }
}

/// @see https://developer.apple.com/reference/os/logging#1682426
public struct Logger {
    private static let log = OSLog(subsystem: "com.miso.gistan", category: "default")

    fileprivate init() {}

    public func info(_ message: @autoclosure () ->  Any?,
                     functionName: StaticString = #function,
                     fileName: StaticString = #file,
                     lineNumber: Int = #line) {
        doLog(message, logType: .info,
              functionName: functionName,
              fileName: fileName,
              lineNumber: lineNumber)
    }

    public func debug(_ message: @autoclosure () ->  Any?,
                      functionName: StaticString = #function,
                      fileName: StaticString = #file,
                      lineNumber: Int = #line) {
        doLog(message, logType:
            .debug, functionName:
            functionName, fileName: fileName,
                          lineNumber: lineNumber)
    }

    public func error(_ message: @autoclosure () ->  Any?,
                      functionName: StaticString = #function,
                      fileName: StaticString = #file,
                      lineNumber: Int = #line) {
        doLog(message, logType: .error,
              functionName: functionName,
              fileName: fileName,
              lineNumber: lineNumber)
    }

    public func fault(_ message: @autoclosure () ->  Any?,
                      functionName: StaticString = #function,
                      fileName: StaticString = #file,
                      lineNumber: Int = #line) {
        doLog(message, logType: .fault,
              functionName: functionName,
              fileName: fileName,
              lineNumber: lineNumber)
    }

    public func `default`(_ message: @autoclosure () ->  Any?,
                          functionName: StaticString = #function,
                          fileName: StaticString = #file,
                          lineNumber: Int = #line) {
        doLog(message, logType: .default,
              functionName: functionName,
              fileName: fileName,
              lineNumber: lineNumber)
    }

    private func doLog(_ message: @autoclosure () ->  Any?,
                       logType: OSLogType,
                       functionName: StaticString,
                       fileName: StaticString,
                       lineNumber: Int) {
        let staticSelf = type(of: self)
        let log = staticSelf.log
        guard log.isEnabled(type: logType) else { return }
        guard let output = staticSelf.buildOutput(message,
                                                  logType: logType,
                                                  functionName: functionName,
                                                  fileName: fileName,
                                                  lineNumber: lineNumber) else { return }
        os_log("%@",
               log: log,
               type: logType,
               output)
    }

    static func buildOutput(_ message: @autoclosure () ->  Any?,
                            logType: OSLogType,
                            functionName: StaticString,
                            fileName: StaticString,
                            lineNumber: Int) -> String? {
        guard let message = message() else { return nil }
        return "[\(logType)] [\(threadName)] [\((String(describing: fileName) as NSString).lastPathComponent):\(lineNumber)] \(functionName) > \(message)"
    }

    private static var threadName: String {
        if Thread.isMainThread {
            return "main"
        }
        if let threadName = Thread.current.name, !threadName.isEmpty {
            return threadName
        }
        if let queueName = DispatchQueue.currentQueueLabel, !queueName.isEmpty {
            return queueName
        }
        return String(format: "[%p] ", Thread.current)
    }
}

extension DispatchQueue {
    public static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}

public let logger = Logger()
