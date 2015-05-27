USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[vSmartNoticeEmailTen]    Script Date: 5/26/2015 12:33:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[vSmartNoticeEmailTen]
with execute as owner
as
exec sp_start_job @job_name = 'vSmartNoticeEmailTen'

GO

