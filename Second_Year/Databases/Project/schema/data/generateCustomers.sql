BEGIN
INSERT INTO CUSTOMERS (id, username, passHash, first_name, second_name, street, street_num, postal_code, city, country) VALUES (0, 'user0C', 'pass0', 'Olaf', 'Placha', 'Dluga', '10', '41-500', 'Chorzow', 'Poland');
INSERT INTO CUSTOMERS (id, username, passHash, first_name, second_name, street, street_num, postal_code, city, country) VALUES (1, 'user1C', 'pass1', 'John', 'Smith', 'Strange Street', '108', '39-900', 'Las Vegas', 'United States');
INSERT INTO CUSTOMERS (id, username, passHash, first_name, second_name, street, street_num, postal_code, city, country) VALUES (2, 'user2C', 'pass2', 'Andrew', 'Ng', 'Xing Hao', '40', '56-987', 'Beijing', 'China');
COMMIT;
 EXCEPTION WHEN OTHERS THEN
 RAISE;
 END;
 /

