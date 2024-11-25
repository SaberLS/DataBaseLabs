-- 1 ---------------------------------------------------------------------------------
USE Northwind
-- 1. Dla każdego zamówienia podaj jego wartość.
-- Posortuj wynik wg wartości zamówień (w malejęcej kolejności)
SELECT
    CONVERT(
        MONEY
        , SUM(((UnitPrice * Quantity) * 1 - Discount))
    ) AS TOTALPRICE
FROM
    [Order Details]
GROUP BY OrderID
ORDER BY TotalPrice DESC



-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało 
-- tylko pierwszych 10 wierszy . 
SELECT
    TOP 10
    CONVERT(
        MONEY
        , SUM(((UnitPrice * Quantity) * 1 - Discount))
    ) AS TOTALPRICE
FROM
    [Order Details]
GROUP BY OrderID
ORDER BY TotalPrice DESC


-- 3. Podaj nr zamówienia oraz wartość zamówienia,
-- dla zamówień, dla których łączna liczba zamawianych jednostek
-- produktów jest większa niż 250
SELECT
    OrderID
    ,CONVERT(
        MONEY
        , SUM (((UnitPrice * Quantity) * 1 - Discount))
    ) AS TOTALPRICE
FROM
    [Order Details]
GROUP BY OrderID
HAVING SUM(Quantity) > 250

-- 4. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których productid jest mniejszy niż 3
SELECT
    ProductID
    ,SUM(Quantity) AS Quantity
FROM
    [Order Details]
WHERE ProductID < 3
GROUP BY ProductID


-- Ćwiczenie 2 ----------------------------------------------------------------------------------
USE library
-- 1. Ilu jest dorosłych czytekników
SELECT
    COUNT(*) AS Dorośli
FROM
    adult

-- 2. Ile jest dzieci zapisanych do biblioteki.
SELECT
    COUNT(*) AS [nieDorośli]
FROM
    juvenile

-- 3. Ilu z dorosłych czytelników mieszka w Kaliforni 2(CA)
USE library

SELECT
    COUNT(*) AS [adultsCount]
FROM
    adult
WHERE [state] = 'CA'

-- 4. Dla każdego dorosłego czytelnika podaj liczbę jego dzieci. 
SELECT
    adult_member_no
    ,COUNT(*) AS [juvenileCount]
FROM
    juvenile
GROUP BY adult_member_no

SELECT
    a.member_no
    ,COUNT(j.member_no) AS [juvenileCount]
FROM
    adult AS a
    JOIN juvenile AS j
    ON j.adult_member_no = a.member_no
GROUP BY a.member_no
-- 5. Dla każdego dorosłego czytelnika podaj liczbę jego dzieci urodzonych przed 1998
SELECT
    a.member_no
    ,COUNT(j.member_no) AS [juvenileCount]
FROM
    adult AS a
    JOIN juvenile AS j
    ON j.adult_member_no = a.member_no
WHERE YEAR(j.birth_date) < 1998
GROUP BY a.member_no


-- Ćwiczenie 3 ---------------------------------------------------------------
USE library
-- 1. Dla każdego czytelnika podaj liczbę zarezerwowanych
-- przez niego książek
SELECT
    member_no
    ,COUNT(*) AS [reservations]
FROM
    reservation
GROUP BY member_no

-- 2. Dla każdego czytelnika podaj liczbę 
-- wypożyczonych przez niego książek 
SELECT
    member_no
    ,COUNT(*) AS [loaned]
FROM
    loan
GROUP BY member_no
-- 3. Dla każdego czytelnika podaj liczbę książek
-- zwróconych przez niego w 2001r.
SELECT
    member_no
    ,COUNT(*) AS [returned]
FROM
    loanhist
WHERE  YEAR(in_date) = 2001
GROUP BY member_no

-- 4. Dla każdego czytelnika podaj sumę 
-- kar jakie zapłacił w 2001r 
SELECT
    member_no
    ,SUM(fine_paid) AS [paid]
FROM
    loanhist
WHERE  YEAR(in_date) = 2001
GROUP BY member_no
ORDER BY SUM(fine_paid) DESC


-- 5. Ile książek wypożyczono w maju 2001
SELECT
    COUNT(*) AS [loaned]
FROM
    loanhist
WHERE MONTH(in_date) = 5 AND YEAR(in_date) = 2001

-- SELECT
--    MONTH(in_date)
--    ,YEAR(in_date)
--FROM
--    loanhist
--ORDER BY 
--    YEAR(in_date)
--    ,MONTH(in_date)

-- 6. Na jak długo średnio były wypożyczane książki 
-- w maju 2001
SELECT
    AVG(DATEDIFF(MINUTE ,in_date, due_date)) AS [loan time]
FROM
    loanhist
WHERE YEAR(in_date) = 2001


-- Ćwiczenie 4-----------------------------------------------------------------
USE Northwind

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych 
-- przez niego zamówień w 1997r 
SELECT
    EmployeeID
    ,COUNT(*) AS [order count]
FROM
    Orders
WHERE 
    YEAR(OrderDate) = 1997
GROUP BY EmployeeID



-- 2. Dla każdego pracownika podaj ilu klientów (różnych
-- klientów) obsługiwał ten pracownik w 1997r
SELECT
    EmployeeID
    ,COUNT(*) AS [DistinctCustomerCount]
FROM
    (SELECT
        DISTINCT
        EmployeeID
        ,CustomerID
    FROM
        Orders
    WHERE YEAR(OrderDate) = 1997
    GROUP BY EmployeeID, CustomerID
    ) AS [DistinctCustomers]
GROUP BY EmployeeID


-- SELECT
--     DISTINCT
--     EmployeeID
--     ,CustomerID
-- FROM
--     Orders
-- WHERE YEAR(OrderDate) = 1997
-- GROUP BY EmployeeID, CustomerID

SELECT
    o1.EmployeeID
    ,(SELECT
        COUNT(*)
    FROM(
        SELECT
            DISTINCT
            o.CustomerID
        FROM
            Orders AS o
        WHERE 
            YEAR (o.OrderDate) = 1997 AND o.EmployeeID = o1.EmployeeID
        ) AS DistinctCustomers 
    ) AS DistinctCustomersCount
FROM
    Orders AS o1
WHERE
    YEAR(o1.OrderDate) = 1997
GROUP BY EmployeeID


-- 3. Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" dla przewożonych przez niego zamówień
SELECT
    ShipVia
    ,SUM(Freight) AS [Freigth sum]
FROM
    Orders
GROUP BY ShipVia

-- 4. Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" przewożonych przez niego zamówień w latach od 1996 do 1997
SELECT
    ShipVia
    ,SUM(Freight) AS [Freigth sum]
FROM
    Orders
WHERE 
    YEAR(OrderDate) IN(1996, 1997)
GROUP BY ShipVia


-- Ćwiczenie 5 -------------------------------------------------------------------------------
-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego 
-- zamówień z podziałem na lata
SELECT
    EmployeeID
    ,YEAR(OrderDate) AS [Year]
    ,COUNT(*) AS [OrderCount]
FROM
    Orders
GROUP BY EmployeeID, YEAR(OrderDate)

SELECT
    DISTINCT
    YEAR(o.OrderDate) AS [Year]
    ,o.EmployeeID
    ,(SELECT
        COUNT(*) AS OrderCount
    FROM
        Orders AS o1
    WHERE 
        o1.EmployeeID = o.EmployeeID
        AND YEAR(o.OrderDate) = YEAR(o1.OrderDate)
    ) AS [YearOrderCount]
FROM
    Orders AS o

-- 2. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z podziałem na lata i miesiące.
SELECT
    EmployeeID
    ,YEAR(OrderDate) AS [Year]
    ,MONTH(OrderDate) AS [Month]
    ,COUNT(*) AS [OrderCount]
FROM
    Orders
GROUP BY EmployeeID, YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate)