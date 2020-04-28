//
//  SwatchView.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI

struct SwatchView: View {
	let colour: Color?
	var size: CGFloat = 24
	
	var body: some View {
		if let colour = colour {
			return AnyView(Rectangle()
				.foregroundColor(colour)
				.cornerRadius(4)
				.frame(width: size, height: size)
				.overlay(
					RoundedRectangle(cornerRadius: 4)
						.stroke(Color(.label), lineWidth: 1)
				)
			)
		} else {
			return AnyView(EmptyView())
		}
	}
}

struct SwatchView_Previews: PreviewProvider {
    static var previews: some View {
		SwatchView(colour: nil)
    }
}
