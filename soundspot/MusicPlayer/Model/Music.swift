//
//  Music.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/25/22.
//

import Foundation

protocol Music {
	var title: String { get set }
	var link: String { get set }
	var pictureLink: String? { get set }
	var pictureDownloaded: Bool { get set }
	var pictureData: Data? { get set }
}
