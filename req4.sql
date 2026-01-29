CREATE OR REPLACE FUNCTION get_my_bookings(p_user_id INT)
RETURNS TABLE (
    booking_id INT,
    hotel_name TEXT,
    hotel_tel TEXT,
    room_number INT,
    check_in DATE,
    check_out DATE,
    total_cost NUMERIC
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.BookingID,
        h.HotelName::TEXT,
        h.Tel::TEXT,
        r.RoomNumber,
        b.Start,
        b.End,
        b.TotalCost
    FROM "Booking" b
    JOIN "Has" has ON b.BookingID = has.BookingID
    JOIN "Room" r ON has.RoomNumber = r.RoomNumber AND has.BuildingId = r.BuildingId
    JOIN "Building" bl ON r.BuildingId = bl.BuildingId
    JOIN "Hotel" h ON bl.HotelId = h.HotelId
    WHERE b.UserId = p_user_id
    ORDER BY b.BookingDate DESC;
END;
$$;