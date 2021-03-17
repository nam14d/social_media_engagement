/****** Object:  Table [dbo].[Team1_MemeAnalysis]    Script Date: 3/16/2021 8:32:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Team1_MemeAnalysis](
	[Tweet_ID] [int] IDENTITY(1,1) NOT NULL,
	[Posted_By] [varchar](50) NOT NULL,
	[Twitter_Handle] [varchar](50) NOT NULL,
	[Tweet] [varchar](8000) NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[No_of_Likes] [int] NOT NULL,
	[No_of_Retweets] [int] NOT NULL,
	[No_of_Followers] [int] NOT NULL,
	[User_Location] [varchar](100) NULL,
	[Image_URL] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Tweet_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
