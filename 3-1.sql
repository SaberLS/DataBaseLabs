USE Northwind

-- I. --------------------------------------------------
-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta.
SELECT
    o.OrderID
    ,c.CompanyName
    ,SUM(od.Quantity) AS Quantity
FROM
    Orders AS o
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID, c.CompanyName

-- 2. Dla każdego zamówienia podaj łączną wartość zamówionych produktów (wartość zamówienia bez opłaty za przesyłkę) oraz nazwę klienta. 
SELECT
    o.OrderId
    ,CONVERT(
        MONEY
        ,SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))
    ) AS TotalValue
FROM
    Orders AS o
    LEFT JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
GROUP BY o.OrderId

-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia (wartość zamówienia wraz z opłatą za przesyłkę) oraz nazwę klienta. . Zmodyfikuj poprzednie przykłady tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówień
SELECT
    o.OrderId
    ,e.FirstName
    ,e.LastName
    ,CONVERT(
        MONEY
        ,SUM(od.UnitPrice * od.Quantity * (1 - od.Discount) + o.Freight)
    ) AS TotalValue
FROM
    Orders AS o
    LEFT JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    LEFT JOIN Employees AS e
    ON o.EmployeeID = e.EmployeeID
GROUP BY o.OrderID, e.FirstName ,e.LastName


-- II. --------------------------------------------------
-- 1. Podaj nazwy przewoźników, którzy w marcu 1998 przewozili produkty z kategorii 'Meat/Poultry'
SELECT
    DISTINCT
    s.CompanyName
FROM
    Shippers AS s
    INNER JOIN Orders AS o
    ON s.ShipperID = o.ShipVia
        AND YEAR(o.OrderDate) = 1998
        AND MONTH(o.OrderDate) = 3
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    JOIN Products AS p
    ON od.ProductID = p.ProductID
    INNER JOIN Categories AS c
    ON p.CategoryID = c.CategoryID
        AND c.CategoryName = 'Meat/Poultry'

-- 2. Podaj nazwy przewoźników, którzy w marcu 1997r nie przewozili produktów z kategorii 'Meat/Poultry'
SELECT
    s1.CompanyName
FROM
    Shippers AS s
    INNER JOIN Orders AS o
    ON s.ShipperID = o.ShipVia
        AND YEAR(o.OrderDate) = 1997
        AND MONTH(o.OrderDate) = 3
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    JOIN Products AS p
    ON od.ProductID = p.ProductID
    JOIN Categories AS c
    ON p.CategoryID = c.CategoryID
        AND c.CategoryName = 'Meat/Poultry'
    RIGHT JOIN Shippers AS s1
    ON s.ShipperID = s1.ShipperID
WHERE s.ShipperID IS NULL




-- 3. Dla każdego przewoźnika podaj wartość produktów z kategorii 'Meat/Poultry' które ten przewoźnik przewiózł w marcu 1997
SELECT
    s.CompanyName
    ,CONVERT(
        MONEY
        ,SUM(od.UnitPrice * od.Quantity *(1 - od.Discount))
    ) AS TotalValue
FROM
    Shippers AS s
    INNER JOIN Orders AS o
    ON s.ShipperID = o.ShipVia
        AND YEAR(o.OrderDate) = 1997
        AND MONTH(o.OrderDate) = 3
    JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
    JOIN Products AS p
    ON od.ProductID = p.ProductID
    JOIN Categories AS c
    ON p.CategoryID = c.CategoryID
        AND c.CategoryName = 'Meat/Poultry'
GROUP BY s.CompanyName


-- III. --------------------------------------------------
-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów z tej kategorii. 
-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych w 1997r jednostek towarów z tej kategorii. 
-- 3. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych towarów z tej kategorii.

-- IV. --------------------------------------------------
-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r 
-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika 
-- 3. Dla każdego przewoźnika podaj łączną wartość "opłat za przesyłkę" przewożonych przez niego zamówień od '1998-05-03' do '1998-05-29' 
-- 4. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika w maju 1996 
-- 5. Który z pracowników obsłużył największą liczbę zamówień w 1996r, podaj imię i nazwisko takiego pracownika 
-- 6. Który z pracowników był najaktywniejszy (obsłużył zamówienia o największej wartości) w 1996r, podaj imię i nazwisko takiego pracownika

-- V. --------------------------------------------------
-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika Ogranicz wynik tylko do pracowników 
-- a) którzy mają podwładnych 
-- b) którzy nie mają podwładnych
-- 2. Napisz polecenie, które wyświetla klientów z Francji którzy w 1998r złożyli więcej niż dwa zamówienia oraz klientów z Niemiec którzy w 1997r złożyli więcej niż trzy zamówienia