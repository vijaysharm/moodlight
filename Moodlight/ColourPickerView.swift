//
//  ColourPickerView.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI

struct ColourPickerView: View {
	@EnvironmentObject var strobeLight: StrobeManager
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	@State var selection: Int = 0
	@State var colours: [UIColor] = []
	
	let strobe: StrobeLight
	let palette: [UIColor] = [
		UIColor(hex: "#f9ebea")!,
		UIColor(hex: "#f2d7d5")!,
		UIColor(hex: "#e6b0aa")!,
		UIColor(hex: "#d98880")!,
		UIColor(hex: "#cd6155")!,
		UIColor(hex: "#c0392b")!,
		UIColor(hex: "#a93226")!,
		UIColor(hex: "#922b21")!,
		UIColor(hex: "#7b241c")!,
		UIColor(hex: "#641e16")!,
		UIColor(hex: "#fdedec")!,
		UIColor(hex: "#fadbd8")!,
		UIColor(hex: "#f5b7b1")!,
		UIColor(hex: "#f1948a")!,
		UIColor(hex: "#ec7063")!,
		UIColor(hex: "#e74c3c")!,
		UIColor(hex: "#cb4335")!,
		UIColor(hex: "#b03a2e")!,
		UIColor(hex: "#943126")!,
		UIColor(hex: "#78281f")!,
		UIColor(hex: "#f5eef8")!,
		UIColor(hex: "#ebdef0")!,
		UIColor(hex: "#d7bde2")!,
		UIColor(hex: "#c39bd3")!,
		UIColor(hex: "#af7ac5")!,
		UIColor(hex: "#9b59b6")!,
		UIColor(hex: "#884ea0")!,
		UIColor(hex: "#76448a")!,
		UIColor(hex: "#633974")!,
		UIColor(hex: "#512e5f")!,
		UIColor(hex: "#f4ecf7")!,
		UIColor(hex: "#e8daef")!,
		UIColor(hex: "#d2b4de")!,
		UIColor(hex: "#bb8fce")!,
		UIColor(hex: "#a569bd")!,
		UIColor(hex: "#8e44ad")!,
		UIColor(hex: "#7d3c98")!,
		UIColor(hex: "#6c3483")!,
		UIColor(hex: "#5b2c6f")!,
		UIColor(hex: "#4a235a")!,
		UIColor(hex: "#eaf2f8")!,
		UIColor(hex: "#d4e6f1")!,
		UIColor(hex: "#a9cce3")!,
		UIColor(hex: "#7fb3d5")!,
		UIColor(hex: "#5499c7")!,
		UIColor(hex: "#2980b9")!,
		UIColor(hex: "#2471a3")!,
		UIColor(hex: "#1f618d")!,
		UIColor(hex: "#1a5276")!,
		UIColor(hex: "#154360")!,
		UIColor(hex: "#ebf5fb")!,
		UIColor(hex: "#d6eaf8")!,
		UIColor(hex: "#aed6f1")!,
		UIColor(hex: "#85c1e9")!,
		UIColor(hex: "#5dade2")!,
		UIColor(hex: "#3498db")!,
		UIColor(hex: "#2e86c1")!,
		UIColor(hex: "#2874a6")!,
		UIColor(hex: "#21618c")!,
		UIColor(hex: "#1b4f72")!,
		UIColor(hex: "#e8f8f5")!,
		UIColor(hex: "#d1f2eb")!,
		UIColor(hex: "#a3e4d7")!,
		UIColor(hex: "#76d7c4")!,
		UIColor(hex: "#48c9b0")!,
		UIColor(hex: "#1abc9c")!,
		UIColor(hex: "#17a589")!,
		UIColor(hex: "#148f77")!,
		UIColor(hex: "#117864")!,
		UIColor(hex: "#0e6251")!,
		UIColor(hex: "#e8f6f3")!,
		UIColor(hex: "#d0ece7")!,
		UIColor(hex: "#a2d9ce")!,
		UIColor(hex: "#73c6b6")!,
		UIColor(hex: "#45b39d")!,
		UIColor(hex: "#16a085")!,
		UIColor(hex: "#138d75")!,
		UIColor(hex: "#117a65")!,
		UIColor(hex: "#0e6655")!,
		UIColor(hex: "#0b5345")!,
		UIColor(hex: "#e9f7ef")!,
		UIColor(hex: "#d4efdf")!,
		UIColor(hex: "#a9dfbf")!,
		UIColor(hex: "#7dcea0")!,
		UIColor(hex: "#52be80")!,
		UIColor(hex: "#27ae60")!,
		UIColor(hex: "#229954")!,
		UIColor(hex: "#1e8449")!,
		UIColor(hex: "#196f3d")!,
		UIColor(hex: "#145a32")!,
		UIColor(hex: "#eafaf1")!,
		UIColor(hex: "#d5f5e3")!,
		UIColor(hex: "#abebc6")!,
		UIColor(hex: "#82e0aa")!,
		UIColor(hex: "#58d68d")!,
		UIColor(hex: "#2ecc71")!,
		UIColor(hex: "#28b463")!,
		UIColor(hex: "#239b56")!,
		UIColor(hex: "#1d8348")!,
		UIColor(hex: "#186a3b")!,
		UIColor(hex: "#fef9e7")!,
		UIColor(hex: "#fcf3cf")!,
		UIColor(hex: "#f9e79f")!,
		UIColor(hex: "#f7dc6f")!,
		UIColor(hex: "#f4d03f")!,
		UIColor(hex: "#f1c40f")!,
		UIColor(hex: "#d4ac0d")!,
		UIColor(hex: "#b7950b")!,
		UIColor(hex: "#9a7d0a")!,
		UIColor(hex: "#7d6608")!,
		UIColor(hex: "#fef5e7")!,
		UIColor(hex: "#fdebd0")!,
		UIColor(hex: "#fad7a0")!,
		UIColor(hex: "#f8c471")!,
		UIColor(hex: "#f5b041")!,
		UIColor(hex: "#f39c12")!,
		UIColor(hex: "#d68910")!,
		UIColor(hex: "#b9770e")!,
		UIColor(hex: "#9c640c")!,
		UIColor(hex: "#7e5109")!,
		UIColor(hex: "#fdf2e9")!,
		UIColor(hex: "#fae5d3")!,
		UIColor(hex: "#f5cba7")!,
		UIColor(hex: "#f0b27a")!,
		UIColor(hex: "#eb984e")!,
		UIColor(hex: "#e67e22")!,
		UIColor(hex: "#ca6f1e")!,
		UIColor(hex: "#af601a")!,
		UIColor(hex: "#935116")!,
		UIColor(hex: "#784212")!,
		UIColor(hex: "#fbeee6")!,
		UIColor(hex: "#f6ddcc")!,
		UIColor(hex: "#edbb99")!,
		UIColor(hex: "#e59866")!,
		UIColor(hex: "#dc7633")!,
		UIColor(hex: "#d35400")!,
		UIColor(hex: "#ba4a00")!,
		UIColor(hex: "#a04000")!,
		UIColor(hex: "#873600")!,
		UIColor(hex: "#6e2c00")!,
		UIColor(hex: "#fdfefe")!,
		UIColor(hex: "#fbfcfc")!,
		UIColor(hex: "#f7f9f9")!,
		UIColor(hex: "#f4f6f7")!,
		UIColor(hex: "#f0f3f4")!,
		UIColor(hex: "#ecf0f1")!,
		UIColor(hex: "#d0d3d4")!,
		UIColor(hex: "#b3b6b7")!,
		UIColor(hex: "#979a9a")!,
		UIColor(hex: "#7b7d7d")!,
		UIColor(hex: "#f8f9f9")!,
		UIColor(hex: "#f2f3f4")!,
		UIColor(hex: "#e5e7e9")!,
		UIColor(hex: "#d7dbdd")!,
		UIColor(hex: "#cacfd2")!,
		UIColor(hex: "#bdc3c7")!,
		UIColor(hex: "#a6acaf")!,
		UIColor(hex: "#909497")!,
		UIColor(hex: "#797d7f")!,
		UIColor(hex: "#626567")!,
		UIColor(hex: "#f4f6f6")!,
		UIColor(hex: "#eaeded")!,
		UIColor(hex: "#d5dbdb")!,
		UIColor(hex: "#bfc9ca")!,
		UIColor(hex: "#aab7b8")!,
		UIColor(hex: "#95a5a6")!,
		UIColor(hex: "#839192")!,
		UIColor(hex: "#717d7e")!,
		UIColor(hex: "#5f6a6a")!,
		UIColor(hex: "#4d5656")!,
		UIColor(hex: "#f2f4f4")!,
		UIColor(hex: "#e5e8e8")!,
		UIColor(hex: "#ccd1d1")!,
		UIColor(hex: "#b2babb")!,
		UIColor(hex: "#99a3a4")!,
		UIColor(hex: "#7f8c8d")!,
		UIColor(hex: "#707b7c")!,
		UIColor(hex: "#616a6b")!,
		UIColor(hex: "#515a5a")!,
		UIColor(hex: "#424949")!,
		UIColor(hex: "#ebedef")!,
		UIColor(hex: "#d6dbdf")!,
		UIColor(hex: "#aeb6bf")!,
		UIColor(hex: "#85929e")!,
		UIColor(hex: "#5d6d7e")!,
		UIColor(hex: "#34495e")!,
		UIColor(hex: "#2e4053")!,
		UIColor(hex: "#283747")!,
		UIColor(hex: "#212f3c")!,
		UIColor(hex: "#1b2631")!,
		UIColor(hex: "#eaecee")!,
		UIColor(hex: "#d5d8dc")!,
		UIColor(hex: "#abb2b9")!,
		UIColor(hex: "#808b96")!,
		UIColor(hex: "#566573")!,
		UIColor(hex: "#2c3e50")!,
		UIColor(hex: "#273746")!,
		UIColor(hex: "#212f3d")!,
		UIColor(hex: "#1c2833")!,
		UIColor(hex: "#17202a")!,
	]
	
    var body: some View {
		VStack(spacing: 8) {
			GridStack(
				items: self.colours.count,
				desired: 48,
				verticalSpacing: 0,
				horizontalSpacing: 0
			) { index in
				SwatchView(
					colour: self.getColour(from: self.colours, index),
					size: 38
				).frame(width: 48, height: 48)
				.background(self.selection == index ? Color.blue : Color(.systemBackground))
				.onTapGesture {
					self.selection = index
				}
			}.frame(maxWidth: .infinity, alignment: .leading)
			Button(action: self.addColour) {
				Text("Add Colour")
					.font(.system(.headline, design: .serif))
					.foregroundColor(Color.black)
					.frame(height: 48)
					.frame(maxWidth: .infinity)
			}.overlay(
				RoundedRectangle(cornerRadius: 4)
					.stroke(Color.black, lineWidth: 2)
			)
			Button(action: self.removeColour) {
				Text("Remove Colour")
					.font(.system(.headline, design: .serif))
					.foregroundColor(Color.black)
					.frame(height: 48)
					.frame(maxWidth: .infinity)
			}.overlay(
				RoundedRectangle(cornerRadius: 4)
					.stroke(Color.black, lineWidth: 2)
			)
			ScrollView {
				GridStack(
					items: self.palette.count,
					desired: 40,
					verticalSpacing: 8,
					horizontalSpacing: 8
				) { index in
					SwatchView(
						colour: self.getColour(
							from: self.palette,
							index
						),
						size: 42
					).onTapGesture {
						self.changeColour(self.palette[index])
					}
				}.padding(8).frame(maxWidth: .infinity)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}.onAppear(perform: {
			self.colours = self.strobe.colours
			self.selection = self.strobe.colours.count - 1
		})
		.navigationBarTitle("Change Colours")
		.navigationBarItems(trailing: Button(action:{
			self.strobeLight.setCurrent(colours: self.colours)
			self.presentationMode.wrappedValue.dismiss()
		}) {
			Text("Save")
		}).padding()
    }
	
	private func getColour(
		from colours: [UIColor],
		_ index: Int) -> Color? {
		guard index < colours.count else {
			return nil
		}

		return Color(colours[index])
	}
	
	private func addColour() {
		guard colours.count < 16 else { return }
		
		colours.append(palette[Int.random(in: 0..<palette.count)])
		selection = colours.count - 1
	}
	
	private func removeColour() {
		guard colours.count > 2 else { return }
		
		colours.remove(at: selection)
		selection = colours.count - 1
	}
	
	private func changeColour(_ colour: UIColor) {
		colours[selection] = colour
	}
}

struct ColourPickerView_Previews: PreviewProvider {
    static var previews: some View {
		ColourPickerView(
			strobe: StrobeLight(
				bpm: 120,
				colours: [.black, .white,.black, .white,.black, .white,.black, .white,.black, .white,.green, .green,.green, .green, .black, .white,.black, .white,.black],
				blend: true
			)
		).environmentObject(StrobeManager())
    }
}

