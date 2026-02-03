CREATE OR REPLACE VIEW ViewHotelList AS
SELECT HotelName, Tel, 
       Number || ' ' || Street || ', ' || City || ', ' || Province || ' ' || Country AS Address
FROM Hotel;

CREATE OR REPLACE PROCEDURE CreateBooking(
    p_UserId INT, p_RoomNum INT, p_BuildId INT, p_StartDate DATE, p_EndDate DATE
)
LANGUAGE plpgsql AS $$
DECLARE
    new_booking_id INT;
BEGIN
    IF (p_EndDate - p_StartDate) > 3 THEN
        RAISE EXCEPTION 'จองได้ไม่เกิน 3 คืนเท่านั้น';
    END IF;

    INSERT INTO Booking (UserId, startdate, enddate, BookingDate, PayStatus)
    VALUES (p_UserId, p_StartDate, p_EndDate, CURRENT_DATE, 'Pending')
    RETURNING BookingID INTO new_booking_id;

    INSERT INTO Has (RoomNumber, BuildingId, BookingId)
    VALUES (p_RoomNum, p_BuildId, new_booking_id);
END;
$$;

SELECT * FROM ViewHotelList;