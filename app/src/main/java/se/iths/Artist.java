package se.iths;

import java.util.ArrayList;
import java.util.Collection;

public class Artist {
    private final long ArtistId;
    private String Name;
    private Collection<Album> albums = new ArrayList<>();

    public Artist(long id, String name){
        this.ArtistId = id;
        this.Name = name;
    }

    public long getArtistId() {
        return ArtistId;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        this.Name = name;
    }

    public void add(Album album){
        albums.add(album);
    }

    public String toString(){
        return "Artist: " + ArtistId + " " + Name + " - ";
    }
}
