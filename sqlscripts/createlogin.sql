USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [vsmartnotices]    Script Date: 5/27/2015 8:51:48 AM ******/
CREATE LOGIN [vsmartnotices] WITH PASSWORD=N'J;;
GO

ALTER LOGIN [vsmartnotices] DISABLE
GO
