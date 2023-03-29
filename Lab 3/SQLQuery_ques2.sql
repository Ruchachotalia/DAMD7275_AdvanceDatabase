SELECT 
    rr.SalesOrderID, 
    JSON_QUERY(
        CONCAT('[',
            STRING_AGG(
                JSON_QUERY(CONCAT('{',
                    '"ProductID":', CAST(d.ProductID AS VARCHAR), ',',
                    '"OrderQty":', CAST(d.OrderQty AS VARCHAR),
                  '}')),
                ','),
          ']')
    ) AS Products
FROM 
    Sales.SalesOrderHeader AS rr 
    JOIN Sales.SalesOrderDetail AS d ON rr.SalesOrderID = d.SalesOrderID
WHERE 
    rr.SalesOrderID BETWEEN 43660 AND 43680
GROUP BY 
    rr.SalesOrderID
FOR JSON PATH
