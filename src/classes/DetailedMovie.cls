public class DetailedMovie {

    public class Production_companies {
        public Integer id;
        public String logo_path;
        public String name;
        public String origin_country;
    }

    public Boolean adult;
    public String backdrop_path;
    public Belongs_to_collection belongs_to_collection;
    public Integer budget;
    public List<Genres> genres;
    public String homepage;
    public Integer id;
    public String imdb_id;
    public String original_language;
    public String original_title;
    public String overview;
    public Double popularity;
    public String poster_path;
    public List<Production_companies> production_companies;
    public List<Production_countries> production_countries;
    public String release_date;
    public Integer revenue;
    public Integer runtime;
    public List<Spoken_languages> spoken_languages;
    public String status;
    public String tagline;
    public String title;
    public Boolean video;
    public Double vote_average;
    public Integer vote_count;

    public class Production_countries {
        public String iso_3166_1;
        public String name;
    }
    public class Belongs_to_collection {
        public Integer id;
        public String name;
        public String poster_path;
        public String backdrop_path;
    }

    public class Genres {
        public Integer id;
        public String name;
    }

    public class Spoken_languages {
        public String english_name;
        public String iso_639_1;
        public String name;
    }

    public static DetailedMovie parse(String json) {
        System.debug(json);
        return (DetailedMovie) System.JSON.deserialize(json, DetailedMovie.class);
    }
}