USE "Northwind"

-- 1. Podaj liczbę produktów o cenach mniejszych niż 10 lub większych niż 20
SELECT
    UnitPrice
    ,p.SupplierID
FROM
    Products AS p
WHERE UnitPrice NOT BETWEEN 10 AND 20
-- 2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20
SELECT
    MAX(UnitPrice)
FROM
    Products
WHERE UnitPrice < 20
-- 3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o produktach sprzedawanych w butelkach (‘bottle’)
SELECT
    MAX(UnitPrice)
    ,MIN(UnitPrice)
    ,AVG(UnitPrice)
FROM
    Products
WHERE QuantityPerUnit LIKE '%bottle%'

-- 4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
SELECT
    *
FROM
    Products
WHERE UnitPrice > (
    SELECT
    AVG(UnitPrice)
FROM
    Products
    )
-- 5. Podaj sumę/wartość zamówienia o numerze 10250
SELECT
    SUM(UnitPrice * Quantity)
FROM
    [Order Details]
WHERE OrderID = 10250

-- 1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
SELECT
    OrderID
    ,MAX(UnitPrice) AS maxPrice
FROM
    [Order Details]
GROUP BY OrderID
-- 2. Posortuj zamówienia wg maksymalnej ceny produkt
SELECT
    OrderID
    ,MAX(UnitPrice) AS maxPrice
FROM
    [Order Details]
GROUP BY OrderID
ORDER BY MAX(UnitPrice) DESC
-- 3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
SELECT
    OrderID
    ,MAX(UnitPrice) AS MaxPrice
    ,MIN(UnitPrice) AS MinPrice
FROM
    [Order Details]
GROUP BY OrderID

-- 4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
SELECT
    COUNT(*) AS OrdersCount
    ,ShipVia
FROM
    Orders
GROUP BY ShipVia

-- 5. Który ze spedytorów był najaktywniejszy w 1997 roku
SELECT
    TOP 1
    COUNT(*) AS OrdersCount
    ,s.CompanyName
FROM
    Orders AS o
    JOIN Shippers AS s
    ON o.ShipVia = s.ShipperID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY s.CompanyName
ORDER BY OrdersCount DESC

-- Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
SELECT
    COUNT(*) AS OrdersCount
    ,OrderID
FROM
    [Order Details]
GROUP BY OrderID
HAVING COUNT(*) > 5

-- Wyświetl  klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień wyniki
-- posortuj malejąco wg  łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
SELECT
    COUNT(*) AS [OrderCount]
    ,CustomerID
    ,SUM(Freight) AS [FreightSum]
FROM
    Orders
GROUP BY CustomerID
HAVING COUNT(*) > 8
ORDER BY SUM(Freight) DESC

