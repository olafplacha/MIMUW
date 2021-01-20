-- Solution to mid-term exam in SQL

-- 1 --
SELECT t.ID, ((A.wysokosc - B.wysokosc) / t.dlugosc) as nachylenie
FROM trasa t JOIN wezel A ON t.skad = A.ID JOIN wezel B on t.dokad = B.ID
ORDER BY nachylenie ASC;

-- 2 --
SELECT w.id, count(t.skad) as ile
FROM wezel w LEFT JOIN trasa t ON w.id = t.skad AND (t.kolor = 'zielona' OR t.kolor = 'niebieska')
GROUP BY w.id
ORDER BY ile DESC;

-- 3 --
-- Korzystamy z przypadku, że trudnosci tras wystepuja w porzadku leksykograficznym
SELECT A.ID, A.skad, A.dokad
FROM trasa A LEFT JOIN trasa B ON A.dokad = B.skad AND A.kolor >= B.kolor
GROUP BY A.ID, A.skad, A.dokad
HAVING count(B.skad) = 0;

-- 4 --
WITH rozbicie AS (
	SELECT t.id,
     	(SELECT count(w.id) FROM wezel w WHERE w.wysokosc > A.wysokosc) ponad,
	(SELECT count(w.id) FROM wezel w WHERE w.wysokosc <= A.wysokosc AND w.wysokosc >= B.wysokosc) pomiedzy,
	(SELECT count(w.id) FROM wezel w WHERE w.wysokosc < B.wysokosc) ponizej
	FROM trasa t JOIN wezel A ON t.skad = A.ID JOIN wezel B ON t.dokad = B.ID
) 
SELECT ID from rozbicie
WHERE ABS(ponad - ponizej) < (pomiedzy - 1);

-- 5 --
WITH przewyzszenia(poczatek, kolejny_punkt, aktualne_przewyzszenie) AS (
	SELECT skad, dokad, A.wysokosc - B.wysokosc 
	FROM trasa t JOIN wezel A on t.skad = A.ID JOIN wezel B on t.dokad = B.ID
	UNION ALL
	SELECT p.poczatek, t.dokad, aktualne_przewyzszenie + A.wysokosc - B.wysokosc
	FROM trasa t JOIN wezel A on t.skad = A.ID JOIN wezel B on t.dokad = B.ID
	JOIN przewyzszenia p ON t.skad = p.kolejny_punkt)
SELECT max(aktualne_przewyzszenie) maksymalne_przewyzszenie from przewyzszenia;


