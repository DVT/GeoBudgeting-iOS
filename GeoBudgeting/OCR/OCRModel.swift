
import Foundation

struct OCRModel: Codable {
    let ocrText: [[String]]
    
    enum CodingKeys: String, CodingKey {
        case ocrText = "OCRText"
    }
}
