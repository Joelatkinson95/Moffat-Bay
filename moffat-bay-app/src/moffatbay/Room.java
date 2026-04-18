package moffatbay;

import java.math.BigDecimal;

/* Holds info about a room type and how many are available.
   Used by the availability page to show what the customer can book. */
public class Room {

    private String roomType;
    private BigDecimal roomPrice;
    private int availableCount;

    public Room(String roomType, BigDecimal roomPrice, int availableCount) {
        this.roomType = roomType;
        this.roomPrice = roomPrice;
        this.availableCount = availableCount;
    }

    // Getters so the JSP page can read the values
    public String getRoomType() {
        return roomType;
    }

    public BigDecimal getRoomPrice() {
        return roomPrice;
    }

    public int getAvailableCount() {
        return availableCount;
    }
}