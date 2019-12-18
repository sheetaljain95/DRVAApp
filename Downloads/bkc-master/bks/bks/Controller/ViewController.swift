import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var CustomTVCOutlet: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let session = URLSession.shared
    var searchActive = false
    
    var page = 0
        
        
    var filtermovie: [MovieTableStruct]?
    var moviearray = [MovieTableStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        searchBar.delegate = self
        callApi()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false
            self.CustomTVCOutlet.reloadData()
            return
        }
        guard let text = searchBar.text else {
            searchActive = false
            return
        }
        searchActive = true
        filtermovie = moviearray.filter {
            return ($0.movieTitle.contains(text))
        }
        self.CustomTVCOutlet.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.CustomTVCOutlet.reloadData()
    }
    
    func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.CustomTVCOutlet.register(textFieldCell, forCellReuseIdentifier:"ident")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtermovie?.count ?? 0
        }
        else {
            return moviearray.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == moviearray.count - 1 {
            if !searchActive {
            callApi()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ident")! as! CustomTableViewCell
        if searchActive {
            cell.movieTitle.text = (self.filtermovie?[indexPath.row].movieTitle)!
            cell.releaseDate.text = self.filtermovie?[indexPath.row].releaseDate
            cell.movieImage.image = self.filtermovie?[indexPath.row].movieImage
        }
        else {
        cell.movieTitle.text = self.moviearray[indexPath.row].movieTitle
        cell.releaseDate.text = self.moviearray[indexPath.row].releaseDate
        cell.movieImage.image = self.moviearray[indexPath.row].movieImage
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsTVC
        if searchActive == false{
        destination.movieimage = moviearray[indexPath.row].movieImage
        destination.movieoverview = moviearray[indexPath.row].movieOverview
        destination.movieid = moviearray[indexPath.row].movieId
        }
        if searchActive == true{
            destination.movieimage = filtermovie?[indexPath.row].movieImage
            destination.movieoverview = filtermovie?[indexPath.row].movieOverview
            destination.movieid = filtermovie?[indexPath.row].movieId
        }
        navigationController?.pushViewController(destination, animated: true)
        
    }
    
    func callApi() {
        page = page + 1
        var moviesService = MoviesService()
        moviesService.getMovies(withPageNo: page) {
            (moviesArray) in
            DispatchQueue.main.async {
                for instance in moviesArray {
                    self.moviearray.append(instance)
                }
                self.CustomTVCOutlet.reloadData()
            }
        }
    }
}
