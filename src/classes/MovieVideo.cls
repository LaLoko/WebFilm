public class MovieVideo{
    public Integer id;	//580489
    public cls_results[] results;
    public class cls_results {
        public String iso_639_1;	//en
        public String iso_3166_1;	//US
        public String name;	//Wild Entertainment
        public String key;	//jU8VNQKKF-g
        public String site;	//YouTube
        public Integer size;	//1080
        public String type;	//Teaser
        public boolean official;
        public String published_at;	//2021-10-04T23:49:42.000Z
        public String id;	//615f03ca8e2ba600434da5f7
    }
    public static MovieVideo parse(String json){
        return (MovieVideo) System.JSON.deserialize(json, MovieVideo.class);
    }
}