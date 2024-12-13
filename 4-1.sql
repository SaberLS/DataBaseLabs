USE Northwind
-- I --------------------------------------------------
-- 1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)


SELECT
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount) + o
.Freight)  AS Price
-- źle to jest bo się freight dodaje do każdego od.OrderID czyli nalicza do jednego zamówienia kilka razy
FROM
    Orders AS o
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
        AND o.OrderID = 10250

SELECT
    (SELECT
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))
    FROM
        [Order Details] AS od
    WHERE o.OrderID = od.OrderID  
        ) + o.Freight AS Price
FROM
    Orders AS o
WHERE o.OrderID = 10250

-- 2. Podaj łączną wartość każdego zamówienia (uwzględnij cenę za przesyłkę)
SELECT
    CONVERT(
        MONEY,
    (SELECT
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))
    FROM
        [Order Details] AS od
    WHERE o.OrderID = od.OrderID  
    ) + o.Freight ) AS Price
FROM
    Orders AS o

-- 3. Dla każdego produktu podaj maksymalną wartość zakupu tego produktu
SELECT
    p.ProductName
    ,(SELECT
        TOP 1
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS [Value]
    FROM
        [Order Details] AS od
    WHERE p.ProductID = od.ProductID
    GROUP BY od.OrderID
    ORDER BY [Value]
    ) AS [MaxValue]
FROM
    Products AS p
ORDER BY [MaxValue] DESC

-- 4. Dla każdego produktu podaj maksymalną wartość zakupu tego produktu w 1997r
SELECT
    p.ProductName
    ,(SELECT
        TOP 1
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS [Value]
    FROM
        [Order Details] AS od
        JOIN Orders AS o
        ON o.OrderID = od.OrderID
            AND YEAR(o.OrderDate) = 1997
    WHERE p.ProductID = od.ProductID
    GROUP BY od.OrderID
    ORDER BY [Value]
    ) AS [MaxValue]
FROM
    Products AS p
ORDER BY [MaxValue] DESC

-- II --------------------------------------------------
-- 1. Dla każdego klienta podaj łączną wartość jego zamówień (bez opłaty za przesyłkę) z 1996r
;WITH
    Price
    AS
    (
        SELECT
            SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS sum
            ,od.OrderID
        FROM
            [Order Details] AS od
        GROUP BY od.OrderID
    )
SELECT
    SUM(p.sum)
    ,o.CustomerID
FROM
    Orders AS o
    JOIN Price AS p
    ON o.OrderID = p.OrderID
GROUP BY o.CustomerID

-- 2. Dla każdego klienta podaj łączną wartość jego zamówień (uwzględnij opłatę za przesyłkę) z 1996r
;WITH
    Price
    AS
    (
        SELECT
            SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS sum
            ,od.OrderID
        FROM
            [Order Details] AS od
        GROUP BY od.OrderID
    )
SELECT
    SUM(p.sum + o.Freight)
    ,o.CustomerID
FROM
    Orders AS o
    JOIN Price AS p
    ON o.OrderID = p.OrderID
GROUP BY o.CustomerID

-- 3. Dla każdego klienta podaj maksymalną wartość zamówienia złożonego przez tego klienta w 1997r

;WITH
    Price
    AS
    (
        SELECT
            SUM(od.UnitPrice * od.Quantity *(1 - od.Discount)
            ) AS sum
            ,od.OrderID
        FROM
            [Order Details] AS od
        GROUP BY od.OrderID
    )
SELECT
    SUM(p.sum + o.Freight) AS Price
    ,o.CustomerID
FROM
    Orders AS o
    JOIN Price AS p
    ON o.OrderID = p.OrderID
        AND YEAR(o.OrderDate) = 1997
GROUP BY o.CustomerID

-- III -------------------------------------------------- 
-- 1. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko oraz liczbę jego dzieci.

-- 2. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko, liczbę jego dzieci, liczbę zarezerwowanych książek oraz liczbę wypożyczonych książek. 
-- 3. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko, liczbę jego dzieci, oraz liczbę książek zarezerwowanych i wypożyczonych przez niego i jego dzieci. 
-- 4. Dla każdego tytułu książki podaj ile razy ten tytuł był wypożyczany w 2001r 
-- 5. Dla każdego tytułu książki podaj ile razy ten tytuł był wypożyczany w 2002r 
-- IV -------------------------------------------------- 
-- 1. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak TO pokaż ich dane adresowe
SELECT
    c.Address
    ,c.City
    ,c.PostalCode
    ,c.Country
FROM
    Customers AS c
    LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
        AND YEAR(o.OrderDate) = 1997
WHERE o.CustomerID IS NULL
-- 2. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma United Package.
SELECT
    c.CompanyName
    ,c.ContactName
    ,c.Phone
FROM
    Customers AS c
WHERE c.CustomerID IN (
    SELECT
    o.CustomerID
FROM
    Orders AS o
WHERE YEAR(o.OrderDate) = 1997 AND o.ShipVia IN (
    SELECT
        s.ShipperID
    FROM
        Shippers AS s
    WHERE s.CompanyName = 'United Package'
    )
)


SELECT
    c.CompanyName
    ,c.ContactName
    ,c.Phone
FROM
    Customers AS c
WHERE c.CustomerID IN (
    SELECT
    o.CustomerID
FROM
    Orders AS o
    JOIN Shippers AS s
    ON o.ShipVia = s.ShipperID
        AND YEAR(o.OrderDate) = 1997
        AND s.CompanyName = 'United Package'
)
-- 3. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłek nie dostarczała firma United Package. 
SELECT
    c.CompanyName
    ,c.ContactName
    ,c.Phone
FROM
    Customers AS c
WHERE c.CustomerID NOT IN (
    SELECT
    o.CustomerID
FROM
    Orders AS o
WHERE YEAR(o.OrderDate) = 1997 AND o.ShipVia IN (
    SELECT
        s.ShipperID
    FROM
        Shippers AS s
    WHERE s.CompanyName = 'United Package'
    )
)

-- 4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections.
SELECT
    c.CompanyName
    ,c.ContactName
    ,c.Phone
FROM
    Customers AS c
WHERE c.CustomerID IN (    
SELECT
    o.CustomerID
FROM
    Orders AS o
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    JOIN Products AS p
    ON od.ProductID = p.ProductID
    JOIN Categories AS ca
    ON p.CategoryID = ca.CategoryID
        AND CategoryName = 'Confections'
)

-- 5. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections. 
SELECT
    c.CompanyName
    ,c.ContactName
    ,c.Phone
FROM
    Customers AS c
WHERE c.CustomerID NOT IN (    
SELECT
    o.CustomerID
FROM
    Orders AS o
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    JOIN Products AS p
    ON od.ProductID = p.ProductID
    JOIN Categories AS ca
    ON p.CategoryID = ca.CategoryID
        AND CategoryName = 'Confections'
)
-- 6. Wybierz nazwy i numery telefonów klientów, którzy w 1997r nie kupowali produktów z kategorii Confections.
SELECT
    c.CompanyName
    ,c.ContactName
    ,c.Phone
FROM
    Customers AS c
WHERE c.CustomerID NOT IN (    
SELECT
    o.CustomerID
FROM
    Orders AS o
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
        AND YEAR(o.OrderDate) = 1997
    JOIN Products AS p
    ON od.ProductID = p.ProductID
    JOIN Categories AS ca
    ON p.CategoryID = ca.CategoryID
        AND CategoryName = 'Confections'
)
-- V -------------------------------------------------- 
-- 1. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
SELECT
    p.*
FROM
    Products AS p
WHERE p.UnitPrice < (SELECT
    avg(p1.UnitPrice)
FROM
    Products AS p1
)

-- 2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej kategorii
SELECT
    p.*
FROM
    Products AS p
WHERE p.UnitPrice < (SELECT
    AVG(p1.UnitPrice)
FROM
    Products AS p1
WHERE p.CategoryID = p1.CategoryID 
)
-- 3. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich produktów oraz różnicę między ceną produktu a średnią ceną wszystkich produktów
SELECT
    p.ProductID
    ,p.UnitPrice - (
    SELECT
        avg(p1.UnitPrice)
    FROM
        Products AS p1
    WHERE p.CategoryID = p1.CategoryID
    ) AS CategoryPriceDiff
    
    ,p.UnitPrice - (SELECT
        avg(p1.UnitPrice)
    FROM
        Products AS p1
    ) AS PriceDiff
FROM
    Products AS p
GROUP BY p.ProductID, p.CategoryID, p.UnitPrice
;
-- 4. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a średnią ceną wszystkich produktów danej kategorii
SELECT
    p.ProductName
    ,(SELECT
        c.CategoryName
    FROM
        Categories AS c
    WHERE p.CategoryID = c.CategoryID) AS CategoryName
    ,p.UnitPrice - (
    SELECT
        avg(p1.UnitPrice)
    FROM
        Products AS p1
    WHERE p.CategoryID = p1.CategoryID
    ) AS CategoryPriceDiff
    
    ,p.UnitPrice - (SELECT
        avg(p1.UnitPrice)
    FROM
        Products AS p1
    ) AS PriceDiff
FROM
    Products AS p
GROUP BY p.ProductID, p.ProductName, p.CategoryID, p.UnitPrice


-- VI -------------------------------------------------- 
-- 1. Podaj produkty kupowane przez więcej niż jednego klienta
-- ?????????????????
SELECT
    DISTINCT
    od.ProductID
FROM
    [Order Details] AS od
WHERE od.ProductID IN (
    SELECT
    od1.ProductID
FROM
    Orders AS o
    JOIN [Order Details] AS od1
    ON o.OrderID = od1.OrderID
        AND od1.ProductID = od.ProductID
GROUP BY o.CustomerID, od1.ProductID
HAVING COUNT(*) > 1
)
-- ?????????????????


-- 2. Podaj produkty kupowane w 1997r przez więcej niż jednego klienta
-- ?????????????????
SELECT
    DISTINCT
    od.ProductID
FROM
    [Order Details] AS od
WHERE od.ProductID IN (
    SELECT
    od1.ProductID
FROM
    Orders AS o
    JOIN [Order Details] AS od1
    ON o.OrderID = od1.OrderID
        AND od1.ProductID = od.ProductID
        AND YEAR(o.OrderDate) = 1997
GROUP BY o.CustomerID, od1.ProductID
HAVING COUNT(*) > 1
)
-- ?????????????????
-- 3. Podaj nazwy klientów którzy w 1997r kupili co najmniej dwa różne produkty z kategorii 'Confections'

-- VII -------------------------------------------------- 
-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika, przy obliczaniu wartości zamówień uwzględnij cenę za przesyłkę 
-- 2. Który z pracowników był najaktywniejszy (obsłużył zamówienia o największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika 
-- 3. Ogranicz wynik z pkt 1 tylko do pracowników 
-- 	a) którzy mają podwładnych 
-- 	b) którzy nie mają podwładnych
-- 4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę ostatnio obsłużonego zamówienia
