BEGIN
INSERT INTO AIRLINES (id, username, passHash, company_name, street, street_num, postal_code, city, country) VALUES (0, 'user0A', 'pass0', 'Polish Airlines', 'Prosta', '70B', '10-500', 'Warsaw', 'Poland');
INSERT INTO AIRLINES (id, username, passHash, company_name, street, street_num, postal_code, city, country) VALUES (1, 'user1A', 'pass1', 'Emirates', 'Samar Street', '10', '32-400', 'Dubai', 'United Arab Emirates');
INSERT INTO AIRLINES (id, username, passHash, company_name, street, street_num, postal_code, city, country) VALUES (2, 'user2A', 'pass2', 'American Airlines', 'John Street', '10/2', '90-505', 'Texas', 'United States');
INSERT INTO AIRLINES (id, username, passHash, company_name, street, street_num, postal_code, city, country) VALUES (3, 'user3A', 'pass3', 'Lufthansa', 'Grosse Strasse', '40', '33-220', 'Cologne', 'Germany');
COMMIT;
 EXCEPTION WHEN OTHERS THEN
 RAISE;
 END;
 /

