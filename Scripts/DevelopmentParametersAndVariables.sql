use SSISDB 
go

if not exists (select * from catalog.environments where name = 'Development')
	begin 

	-- create development environment
	exec catalog.create_environment
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@environment_description = ''

	-- create development environment variables
	exec catalog.create_environment_variable
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@variable_name = 'AdminServer', 
		@data_type =N'String', 
		@sensitive = 0, 
		@value = N'.\SQL2012', 
		@description = N''

	exec catalog.create_environment_variable
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@variable_name = 'SourceInitialCataog', 
		@data_type =N'String', 
		@sensitive = 0, 
		@value = N'Northwind', 
		@description = N''

	exec catalog.create_environment_variable
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@variable_name = 'SourceServer', 
		@data_type =N'String', 
		@sensitive = 0, 
		@value = N'.\SQL2005', 
		@description = N''

	exec catalog.create_environment_variable
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@variable_name = 'StagingInitialCatalog', 
		@data_type =N'String', 
		@sensitive = 0, 
		@value = N'stage_Northwind', 
		@description = N''

	exec catalog.create_environment_variable
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@variable_name = 'StagingServer', 
		@data_type =N'String', 
		@sensitive = 0, 
		@value = N'.\SQL2012', 
		@description = N''

	exec catalog.create_environment_variable
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@variable_name = 'WarehouseInitialCatalog', 
		@data_type =N'String', 
		@sensitive = 0, 
		@value = N'DW_Northwind', 
		@description = N''

	exec catalog.create_environment_variable
		@folder_name = 'MasterChildCatalog', 
		@environment_name = 'Development', 
		@variable_name = 'WarehouseServer', 
		@data_type =N'String', 
		@sensitive = 0, 
		@value = N'.\SQL2012', 
		@description = N''


	-- create project reference to development environment
	declare @referenceId bigint
	exec catalog.create_environment_reference
		@folder_name = 'MasterChildCatalog', 
		@project_name = 'SSISMasterChildPattern', 
		@environment_name = 'Development', 
		@reference_type = 'R', 
		@reference_id = @referenceId output

	-- configure parameters
	exec catalog.set_object_parameter_value
		@object_type = 20,		-- 20 = project, 30 = Package
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'AdminServer', 
		@parameter_value = 'AdminServer',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'R'				-- R = reference(d by environmental variable), V = value type

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'Application', 
		@parameter_value = N'',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'V'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'Destination', 
		@parameter_value = N'',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'V'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'SourceInitialCataog', 
		@parameter_value = 'SourceInitialCataog',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'R'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'SourceServer', 
		@parameter_value = 'SourceServer',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'R'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'StagingInitialCatalog', 
		@parameter_value = 'StagingInitialCatalog',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'R'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'StagingServer', 
		@parameter_value = 'StagingServer',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'R'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'System', 
		@parameter_value = N'',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'V'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'WarehouseInitialCatalog', 
		@parameter_value = 'WarehouseInitialCatalog',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'R'

	exec catalog.set_object_parameter_value
		@object_type = 20,
		@folder_name = 'MasterChildCatalog', 
		@project_name ='SSISMasterChildPattern', 
		@parameter_name = 'WarehouseServer', 
		@parameter_value = 'WarehouseServer',
		@object_name = 'SSISMasterChildPattern', 
		@value_type = 'R'
	end
