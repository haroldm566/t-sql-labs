/*
Using Transact-SQL : Exercises
------------------------------------------------------------


Exercises for section 17 : RANKING FUNCTIONS
ROW_NUMBER
The ROW_NUMBER ranking function is the simplest of the ranking functions. Its purpose in life is to provide consecutive numbering of the rows in the result set by the order selected in the OVER clause for each partition specified in the OVER clause.

If no partition is specified, ROW_NUMBER will provide a consecutive numbering of the rows based on the order clause. If a partition is provided, the numbering is consecutive within the partition and begins again at 1 when the partition changes.

Use AdventureWorks2016
17.1. 
Find the top 10 products that sold in June 2012. Return ProductID, SUM of the order count and the Row number. 
ROW_NUMBER is used here to designate the ordering from highest qty ordered to lowest. 
(The order clause in the OVER clause tells it to rank the rows by the sum of all the order quantities for that product.)

You will need to use the following tables:


Sales.SalesOrderDetail
Sales.SalesOrderHeader 
*/

USE AdventureWorks2016;

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

SELECT TOP 10 sod.ProductID, SUM(sod.OrderQty) AS [Order Total], ROW_NUMBER() OVER (ORDER BY SUM(sod.OrderQty) DESC) as [Row Number] FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2012 AND MONTH(soh.OrderDate) = 06
GROUP BY sod.ProductID


/*
RANK
17.2. 
Take the exercise from above (products ordered in 2012) and apply RANK instead of ROW_NUMBER. 
To get a result worth looking at you will have to limit the products to those having a ProductOrderCount between 100 and 400. 
You should see in the results that two of the rows had ProductOrderCount equal to 243. Therefore, with RANK, they both received the same ranking, in this case 6, and the next number is skipped.
*/
SELECT TOP 10 sod.ProductID, SUM(sod.OrderQty) AS [Order Total], RANK() OVER (ORDER BY SUM(sod.OrderQty) DESC) as [Rank] FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2012 AND MONTH(soh.OrderDate) = 06
GROUP BY sod.ProductID

