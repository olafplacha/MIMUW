-- Solution to mid-term exam in logical modelling

CREATE TABLE oddzial (
	id NUMBER(10) PRIMARY KEY,
	klasa NUMBER(1) NOT NULL CHECK (klasa BETWEEN 1 AND 8),
	podklasa VARCHAR2(2) NOT NULL,
	CONSTRAINT unikalnyOddzial UNIQUE (klasa, podklasa)
);
-- id -> wszystko
-- klasa, podklasa (klucz alternatywny) -> id

CREATE TABLE nauczyciel (
	id NUMBER(10) PRIMARY KEY,
	imie VARCHAR2(50) NOT NULL,
	nazwisko VARCHAR2(50) NOT NULL,
	email VARCHAR2(50) NOT NULL,
	wychowawstwo NUMBER(10) UNIQUE REFERENCES oddzial
);

--id -> wszystko

CREATE TABLE sylabus (
	id NUMBER(10) PRIMARY KEY,
	opis VARCHAR(300) NOT NULL
);
-- id -> wszystko

CREATE TABLE zajecia (
	id NUMBER(10) PRIMARY KEY,
	przedmiot VARCHAR2(10) NOT NULL,
	idSylabusu NUMBER(10) NOT NULL REFERENCES sylabus,
	CONSTRAINT unikalnyPrzedmiotSylabus UNIQUE (przedmiot, idSylabusu)
);

-- id -> wszystko
	
CREATE TABLE uczen (
	id NUMBER(10) PRIMARY KEY,
	imie VARCHAR2(50) NOT NULL,
	nazwisko VARCHAR2(50) NOT NULL,
	idOddzialu NUMBER(10) NOT NULL REFERENCES oddzial
);

id -> wszystko

CREATE TABLE lekcje (
	idOddzialu NUMBER(10) NOT NULL REFERENCES oddzial,
	idZajec NUMBER(10) NOT NULL REFERENCES zajecia,
	idNauczyciela NUMBER(10) NOT NULL REFERENCES nauczyciel,
	CONSTRAINT unikalnaPara UNIQUE (idOddzialu, idZajec)
)

-- idOddzialu, idZajec (klucz alternatywny) -> idNauczyciela
-- Zatem wszystkie tabele są w BCNF (bo zależności wynikają z nadkluczy)

