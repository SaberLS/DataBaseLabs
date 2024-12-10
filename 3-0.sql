-- I --------------------------------
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
    c.CustomerID ,c.Address ,c.City ,c.Country ,c.PostalCode
FROM
    Customers AS c
    LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
        AND YEAR(o.OrderDate) = 1997
WHERE o.CustomerID IS NULL


-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie ma w magazynie.
USE Northwind
SELECT
    s.ContactName
    ,s.Phone
FROM
    Suppliers AS s
    JOIN Products AS p
    ON s.SupplierID = p.SupplierID
WHERE p
.UnitsInStock = 0


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


-- II ---------------------------------------------------------------------------
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
    DATEDIFF(DAY, l.in_date, l.due_date) AS [dateDiff]
    ,l.fine_paid
    ,t.title
FROM
    loanhist AS l
    INNER JOIN title AS t
    ON l.title_no = t.title_no
        AND t.title = 'Tao Teh King'
        AND DATEDIFF(DAY, l.in_date, l.due_date) > 0


-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych przez osobę o nazwisku: Stephen A. Graff
USE library

SELECT
    r.isbn
FROM
    reservation AS r
    INNER JOIN member AS m
    ON r.member_no = m.member_no
        AND m.lastname = 'Graff'
        AND m.firstname = 'Stephen'
        AND m.middleinitial = 'A'


-- III ----------------------------------------------

-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, interesują nas tylko produkty z kategorii ‘Meat/Poultry’
USE Northwind

SELECT
    p.ProductName 
    ,p.UnitPrice
    ,s.Address
    ,s.City
    ,s.Country
    ,s.PostalCode
FROM
    Products
AS p
    INNER JOIN Categories AS c
    ON p.CategoryID = c.CategoryID
        AND c.CategoryName = 'Meat/Poultry'
    INNER JOIN Suppliers AS s
    ON p.SupplierID = s.SupplierID
WHERE 
    p.UnitPrice BETWEEN 20 AND 30




-- 2. Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu podaj nazwę dostawcy.
USE Northwind

SELECT
    p.ProductName
    ,p.UnitPrice
    ,s.CompanyName
FROM
    Products AS p
    INNER JOIN Categories AS c
    ON p.CategoryID = c.CategoryID
        AND c.CategoryName = 'Confections'
    LEFT JOIN Suppliers AS s
    ON p.SupplierID = s.SupplierID


-- 3. Dla każdego klienta podaj liczbę złożonych przez niego zamówień. Zbiór wynikowy powinien zawierać nazwę klienta, oraz liczbę zamówień
USE Northwind

SELECT
    c.CompanyName
    ,COUNT(*) AS OrderCount
FROM
    Customers AS c
    LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName


-- 4. Dla każdego klienta podaj liczbę złożonych przez niego zamówień w marcu 1997r
USE Northwind

SELECT
    c.CompanyName
    ,COUNT(*) AS OrderCount
FROM
    Customers AS c
    INNER JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
        AND YEAR(o.OrderDate) = 1997
        AND MONTH(o.OrderDate) = 3
GROUP BY c.CompanyName


-- SELECT
--    c.CompanyName
--    ,oc.OrderCount
-- FROM
--    Customers AS c
--    JOIN ( SELECT
--        o.CustomerID
--        ,COUNT(*) AS [OrderCount]
--    FROM
--        Orders AS o
--    WHERE 
--        YEAR(o.OrderDate) = 1997
--        AND MONTH(o.OrderDate) = 3
--    GROUP BY o.CustomerID
--    HAVING COUNT(*) IS NOT NULL
--    ) AS oc
--    ON c.CustomerID = oc.CustomerID


-- IV. --------------------------------------------------------------------------------------------------
-- 1. Który ze spedytorów był najaktywniejszy w 1997 roku, podaj nazwę tego spedytora
USE Northwind

SELECT
    TOP 1
    s.CompanyName
    ,COUNT(*) AS [OrderCount]
FROM
    Shippers AS s
    LEFT JOIN Orders AS o
    ON s.ShipperID = o.ShipVia
        AND YEAR(o.OrderDate) = 1997
GROUP BY s.CompanyName
ORDER BY OrderCount DESC


-- 2. Dla każdego zamówienia podaj wartość zamówionych produktów. Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta oraz wartość zamówionych produktów
USE Northwind

SELECT
    o.OrderId
    ,o.OrderDate
    ,c.CompanyName
    ,CONVERT(
        MONEY
        ,SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount))
    ) AS TotalValue
FROM
    Orders AS o
    LEFT JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    LEFT JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY o.OrderId, o.OrderDate, c.CompanyName

-- 3. Dla każdego zamówienia podaj jego pełną wartość (wliczając opłatę za przesyłkę). Zbiór wynikowy powinien zawierać nr zamówienia, datę zamówienia, nazwę klienta oraz pełną wartość zamówienia
USE Northwind

SELECT
    o.OrderID
    ,o.OrderDate
    ,c.CompanyName
    ,CONVERT(
        MONEY
        ,SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount) + o.Freight)
    ) AS TotalPrice
FROM
    Orders AS o
    LEFT JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
    LEFT JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate, c.CompanyName


-- SELECT
--     o .OrderID
--     ,SUM(t.TotalValue + o.Freight
-- ) AS TotalPrice
-- FROM
--     Orders AS o
--     JOIN
--     (SELECT
--         od.OrderID
--         ,CONVERT(
--             MONEY
--             ,SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount))
--         ) AS TotalValue
--     FROM
--         [Order Details] AS od
--     GROUP BY od.OrderID)
-- AS t ON o.OrderID = t.OrderID
-- GROUP BY o.OrderID



-- SELECT
--     SUM(t.TotalValue + o.Freight) AS TotalPrice
-- FROM
--     Orders AS o
--     JOIN (SELECT
--         od.OrderID
--         ,CONVERT(
--             MONEY
--             ,SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount))
--         ) AS TotalValue
--     FROM
--         [Order Details] AS od
--     GROUP BY od.OrderID)
--     AS t ON o.OrderID = t.OrderID
-- GROUP BY o.OrderID

--SELECT
--     od.OrderID
--     ,CONVERT(
--         MONEY
--         ,SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount))
--     ) AS TotalValue
-- FROM
--     [Order Details] AS od
-- GROUP BY od.OrderID

-- V ------------------------------------------------------------
-- 1. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty  z kategorii ‘Confections’
USE Northwind

SELECT
    DISTINCT
    c.CompanyName
    ,c.Phone
    ,c.CustomerID
FROM
    Customers AS c
    JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    JOIN Products AS p
    ON od.ProductID = p.ProductID
    JOIN Categories AS ca
    ON p.CategoryID = ca.CategoryID
        AND CategoryName = 'Confections'



-- SELECT
--     c.CompanyName
--     ,c.Phone
--     ,cc.CustomerID
-- FROM
--     Customers AS c
--     INNER JOIN (SELECT
--        DISTINCT
--        o.CustomerID
--     FROM
--         Orders AS o
--         INNER JOIN (SELECT
--             DISTINCT
--             od.OrderID
--         FROM
--             [Order Details] AS od
--             INNER JOIN (SELECT
--                 p.ProductID
--             FROM
--                 Products AS p
--                 INNER JOIN Categories AS c
--                 ON p.CategoryID = c.CategoryID
--                     AND c.CategoryName = 'Confections'
--         ) AS con -- ProductsWithConfections
--             ON od.ProductID = con.ProductID
-- ) AS oc -- OrdersWithConfections-- 
--        ON o.OrderID = oc.OrderID
--    ) AS cc -- CustomersWithConfections
--    ON c.CustomerID = cc.CustomerID


-- ProductID's in Confecions category
SELECT
    p.ProductID
FROM
    Products AS p
    INNER JOIN Categories AS c
    ON p.CategoryID = c.CategoryID
        AND c.CategoryName = 'Confections'

--  OrderID's with confections
SELECT
    DISTINCT
    od.OrderID
FROM
    [Order Details] AS od
    INNER JOIN (SELECT
        p.ProductID
    FROM
        Products AS p
        INNER JOIN Categories AS c
        ON p.CategoryID = c.CategoryID
            AND c.CategoryName = 'Confections'
        ) AS con
    ON od.ProductID = con.ProductID


--  Customers with confections
SELECT
    DISTINCT
    o.CustomerID
FROM
    Orders AS o
    INNER JOIN (SELECT
        DISTINCT
        od.OrderID
    FROM
        [Order Details] AS od
        INNER JOIN (SELECT
            p.ProductID
        FROM
            Products AS p
            INNER JOIN Categories AS c
            ON p.CategoryID = c.CategoryID
                AND c.CategoryName = 'Confections'
        ) AS con -- ProductsWithConfections
        ON od.ProductID = con.ProductID
) AS oc -- OrdersWithConfections
    ON o.OrderID = oc.OrderID

-- 2. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii ‘Confections’
USE Northwind

SELECT
    c.CompanyName
    ,c.Phone
FROM
    Categories AS ca
    JOIN Products AS p
    ON ca.CategoryID = p.CategoryID
        AND CategoryName = 'Confections'
    JOIN [Order Details] AS od
    ON p.ProductID = od.ProductID
    JOIN Orders AS o
    ON od.OrderID = o.OrderID
    RIGHT JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
WHERE ca.CategoryID IS NULL





SELECT
    c.CompanyName
    ,c.Phone
FROM
    Customers AS c
    LEFT JOIN (SELECT
        DISTINCT
        o.CustomerID
    FROM
        Orders AS o
        INNER JOIN (SELECT
            DISTINCT
            od.OrderID
        FROM
            [Order Details] AS od
            INNER JOIN (SELECT
                p.ProductID
            FROM
                Products AS p
                INNER JOIN Categories AS c
                ON p.CategoryID = c.CategoryID
                    AND c.CategoryName = 'Confections'
        ) AS con -- ProductsWithConfections
            ON od.ProductID = con.ProductID
) AS oc -- OrdersWithConfections
        ON o.OrderID = oc.OrderID
    ) AS cc -- CustomersWithConfections
    ON c.CustomerID = cc.CustomerID
WHERE cc.CustomerID IS NULL



-- 3. Wybierz nazwy i numery telefonów klientów, którzy w 1997r nie kupowali produktów z kategorii ‘Confections’
USE Northwind

SELECT
    c.CompanyName
    ,c.Phone
FROM
    Categories AS ca
    JOIN Products AS p
    ON ca.CategoryID = p.CategoryID
        AND CategoryName = 'Confections'
    JOIN [Order Details] AS od
    ON p.ProductID = od.ProductID
    JOIN Orders AS o
    ON od.OrderID = o.OrderID
        AND YEAR(o.OrderDate) = 1997
    RIGHT JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
WHERE ca.CategoryID IS NULL




SELECT
    c.CompanyName
    ,c.Phone
FROM
    Customers AS c
    LEFT JOIN (SELECT
        DISTINCT
        o.CustomerID
    FROM
        Orders AS o
        INNER JOIN (SELECT
            DISTINCT
            od.OrderID
        FROM
            [Order Details] AS od
            INNER JOIN (SELECT
                p.ProductID
            FROM
                Products AS p
                INNER JOIN Categories AS c
                ON p.CategoryID = c.CategoryID
                    AND c.CategoryName = 'Confections'
        ) AS con -- ProductsWithConfections
            ON od.ProductID = con.ProductID
) AS oc -- OrdersWithConfections
        ON o.OrderID = oc.OrderID
            AND YEAR(o.OrderDate) = 1997
    ) AS cc -- CustomersWithConfections
    ON c.CustomerID = cc.CustomerID
WHERE cc.CustomerID IS NULL


-- VI --------------------------------------------------

-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki
-- (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres zamieszkania dziecka.
USE library

SELECT
    m.lastname AS [childLastname]
    ,m.firstname AS [childFirstname]
    ,j.birth_date AS [childBirthdate]
    ,a.state + ' ' + a.city + ' ' + a.zip + ' ' + a.street AS [Address]
FROM
    juvenile AS j
    INNER JOIN member AS m
    ON j.member_no = m.member_no
    INNER JOIN adult AS a
    ON j.adult_member_no = a.member_no


-- 2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki 
--(baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania dziecka oraz imię i nazwisko rodzica.
USE library

SELECT
    m.lastname AS [childLastname]
    ,m.firstname AS [childFirstname]
    ,j.birth_date AS [childBirthdate]
    ,m2.lastname AS [parentLastname]
    ,m2.firstname AS [parentFirstname]
    ,a.state + ' ' + a.city + ' ' + a.zip + ' ' + a.street AS [Address]
FROM
    juvenile AS j
    INNER JOIN member AS m
    ON j.member_no = m.member_no
    INNER JOIN adult AS a
    ON j.adult_member_no = a.member_no
    INNER JOIN member AS m2
    ON a.member_no = m2.member_no


-- VII --------------------------------------------------
-- 1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych
-- (baza northwind)
USE Northwind

SELECT
    ReportsTo AS [Supervisor]
    ,EmployeeID
FROM
    Employees


-- supervisors
SELECT
    DISTINCT
    ReportsTo
FROM
    Employees
WHERE ReportsTo IS NOT NULL
-- 2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych
-- (baza northwind)
USE Northwind

SELECT
    *
FROM
    Employees AS e
    LEFT JOIN Employees AS e1
    ON e.EmployeeID = e1.ReportsTo
WHERE e1.ReportsTo IS NULL

-- 3. Napisz polecenie, które wyświetla pracowników, którzy mają podwładnych
-- (baza northwind)]
USE Northwind

SELECT
    e.EmployeeID
FROM
    Employees AS e
    JOIN Employees AS e1
    ON e.ReportsTo = e1.EmployeeID



-- VIII --------------------------------------------------
-- 1. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mających  więcej niż dwoje dzieci zapisanych do biblioteki
USE library

SELECT
    m.firstname
    ,m.lastname
    ,COUNT(*) AS ChildCount
FROM
    adult AS a
    JOIN juvenile AS j
    ON a.member_no = j.adult_member_no
        AND a.[state] = 'AZ'
    JOIN member AS m
    ON a.member_no = m.member_no
GROUP BY m.firstname ,m.lastname
HAVING COUNT(*) > 2

-- 2. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają  więcej niż dwoje dzieci zapisanych do biblioteki 
-- oraz takich którzy mieszkają w Kaliforni (CA) i mają więcej niż troje dzieci zapisanych do biblioteki
USE library

SELECT
    m.firstname
    ,m.lastname
    ,COUNT(*) AS ChildCount
FROM
    adult AS a
    JOIN member AS m
    ON a.member_no = m.member_no
    JOIN juvenile AS j
    ON a.member_no = j.adult_member_no
        AND a.[state] IN ('AZ','CA')
GROUP BY m.firstname ,m.lastname
HAVING COUNT(*) > 2

SELECT
    m.lastname
    ,m.firstname
    ,c.childCount
    ,a.[state]
FROM
    adult AS a
    JOIN member AS m
    ON a.member_no = m.member_no
    JOIN (SELECT
        adult_member_no
        ,COUNT(*) AS childCount
    FROM
        juvenile
    GROUP BY adult_member_no
    ) AS c
    ON a.member_no = c.adult_member_no
WHERE (
    a.[state] = 'AZ'
    AND c.childCount > 2
    ) OR (      
    a.[state]= 'CA'
    AND c.childCount > 3
    )