/*
Using Transact-SQL : Exercises
------------------------------------------------------------

		


Exercises for section 15 : UDF

15.1. Create a UDF on your database that references the AdventureWorks2016 database. Note you will have to reference AdventureWorks2016 using the FQDN as you only have select over it
AdventureWorks2016 is a large and complex Microsoft training database.
The function takes one input parameter, a customer (store) ID , and returns the columns ProductID, Name, and the aggregate of year-to-date sales as YTD Total for each product sold to the store.

You will need to use the following tables:

Production.Product
Sales.SalesOrderDetail
Sales.SalesOrderHeader -- check here for CustomerID
Sales.Customer
*/

USE AdventureWorks2016;

GO
CREATE FUNCTION returnAgg(@StoreID float(4))
RETURNS table
AS
RETURN
(
	SELECT DISTINCT pp.ProductID, pp.Name, SUM(ssod.LineTotal) AS 'YTD Total' FROM Production.Product pp
	JOIN Sales.SalesOrderDetail ssod ON pp.ProductID = ssod.ProductID
	JOIN Sales.SalesOrderHeader ssoh ON ssod.SalesOrderID = ssoh.SalesOrderID
	JOIN Sales.Customer sc ON ssoh.CustomerID = sc.CustomerID
	WHERE sc.StoreID = 934
	GROUP BY pp.ProductID, pp.Name
)
GO
--SELECT dbo.returnAgg(934)
GO

SELECT * FROM Production.Product -- productId*
SELECT * FROM Sales.SalesOrderDetail -- salesOrderId* salesOrderDetailId carrierTrackingNumber orderQty productID* specialOfferID unitPrice unitPriceDiscount lineTotal 
SELECT * FROM Sales.SalesOrderHeader -- salesOrderId* customerid* territoryid*
SELECT * FROM Sales.Customer --customerid* personid storeid territoryid* accountnumber rowguid modifieddate

/*
15.2
Load up the BikeStore Tables and Data.
Creates a table-valued function that returns a list of products including product name, model year and the list price for a specific model year:
*/
--select * from sys.triggers
GO
CREATE OR ALTER FUNCTION productList(@model_year float(4))
RETURNS table
AS
RETURN
(
	SELECT pp.product_id, pp.product_name, pp.model_year, pp.list_price FROM production.products pp
	WHERE pp.model_year = @model_year

)
GO
SELECT * FROM productList(2019)
GO