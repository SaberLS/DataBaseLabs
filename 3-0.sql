-- 1 --------------------------------
-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
USE Northwind
SELECT
    p.ProductName
    ,p.ProductID
    ,s.Address
    ,s.City
    ,s.Country
    ,s.PostalCode
FROM
    Products AS p
    LEFT JOIN Suppliers AS s
    ON p.SupplierID = s.SupplierID
WHERE p.UnitPrice BETWEEN 20 AND 30


-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
USE Northwind
SELECT
    p.ProductName
    ,p.UnitsInStock
FROM
    Products AS p
    INNER JOIN Suppliers AS s
    ON p.SupplierID = s.SupplierID AND s.CompanyName = 'Tokyo Traders'


-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak TO pokaż ich dane adresowe
USE Northwind
SELECT
    c.CustomerID
    ,c.Address
    ,c.City
    ,c.Country
    ,c.PostalCode
FROM
    Customers AS c
    LEFT JOIN (SELECT
        o.CustomerID
    FROM
        Orders AS o
    WHERE YEAR(o.OrderDate) = 1997
    GROUP BY o.CustomerID
    ) AS o997
    ON c.CustomerID = o997.CustomerID
WHERE o997.CustomerID IS NULL


-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie ma w magazynie.
USE Northwind
SELECT
    s.ContactName
    ,s.Phone
FROM
    Suppliers AS s
    JOIN Products AS p
    ON s.SupplierID = p.SupplierID
        AND p.UnitsInStock = 0


-- 5. Wybierz zamówienia złożone w marcu 1997. Dla każdego takiego zamówienia wyświetl jego numer, datę złożenia zamówienia oraz nazwę i numer telefonu klienta
USE Northwind
SELECT
    o.OrderID
    ,o.OrderDate
    ,c.CompanyName
    ,c.Phone
    ,o.OrderDate
FROM
    Orders AS o
    JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
        AND YEAR(o.OrderDate) = 1997
        AND MONTH(o.OrderDate) = 3


-- 2.---------------------------------------------------------------------------
-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
USE library
SELECT
    m.lastname
    ,m.firstname
    ,j.birth_date
FROM
    juvenile AS j
    INNER JOIN member AS m
    ON j.member_no = m.member_no 

-- 2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
USE library
SELECT
    DISTINCT
    t.title
FROM
    loan AS l
    INNER JOIN title AS t
    ON l.title_no = t.title_no


-- 3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao Teh King’.  Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką zapłacono karę
USE library

SELECT
    CASE 
        WHEN DATEDIFF(DAY ,l.due_date, l.in_date) < 0 THEN 0
        ELSE DATEDIFF(DAY ,l.due_date, l.in_date)  
    END AS [dateDiff]
    ,l.fine_paid
    ,t.title
FROM
    loanhist AS l
    INNER JOIN title AS t
    ON l.title_no = t.title_no
        AND t.title = 'Tao Teh King'


-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych przez osobę o nazwisku: Stephen A. Graff
SELECT
    r.isbn
FROM
    reservation AS r
    INNER JOIN member AS m
    ON r.member_no = m.member_no
        AND m.lastname = 'Graff'
        AND m.firstname = 'Stephen'
        AND m.middleinitial = 'A'


--3. ----------------------------------------------

-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, interesują nas tylko produkty z kategorii ‘Meat/Poultry’


-- 2. Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu podaj nazwę dostawcy.


-- 3. Dla każdego klienta podaj liczbę złożonych przez niego zamówień. Zbiór wynikowy powinien zawierać nazwę klienta, oraz liczbę zamówień


-- 4. Dla każdego klienta podaj liczbę złożonych przez niego zamówień w marcu 1997r

--------------




-- 1. Który ze spedytorów był najaktywniejszy w 1997 roku, podaj nazwę tego spedytora


-- 2. Dla każdego zamówienia podaj wartość zamówionych produktów. Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta oraz wartość zamówionych produktów


-- 3. Dla każdego zamówienia podaj jego pełną wartość (wliczając opłatę za przesyłkę). Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta oraz pełną wartość zamówienia


----------------------------------------------------


-- 1. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty  z kategorii ‘Confections’


-- 2. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii ‘Confections’


-- 3. Wybierz nazwy i numery telefonów klientów, którzy w 1997r nie kupowali produktów z kategorii ‘Confections’



----------------------------------------------------

-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki
-- (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres zamieszkania dziecka.


-- 2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki 
--(baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania dziecka oraz imię i nazwisko rodzica.

----------------------------------------------------


-- 1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych
-- (baza northwind)

-- 2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych
-- (baza northwind)

-- 3. Napisz polecenie, które wyświetla pracowników, którzy mają podwładnych
-- (baza northwind)


----------------------------------------------------


-- 1. Podaj listę członków biblioteki mieszkających w Arizonie

-- (AZ) mają  więcej niż dwoje dzieci zapisanych do biblioteki

-- 2. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają  więcej niż dwoje dzieci zapisanych do biblioteki 
-- oraz takich którzy mieszkają w Kaliforni (CA) i mają więcej niż troje dzieci zapisanych do biblioteki