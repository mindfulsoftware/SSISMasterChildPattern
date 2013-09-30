use DW_Northwind
go
create table dbo.Dim_Employee(
	EmployeeKey int identity(1,1) not null,
	EmployeeID int not null,
	LastName nvarchar(20) not null,
	FirstName nvarchar(10) not null,
	Title nvarchar(30) not null,
	TitleOfCourtesy nvarchar(25) not null,
	HireDate datetime not null,
	EffectiveFrom datetime not null,
	EffectiveTo datetime null,
	EffectiveFlag bit not null,
	HashCode varbinary(16) not null,
	RunId int not null
)
go
create table dbo.Dim_Product(
	ProductKey int identity(1,1) not null,
	ProductID int not null,
	ProductName nvarchar(40) not null,
	QuantityPerUnit nvarchar(20) not null,
	Discontinued bit not null,
	HashCode varbinary(16) not null,
	RundId int not null,
)
go
create table dbo.Fact_Orders (
	OrderKey int identity(1,1) not null,
	OrderId int not null,
	ProductKey int not null,
	EmployeeKey int not null, 
	OrderDateKey int not null, 
	RequiredDateKey int not null, 
	ShippedDateKey int not null, 
	UnitPrice decimal(18,2) not null, 
	Quantity decimal(18,2) not null, 
	Discount decimal(18,2) not null,  
	HashCode varbinary(16) not null,
	RunId int not null
)
go
create view dbo.vw_Dim_Employee
as
	select	EmployeeKey, EmployeeID, LastName, FirstName, Title, 
			TitleOfCourtesy, HireDate, EffectiveFrom, EffectiveTo, 
			EffectiveFlag
	from	dbo.Dim_Employee
	where	EffectiveFlag = 1

go
