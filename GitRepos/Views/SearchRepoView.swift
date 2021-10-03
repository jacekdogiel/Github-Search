import SwiftUI

struct SearchRepoView: View {
    @ObservedObject var viewModel = SearchRepoViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchRepoBar(text: $viewModel.name) {
                    self.viewModel.search()
                }
                
                List{
                    ForEach(viewModel.repositories) { repository in
                        SearchRepoRow(viewModel: self.viewModel, repository: repository).onTapGesture {
                            UIApplication.shared.open(repository.html_url)
                        }
                    }
                    if viewModel.reposListFull == false && viewModel.repositories.count > 0 {
                        ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                            .onAppear {
                                self.viewModel.fetchRepositories()
                            }
                    }
                }
                .listStyle(InsetListStyle())
                
            }
            .navigationBarTitle(Text("Repositories"))
        }
    }
}

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
