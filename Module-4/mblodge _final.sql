-- Moffat Bay Lodge Database 
-- CSD-460 Capstone
-- Updated for submission (constraints, trigger fix, data integrity)
-- Authors: Kyle Klausen, Joel Atkinson, Zachary Baker, Juan Macias-Vasquez, and Brittaney Perry-Morgan

DROP DATABASE IF EXISTS mblodge;
CREATE DATABASE mblodge;
USE mblodge;

CREATE USER IF NOT EXISTS 'mbGuest123'@'localhost' IDENTIFIED BY 'mbPass123!';
GRANT ALL PRIVILEGES ON mblodge.* TO 'mbGuest123'@'localhost';
FLUSH PRIVILEGES;

--------------------------------------------------
-- Table: users
--------------------------------------------------

CREATE TABLE users (
    user_id          INT PRIMARY KEY AUTO_INCREMENT,
    user_email       VARCHAR(100) NOT NULL UNIQUE,
    user_password    VARCHAR(255) NOT NULL,
    user_firstName   VARCHAR(50) NOT NULL,
    user_lastName    VARCHAR(50) NOT NULL,
    user_phoneNumber VARCHAR(20) NOT NULL
);

INSERT INTO users (user_email, user_password, user_firstName, user_lastName, user_phoneNumber) VALUES
('john.doe@email.com',    'Password1a', 'John',  'Doe',     '555-101-2020'),
('jane.smith@email.com',  'Password2b', 'Jane',  'Smith',   '555-203-4040'),
('bob.johnson@email.com', 'Password3c', 'Bob',   'Johnson', '555-305-6060');

--------------------------------------------------
-- Table: rooms
--------------------------------------------------

CREATE TABLE rooms (
    room_id     INT PRIMARY KEY,
    room_type   VARCHAR(50)   NOT NULL,
    room_price  DECIMAL(10,2) NOT NULL,
    room_status VARCHAR(20)   NOT NULL DEFAULT 'available',
    CONSTRAINT check_room_status 
        CHECK (room_status IN ('available', 'occupied', 'maintenance', 'out_of_service'))
);

INSERT INTO rooms (room_id, room_type, room_price, room_status) VALUES
-- Floor 1
(101, 'Double Queen',       119.99, 'available'),
(102, 'Double Queen',       119.99, 'available'),
(103, 'Double Queen',       119.99, 'available'),
(104, 'Double Queen',       119.99, 'available'),
(105, 'Double Queen',       119.99, 'available'),
(106, 'King',               149.99, 'available'),
(107, 'King',               149.99, 'available'),
(108, 'King',               149.99, 'available'),
(109, 'Family Suite',       219.99, 'available'),
(110, 'Family Suite',       219.99, 'available'),
-- Floor 2
(201, 'Double Queen',       119.99, 'available'),
(202, 'Double Queen',       119.99, 'available'),
(203, 'Double Queen',       119.99, 'available'),
(204, 'Double Queen',       119.99, 'available'),
(205, 'Double Queen',       119.99, 'available'),
(206, 'King',               149.99, 'available'),
(207, 'King',               149.99, 'available'),
(208, 'King',               149.99, 'available'),
(209, 'Family Suite',       219.99, 'available'),
(210, 'Family Suite',       219.99, 'available'),
-- Floor 3
(301, 'Double Queen',       119.99, 'available'),
(302, 'Double Queen',       119.99, 'available'),
(303, 'Double Queen',       119.99, 'available'),
(304, 'Double Queen',       119.99, 'available'),
(305, 'Double Queen',       119.99, 'available'),
(306, 'King',               149.99, 'available'),
(307, 'King',               149.99, 'available'),
(308, 'King',               149.99, 'available'),
(309, 'Family Suite',       219.99, 'available'),
(310, 'Family Suite',       219.99, 'available'),
-- Floor 4
(401, 'Double Queen',       119.99, 'available'),
(402, 'Double Queen',       119.99, 'available'),
(403, 'Double Queen',       119.99, 'available'),
(404, 'Double Queen',       119.99, 'available'),
(405, 'King',               149.99, 'available'),
(406, 'King',               149.99, 'available'),
(407, 'King',               149.99, 'available'),
(408, 'Family Suite',       219.99, 'available'),
(409, 'Family Suite',       219.99, 'available'),
(410, 'Presidential Suite', 499.99, 'available');

--------------------------------------------------
-- Table: reservation
--------------------------------------------------

CREATE TABLE reservation (
    reservation_id          INT AUTO_INCREMENT PRIMARY KEY,
    reservation_guestAmount INT  NOT NULL,
    reservation_checkIn     DATE NOT NULL,
    reservation_checkOut    DATE NOT NULL,
    reservation_status      VARCHAR(20) NOT NULL DEFAULT 'confirmed',
    room_id                 INT  NOT NULL,
    user_id                 INT  NOT NULL,

    CONSTRAINT check_dates 
        CHECK (reservation_checkOut > reservation_checkIn),

    CONSTRAINT check_guest_amount 
        CHECK (reservation_guestAmount > 0),

    CONSTRAINT check_res_status 
        CHECK (reservation_status IN ('confirmed', 'cancelled', 'completed', 'no_show')),

    FOREIGN KEY (room_id) REFERENCES rooms(room_id)  
        ON DELETE RESTRICT ON UPDATE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(user_id)  
        ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO reservation 
(reservation_guestAmount, reservation_checkIn, reservation_checkOut, reservation_status, room_id, user_id) VALUES
(2, '2025-06-01', '2025-06-05', 'confirmed', 101, 1),
(3, '2025-06-10', '2025-06-14', 'confirmed', 106, 2),
(1, '2025-06-20', '2025-06-22', 'confirmed', 109, 3);

--------------------------------------------------
-- Trigger: Prevent Double Booking (FIXED)
--------------------------------------------------

DELIMITER //

CREATE TRIGGER before_reservation_insert
BEFORE INSERT ON reservation
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;

    SELECT COUNT(*) INTO overlap_count
    FROM reservation
    WHERE room_id = NEW.room_id
      AND reservation_status = 'confirmed'
      AND (
        NEW.reservation_checkIn  < reservation_checkOut AND
        NEW.reservation_checkOut > reservation_checkIn
      );

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Room already booked for selected dates.';
    END IF;
END;
//

DELIMITER ;

--------------------------------------------------
-- SELECT STATEMENTS (for screenshots)
--------------------------------------------------

SELECT * FROM users;
SELECT * FROM rooms;
SELECT * FROM reservation;