USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[vSmartNoticeEmailFirst]    Script Date: 5/26/2015 12:32:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[vSmartNoticeEmailFirst]
with execute as owner
as
exec sp_start_job @job_name = 'vSmartNoticeEmailFirst'

GO

