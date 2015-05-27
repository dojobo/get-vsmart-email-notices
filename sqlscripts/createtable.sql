USE [vSmartNotices]
GO

/****** Object:  Table [dbo].[noticeRecords]    Script Date: 5/26/2015 12:29:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[noticeRecords](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[noticedate] [date] NULL,
	[reservations] [int] NULL,
	[firstoverdues] [int] NULL,
	[tendayoverdues] [int] NULL,
	[invoices] [int] NULL,
	[timecounted] [datetime] NULL CONSTRAINT [DF_noticeRecords_timecounted]  DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

