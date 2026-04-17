package moffatbay;

import java.math.BigDecimal;

/* Simple class that holds information about one room.
   Matches the columns in the rooms table. */
public class Room {

    private int roomId;
    private String roomType;
    private BigDecimal roomPrice;
    private String roomStatus;

    public Room(int roomId, String roomType, BigDecimal roomPrice, String roomStatus) {
        this.roomId = roomId;
        this.roomType = roomType;
        this.roomPrice = roomPrice;
        this.roomStatus = roomStatus;
    }

    // Getters so the JSP page can read the values
    public int getRoomId() {
        return roomId;
    }

    public String getRoomType() {
        return roomType;
    }

    public BigDecimal getRoomPrice() {
        return roomPrice;
    }

    public String getRoomStatus() {
        return roomStatus;
    }
}