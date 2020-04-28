//
//  TempoPickerView.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI
import Foundation

struct TempoPickerView: View {
	@EnvironmentObject var strobeLight: StrobeManager
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State var bpm: Int = 0
	
	private static let MINIMUM_TEMPO = 1
	private static let MAXIMUM_TEMPO = 600
	
	let strobe: StrobeLight
	let counter = TapCounter()
	
    var body: some View {
		VStack(spacing: 20) {
			HStack {
				TempoChangeButton(text: "-") {
					self.bpm = max(self.bpm - 1, TempoPickerView.MINIMUM_TEMPO)
				}
				Text("\(bpm)")
					.font(.system(.headline, design: .serif))
					.frame(maxWidth: .infinity)
				TempoChangeButton(text: "+")  {
					self.bpm = min(self.bpm + 1, TempoPickerView.MAXIMUM_TEMPO)
			   }
			}.cornerRadius(4).frame(maxWidth: .infinity)
			Button(action: self.tap) {
				Text("Tap")
					.font(.system(.headline, design: .serif))
					.foregroundColor(Color(.label))
					.frame(height: 48)
					.frame(maxWidth: .infinity)
			}.overlay(
				RoundedRectangle(cornerRadius: 4)
					.stroke(Color(.label), lineWidth: 2)
			)
			Button(action: self.reset) {
				Text("Reset")
					.font(.system(.headline, design: .serif))
					.foregroundColor(Color(.label))
					.frame(height: 48)
					.frame(maxWidth: .infinity)
			}.overlay(
				RoundedRectangle(cornerRadius: 4)
					.stroke(Color(.label), lineWidth: 2)
			)
		}
		.padding()
		.onAppear(perform: {
			self.bpm = self.strobe.bpm
		})
		.navigationBarTitle("Change Tempo")
		.navigationBarItems(trailing: Button(action:{
			self.strobeLight.setCurrent(bpm: self.bpm)
			self.presentationMode.wrappedValue.dismiss()
		}) {
			Text("Save")
		})
    }
	
	func tap() {
		if let bpm = counter.tap() {
			self.bpm = bpm.clamp(low: TempoPickerView.MINIMUM_TEMPO, high: TempoPickerView.MAXIMUM_TEMPO)
		}
	}
	
	func reset() {
		counter.reset()
		self.bpm = self.strobe.bpm
	}
}

struct TempoPickerView_Previews: PreviewProvider {
    static var previews: some View {
		TempoPickerView(
			strobe: StrobeLight(
				bpm: 120,
				colours: [.black, .white],
				blend: true
			)
		).environmentObject(StrobeManager())
    }
}

struct TempoChangeButton: View {
	let text: String
	let action: () -> Void
	init(text: String, _ action: @escaping () -> Void) {
		self.text = text
		self.action = action
	}
	
	var body: some View {
		Button(action: self.action) {
			Text("\(self.text)")
				.foregroundColor(Color(.systemGray6))
				.padding(.vertical, 10)
				.padding(.horizontal, 30)
		}.background(Color(.label))
	}
}

class TapCounter {
	private var tapCount = 0
	private var tapSecondsFirst: TimeInterval = 0
	
	func tap() -> Int? {
		let now = Date().timeIntervalSince1970
		if tapCount == 0 {
			tapSecondsFirst = now
			tapCount += 1
			return nil
		}
			
		let bpmAvg = 60 * Double(tapCount) / (now - tapSecondsFirst);
		let whole = Int(round(bpmAvg))
		tapCount += 1
		
		return whole
	}
	
	func reset() {
		tapCount = 0
	}
}

extension Comparable {
    func clamp(low: Self, high: Self) -> Self {
        if (self > high) {
            return high
        } else if (self < low) {
            return low
        }

        return self
    }
}
