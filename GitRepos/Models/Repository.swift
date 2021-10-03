import Foundation
import SwiftUI

struct Repository: Hashable, Identifiable, Decodable {
    var id: Int64
    var name: String
    var html_url: URL
}
