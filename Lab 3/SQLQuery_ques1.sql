SELECT 
    SalesPersonID, 
    CAST(SUM(TotalDue) AS decimal(10, 2)) AS TotalSales
FROM 
    Sales.SalesOrderHeader
WHERE 
    SalesPersonID IS NOT NULL
GROUP BY 
    SalesPersonID
ORDER BY 
    SalesPersonID
FOR JSON PATH
