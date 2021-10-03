import SwiftUI
import Combine

final class SearchRepoViewModel: ObservableObject {

    @Published var name = ""

    @Published private(set) var repositories = [Repository]()
    
    var reposListFull = false
    var currentPage = 1
    let perPage = 20
    
    private var searchCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        searchCancellable?.cancel()
    }
    
    func search(){
        currentPage = 1
        reposListFull = false
        repositories = []
        fetchRepositories()
    }

    func fetchRepositories() {
        guard !name.isEmpty else {
            return repositories = []
        }

        var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "page", value: String(currentPage)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        searchCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: SearchRepoResponse.self, decoder: JSONDecoder())
            .map { $0.items }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.repositories) }
            .sink { [weak self] in
                self?.currentPage += 1
                self?.repositories.append(contentsOf: $0)
                if $0.count < self!.perPage {
                    self?.reposListFull = true
                }}
    }
}
