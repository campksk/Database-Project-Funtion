-- [1] 
CALL RegisterUser('John', 'Doe', '0812223333', 'john@email.com', 'mypassword');

SELECT * FROM Account;
SELECT * FROM Client;


-- [2] ถูก
SELECT * FROM LoginUser('john@email.com', 'mypassword');

-- ผิด
SELECT * FROM LoginUser('john@email.com', 'wrong_pass');


-- [3] 
SELECT * FROM ViewHotelList;

-- จองไม่เกิน
CALL CreateBooking(1, 343, 65, '2026-03-01', '2026-03-03');

-- จองเกิน
CALL CreateBooking(1, 343, 65, '2026-03-01', '2026-03-06');


-- [4] 
SELECT * FROM ViewMyBookings(1);


-- [5] 
CALL UserEditBooking(102, 1, '2026-03-04', '2026-03-06');


-- [6] 
CALL UserDeleteBooking(2, 48);


-- [7]
SELECT * FROM AdminViewAllBookings;


-- [8] 
CALL AdminEditBooking(1, '2026-03-01', '2026-03-03', 'Paid');


-- [9] 
CALL AdminDeleteBooking(1);

SELECT * FROM booking 
ORDER BY bookingid;