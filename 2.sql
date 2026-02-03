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

SELECT * FROM LoginUser('john@email.com', 'mypassword'); --Correct
SELECT * FROM LoginUser('john@email.com', 'wrong_pass'); --Worng