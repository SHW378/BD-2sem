SELECT 'hello world' AS greeting;

-- Test case: Check if greeting is 'hello world'
SELECT CASE 
    WHEN (SELECT greeting) = 'hello world' THEN 'Test Passed' 
    ELSE 'Test Failed' 
END AS result;