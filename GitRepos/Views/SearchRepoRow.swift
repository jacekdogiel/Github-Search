import SwiftUI

struct SearchRepoRow: View {
    @ObservedObject var viewModel: SearchRepoViewModel
    @State var repository: Repository

    var body: some View {
        HStack {
            Text(repository.name)
                .font(Font.system(size: 18).bold())
            }
            .frame(height: 30)
    }
}
