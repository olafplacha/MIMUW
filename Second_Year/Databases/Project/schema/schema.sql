-- DROP TABLE airlines CASCADE CONSTRAINTS;
-- DROP TABLE customers CASCADE CONSTRAINTS;
-- DROP TABLE cities CASCADE CONSTRAINTS;
-- DROP TABLE airports CASCADE CONSTRAINTS;
-- DROP TABLE airplaneModels CASCADE CONSTRAINTS;
-- DROP TABLE airplanes CASCADE CONSTRAINTS;
-- DROP TABLE flights CASCADE CONSTRAINTS;
-- DROP TABLE bookings CASCADE CONSTRAINTS;

--stores information about Airlines
CREATE TABLE airlines (
	id NUMBER(6) PRIMARY KEY,
	username VARCHAR2(30) NOT NULL UNIQUE,
	passHash VARCHAR2(255) NOT NULL,
	date_created TIMESTAMP(0) DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL, --UTC time for convenience
	date_last_active TIMESTAMP(0) DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,
	company_name VARCHAR2(30) NOT NULL,
	street VARCHAR2(30) NOT NULL,
	street_num VARCHAR2(6) NOT NULL,
	postal_code VARCHAR2(6) NOT NULL,
	city VARCHAR2(30) NOT NULL,
	country VARCHAR2(30) NOT NULL
);

-- CREATE UNIQUE INDEX fast_login ON airlines(username); (actually created automatically by BD)

--stores information about Customers
CREATE TABLE customers (
	id NUMBER(6) PRIMARY KEY,
	username VARCHAR2(30) NOT NULL UNIQUE,
	passHash VARCHAR2(255) NOT NULL,
	date_created TIMESTAMP(0) DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP),
	date_last_active TIMESTAMP(0) DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP),
	first_name VARCHAR2(30) NOT NULL,
	second_name VARCHAR2(30) NOT NULL,
	street VARCHAR2(30) NOT NULL,
	street_num VARCHAR2(6) NOT NULL,
	postal_code VARCHAR2(6) NOT NULL,
	city VARCHAR2(30) NOT NULL,
	country VARCHAR2(30) NOT NULL
);

--stores information about cities
CREATE TABLE cities (
	id NUMBER(6) PRIMARY KEY,
	name VARCHAR2(30) NOT NULL,
	country VARCHAR2(30) NOT NULL,
	latitude NUMBER(9,6) NOT NULL,
	longitude NUMBER(9,6) NOT NULL
);

CREATE TABLE airports (
	id NUMBER(6) PRIMARY KEY,
	name VARCHAR2(100) NOT NULL,
	idCity NUMBER(6) NOT NULL REFERENCES cities(id)
);

CREATE INDEX city_index ON airports(idCity); --will be useful when we want to get all airports in a given city

CREATE TABLE airplaneModels (
	id NUMBER(6) PRIMARY KEY,
	producer VARCHAR2(30) NOT NULL,
	type VARCHAR2(100) NOT NULL,
	capacity NUMBER(4) NOT NULL CHECK (capacity > 0)
);

CREATE TABLE airplanes (
	id NUMBER(6) PRIMARY KEY,
	ownerId NUMBER(6) NOT NULL REFERENCES airlines(id),
	modelId NUMBER(6) NOT NULL REFERENCES airplaneModels(id)
);

CREATE TABLE flights (
	id NUMBER(6) PRIMARY KEY,
	planeId NUMBER(6) NOT NULL REFERENCES airplanes(id),
	price_per_ticket NUMBER(4) NOT NULL CHECK (price_per_ticket > 0),
	seats_taken NUMBER(4) DEFAULT 0 NOT NULL, --redundant, but computing it on every booking might be expensive
	date_dept TIMESTAMP(0) NOT NULL,
	date_arr TIMESTAMP(0) NOT NULL,
	airport_dept NUMBER(6) NOT NULL REFERENCES airports(id),
	airport_arr NUMBER(6) NOT NULL REFERENCES airports(id),
	CONSTRAINT dept_before_arr CHECK (date_dept < date_arr)
);

CREATE INDEX flights_index ON flights(airport_dept, date_dept); --will be useful when we want to get all flights in a given time interval from a given airport

CREATE TABLE bookings (
	id NUMBER(6) PRIMARY KEY,
	customerId NUMBER(6) NOT NULL REFERENCES customers(id),
	flightId NUMBER(6) NOT NULL REFERENCES flights(id),
	number_of_tickets NUMBER(3) NOT NULL CHECK (number_of_tickets > 0)
);
	
--trigger for checking if a new booking is possible regarding seats taken
--not sure if it can prevent overbooking when two users are booking the last ticket at the same time (to do: think about isolation level that will prevent this)

CREATE OR REPLACE TRIGGER check_if_not_overbooked
	BEFORE INSERT ON bookings
	FOR EACH ROW
	DECLARE
		before_booking NUMBER;
		max_booking NUMBER;
	BEGIN
		SELECT seats_taken INTO before_booking FROM flights WHERE id = :NEW.flightId;
		SELECT capacity INTO max_booking FROM airplaneModels WHERE id = (
				SELECT modelId FROM airplanes WHERE id = 
				(
					SELECT planeID FROM flights WHERE flights.id = :NEW.flightID
				)
			);
		IF before_booking + :NEW.number_of_tickets > max_booking THEN 
			raise_application_error(-20000, 'Not enough free seats!');
		END IF;
	END;
/

--trigger for checking if a already booked flight is not being deleted

CREATE OR REPLACE TRIGGER check_if_not_del_booked_flight
	BEFORE DELETE ON flights
	FOR EACH ROW
	DECLARE
		num_bookings NUMBER;
	BEGIN
		SELECT count(*) INTO num_bookings FROM bookings WHERE flightid = :OLD.id;
		IF num_bookings > 0 THEN
			raise_application_error(-20000, 'Before deleting a flight bookings must be deleted!');
		END IF;
	END;
/



