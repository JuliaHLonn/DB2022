package se.iths;

public class Constants {
    public static final String JDBC_CONNECTION = "jdbc:mysql://localhost:3306/Chinook";
    public static final String JDBC_USER = "iths";
    public static final String JDBC_PASSWORD = "iths";
    public static final String SQL_SELECT_ALL_ARTISTS = "SELECT ArtistId, Name FROM Artist";
    public static final String SQL_COL_ARTIST_ID = "ArtistId";
    public static final String SQL_COL_ALBUM_ID = "AlbumId";
    public static final String SQL_COL_ARTIST_NAME = "name";
    public static final String SQL_COL_ALBUM_TITLE = "title";
    public static final String SQL_SELECT_ALBUMS_BY_ARTISTID = "SELECT ArtistId, Name, AlbumId, Title FROM Artist JOIN Album USING (ArtistId) where ArtistId = ? ORDER BY ArtistId";
}
