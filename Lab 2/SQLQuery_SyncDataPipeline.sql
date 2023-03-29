SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sync_DataPipeline]
AS
BEGIN
    MERGE destination_db_Rucha.dbo.ItemsReport d
USING source_db_Rucha.dbo.Rucha_view s
ON s.OrderID  = d.OrderID
WHEN MATCHED THEN
    update set  d.Quantity     = s.Quantity,
                d.UnitPrice    = s.UnitPrice,
                d.LastModified = s.LastModified
WHEN NOT MATCHED BY SOURCE THEN
    delete
WHEN NOT MATCHED THEN
    insert (CustomerID, OrderDate, OrderID, ItemID, Quantity, UnitPrice, LastModified)
    values (s.CustomerID, s.OrderDate, s.OrderID, s.ItemID, s.Quantity, s.UnitPrice, s.LastModified)

OUTPUT
    $Action,
    ISNULL(Deleted.CustomerID, Inserted.CustomerID),
    ISNULL(Deleted.OrderDate, Inserted.OrderDate),
    ISNULL(Deleted.OrderID, Inserted.OrderID),
    ISNULL(Deleted.ItemID, Inserted.ItemID),
    Deleted.Quantity,
    Inserted.Quantity,
    Deleted.UnitPrice,
    Inserted.UnitPrice,
    Inserted.LastModified,
    Deleted.LastModified
INTO destination_db_Rucha.dbo.ItemsAudit
    ([Action],
    CustomerID,
    OrderDate,
    OrderID,
    ItemID,
    OldQuantity,
    NewQuantity,
    OldUnitPrice,
    NewUnitPrice,
    NewLastModified,
    OldLastModified);
;
END;
GO
