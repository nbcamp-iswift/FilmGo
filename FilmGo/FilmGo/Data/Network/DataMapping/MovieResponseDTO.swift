import Foundation

// MARK: - Now Playing URL <-> Response Data

struct NowPlayingPopularMovieResponseDTO: Codable {
    let page: Int
    let results: [MovieDetailResponseDTO]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MovieDetail URL <-> Response Data

struct MovieDetailResponseDTO: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollectionDTO?
    let budget: Int?
    let genres: [GenreDTO]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompanyDTO]?
    let productionCountries: [ProductionCountryDTO]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguageDTO]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let videos: Videos?
    let images: ImagesDTO?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case videos, images
    }
}

struct BelongsToCollectionDTO: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct GenreDTO: Codable {
    let id: Int?
    let name: String?
}

struct ImagesDTO: Codable {
    let backdrops: [ImageItemDTO]
    let logos: [ImageItemDTO]
    let posters: [ImageItemDTO]
}

struct ImageItemDTO: Codable {
    let aspectRatio: Double?
    let filePath: String?
    let width: Int?
    let height: Int?
    let iso6391: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case iso6391 = "iso_639_1"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

struct ProductionCompanyDTO: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

struct ProductionCountryDTO: Codable {
    let iso3166_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguageDTO: Codable {
    let englishName: String?
    let iso639_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

struct Videos: Codable {
    let results: [VideoItem]?
}

struct VideoItem: Codable {
    let iso639_1, iso3166_1, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

// MARK: - MovieCredit

struct MovieCreditResponseDTO: Codable {
    let id: Int?
    let cast: [CastDTO]?
    let crew: [CastDTO]?
}

// MARK: - Cast

struct CastDTO: Codable {
    let name: String?
}
