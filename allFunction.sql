-- [1]
CREATE OR REPLACE PROCEDURE RegisterUser(
    p_FName VARCHAR, p_LName VARCHAR, p_Tel VARCHAR, p_Email VARCHAR, p_Pass VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    new_user_id INT;
BEGIN
    INSERT INTO Account (FName, LName, Tel, Email, Password)
    VALUES (p_FName, p_LName, p_Tel, p_Email, p_Pass)
    RETURNING UserId INTO new_user_id;

    INSERT INTO Client (UserId) VALUES (new_user_id);
END;
$$;

-- [2]
CREATE OR REPLACE FUNCTION LoginUser(p_Email VARCHAR, p_Pass VARCHAR)
RETURNS TABLE(UserId INT, FName VARCHAR, LName VARCHAR) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY 
    SELECT a.UserId, a.FName, a.LName 
    FROM Account a
    WHERE a.Email = p_Email AND a.Password = p_Pass;
END;
$$;

-- [3]
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

-- [4]
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

-- [5]
CREATE OR REPLACE PROCEDURE UserEditBooking(p_BookingId INT, p_UserId INT, p_NewStart DATE, p_NewEnd DATE)
LANGUAGE plpgsql AS $$
BEGIN
    IF (p_NewEnd - p_NewStart) > 3 THEN
        RAISE EXCEPTION 'แก้ไขไม่สำเร็จ: ห้ามจองเกิน 3 คืน';
    END IF;

    UPDATE Booking 
    SET startdate = p_NewStart, enddate = p_NewEnd
    WHERE BookingID = p_BookingId AND UserId = p_UserId;
END;
$$;

-- [6]
CREATE OR REPLACE PROCEDURE UserDeleteBooking(p_Id INT, p_User INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Has WHERE BookingId = p_Id;
    DELETE FROM Booking WHERE BookingID = p_Id AND UserId = p_User;
END;
$$;

-- [7]
CREATE OR REPLACE VIEW AdminViewAllBookings AS
SELECT b.*, a.FName || ' ' || a.LName AS CustomerName
FROM Booking b
JOIN Account a ON b.UserId = a.UserId;

-- [8]
CREATE OR REPLACE PROCEDURE AdminEditBooking(p_Id INT, p_Start DATE, p_End DATE, p_PayStatus VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Booking 
    SET startdate = p_Start, enddate = p_End, PayStatus = p_PayStatus::payment_status
    WHERE BookingID = p_Id;
END;
$$;

-- [9]
CREATE OR REPLACE PROCEDURE AdminDeleteBooking(p_Id INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM edit WHERE BookingId = p_Id;
    DELETE FROM Has WHERE BookingId = p_Id;
    DELETE FROM Booking WHERE BookingID = p_Id;
END;
$$;