CREATE OR REPLACE FUNCTION get_my_bookings(p_user_id INT)
RETURNS TABLE (
    booking_id INT,
    hotel_name TEXT,
    hotel_tel TEXT,
    room_number TEXT, -- เปลี่ยนจาก INT เป็น TEXT
    check_in DATE,
    check_out DATE,
    total_cost NUMERIC
)
 LANGUAGE plpgsql

AS $$

BEGIN

    RETURN QUERY

    SELECT 

        b.bookingid,

        h.hotelname::TEXT,

        h.tel::TEXT,

        r.roomnumber::TEXT,

        b.startdate,

        b.enddate,

        b.totalcost

    FROM "booking" b

    JOIN "has" has ON b.bookingid = has.bookingid

    JOIN "room" r ON has.roomnumber = r.roomnumber AND has.buildingid = r.buildingid

    JOIN "building" bl ON r.buildingid = bl.buildingid

    JOIN "hotel" h ON bl.hotelid = h.hotelid

    WHERE b.userId = p_user_id

    ORDER BY b.bookingdate DESC;

END;

$$; 