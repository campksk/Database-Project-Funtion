CREATE OR REPLACE FUNCTION admin_get_all_bookings()
RETURNS TABLE (
    booking_id INT,
    customer_name TEXT,
    customer_tel TEXT,
    hotel_name TEXT,
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
        (u.FName || ' ' || u.LName)::TEXT,
        u.Tel::TEXT,
        h.HotelName::TEXT,
        r.RoomNumber,
        b.Start,
        b.End,
        b.TotalCost
    FROM "Booking" b
    JOIN "User" u ON b.UserId = u.UserId
    JOIN "Has" has ON b.BookingID = has.BookingID
    JOIN "Room" r ON has.RoomNumber = r.RoomNumber AND has.BuildingId = r.BuildingId
    JOIN "Building" bl ON r.BuildingId = bl.BuildingId
    JOIN "Hotel" h ON bl.HotelId = h.HotelId
    ORDER BY b.BookingID ASC;
END;
$$;