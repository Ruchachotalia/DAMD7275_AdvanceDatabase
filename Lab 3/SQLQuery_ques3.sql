SELECT 
    rr.TerritoryID, 
    (
        SELECT TOP 3 
            p.ProductID, 
            SUM(salesdt.OrderQty) AS TotalProductQuantity 
        FROM 
            Sales.SalesOrderDetail AS salesdt 
            JOIN Sales.SalesOrderHeader AS saleshead ON salesdt.SalesOrderID = saleshead.SalesOrderID 
            JOIN Production.Product AS p ON salesdt.ProductID = p.ProductID
        WHERE 
            saleshead.TerritoryID = rr.TerritoryID 
        GROUP BY 
            p.ProductID 
        ORDER BY 
            TotalProductQuantity DESC, 
            p.ProductID ASC 
        FOR JSON PATH
    ) AS Top3Products 
FROM 
    Sales.SalesTerritory AS rr 
FOR JSON PATH;
