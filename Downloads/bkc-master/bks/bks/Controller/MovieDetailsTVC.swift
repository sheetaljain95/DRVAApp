//
//  MovieDetailsTVC.swift
//  bks
//
//  Created by Sheetal Jain on 19/08/19.
//




import UIKit

class MovieDetailsTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var page = 0
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var segOutlet: UITableView!
    
    var movieimage: UIImage!
    var movieoverview :String!
    var movieid: Int!
    var segmentVar: Int?
    let imagePrefix: String = "https://image.tmdb.org/t/p/w500/"

    @IBOutlet weak var movieSegment: UISegmentedControl!
    
    @IBAction func movieSegmentAction(_ sender: Any) {
        switch movieSegment.selectedSegmentIndex {
        case 0:
            segmentVar = 1
            callReview()
        case 1:
            segmentVar = 2
            callCredits()
        case 2:
            segmentVar = 3
            callsimilarMovies()
        default:
            segmentVar = 1
        }
    }
    
    var credit = [CreditStruct]()
    var reviews = Reviews()
    var similarmovies = [SimilarMovies]()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentVar == 1 {
            print("in TB")
        return 180
        }
        else if segmentVar == 2 {
        return 100
        }
        else if segmentVar == 3 {
        return 120
        }
        else {
            return 180}
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segmentVar == 1 {
            return UITableView.automaticDimension
        }
            
        else if segmentVar == 2 {
        return 100
        }
            
        else if segmentVar == 3 {
        return 120
        }
        
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentVar == 1) {
        return self.reviews.results?.count ?? 0
        }
        else if (segmentVar == 2) {
            return credit.count
        }
        else if (segmentVar == 3) {
            return similarmovies.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (segmentVar == 1){
        let Cell  = tableView.dequeueReusableCell(withIdentifier: "ReviewCell")! as! ReviewTVC
        Cell.Author!.text = self.reviews.results?[indexPath.row].author
        Cell.Content!.text = self.reviews.results?[indexPath.row].content

        return Cell
        }
        else if (segmentVar == 2){
            let Cell  = tableView.dequeueReusableCell(withIdentifier: "CreditsCell")! as! CreditsTVC
            Cell.Name!.text = self.credit[indexPath.row].name
            Cell.Department!.text = self.credit[indexPath.row].department
            let image: String = self.credit[indexPath.row].profile_path!
            let urlimg = URL(string: image)!
            if let dataImg = try? Data(contentsOf: urlimg) {
                Cell.creditsImage.image = UIImage(data: dataImg)!
            }
            return Cell
        }
            
        else if (segmentVar == 3){
            let Cell  = tableView.dequeueReusableCell(withIdentifier: "similarMoviesCell")! as! SimilarMoviesTVC
            print(Cell)
            Cell.similarMoviesCell!.text = self.similarmovies[indexPath.row].title
            let image: String = self.similarmovies[indexPath.row].poster_path!
            let urlimg = URL(string: image)!
            print(urlimg)
            if let dataImg = try? Data(contentsOf: urlimg) {
                Cell.similarMoviesImage.image = UIImage(data: dataImg)!
            }
            return Cell
        }
            

            
        else {
            let Cell  = tableView.dequeueReusableCell(withIdentifier: "CreditsCell")! as! CreditsTVC
            Cell.Name!.text = self.reviews.results?[indexPath.row].author
            Cell.Department!.text = self.reviews.results?[indexPath.row].content
            return Cell        }
        
    }
    
    func registerTableViewCellsReview() {
        let textFieldCell = UINib(nibName: "ReviewTVC", bundle: nil)
        self.segOutlet.register(textFieldCell, forCellReuseIdentifier:"ReviewCell")
    }
    func registerTableViewCellsSimilarMovies() {
        let textFieldCell = UINib(nibName: "SimilarMoviesTVC", bundle: nil)
        self.segOutlet.register(textFieldCell, forCellReuseIdentifier:"similarMoviesCell")
    }

    func registerTableViewCellsCredits() {
        let textFieldCell = UINib(nibName: "CreditsTVC", bundle: nil)
        self.segOutlet.register(textFieldCell, forCellReuseIdentifier:"CreditsCell")
    }

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        registerTableViewCellsReview()
        registerTableViewCellsCredits()
        registerTableViewCellsSimilarMovies()
        movieImageView.image = movieimage
        overview.text = movieoverview
    }

    func callReview() {
        let moviesService = MoviesService()
        moviesService.callReview(withMovieID: movieid) {
            (reviews) in
            DispatchQueue.main.async {
            self.reviews = reviews
            self.segOutlet.reloadData()
            }
        }
    }
    
    func callCredits() {
        let moviesService = MoviesService()
        moviesService.callCredits(withMovieID: movieid) {
            (credits) in
            DispatchQueue.main.async {
            self.credit = credits
            self.segOutlet.reloadData()
            }
        }
    }
    
    func callsimilarMovies() {
        let moviesService = MoviesService()
        moviesService.callsimilarMovies(withMovieID: movieid) {
            (similarMovies) in
            DispatchQueue.main.async {
            self.similarmovies = similarMovies
            self.segOutlet.reloadData()
            }
        }
    }
}

 



