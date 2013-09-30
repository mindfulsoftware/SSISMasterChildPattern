use stage_Northwind
go
create table dbo.stage_Employees(
	SourceServer varchar(20),
	SourceInitialCatalog  varchar(20),
	ExtractedOn datetime,
	EmployeeID int,
	LastName nvarchar(20),
	FirstName nvarchar(10),
	Title nvarchar(30),
	TitleOfCourtesy nvarchar(25),
	HireDate datetime
)
go
create table dbo.stage_Orders (
	SourceServer varchar(20),
	SourceInitialCatalog  varchar(20),
	ExtractedOn datetime,
	OrderID int,
	CustomerID nchar(5),
	EmployeeID int,
	OrderDate datetime,
	RequiredDate datetime,
	ShippedDate datetime,
	ShipVia int,
	Freight money,
	ShipName nvarchar(40),
	ShipAddress nvarchar(60),
	ShipCity nvarchar(15),
	ShipRegion nvarchar(15),
	ShipPostalCode nvarchar(10),
	ShipCountry nvarchar(15)
)
go
create table dbo.stage_OrderDetails (
	SourceServer varchar(20),
	SourceInitialCatalog  varchar(20),
	ExtractedOn datetime,
	OrderID int,
	ProductID int,
	UnitPrice money,
	Quantity int,
	Discount real
)
go
create table dbo.stage_Products (
	SourceServer varchar(20),
	SourceInitialCatalog  varchar(20),
	ExtractedOn datetime,
	ProductID int,
	ProductName nvarchar(40),
	QuantityPerUnit nvarchar(20),
	Discontinued bit
)
go
create view dbo.vw_Dim_Employee
as

	select	EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, HireDate, 
			HashCode = cast(hashbytes('MD5',
				coalesce(cast(EmployeeID as nvarchar), '') + 
				coalesce(cast(LastName as nvarchar), '') + 
				coalesce(cast(FirstName as nvarchar), '') + 
				coalesce(cast(Title as nvarchar), '') + 
				coalesce(cast(TitleOfCourtesy as nvarchar), '') + 
				coalesce(cast(HireDate as nvarchar), '')
				) as varbinary(16))
	from (
		select
			EmployeeID, 
			LastName = coalesce(LastName, ''), 
			FirstName = coalesce(FirstName, ''), 
			Title = coalesce(Title, ''), 
			TitleOfCourtesy = coalesce(TitleOfCourtesy, ''), 
			HireDate
		from	
			dbo.stage_Employees
	) t

go
create view dbo.vw_Dim_Product
as
	select	ProductID, ProductName, QuantityPerUnit, Discontinued,
			HashCode = cast(hashbytes('MD5',
				coalesce(cast(ProductID as nvarchar), '') + 
				coalesce(cast(ProductName as nvarchar), '') + 
				coalesce(cast(QuantityPerUnit as nvarchar), '') + 
				coalesce(cast(Discontinued as nvarchar), '')
				) as varbinary(16))
	from (
		select
			ProductID, 
			ProductName = coalesce(ProductName, ''), 
			QuantityPerUnit = coalesce(QuantityPerUnit, ''), 
			Discontinued = coalesce(Discontinued, '')

		from	
			dbo.stage_Products 
	) t
go
create view dbo.vw_Fact_Orders
as
	select	OrderId, ProductKey, EmployeeKey, OrderDateKey, RequiredDateKey, ShippedDateKey, 
			UnitPrice, Quantity, Discount,
			HashCode = cast(hashbytes('MD5',
				coalesce(cast(OrderId as nvarchar), '') + 
				coalesce(cast(ProductKey as nvarchar), '') + 
				coalesce(cast(EmployeeKey as nvarchar), '') + 
				coalesce(cast(OrderDateKey as nvarchar), '') + 
				coalesce(cast(RequiredDateKey as nvarchar), '') + 
				coalesce(cast(ShippedDateKey as nvarchar), '') + 
				coalesce(cast(UnitPrice as nvarchar), '') + 
				coalesce(cast(Quantity as nvarchar), '') + 
				coalesce(cast(Discount as nvarchar), '')
				) as varbinary(16))
	from (
		select
			o.OrderId, 
			ProductKey = p.ProductKey,
			--CustomerKey = ,
			EmployeeKey = e.EmployeeKey, 
			OrderDateKey = do.DateKey,
			RequiredDateKey = dr.DateKey,
			ShippedDateKey = ds.DateKey,
			UnitPrice = od.UnitPrice,
			Quantity = od.Quantity,
			Discount = od.Discount
		from	
			dbo.stage_Orders o
		join	
			dbo.Stage_OrderDetails od on o.OrderId = od.OrderId
		join
			DW_Northwind.dbo.vw_Dim_Employee e on o.EmployeeID = e.EmployeeId
		join
			DW_Northwind.dbo.Dim_Product p on od.ProductID = p.ProductId
		join
			DW_Northwind.dbo.Dim_Date do on cast(convert(varchar(8), o.OrderDate, 112) as int) = do.DateKey
		join
			DW_Northwind.dbo.Dim_Date dr on cast(convert(varchar(8), o.RequiredDate, 112) as int) = dr.DateKey
		join
			DW_Northwind.dbo.Dim_Date ds on cast(convert(varchar(8), o.ShippedDate, 112) as int) = ds.DateKey
) t


go