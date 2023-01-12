package se.iths;

public class Album {
    private final long AlbumId;
    private String Title;

    public Album(long id, String title){
        this.AlbumId = id;
        this.Title = title;
    }

    public long getAlbumId() {
        return AlbumId;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        this.Title = title;
    }

    public String toString() {
        return "Album: " + AlbumId + " " + Title;
    }
}
