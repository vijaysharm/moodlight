//
//  Models.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI

class StrobeLight: NSObject, NSCoding {
	let id = UUID()
	var bpm: Int
	var colours: [UIColor]
	var blend: Bool
	
	init(bpm: Int, colours: [UIColor], blend: Bool) {
		self.bpm = bpm
		self.colours = colours
		self.blend = blend
	}
	
	required init?(coder: NSCoder) {
		bpm = coder.decodeInteger(forKey: "bpm")
		blend = coder.decodeBool(forKey: "blend")
		if let colorStrings = coder.decodeObject(forKey: "colours") as? [String] {
			colours = colorStrings.map({ UIColor(hex: $0)! })
		} else {
			colours = [.black, .white]
		}
	}
	
	func encode(with coder: NSCoder) {
		coder.encode(bpm, forKey: "bpm")
		coder.encode(blend, forKey: "blend")
		coder.encode(colours.map({ $0.toHexString() }), forKey: "colours")
	}
	
	static func == (lhs: StrobeLight, rhs: StrobeLight) -> Bool {
		return lhs.id == rhs.id
	}
}

class StrobeManager: ObservableObject {
	@Published var colour: UIColor
	@Published var blend = false
	@Published var duration: Double
	@Published var isPlaying  = false
	
	var colours: [UIColor] = []
	var presets: [StrobeLight] = []
	var current: StrobeLight {
		willSet {
			objectWillChange.send()
		}
		didSet {
			stop()
			reset()
			store()
		}
	}
	
	private var timer: RhythmBox? = nil
	private var colourIndex = 0
	private lazy var preferences: UserDefaults = .standard
	
	init() {
		presets.append(StrobeLight(bpm: 120, colours: [.black, .white], blend: true))
		presets.append(StrobeLight(bpm: 80, colours: [.red, .blue, .green], blend: true))
		presets.append(StrobeLight(bpm: 180, colours: [.blue, .green, .purple], blend: true))
		
		current = presets[0]
		
		colourIndex = 0
		colours = current.colours
		blend = current.blend
		colour = current.colours[0]
		duration = 30.0 / Double(current.bpm)
	}
	
	public func load() {
		guard let decoded  = preferences.data(forKey: "presets") else { return }
		guard let decodedPresets = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [StrobeLight] else { return }
		
		presets.removeAll()
		presets.append(contentsOf: decodedPresets)
		
		let selection = preferences.integer(forKey: "selection")
		if selection < presets.count {
			current = presets[selection]
		} else {
			current = presets[0]
		}
		
		reset()
	}
	
	public func start() {
		timer?.stop()
		timer = RhythmBox(bpm: 120, timeSignature: (4, 4))
		timer?.perform { _, _, _ in
			let next = self.current.colours[self.colourIndex]
			self.colourIndex = (self.colourIndex + 1) % self.current.colours.count
			self.colour = next
			return .resume
		}
		isPlaying = true
	}
	
	public func stop() {
		timer?.stop()
		timer = nil
		isPlaying = false
	}
	
	public func toggle() {
		if isPlaying {
			self.stop()
		} else {
			self.start()
		}
	}
	
	func setCurrent(colours: [UIColor]) {
		let first = presets.firstIndex { current.id == $0.id }
		guard let index = first else { return }
		
		let item = presets[index]
		let newItem = StrobeLight(
			bpm: item.bpm,
			colours: colours,
			blend: item.blend
		)

		presets[index] = newItem
		current = presets[index]
	}
	
	func setCurrent(bpm: Int) {
		let first = presets.firstIndex { current.id == $0.id }
		guard let index = first else { return }
		
		let item = presets[index]
		let newItem = StrobeLight(
			bpm: bpm,
			colours: item.colours,
			blend: item.blend
		)

		presets[index] = newItem
		current = presets[index]
	}
	
	func setCurrent(blended: Bool) {
		let first = presets.firstIndex { current.id == $0.id }
		guard let index = first else { return }
		
		let item = presets[index]
		let newItem = StrobeLight(
			bpm: item.bpm,
			colours: item.colours,
			blend: blended
		)

		presets[index] = newItem
		current = presets[index]
	}
	
	private func reset() {
		colourIndex = 0
		colours = current.colours
		blend = current.blend
		colour = current.colours[0]
		duration = 30.0 / Double(current.bpm)
	}
	
	private func store() {
		let selection = presets.firstIndex { current.id == $0.id }
		if (selection != nil), let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: presets, requiringSecureCoding: false) {
			preferences.set(selection, forKey: "selection")
			preferences.set(encodedData, forKey: "presets")
			preferences.synchronize()
		}
	}
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat
		let start = hex.dropFirst()
		let hexColour = String(start)
		let scanner = Scanner(string: hexColour)
		var hexNumber: UInt64 = 0

		if scanner.scanHexInt64(&hexNumber) {
			r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
			g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
			b = CGFloat(hexNumber & 0x000000ff) / 255

			self.init(red: r, green: g, blue: b, alpha: 1.0)
			return
		}
		
		return nil;
    }
	
	func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        
		return NSString(format:"#%06x", rgb) as String
    }
}
