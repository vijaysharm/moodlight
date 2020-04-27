//
//  MenuView.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI

struct MenuView: View {
	private static let AD_ID = "ca-app-pub-1077332010614613/4056172929" // Production
//	private static let AD_ID = "ca-app-pub-3940256099942544/2934735716" // test
	
	@EnvironmentObject var strobeLight: StrobeManager
	@Binding var showMenu: Bool
	
	var body: some View {
		NavigationView {
			VStack {
				StrobeControlView(isPlaying: $strobeLight.isPlaying) {
					self.strobeLight.toggle()
					if self.strobeLight.isPlaying {
						self.showMenu = false
					}
				}
				AdBanner(adId: MenuView.AD_ID).frame(height: 50)
				List {
					Section(header: Text("Current")) {
						NavigationLink(destination: TempoPickerView(strobe: self.strobeLight.current)) {
							MenuItemView(title: "Tempo", subtitle: "\(strobeLight.current.bpm) BPM")
						}
						NavigationLink(destination: ColourPickerView(strobe: self.strobeLight.current)) {
							ColoursMenuItemView(colours: strobeLight.current.colours)
						}
					}
					Section(header: Text("Presets")) {
						ForEach(strobeLight.presets, id: \.id) { preset in
							PresetView(preset: preset)
								.background(self.strobeLight.current == preset ? Color(.systemFill) : Color(.systemBackground))
								.onTapGesture {
									self.strobeLight.current = preset
								}
						}
					}
				}
				}.navigationBarTitle("Moodlight!", displayMode: .inline)
		}
	}
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
		MenuView(showMenu: .constant(true)).environmentObject(StrobeManager())
    }
}

struct PresetView: View {
	var preset: StrobeLight
	var body: some View {
		VStack {
			Text(self.createName(from: preset))
				.font(.system(.body, design: .serif))
				.frame(maxWidth: .infinity, alignment: .leading)
			GridStack(
				items: preset.colours.count,
				desired: 24,
				verticalSpacing: 8,
				horizontalSpacing: 8
			) { index in
				SwatchView(colour: self.getColour(from: self.preset.colours, index), size: 24)
			}.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
	
	private func createName(from preset: StrobeLight) -> String {
		let colour = preset.colours.count == 1 ? "colour" : "colours"
//		let blend = preset.blend ? " (blended)" : ""
		let blend = ""
		return "\(preset.colours.count) \(colour)\(blend), \(preset.bpm) BPM"
	}
	
	private func getColour(from colours: [UIColor], _ index: Int) -> Color? {
		guard index < colours.count else {
			return nil
		}

		return Color(colours[index])
	}
}

struct StrobeControlView: View {
	@Binding var isPlaying: Bool
	let action: () -> Void
	
	public init(isPlaying: Binding<Bool>, _ action: @escaping () -> Void) {
		self.action = action
		self._isPlaying = isPlaying
	}
	
	var body: some View {
		Group {
			Button(action: self.action) {
				Image(systemName: self.isPlaying ? "stop.fill" : "play.fill")
					.accentColor(Color(.label))
					.frame(maxWidth: .infinity)
					.frame(height: 48)
			}.overlay(
				RoundedRectangle(cornerRadius: 4)
					.stroke(Color(.label), lineWidth: 2)
			)
		}.padding()
	}
}

struct ColoursMenuItemView: View {
	let colours: [UIColor]
	var body: some View {
		VStack {
			Text("Colours")
				.font(.system(.headline, design: .serif))
				.frame(maxWidth: .infinity, alignment: .leading)
			GridStack(
				items: colours.count,
				desired: 24
			) { index in
				SwatchView(colour: self.getColour(from: self.colours, index), size: 24)
			}.frame(maxWidth: .infinity, alignment: .leading)
		}.frame(maxWidth: .infinity)
	}
	
	private func getColour(from colours: [UIColor], _ index: Int) -> Color? {
		guard index < colours.count else {
			return nil
		}

		return Color(colours[index])
	}
}

struct MenuItemView: View {
	let title: String
	let subtitle: String
	var body: some View {
		VStack {
			Text("\(title)")
				.font(.system(.headline, design: .serif))
				.frame(maxWidth: .infinity, alignment: .leading)
			Text("\(subtitle)")
				.font(.system(.caption, design: .serif))
				.foregroundColor(.gray)
				.frame(maxWidth: .infinity, alignment: .leading)
		}.frame(maxWidth: .infinity)
	}
}
