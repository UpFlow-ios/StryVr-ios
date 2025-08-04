//
//  PerformanceMonitor.swift
//  StryVr
//
//  Real-time performance monitoring and optimization
//

import Foundation
import OSLog
import SwiftUI

/// Professional performance monitoring for production apps
@MainActor
final class PerformanceMonitor: ObservableObject {
    static let shared = PerformanceMonitor()

    private let logger = Logger(subsystem: "com.stryvr.app", category: "Performance")
    private var startupTime: CFAbsoluteTime = 0
    private var memoryUsage: UInt64 = 0

    // MARK: - Performance Metrics

    @Published var isMonitoring = false
    @Published var currentMemoryUsage: String = "0 MB"
    @Published var startupDuration: String = "0.0s"

    private init() {
        startMonitoring()
    }

    // MARK: - Startup Performance

    func startAppLaunch() {
        startupTime = CFAbsoluteTimeGetCurrent()
        logger.info("🚀 App launch started")
    }

    func endAppLaunch() {
        let duration = CFAbsoluteTimeGetCurrent() - startupTime
        startupDuration = String(format: "%.2fs", duration)

        logger.info("✅ App launch completed in \(startupDuration)")

        #if DEBUG
            if duration > 3.0 {
                logger.warning("⚠️ Slow app launch detected: \(startupDuration)")
            }
        #endif
    }

    // MARK: - Memory Monitoring

    func startMonitoring() {
        isMonitoring = true
        updateMemoryUsage()

        // Monitor memory every 5 seconds
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateMemoryUsage()
        }
    }

    private func updateMemoryUsage() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(
                    mach_task_self_,
                    task_flavor_t(MACH_TASK_BASIC_INFO),
                    $0,
                    &count)
            }
        }

        if kerr == KERN_SUCCESS {
            let memoryMB = Double(info.resident_size) / 1024.0 / 1024.0
            memoryUsage = info.resident_size
            currentMemoryUsage = String(format: "%.1f MB", memoryMB)

            #if DEBUG
                if memoryMB > 500 {
                    logger.warning("⚠️ High memory usage: \(currentMemoryUsage)")
                }
            #endif
        }
    }

    // MARK: - Performance Analytics

    func logPerformanceEvent(_ event: String, duration: TimeInterval? = nil) {
        if let duration = duration {
            logger.info("📊 \(event): \(String(format: "%.3fs", duration))")
        } else {
            logger.info("📊 \(event)")
        }
    }

    func logMemoryWarning() {
        logger.warning("⚠️ Memory warning received - current usage: \(currentMemoryUsage)")
    }

    // MARK: - Crash Prevention

    func checkSystemResources() -> Bool {
        let availableMemory = ProcessInfo.processInfo.physicalMemory
        let usedMemory = memoryUsage

        let memoryUsagePercentage = Double(usedMemory) / Double(availableMemory) * 100

        if memoryUsagePercentage > 80 {
            logger.error(
                "🚨 Critical memory usage: \(String(format: "%.1f%%", memoryUsagePercentage))")
            return false
        }

        return true
    }
}

// MARK: - Performance Extensions

extension View {
    /// Monitor view performance with automatic timing
    func monitorPerformance(_ name: String) -> some View {
        let startTime = CFAbsoluteTimeGetCurrent()

        return self.onAppear {
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            PerformanceMonitor.shared.logPerformanceEvent(
                "View appeared: \(name)", duration: duration)
        }
    }
}
