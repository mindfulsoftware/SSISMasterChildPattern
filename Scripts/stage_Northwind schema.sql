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