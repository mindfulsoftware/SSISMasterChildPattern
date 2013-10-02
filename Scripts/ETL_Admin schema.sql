use ETL_Admin
go

create table dbo.Package (
	Id int identity(1,1) not null primary key,
	[Application] varchar(100) not null,
	[System] varchar(100) not null,
	Destination varchar(100) not null,
	Package varchar(100) not null,
	LoadOrder int not null,
	LoadEnabled bit not null
)

create table dbo.PackageVariable (
	Id int identity(1,1) not null primary key,
	PackageId int not null,
	Name varchar(100) not null,
	Value varchar(100) not null,
	[Description] varchar(max) not null default(''),
)

create table dbo.ExecutionLog (
	Id int identity(1,1) not null primary key,
	RunId int not null,
	PackageId int not null,
	[Status] varchar(20) not null,
	StartTime datetime,
	EndTime datetime,
	[Message] varchar(max) not null default(''),
	RowsRead int not null default(0),
	RowsInserted int not null default(0),
	RowsUpdated int not null default(0),
	RowsDeleted int not null default(0),
	RowsUnchanged int not null default(0)
)

create table dbo.Seed (
	Name varchar(20) not null, 
	Value int not null
)

alter table dbo.PackageVariable 
	add constraint FK_PackageVariable_Package foreign key (PackageId) references dbo.Package(Id)

alter table dbo.ExecutionLog 
	add constraint FK_ExecutionLog_Package foreign key (PackageId) references dbo.Package(Id)

go
create proc dbo.GetSeed
	@Name varchar(20),
	@Value int output
as
	begin
	set nocount on

	if not exists(select * from dbo.Seed where Name = @Name)
		insert dbo.Seed values(@Name, 1)

	begin tran
		set @Value = (select Value from dbo.Seed where Name = @Name)
		update dbo.Seed set Value = Value + 1 where Name = @Name
	commit

	end
go
create proc dbo.GetPackagesForProcessing
	@Application varchar(100),
	@System varchar(100),
	@Destination varchar(100)
as
	begin
	set nocount on

	if (
		select	count(*) 
		from	dbo.Package 
		where	[Application] = @Application 
		and		[System]  = @System
		and		Destination = @Destination
	) = 0
	begin
		raiserror('The package collection cannot be found (Application: %s, System: %s, Destination: %s)', 
			16, 1, @Application, @System, @Destination)	
	end

	declare @RunId int
	exec dbo.GetSeed 'RunId', @RunId output 

	insert	dbo.ExecutionLog(PackageId, RunId, [Status])
	select	Id, @RunId, 'Not Started'
	from	dbo.Package 
	where	[Application] = @Application 
	and		[System]  = @System
	and		Destination = @Destination
	and		LoadEnabled = 1
	order by [LoadOrder]

	select	RunId = @RunId, PackageId = Id, PackageName = Package
	from	dbo.Package 
	where	[Application] = @Application 
	and		[System]  = @System
	and		Destination = @Destination
	and		LoadEnabled = 1
	order by [LoadOrder]	

	end
go
create proc dbo.GetPackageVariables
	@PackageId int
as
	begin
	set nocount on

	select	Name, Value
	from	dbo.PackageVariable

	end
go
create proc dbo.UpdateExecutionLog
	@RunId int,
	@PackageId int,
	@Status varchar(20),
	@StartDate datetime = null,
	@EndDate datetime = null,
	@Message varchar(max) = '', 
	@RowsRead int = 0, 
	@RowsInserted int = 0, 
	@RowsUpdated int = 0, 
	@RowsDeleted int = 0, 
	@RowsUnchanged int = 0
as
	begin
	set nocount on

	if exists(select * from dbo.ExecutionLog where RunId = @RunId and PackageId = @PackageId)
		if @StartDate is null
			set @StartDate = (select StartTime from dbo.ExecutionLog where RunId = @RunId and PackageId = @PackageId)

	update	dbo.ExecutionLog
	set	[Status] = @Status, 
		StartTime = @StartDate,
		EndTime = @EndDate, 
		[Message] = @Message, 
		RowsRead = @RowsRead, 
		RowsInserted = @RowsInserted, 
		RowsUpdated = @RowsUpdated, 
		RowsDeleted = @RowsDeleted, 
		RowsUnchanged = @RowsUnchanged
	where
		RunId = @RunId
	and	
		PackageId = @PackageId

	end
go
-- extract packages
insert dbo.Package ([Application], [System], Destination, Package, LoadOrder, LoadEnabled)
values('Demo', 'Northwind', 'Staging', 'Employees_Extract.dtsx', 1, 1)

insert dbo.Package ([Application], [System], Destination, Package, LoadOrder, LoadEnabled)
values('Demo', 'Northwind', 'Staging', 'Products_Extract.dtsx', 3, 1)

insert dbo.Package ([Application], [System], Destination, Package, LoadOrder, LoadEnabled)
values('Demo', 'Northwind', 'Staging', 'Orders_Extract.dtsx', 3, 1)

insert dbo.Package ([Application], [System], Destination, Package, LoadOrder, LoadEnabled)
values('Demo', 'Northwind', 'Staging', 'OrderDetails_Extract.dtsx', 4, 1)

-- load pacakges
insert dbo.Package ([Application], [System], Destination, Package, LoadOrder, LoadEnabled)
values('Demo', 'Northwind', 'DW', 'Dim_Employees_Load.dtsx', 1, 1)

insert dbo.Package ([Application], [System], Destination, Package, LoadOrder, LoadEnabled)
values('Demo', 'Northwind', 'DW', 'Dim_Products_Load.dtsx', 2, 1)

insert dbo.Package ([Application], [System], Destination, Package, LoadOrder, LoadEnabled)
values('Demo', 'Northwind', 'DW', 'Fact_Orders_Load_1.dtsx', 3, 1)

-- package variables
insert dbo.PackageVariable(PackageId, Name, Value, [Description])
values (1, 'Country', 'USA', 'Extract USA Employees only')
