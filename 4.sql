CREATE OR REPLACE FUNCTION ViewMyBookings(p_UserId INT)
RETURNS TABLE(BookingID INT, HotelName VARCHAR, StartDate DATE, EndDate DATE, PaymentStatus VARCHAR) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY 
    SELECT b.BookingID, h.HotelName, b.startdate, b.enddate, b.PayStatus::VARCHAR
    FROM Booking b
    JOIN Has hs ON b.BookingID = hs.BookingId
    JOIN Building bd ON hs.BuildingId = bd.BuildingId
    JOIN Hotel h ON bd.HotelId = h.HotelId
    WHERE b.UserId = p_UserId;
END;
$$;

SELECT * FROM ViewMyBookings(1);