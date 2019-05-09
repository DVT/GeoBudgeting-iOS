/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Result : Codable {
	let address_components : [Address_components]?
	let adr_address : String?
	let formatted_address : String?
	let formatted_phone_number : String?
	let geometry : Geometry?
	let icon : String?
	let id : String?
	let international_phone_number : String?
	let name : String?
	let opening_hours : Opening_hours?
	let place_id : String?
	let plus_code : Plus_code?
	let reference : String?
	let scope : String?
	let types : [String]?
	let url : String?
	let utc_offset : Int?
	let vicinity : String?
	let website : String?

	enum CodingKeys: String, CodingKey {

		case address_components = "address_components"
		case adr_address = "adr_address"
		case formatted_address = "formatted_address"
		case formatted_phone_number = "formatted_phone_number"
		case geometry = "geometry"
		case icon = "icon"
		case id = "id"
		case international_phone_number = "international_phone_number"
		case name = "name"
		case opening_hours = "opening_hours"
		case place_id = "place_id"
		case plus_code = "plus_code"
		case reference = "reference"
		case scope = "scope"
		case types = "types"
		case url = "url"
		case utc_offset = "utc_offset"
		case vicinity = "vicinity"
		case website = "website"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address_components = try values.decodeIfPresent([Address_components].self, forKey: .address_components)
		adr_address = try values.decodeIfPresent(String.self, forKey: .adr_address)
		formatted_address = try values.decodeIfPresent(String.self, forKey: .formatted_address)
		formatted_phone_number = try values.decodeIfPresent(String.self, forKey: .formatted_phone_number)
		geometry = try values.decodeIfPresent(Geometry.self, forKey: .geometry)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		international_phone_number = try values.decodeIfPresent(String.self, forKey: .international_phone_number)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		opening_hours = try values.decodeIfPresent(Opening_hours.self, forKey: .opening_hours)
		place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
		plus_code = try values.decodeIfPresent(Plus_code.self, forKey: .plus_code)
		reference = try values.decodeIfPresent(String.self, forKey: .reference)
		scope = try values.decodeIfPresent(String.self, forKey: .scope)
		types = try values.decodeIfPresent([String].self, forKey: .types)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		utc_offset = try values.decodeIfPresent(Int.self, forKey: .utc_offset)
		vicinity = try values.decodeIfPresent(String.self, forKey: .vicinity)
		website = try values.decodeIfPresent(String.self, forKey: .website)
	}

}