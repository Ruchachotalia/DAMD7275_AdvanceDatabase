SELECT 
    SalesPersonID, 
    CAST(SUM(TotalDue) AS decimal(10, 2)) AS SalesTotal
FROM 
    Sales.SalesOrderHeader
WHERE 
    SalesPersonID IS NOT NULL
GROUP BY 
    SalesPersonID
ORDER BY 
    SalesPersonID
FOR JSON PATH