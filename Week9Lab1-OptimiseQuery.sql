--Find the second highest order quantity of all records in the Sales.SalesOrderDetail.
-- Optimise the query below


SELECT 	MIN(OrderQty) 
FROM 	Sales.SalesOrderDetail 
WHERE 	OrderQty IN
			(SELECT   TOP 2 	OrderQty 
			FROM Sales.SalesOrderDetail 
			ORDER BY OrderQty Desc
			)

-- SQL Server Execution Times:
--   CPU time = 31 ms,  elapsed time = 18 ms.

--	My optimized query
USE AdventureWorks2016;

SELECT OrderQty
FROM Sales.SalesOrderDetail
GROUP BY OrderQty
ORDER BY OrderQty DESC
OFFSET 1 ROW
FETCH NEXT 1 ROW ONLY

-- SQL Server Execution Times:
--   CPU time = 15 ms,  elapsed time = 24 ms.
	