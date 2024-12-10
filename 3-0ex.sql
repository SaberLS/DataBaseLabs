USE Northwind

SELECT
    productname
    ,companyname
FROM
    products
    INNER JOIN suppliers
    ON products.supplierid = suppliers.supplierid

SELECT
    DISTINCT
    companyname
FROM
    orders
    INNER JOIN customers
    ON orders.customerid = customers.customerid
WHERE orderdate > '1998-03-01'


SELECT
    companyname
    ,customers.customerid
    ,orderdate
FROM
    customers
    LEFT OUTER JOIN orders
    ON customers.customerid = orders.customerid
WHERE orders.OrderDate IS NULL

-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
SELECT
    p.ProductName
    ,p.UnitsInStock
    ,s.CompanyName
FROM
    Products AS p
    INNER JOIN Suppliers AS s
    ON p.SupplierID = s.SupplierID
        AND s.CompanyName = 'Tokyo Traders'


-- 5. Wybierz zamówienia złożone w marcu 1997. Dla każdego takiego zamówienia wyświetl jego numer, datę złożenia zamówienia oraz nazwę i numer telefonu klienta
USE Northwind

SELECT
    o.OrderID
    ,o.OrderDate
    ,c.CompanyName
    ,c.Phone
FROM
    Orders AS o
    JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
WHERE YEAR
(o.OrderDate) = 1997
    AND MONTH
(o.OrderDate) = 3


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

-- dla każdego klienta podaj liczbe złożonych zamówień w 1997
USE Northwind
SELECT
    COUNT(*) AS OrderCount
    ,o.CustomerID
    ,c.CompanyName
FROM
    Orders AS o
    RIGHT OUTER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
        AND YEAR(o.OrderDate) = 1997
GROUP BY o.CustomerID, c.CompanyName

SELECT
    COUNT(*)
FROM
    Customers


USE joindb
SELECT
    DISTINCT
    productname
FROM
    orders AS O
    INNER JOIN [order details] AS OD
    ON O.orderid = OD.orderid
    INNER JOIN products AS P
    ON OD.productid = P.productid
        AND orderdate = '1996-07-08'