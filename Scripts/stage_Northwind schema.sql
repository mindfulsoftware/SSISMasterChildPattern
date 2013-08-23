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