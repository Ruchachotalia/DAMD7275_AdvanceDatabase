CREATE TRIGGER CustomerOrder_Trigger   
ON source_db_Rucha.dbo.CustomerOrder   
FOR INSERT, UPDATE, DELETE  AS  BEGIN        
DECLARE @CustomerID INT, @OrderID INT, @OrderDate DATETIME, @OrderValue MONEY, @Action CHAR(6);        
-- insert operation       
IF EXISTS ( 
    SELECT 1 FROM inserted)  
    AND NOT EXISTS ( 
        SELECT 1 FROM deleted)       
        BEGIN           
        SELECT @CustomerID = CustomerID, @OrderID = OrderID, @OrderDate = OrderDate, @OrderValue = OrderValue           
        FROM inserted;            
        SET @Action = 'INSERT';          
 INSERT INTO destination_db_Rucha.dbo.AuditCustomer           
 (CustomerID, OrderID, OrderDate, OrderValue, ModifiedDate, [Action])           
 VALUES (@CustomerID, @OrderID, @OrderDate, @OrderValue, GETDATE(), @Action);            
 insert into destination_db_Rucha.dbo.CustomerReport (CustomerID, LastName, FirstName, Email, Phone, TotalPurchase, NumberOfOrders, ModifiedDate)          
 values( @CustomerID, null ,null, null, null, @OrderValue, 1,  GETDATE() );      
 END;        
 --update operation       
 IF EXISTS ( 
     SELECT 1 FROM inserted 
     )  
     AND EXISTS ( 
         SELECT 1 FROM deleted 
         )       
         BEGIN           
         SELECT @CustomerID = CustomerID, @OrderID = OrderID, @OrderDate = OrderDate, @OrderValue = OrderValue           
         FROM inserted;            
         SET @Action = 'UPDATE';           
         INSERT INTO destination_db_Rucha.dbo.AuditCustomer (CustomerID, OrderID, OrderDate, OrderValue, ModifiedDate, [Action])           
         VALUES (@CustomerID, @OrderID, @OrderDate, @OrderValue, GETDATE(), @Action);            
         UPDATE destination_db_Rucha.dbo.CustomerReport  
         SET TotalPurchase = TotalPurchase + @OrderValue, ModifiedDate = GETDATE()           
         WHERE CustomerID = @CustomerID;       
         END;        
         -- delete operation       
         IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)       
         BEGIN       
         SELECT @CustomerID = CustomerID, @OrderID = OrderID, @OrderDate = OrderDate, @OrderValue = OrderValue           
         FROM deleted;           SET @Action = 'DELETE';          INSERT INTO destination_db_Rucha.dbo.AuditCustomer           
         (CustomerID, OrderID, OrderDate, OrderValue, ModifiedDate, [Action])           
         VALUES (@CustomerID, @OrderID, @OrderDate, @OrderValue, GETDATE(), @Action);            
         UPDATE destination_db_Rucha.dbo.CustomerReport           
         SET TotalPurchase = TotalPurchase - @OrderValue,  
         NumberOfOrders = NumberOfOrders - 1,  
         ModifiedDate = GETDATE()           
         WHERE CustomerID = @CustomerID;      
        END;   
        END;