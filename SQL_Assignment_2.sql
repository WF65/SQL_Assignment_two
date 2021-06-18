--Part 1

--1
/*
A SQL result set is a set of rows from a database and metadata about the query such as the column names,
and the types and sizes of each column.
*/

--2
/*
UNION command combines the distinct values in the result sets of two or more SELECT statments
UNION ALL command combines all the result sets of two or more SELECT statements including 
	      duplicate values
*/

--3
/*
INTERSECT: it takes the data from both result sets which are in common.
EXCEPT: it takes data from first result set, but not from the second.
*/

--4
/*
UNION is used to combine the result set of two or more SELECT statements. The data combined using 
	  UNION statement is into results into new distinct rows. Number of cplumns selected from each
	  table should be same. Datatypes of corresponding columns selected from each table should be same.
JOIN is used to combine data from multiple tables based on a matched comditon among them. The data
	 combined using JOIN statment is into new columns.Numbers of columns selected from each
	 table may not be same. Datatypes of corresponding columns selected from each table can be different.
	 */

--5
/*
INNER JOIN brings the data from left and right table which statisfy the join condition.
FULL JOIN brings all the records from the left and right table. For non-matching records, 
          both tables return null value.
*/

--6
/* 
LEFT JOIN brings all the records from the left table and only those records from the right
			 table which statisfy the join condition. For non-matching records, right table will
			 return null value.
FULL JOIN can be used to prevent the loss of data from the tables. And LEFT JOIN is a kind of 
		  FULL JOIN.
*/

--7
/*
CROSS JOIN returns all records from both left and right tables.
*/

--8
/*
WHERE clause is applied first to the individual rows in the tables or table-valued objects inthe
			 Diagram pane. Only the rows that meet the conditions in the WHERE clause are grouped
HAVING clause is then applied to the rows in the result set. Only the groups that meet the HAVING
			  conditions appear in the query output. And HAVING clause can only be applied to columns
			  taht also appear in the GROUP BY clause or in an aggregate function.
*/

--9
/*
yes. GROUP BY x, y means put all those records with the same values for both x and y in one group.
*/

--part 2

use AdventureWorks2019
go
--1
select count(p.ProductID)
from Production.Product p

--2
select count(p.ProductID) as Number_of_products_in_subcategory
from Production.Product p
where p.ProductSubcategoryID  is not null

--3
select p.ProductSubcategoryID as "ProductSubcategoryID", count(p.ProductSubcategoryID) as "CountedProducts"
from Production.Product p
where p.ProductSubcategoryID  is not null
group by p.ProductSubcategoryID

--4
select count(p.ProductID) as Number_of_products_in_subcategory
from Production.Product p
where p.ProductSubcategoryID  is null

--5
select i.ProductID, sum(i.Quantity) as "TheSum"
from Production.ProductInventory i
group by i.ProductID

--6
select i.ProductID, sum(i.Quantity) as "TheSum"
from Production.ProductInventory i
where i.LocationID = 40
group by i.ProductID
having sum(i.Quantity) < 100

--7
select i.Shelf,i.ProductID, sum(i.Quantity) as "TheSum"
from Production.ProductInventory i
where i.LocationID = 40
group by i.ProductID, i.Shelf
having sum(i.Quantity) < 100

--8
select AVG(i.Quantity)
from Production.ProductInventory i
where i.LocationID = 10

--9
select i.ProductID, i.Shelf, AVG(i.Quantity) as "TheAvg"
from Production.ProductInventory i
group by i.ProductID, i.shelf

--10
select i.ProductID, i.Shelf, AVG(i.Quantity) as "TheAvg"
from Production.ProductInventory i
where i.Shelf != 'N/A'
group by i.ProductID, i.shelf

--11
select p.Color, p.Class, count(p.ProductID) as "TheCount", avg(p.ListPrice) as "AvgPrice"
from Production.Product p
where p.Color is not null and p.Class is not null
group by p.Color, p.Class

--join
--12
select c.Name as "Country", s.Name as "Province"
from person.CountryRegion c full join Person.StateProvince s
on c.CountryRegionCode = s.CountryRegionCode

--13
select c.Name as "Country", s.Name as "Province"
from person.CountryRegion c full join Person.StateProvince s
on c.CountryRegionCode = s.CountryRegionCode
where c.Name in ('Germany','Canada')

use Northwind
go

--14
select p.ProductName
from Products p inner join [Order Details] d
on p.ProductID = d.ProductID
inner join Orders o
on d.OrderID = o.OrderID
where o.OrderDate between '1996-01-01' and '2021-12-12' 
group by p.ProductName

--15
select top 5 o.ShipPostalCode --, count(o.ShipPostalCode)
from Orders o
group by o.ShipPostalCode
order by count(o.ShipPostalCode) desc

--16
select top 5 o.ShipPostalCode 
from Orders o
where o.OrderDate between '2001-01-01' and '2021-12-12' 
--where datediff(year, o.OrderDate, GETDATE()) <20
group by o.ShipPostalCode
order by count(o.ShipPostalCode) desc

--17
select c.City, count(c.CustomerID) as "CustomerCount"
from Customers c
group by c.City

--18
select c.City, count(c.CustomerID) as "CustomerCount"
from Customers c
group by c.City
having count(c.CustomerID) > 10

--19
select c.ContactName, o.OrderDate
from Customers c inner join Orders o
on c.CustomerID = o.CustomerID
where o.OrderDate > '1998-01-01'


--20
select c.ContactName, max(o.OrderDate)
from Customers c left join Orders o
on c.CustomerID = o.CustomerID
group by c.ContactName
order by max(o.OrderDate) desc, c.ContactName

--21
select c.ContactName, sum(d.Quantity) as "CountOfBoughtProduct"
from Customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join [Order Details] d
on o.OrderID = d.OrderID
group by c.ContactName

--22
select c.CustomerID, sum(d.Quantity) as "CountOfBoughtProduct"
from Customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join [Order Details] d
on o.OrderID = d.OrderID
group by c.CustomerID
having sum(d.Quantity) >100

--23
select su.CompanyName as "Supplier Company Name", sh.CompanyName as "Shipping Company Name"
from Suppliers su cross join Shippers sh

--24
select o.OrderDate, p.ProductName
from [Order Details] d inner join Orders o
on d.OrderID = o.OrderID
inner join Products p
on d.ProductID = p.ProductID

--25
select e.FirstName + ' ' + e.LastName as "employee 1", m.FirstName + ' ' + m.LastName as "Employee 2"
from Employees e inner join Employees m
on e.Title = m.Title

--26
select e.EmployeeID, e.FirstName, e.LastName
from Employees e inner join Employees m
on e.EmployeeID = m.ReportsTo
group by e.EmployeeID,e.FirstName, e.LastName
having count(m.ReportsTo) > 2

--27
select c.City, c.ContactName as "Name", 'Customer' as "Type"
from Customers c
union
select e.City, e.FirstName + ' ' +e.LastName as "Name", 'Employee' as "Type"
from Employees e
order by c.City

--28
select T1.F1, T2,F2
from T1 inner join T2
on T1.F1 = T2.F2

--result
/*
T1.F1 T2.F2
2     2
3	  3
*/

--29
select T1.F1, T2.F2
from T1 left join T2
on T1.F1 = T2.F2

--result
/*
T1.F1 T2.F2
1	  null
2	  2
3	  3


