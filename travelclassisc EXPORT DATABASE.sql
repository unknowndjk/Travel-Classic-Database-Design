USE [master]
GO
/****** Object:  Database [tcdb]    Script Date: 1/12/2024 8:17:42 PM ******/
CREATE DATABASE [tcdb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'tcdb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\tcdb.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'tcdb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\tcdb_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [tcdb] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [tcdb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [tcdb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [tcdb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [tcdb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [tcdb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [tcdb] SET ARITHABORT OFF 
GO
ALTER DATABASE [tcdb] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [tcdb] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [tcdb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [tcdb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [tcdb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [tcdb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [tcdb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [tcdb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [tcdb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [tcdb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [tcdb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [tcdb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [tcdb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [tcdb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [tcdb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [tcdb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [tcdb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [tcdb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [tcdb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [tcdb] SET  MULTI_USER 
GO
ALTER DATABASE [tcdb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [tcdb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [tcdb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [tcdb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [tcdb]
GO
/****** Object:  StoredProcedure [dbo].[hotelbooking]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[hotelbooking] @hotelid int
as
select r.reservationid, tc.value , r.roomID ,rc.hotelid, rc.roomCatagoryName, r.travelerID , t.travelerName
from reservation as r
inner join room as rm
on r.roomid = rm.roomid 
inner join roomcatagory as rc
on rm.roomcatagoryId = rc.roomcatagoryId 
inner join transactionTC as tc
on r.reservationId = tc.reservationId
inner join traveler as t
on t.travelerID = r.travelerID
where hotelId = @hotelid

GO
/****** Object:  StoredProcedure [dbo].[sumoftransaction]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sumoftransaction] @hotelid int
as
select sum(tc.value) as TotleValue , rc.hotelid, ht.hotelName
from reservation as r
inner join room as rm
on r.roomid = rm.roomid 
inner join roomcatagory as rc
on rm.roomcatagoryId = rc.roomcatagoryId 
inner join transactionTC as tc
on r.reservationId = tc.reservationId
inner join hotel as ht
on ht.hotelid = rc.hotelid
where rc.hotelId = @hotelid
group by
rc.hotelid,
ht.hotelName

GO
/****** Object:  StoredProcedure [dbo].[totlerooms]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[totlerooms] @hotelid int
as
select sum(numberofroom) as TotleRooms , ht.hotelname as HotelName
from roomcatagory as rc
inner join hotel as ht
on rc.hotelid = ht.hotelid
where ht.hotelid = @hotelid
group by 
ht.hotelname

GO
/****** Object:  StoredProcedure [dbo].[travelarlocation]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[travelarlocation] @location varchar(20)
as 
select travelerid , travelername , travalerCity
from traveler
where travalerCountry = @location 

GO
/****** Object:  Table [dbo].[facilities]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[facilities](
	[facilityId] [int] NOT NULL,
	[facilityName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_facilities] PRIMARY KEY CLUSTERED 
(
	[facilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[hotel]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hotel](
	[hotelID] [int] NOT NULL,
	[hotelName] [varchar](50) NOT NULL,
	[hotelContactNum] [varchar](30) NOT NULL,
	[userId] [int] NOT NULL,
 CONSTRAINT [PK_hotel] PRIMARY KEY CLUSTERED 
(
	[hotelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[hotel_address]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hotel_address](
	[addressId] [int] NOT NULL,
	[street] [varchar](100) NOT NULL,
	[city] [varchar](50) NOT NULL,
	[country] [varchar](50) NOT NULL,
	[hotelId] [int] NOT NULL,
 CONSTRAINT [PK_hotelAddress] PRIMARY KEY CLUSTERED 
(
	[hotelId] ASC,
	[addressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[hotel_facility]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hotel_facility](
	[hotelId] [int] NOT NULL,
	[facilityId] [int] NOT NULL,
 CONSTRAINT [PK_hotelFacility] PRIMARY KEY CLUSTERED 
(
	[hotelId] ASC,
	[facilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[report]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[report](
	[reportId] [varchar](20) NOT NULL,
	[reportTitle] [varchar](100) NULL,
	[description] [varchar](1000) NULL,
	[travelerId] [int] NOT NULL,
	[destination] [varchar](20) NULL,
 CONSTRAINT [PK_report] PRIMARY KEY CLUSTERED 
(
	[reportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[reservation]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[reservation](
	[reservationId] [varchar](20) NOT NULL,
	[travelerID] [int] NOT NULL,
	[roomID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_reservation] PRIMARY KEY CLUSTERED 
(
	[reservationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[reservation_make]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[reservation_make](
	[reservationId] [varchar](20) NOT NULL,
	[travelerID] [int] NOT NULL,
	[noOfGuest] [int] NOT NULL,
 CONSTRAINT [PK_reservationMake] PRIMARY KEY CLUSTERED 
(
	[reservationId] ASC,
	[travelerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[room]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[room](
	[roomId] [varchar](20) NOT NULL,
	[avalibility] [varchar](10) NOT NULL,
	[roomcatagoryId] [varchar](20) NOT NULL,
 CONSTRAINT [PK_room] PRIMARY KEY CLUSTERED 
(
	[roomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[roomcatagory]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[roomcatagory](
	[roomCatagoryId] [varchar](20) NOT NULL,
	[roomCatagoryName] [varchar](50) NULL,
	[hotelid] [int] NULL,
	[numberofroom] [int] NULL,
 CONSTRAINT [PK_roomcatagory] PRIMARY KEY CLUSTERED 
(
	[roomCatagoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[transactionTC]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[transactionTC](
	[transactionID] [int] NOT NULL,
	[transactionTime] [time](7) NULL,
	[transactionDate] [date] NOT NULL,
	[reservationId] [varchar](20) NOT NULL,
	[value] [real] NULL,
 CONSTRAINT [PK_transactionTC] PRIMARY KEY CLUSTERED 
(
	[transactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[travelclassics]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[travelclassics](
	[userId] [int] NOT NULL,
	[userName] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[userType] [varchar](30) NOT NULL,
 CONSTRAINT [PK_travelclassics] PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[traveler]    Script Date: 1/12/2024 8:17:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[traveler](
	[travelerID] [int] NOT NULL,
	[travelerName] [varchar](50) NOT NULL,
	[travalerEmail] [varchar](50) NOT NULL,
	[travalerHouseNo] [varchar](30) NOT NULL,
	[travalerCity] [varchar](30) NOT NULL,
	[travalerCountry] [varchar](30) NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_traveler] PRIMARY KEY CLUSTERED 
(
	[travelerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[hotel]  WITH CHECK ADD  CONSTRAINT [FK_hoteluid] FOREIGN KEY([userId])
REFERENCES [dbo].[travelclassics] ([userId])
GO
ALTER TABLE [dbo].[hotel] CHECK CONSTRAINT [FK_hoteluid]
GO
ALTER TABLE [dbo].[hotel_address]  WITH CHECK ADD  CONSTRAINT [FK_hotelIdAddress] FOREIGN KEY([hotelId])
REFERENCES [dbo].[hotel] ([hotelID])
GO
ALTER TABLE [dbo].[hotel_address] CHECK CONSTRAINT [FK_hotelIdAddress]
GO
ALTER TABLE [dbo].[hotel_facility]  WITH CHECK ADD  CONSTRAINT [FK_hotelFacilitiesID] FOREIGN KEY([facilityId])
REFERENCES [dbo].[facilities] ([facilityId])
GO
ALTER TABLE [dbo].[hotel_facility] CHECK CONSTRAINT [FK_hotelFacilitiesID]
GO
ALTER TABLE [dbo].[hotel_facility]  WITH CHECK ADD  CONSTRAINT [FK_hotelIdFacilities] FOREIGN KEY([hotelId])
REFERENCES [dbo].[hotel] ([hotelID])
GO
ALTER TABLE [dbo].[hotel_facility] CHECK CONSTRAINT [FK_hotelIdFacilities]
GO
ALTER TABLE [dbo].[report]  WITH CHECK ADD  CONSTRAINT [FK_travelerReport] FOREIGN KEY([travelerId])
REFERENCES [dbo].[traveler] ([travelerID])
GO
ALTER TABLE [dbo].[report] CHECK CONSTRAINT [FK_travelerReport]
GO
ALTER TABLE [dbo].[reservation]  WITH CHECK ADD  CONSTRAINT [FK_resarvation_Room] FOREIGN KEY([roomID])
REFERENCES [dbo].[room] ([roomId])
GO
ALTER TABLE [dbo].[reservation] CHECK CONSTRAINT [FK_resarvation_Room]
GO
ALTER TABLE [dbo].[reservation]  WITH CHECK ADD  CONSTRAINT [FK_reservationTraveler] FOREIGN KEY([travelerID])
REFERENCES [dbo].[traveler] ([travelerID])
GO
ALTER TABLE [dbo].[reservation] CHECK CONSTRAINT [FK_reservationTraveler]
GO
ALTER TABLE [dbo].[reservation_make]  WITH CHECK ADD  CONSTRAINT [FK_reservationMakeReservation] FOREIGN KEY([reservationId])
REFERENCES [dbo].[reservation] ([reservationId])
GO
ALTER TABLE [dbo].[reservation_make] CHECK CONSTRAINT [FK_reservationMakeReservation]
GO
ALTER TABLE [dbo].[reservation_make]  WITH CHECK ADD  CONSTRAINT [FK_reservationMakeTraveler] FOREIGN KEY([travelerID])
REFERENCES [dbo].[traveler] ([travelerID])
GO
ALTER TABLE [dbo].[reservation_make] CHECK CONSTRAINT [FK_reservationMakeTraveler]
GO
ALTER TABLE [dbo].[room]  WITH CHECK ADD  CONSTRAINT [FK_roomRoomCatagory] FOREIGN KEY([roomcatagoryId])
REFERENCES [dbo].[roomcatagory] ([roomCatagoryId])
GO
ALTER TABLE [dbo].[room] CHECK CONSTRAINT [FK_roomRoomCatagory]
GO
ALTER TABLE [dbo].[roomcatagory]  WITH CHECK ADD  CONSTRAINT [FK_hotelidroomcatagory] FOREIGN KEY([hotelid])
REFERENCES [dbo].[hotel] ([hotelID])
GO
ALTER TABLE [dbo].[roomcatagory] CHECK CONSTRAINT [FK_hotelidroomcatagory]
GO
ALTER TABLE [dbo].[transactionTC]  WITH CHECK ADD  CONSTRAINT [FK_transactionTcReservation] FOREIGN KEY([reservationId])
REFERENCES [dbo].[reservation] ([reservationId])
GO
ALTER TABLE [dbo].[transactionTC] CHECK CONSTRAINT [FK_transactionTcReservation]
GO
ALTER TABLE [dbo].[traveler]  WITH CHECK ADD  CONSTRAINT [FK_traveleruid] FOREIGN KEY([userID])
REFERENCES [dbo].[travelclassics] ([userId])
GO
ALTER TABLE [dbo].[traveler] CHECK CONSTRAINT [FK_traveleruid]
GO
USE [master]
GO
ALTER DATABASE [tcdb] SET  READ_WRITE 
GO
