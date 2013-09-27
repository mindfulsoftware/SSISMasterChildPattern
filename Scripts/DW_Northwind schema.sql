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