//
//  String+Interpolation.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation

extension String.StringInterpolation {

	mutating func appendInterpolation(format: String, _ arguments: CVarArg...) {
		appendInterpolation(String(format: format, arguments))
	}
}
