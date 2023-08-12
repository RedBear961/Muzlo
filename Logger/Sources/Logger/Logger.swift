public final class Logger {

	public enum LogLevel {

		case message
		case warning
		case error
	}

	public static let shared = Logger(name: "Global")

	public let name: String
	public var isEnabled: Bool

	public init(name: String) {
		self.name = name
		self.isEnabled = true
	}

	public func log(level: LogLevel = .warning, _ items: Any...) {
		guard isEnabled else { return }

		#if DEBUG
		print(items)
		#endif
	}
}

public extension Logger {

	func assert(_ condition: Bool, message: String = "") {
		#if DEBUG
		Swift.assert(condition, message)
		#endif
	}
}
