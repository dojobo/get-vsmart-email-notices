USE [vSmartNotices]
GO

/****** Object:  Trigger [dbo].[TR_noticeRecords_onInsertZero]    Script Date: 5/26/2015 12:31:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE trigger [dbo].[TR_noticeRecords_onInsertZero]
on [dbo].[noticeRecords] 
after insert as
begin
	set nocount on;
	if (select count(id) from inserted where reservations = 0) > 0
	begin
		exec msdb.dbo.vSmartNoticeEmailRes;
	end
	if (select count(id) from inserted where firstoverdues = 0) > 0
	begin
		exec msdb.dbo.vSmartNoticeEmailFirst;
	end
	if (select count(id) from inserted where tendayoverdues = 0) > 0
	begin
		exec msdb.dbo.vSmartNoticeEmailTen;
	end
end
GO

