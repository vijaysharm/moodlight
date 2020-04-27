//
//  GridStack.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let items: Int
    let desired: Int
	let verticalSpacing: CGFloat
	let horizontalSpacing: CGFloat
    let content: (Int) -> Content
    
	init(
		items: Int,
		desired: Int,
		verticalSpacing: CGFloat = 8,
		horizontalSpacing: CGFloat = 8,
		@ViewBuilder content: @escaping (Int) -> Content
	) {
		self.items = items
		self.desired = desired
		self.content = content
		self.verticalSpacing = verticalSpacing
		self.horizontalSpacing = horizontalSpacing
	}
	
    var body: some View {
		VStack(alignment: .leading, spacing: self.verticalSpacing) {
			ForEach(0 ..< self.computeRows(), id: \.self) { row in
				HStack(spacing: self.horizontalSpacing) {
					ForEach(0 ..< self.computeColumns(), id: \.self) { column in
						self.content(self.computeIndex(row, column))
					}
				}
			}
		}
    }
	
	private func computeIndex(_ row: Int, _ col: Int) -> Int {
		let columns = computeColumns()
		return row * columns + col
	}
	
	private func computeRows() -> Int {
		let columns = self.computeColumns()
		var rows = items / columns
		
		if items % columns > 0 {
			rows += 1
		}
		
		return Int(rows)
	}
	
	private func computeColumns() -> Int {
//		let actualWidth = proxy.size.width
		let actualWidth = UIScreen.main.bounds.width
		let columns = floor(actualWidth / (CGFloat(desired) + horizontalSpacing))
		
		return Int(columns)
	}
	
	private static func computeSize(
		items: Int,
		desired: Int,
		spacing: CGFloat
	) -> CGSize {
		let size = UIScreen.main.bounds
		let actualWidth = size.width
		let columns = floor(actualWidth / (CGFloat(desired) + spacing))
		var rows = round(CGFloat(items) / columns)
		
		if items % Int(columns) > 0 {
			rows += 1
		}
		

		return CGSize(width: columns, height: rows)
	}
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
		GridStack(items: 14, desired: 48, verticalSpacing: 10, horizontalSpacing: 10) { index in
			Image(systemName: "\(index).circle")
		}
    }
}
