//
//  CMTime+formatted.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 19.08.2023.
//

import CoreMedia

extension CMTime {

	var minutes: Int {
		seconds / 60
	}

	var seconds: Int {
		Int(CMTimeGetSeconds(self))
	}
}
