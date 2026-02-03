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

CALL RegisterUser('John', 'Doe', '0812223333', 'john@email.com', 'mypassword');

SELECT * FROM Account;
SELECT * FROM Client;