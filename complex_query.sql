SELECT h.hotelid, h.hotelname, round(COUNT(r.roomnumber)::decimal / (tr.total_room),2) as score
FROM hotel h
NATURAL JOIN building b
NATURAL JOIN room r
NATURAL JOIN has ha
NATURAL JOIN booking bo
JOIN
(
        SELECT COUNT(r2.roomnumber) AS total_room, h2.hotelid
        FROM hotel h2
        NATURAL JOIN building b2
        NATURAL JOIN room r2
        GROUP BY h2.hotelid
) tr ON tr.hotelid = h.hotelid
GROUP BY h.hotelid, h.hotelname, total_room
order by score desc;