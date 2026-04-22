package moffatbay;

import java.math.BigDecimal;
import java.sql.Date;

/* Holds all the info for one reservation.
   Populated by CreateReservationServlet after a successful insert
   and by LookupReservationServlet when a guest searches their record. */
public class Reservation {

    private int reservationId;
    private int userId;
    private int roomId;
    private String roomType;
    private BigDecimal roomPrice;
    private Date checkIn;
    private Date checkOut;
    private int guestAmount;
    private String status;
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    private BigDecimal finalPrice;
    private boolean localDiscountApplied;

    public Reservation() { }

    // Getters
    public int getReservationId() { return reservationId; }
    public int getUserId() { return userId; }
    public int getRoomId() { return roomId; }
    public String getRoomType() { return roomType; }
    public BigDecimal getRoomPrice() { return roomPrice; }
    public Date getCheckIn() { return checkIn; }
    public Date getCheckOut() { return checkOut; }
    public int getGuestAmount() { return guestAmount; }
    public String getStatus() { return status; }
    public String getGuestName() { return guestName; }
    public String getGuestEmail() { return guestEmail; }
    public String getGuestPhone() { return guestPhone; }
    public BigDecimal getFinalPrice() { return finalPrice; }
    public boolean isLocalDiscountApplied() { return localDiscountApplied; }

    // Display-friendly confirmation ID like MB-00042
    public String getConfirmationId() {
        return String.format("MB-%05d", reservationId);
    }

    // Setters
    public void setReservationId(int v) { this.reservationId = v; }
    public void setUserId(int v) { this.userId = v; }
    public void setRoomId(int v) { this.roomId = v; }
    public void setRoomType(String v) { this.roomType = v; }
    public void setRoomPrice(BigDecimal v) { this.roomPrice = v; }
    public void setCheckIn(Date v) { this.checkIn = v; }
    public void setCheckOut(Date v) { this.checkOut = v; }
    public void setGuestAmount(int v) { this.guestAmount = v; }
    public void setStatus(String v) { this.status = v; }
    public void setGuestName(String v) { this.guestName = v; }
    public void setGuestEmail(String v) { this.guestEmail = v; }
    public void setGuestPhone(String v) { this.guestPhone = v; }
    public void setFinalPrice(BigDecimal v) { this.finalPrice = v; }
    public void setLocalDiscountApplied(boolean v) { this.localDiscountApplied = v; }
}
