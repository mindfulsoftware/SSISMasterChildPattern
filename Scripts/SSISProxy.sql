USE [msdb]
GO

/****** Object:  ProxyAccount [ssis proxy]    Script Date: 2/10/2013 1:57:34 PM ******/
EXEC msdb.dbo.sp_add_proxy @proxy_name=N'ssis proxy',@credential_name=N'sysadmin Credential', 
		@enabled=1
GO

EXEC msdb.dbo.sp_grant_proxy_to_subsystem @proxy_name=N'ssis proxy', @subsystem_id=11
GO

EXEC msdb.dbo.sp_grant_login_to_proxy @proxy_name=N'ssis proxy', @fixed_server_role=N'sysadmin'
GO


