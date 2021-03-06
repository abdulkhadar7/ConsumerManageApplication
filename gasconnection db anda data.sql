/****** Object:  Index [UC_TemplateCode]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MessageTemplate]') AND name = N'UC_TemplateCode')
ALTER TABLE [dbo].[MessageTemplate] DROP CONSTRAINT [UC_TemplateCode]
GO
/****** Object:  Table [dbo].[SettingsMaster]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SettingsMaster]') AND type in (N'U'))
DROP TABLE [dbo].[SettingsMaster]
GO
/****** Object:  Table [dbo].[PaymentDetails]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentDetails]') AND type in (N'U'))
DROP TABLE [dbo].[PaymentDetails]
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
DROP TABLE [dbo].[Payment]
GO
/****** Object:  Table [dbo].[MessageTemplate]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageTemplate]') AND type in (N'U'))
DROP TABLE [dbo].[MessageTemplate]
GO
/****** Object:  Table [dbo].[MessageLog]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageLog]') AND type in (N'U'))
DROP TABLE [dbo].[MessageLog]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
DROP TABLE [dbo].[Customer]
GO
/****** Object:  StoredProcedure [dbo].[UpdatePaymentInfo]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePaymentInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdatePaymentInfo]
GO
/****** Object:  StoredProcedure [dbo].[GetPaymentList]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaymentList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPaymentList]
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerList]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCustomerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCustomerList]
GO
/****** Object:  StoredProcedure [dbo].[GenerateClassFromTable]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GenerateClassFromTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GenerateClassFromTable]
GO
/****** Object:  StoredProcedure [dbo].[AddPaymentInfo]    Script Date: 21-02-2019 22:28:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPaymentInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddPaymentInfo]
GO
/****** Object:  StoredProcedure [dbo].[AddPaymentInfo]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPaymentInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddPaymentInfo]
	-- Add the parameters for the stored procedure here
	@customerId INT,
	@advanceAmount Decimal(18,2),
	@installment1 Decimal(18,2),
	@installment2 Decimal(18,2),
	@installment3 Decimal(18,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @paymentID INT=0
	,@createdDate DATETIME
    --insert statement for payment
	INSERT INTO [dbo].[Payment]
           ([CustomerID]
           ,[InstallmentAmount]
           ,[TotalPaid]
           ,[TotalPending]
           ,[CreatedOn]
           ,[ModifiedOn]
           ,[AdvanceAmount])
     
	 SELECT
		   @customerId,
		   @installment1+@installment2+@installment3,
		   0.0,
		   0.0,
		   C.CreatedOn,
		   GETDATE(),
		   @advanceAmount
		  FROM Customer C WHERE C.CustomerID=@customerId 

	SET @paymentID=SCOPE_IDENTITY()

	SELECT @createdDate=CreatedOn FROM Customer WHERE CustomerID=@customerId
	--INSERT statement for paymentdetails
	
	INSERT INTO [dbo].[PaymentDetails]
           ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
     VALUES
           (@paymentID,@advanceAmount,@createdDate,NULL,0,GETDATE(),GETDATE(),0)

	INSERT INTO [dbo].[PaymentDetails]
           ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
     VALUES
           (@paymentID,@installment1,@createdDate+30,NULL,0,GETDATE(),GETDATE(),1)

	INSERT INTO [dbo].[PaymentDetails]
           ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
     VALUES
           (@paymentID,@installment2,@createdDate+60,NULL,0,GETDATE(),GETDATE(),2)

	INSERT INTO [dbo].[PaymentDetails]
           ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
     VALUES
           (@paymentID,@installment3,@createdDate+90,NULL,0,GETDATE(),GETDATE(),3)

	SELECT @paymentID AS PaymentId
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GenerateClassFromTable]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GenerateClassFromTable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateClassFromTable] 
	-- Add the parameters for the stored procedure here
	@tableName VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @Result varchar(max) = ''public class '' + @TableName + ''
		{''
		
		select @Result = @Result + ''
		    public '' + ColumnType + NullableSign + '' '' + ColumnName + '' { get; set; }
		''
		from
		(
		    select 
		        replace(col.name, '' '', ''_'') ColumnName,
		        column_id ColumnId,
		        case typ.name 
		            when ''bigint'' then ''long''
		            when ''binary'' then ''byte[]''
		            when ''bit'' then ''bool''
		            when ''char'' then ''string''
		            when ''date'' then ''DateTime''
		            when ''datetime'' then ''DateTime''
		            when ''datetime2'' then ''DateTime''
		            when ''datetimeoffset'' then ''DateTimeOffset''
		            when ''decimal'' then ''decimal''
		            when ''float'' then ''double''
		            when ''image'' then ''byte[]''
		            when ''int'' then ''int''
		            when ''money'' then ''decimal''
		            when ''nchar'' then ''string''
		            when ''ntext'' then ''string''
		            when ''numeric'' then ''decimal''
		            when ''nvarchar'' then ''string''
		            when ''real'' then ''float''
		            when ''smalldatetime'' then ''DateTime''
		            when ''smallint'' then ''short''
		            when ''smallmoney'' then ''decimal''
		            when ''text'' then ''string''
		            when ''time'' then ''TimeSpan''
		            when ''timestamp'' then ''long''
		            when ''tinyint'' then ''byte''
		            when ''uniqueidentifier'' then ''Guid''
		            when ''varbinary'' then ''byte[]''
		            when ''varchar'' then ''string''
		            else ''UNKNOWN_'' + typ.name
		        end ColumnType,
		        case 
		            when col.is_nullable = 1 and typ.name in (''bigint'', ''bit'', ''date'', ''datetime'', ''datetime2'', ''datetimeoffset'', ''decimal'', ''float'', ''int'', ''money'', ''numeric'', ''real'', ''smalldatetime'', ''smallint'', ''smallmoney'', ''time'', ''tinyint'', ''uniqueidentifier'') 
		            then ''?'' 
		            else '''' 
		        end NullableSign
		    from sys.columns col
		        join sys.types typ on
		            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
		    where object_id = object_id(@TableName)
		) t
		order by ColumnId
		
		set @Result = @Result  + ''
		}''
		
		print @Result
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerList]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCustomerList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

--	exec GetCustomerList NULL,NULL,''2018-12-06'',NULL

-- =============================================

CREATE PROCEDURE [dbo].[GetCustomerList]

	@CustomerName VARCHAR(100)=NULL,

	@ConsumerNumber INT=NULL,

	@SubmitDate DATE=NULL,

	@Aadhar VARCHAR(20)=NULL



	--,,,

AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	--select @SubmitDate

    -- Insert statements for procedure here

	SELECT  [CustomerID]

      ,[FirstName]

      ,[LastName]

      ,[DOB]

      ,[Gender]

      ,[Aadhar]

      ,[Street]

      ,[City]

      ,[PostCode]

      ,[State]

      ,[MobileNumber]

      ,[CreatedOn]

      ,[ModifiedOn]
	 
  FROM [Customer] C

	WHERE 

		(@CustomerName IS NULL OR C.FirstName +'' '' +C.LastName LIKE ''%''+@CustomerName+''%'')

		AND (@ConsumerNumber IS NULL OR C.ConsumerNo=@ConsumerNumber )

		AND (@Aadhar IS NULL OR C.Aadhar LIKE ''%''+@Aadhar+''%'' )

		AND (@SubmitDate IS NULL OR @SubmitDate=CONVERT(DATE,C.CreatedOn) )

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPaymentList]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaymentList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,> GetPaymentList NULL,NULL,NULL,NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetPaymentList]
	-- Add the parameters for the stored procedure here
	@CustomerName VARCHAR(100)=NULL,
	@ConsumerNumber INT=NULL,
	@SubmitDate DATE=NULL
	--@Aadhar VARCHAR(20)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
				

		SELECT distinct 
			C.FirstName+'' ''+C.LastName AS CustomerName,
			pay.*,CONVERT(DATE,pd.ModifiedOn)ModifiedOn 
			FROM (
					SELECT
					   PayDet.PaymentID
					   ,SUM(PayDet.Advance) Advance
					   ,SUM(PayDet.InstallmentAmount) InstallmentAmount
					   ,SUM(PayDet.TotalPaid) TotalPaid
					   ,SUM(PayDet.TotalPending) TotalPending
					   ,SUM(PayDet.PaymentAmount) TotalAmount
					  -- ,PayDet.ModifiedOn
					   FROM 
					   (
							SELECT 
									PD.PaymentID AS PaymentID,
									CASE WHEN PD.InstallmentNo=0 THEN ISNULL(PD.PaymentAmount,0) ELSE 0 END AS Advance,
									CASE WHEN PD.InstallmentNo<>0 THEN ISNULL(PD.PaymentAmount,0)ELSE 0 END AS InstallmentAmount,
									CASE WHEN PD.PaymentStatus=1 THEN ISNULL(PD.PaymentAmount,0) ELSE 0 END AS TotalPaid,
									CASE WHEN PD.PaymentStatus<>1 THEN ISNULL(PD.PaymentAmount,0)ELSE 0 END AS TotalPending,
									ISNULL(PD.PaymentAmount,0) AS PaymentAmount
									FROM PaymentDetails PD			
						) AS PayDet
			WHERE PayDet.TotalPaid+PayDet.TotalPending>0
			GROUP BY PayDet.PaymentID
		) pay 
		JOIN PaymentDetails pd on pay.PaymentID=pd.PaymentID
		JOIN Payment P ON P.PaymentID=pd.PaymentID
		JOIN Customer C ON C.CustomerID=p.CustomerID

		WHERE 
			(@CustomerName IS NULL OR C.FirstName+'' ''+C.LastName LIKE ''%''+@CustomerName+''%'')
			AND (@ConsumerNumber IS NULL OR C.ConsumerNo=@ConsumerNumber)
			AND (@SubmitDate IS NULL OR CONVERT(DATE,C.CreatedOn)=@SubmitDate)
		order by CONVERT(DATE,pd.ModifiedOn)  desc
		

			

		
			




		
		
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdatePaymentInfo]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePaymentInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePaymentInfo] 
	-- Add the parameters for the stored procedure here
	@paymentId int=NULL,
	@CustomerId INT=NULL,
	@advAmount decimal(18,2)=NULL,
	@insta1Amount decimal(18,2)=NULL,
	@insta2Amount decimal(18,2)=NULL,
	@insta3Amount decimal(18,2)=NULL,
	@advStatus BIT =NULL,
	@inst1Status BIT =NULL,
	@inst2Status BIT =NULL,
	@inst3Status BIT =NULL,
	@mode VARCHAR(10)=NULL,
	@IsUpdate BIT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TotalPaid DECIMAL(18,2),@TotalPending DECIMAL(18,2)

    -- Insert statements for procedure here
	IF(@mode=''UPDATE'')
	BEGIN
		
		IF(@IsUpdate=1)
		BEGIN
			UPDATE PaymentDetails SET PaymentAmount=@advAmount,   PaymentStatus=@advStatus,  ModifiedOn=GETDATE(),dueDate=GETDATE() WHERE PaymentID=@paymentId AND InstallmentNo=0
			UPDATE PaymentDetails SET PaymentAmount=@insta1Amount,PaymentStatus=@inst1Status,ModifiedOn=GETDATE(),dueDate=DATEADD(DAY,30,GETDATE()) WHERE PaymentID=@paymentId AND InstallmentNo=1
			UPDATE PaymentDetails SET PaymentAmount=@insta2Amount,PaymentStatus=@inst2Status,ModifiedOn=GETDATE(),dueDate=DATEADD(DAY,60,GETDATE()) WHERE PaymentID=@paymentId AND InstallmentNo=2
			UPDATE PaymentDetails SET PaymentAmount=@insta3Amount,PaymentStatus=@inst3Status,ModifiedOn=GETDATE(),dueDate=DATEADD(DAY,90,GETDATE()) WHERE PaymentID=@paymentId AND InstallmentNo=3
		END

		UPDATE PaymentDetails SET PaymentAmount=@advAmount,   PaymentStatus=@advStatus,  ModifiedOn=GETDATE() WHERE PaymentID=@paymentId AND InstallmentNo=0
		UPDATE PaymentDetails SET PaymentAmount=@insta1Amount,PaymentStatus=@inst1Status,ModifiedOn=GETDATE() WHERE PaymentID=@paymentId AND InstallmentNo=1
		UPDATE PaymentDetails SET PaymentAmount=@insta2Amount,PaymentStatus=@inst2Status,ModifiedOn=GETDATE() WHERE PaymentID=@paymentId AND InstallmentNo=2
		UPDATE PaymentDetails SET PaymentAmount=@insta3Amount,PaymentStatus=@inst3Status,ModifiedOn=GETDATE() WHERE PaymentID=@paymentId AND InstallmentNo=3

		SELECT 
			@TotalPaid=SUM(t.TotalPaid),@TotalPending=SUM(t.TotalPending)  
			FROM (
					 SELECT 
						TotalPaid=CASE 
							WHEN pd.PaymentStatus =1 THEN ISNULL(pd.PaymentAmount,0) 
							ELSE 0	END ,
						TotalPending= CASE 
							WHEN pd.PaymentStatus =0 THEN ISNULL(pd.PaymentAmount,0)
							ELSE 0 END  
						 FROM PaymentDetails pd WHERE PaymentID=@paymentId
				) AS  t

		UPDATE Payment SET TotalPaid=@TotalPaid,TotalPending=@TotalPending,InstallmentAmount=(@insta1Amount+@insta2Amount+@insta3Amount),AdvanceAmount=@advAmount,ModifiedOn=GETDATE() WHERE PaymentID=@paymentId

		SELECT @paymentId AS paymentId
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Payment]
           ([CustomerID]
           ,[InstallmentAmount]
           ,[TotalPaid]
           ,[TotalPending]
           ,[CreatedOn]
           ,[ModifiedOn]
           ,[AdvanceAmount])
     VALUES
           (@CustomerId,(@insta1Amount+@insta2Amount+@insta3Amount),0,0,GETDATE(),NULL,@advAmount)
		
		SET @paymentID=SCOPE_IDENTITY()

				 INSERT INTO [dbo].[PaymentDetails]
				   ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
				 VALUES
					   (@paymentID,@advAmount,GETDATE(),NULL,@advStatus,GETDATE(),GETDATE(),0)

				INSERT INTO [dbo].[PaymentDetails]
					   ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
				 VALUES
					   (@paymentID,@insta1Amount,DATEADD(DAY,30,GETDATE()),NULL,@inst1Status,GETDATE(),GETDATE(),1)

				INSERT INTO [dbo].[PaymentDetails]
					   ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
				 VALUES
					   (@paymentID,@insta2Amount,DATEADD(DAY,60,GETDATE()),NULL,@inst2Status,GETDATE(),GETDATE(),2)

				INSERT INTO [dbo].[PaymentDetails]
					   ([PaymentID],[PaymentAmount],[DueDate],[PaidOn],[PaymentStatus],[CreatedOn],[ModifiedOn],[InstallmentNo])
				 VALUES
					   (@paymentID,@insta3Amount,DATEADD(DAY,90,GETDATE()),NULL,@inst3Status,GETDATE(),GETDATE(),3)

		SELECT 
			@TotalPaid=SUM(t.TotalPaid),@TotalPending=SUM(t.TotalPending)  
			FROM (
					 SELECT 
						TotalPaid=CASE 
							WHEN pd.PaymentStatus =1 THEN ISNULL(pd.PaymentAmount,0) 
							ELSE 0	END ,
						TotalPending= CASE 
							WHEN pd.PaymentStatus =0 THEN ISNULL(pd.PaymentAmount,0)
							ELSE 0 END  
						 FROM PaymentDetails pd WHERE PaymentID=@paymentId
				) AS  t

		UPDATE Payment SET TotalPaid=@TotalPaid,TotalPending=@TotalPending,InstallmentAmount=(@insta1Amount+@insta2Amount+@insta3Amount),AdvanceAmount=@advAmount,ModifiedOn=GETDATE() WHERE PaymentID=@paymentId

		SELECT @paymentId AS paymentId
	END
END
' 
END
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](150) NOT NULL,
	[LastName] [varchar](150) NULL,
	[DOB] [date] NOT NULL,
	[Gender] [varchar](10) NOT NULL,
	[Aadhar] [varchar](100) NOT NULL,
	[Street] [varchar](max) NOT NULL,
	[City] [varchar](100) NOT NULL,
	[PostCode] [varchar](10) NOT NULL,
	[State] [varchar](100) NOT NULL,
	[MobileNumber] [varchar](15) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
	[ConsumerNo] [int] NULL,
 CONSTRAINT [CustomerID] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MessageLog]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MessageLog](
	[MessageLogId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ActualMessage] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[TemplateCode] [varchar](10) NULL,
 CONSTRAINT [MessageLogId] PRIMARY KEY CLUSTERED 
(
	[MessageLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MessageTemplate]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageTemplate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MessageTemplate](
	[TemplateID] [int] IDENTITY(1,1) NOT NULL,
	[TemplateCode] [varchar](10) NOT NULL,
	[TemplateDesc] [varchar](50) NULL,
	[ActualMesage] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [TemplateID] PRIMARY KEY CLUSTERED 
(
	[TemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[InstallmentAmount] [decimal](18, 2) NULL,
	[TotalPaid] [decimal](18, 2) NULL,
	[TotalPending] [decimal](18, 2) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
	[AdvanceAmount] [decimal](18, 2) NULL,
 CONSTRAINT [PaymentID] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PaymentDetails]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentDetails](
	[PaymentDetail_ID] [int] IDENTITY(1,1) NOT NULL,
	[PaymentID] [int] NOT NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[DueDate] [date] NULL,
	[PaidOn] [date] NULL,
	[PaymentStatus] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
	[InstallmentNo] [int] NULL,
 CONSTRAINT [PaymentDetail_ID] PRIMARY KEY CLUSTERED 
(
	[PaymentDetail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[SettingsMaster]    Script Date: 21-02-2019 22:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SettingsMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SettingsMaster](
	[SettingsId] [int] IDENTITY(1,1) NOT NULL,
	[SettingsName] [varchar](50) NOT NULL,
	[SettingsValue] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SettingsMaster] PRIMARY KEY CLUSTERED 
(
	[SettingsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Customer] ON 

GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (1, N'abdul', N'khadar', CAST(0x94140B00 AS Date), N'Male', N'1234 5678 9012 ', N'kaniyam parampil house', N'kayamkulam', N'690502', N'kerala', N'8907970870', CAST(0x0000A9AB017F8754 AS DateTime), CAST(0x0000A9D50164E946 AS DateTime), 123456)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (2, N'rahul', N'asokan', CAST(0x2C250B00 AS Date), N'Male', N'4444 4444 4444', N'vadakkanchery', N'thrissur', N'698475', N'kerala', N'9895959598', CAST(0x0000A9AD016A5AF0 AS DateTime), CAST(0x0000A9D10171344E AS DateTime), NULL)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (3, N'Mohammed', N'Mussamil', CAST(0x58160B00 AS Date), N'Male', N'1111 2222 3333', N'thiroor', N'malappuram', N'689689', N'kerala', N'7805780511', CAST(0x0000A9AD016A5AF1 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (4, N'Geordin', N'thomas', CAST(0x8C070B00 AS Date), N'Male', N'7485 1025 7777', N'Muvattupuzha', N'Ernakulam', N'680147', N'kerala', N'9955889944', CAST(0x0000A9AD016A5AF2 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (5, N'vahab', N'ca', CAST(0x0F3F0B00 AS Date), N'Male', N'1234 5678 9012 ', N'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq', N'ernakulsm', N'789456', N'kerala', N'1234567890', CAST(0x0000A9AE0166BB26 AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (6, N'fousiya', N'afsal', CAST(0x8E280B00 AS Date), N'Female', N'1112 2222 4443 ', N'kaniyam para,pil', N'kollam ', N'690502', N'kerala', N'8907970870', CAST(0x0000A9B10119D44C AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (7, N'Fousiya', N'Afsal', CAST(0x8A160B00 AS Date), N'Female', N'1234 5678 9012 ', N'Faisal nivas,Pazhyattinkuzy', N'Kollam', N'658254', N'Kerala', N'1234567890', CAST(0x0000A9B400000000 AS DateTime), NULL, 0)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (8, N'Shareef', N'Thayyib', CAST(0x37C70A00 AS Date), N'Male', N'1212 3232 3233 ', N'Kaniyam parampil house near fish market kayamkulam', N'kaymkuam', N'658958', N'kerala', N'1234567890', CAST(0x0000A9C400000000 AS DateTime), CAST(0x0000A9D10170C037 AS DateTime), 0)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [DOB], [Gender], [Aadhar], [Street], [City], [PostCode], [State], [MobileNumber], [CreatedOn], [ModifiedOn], [ConsumerNo]) VALUES (9, N'hari', N'krishnan', CAST(0x60EF0A00 AS Date), N'Male', N'7777 8888 9999 ', N'prem nivas kaitholil', N'kayamkulam', N'690502', N'kerala', N'8989898989', CAST(0x0000A9FA00000000 AS DateTime), CAST(0x0000A9FA01754865 AS DateTime), 123456)
GO
SET IDENTITY_INSERT [dbo].[Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[MessageTemplate] ON 

GO
INSERT [dbo].[MessageTemplate] ([TemplateID], [TemplateCode], [TemplateDesc], [ActualMesage], [IsActive]) VALUES (1, N'APPSUB', N'Application Submission Message', N'Dear Customer,
Info from HP Gas Services:
Your application for Gas Connection has Approved.
Thank You.', 1)
GO
INSERT [dbo].[MessageTemplate] ([TemplateID], [TemplateCode], [TemplateDesc], [ActualMesage], [IsActive]) VALUES (2, N'ADVMSG', N'Advance Amount Message Template', N'Dear Customer,
Info from HP Gas Services:
Your Advance amount Rs.$$Amount$$ has been received
Thank You.', 1)
GO
INSERT [dbo].[MessageTemplate] ([TemplateID], [TemplateCode], [TemplateDesc], [ActualMesage], [IsActive]) VALUES (3, N'INST1', N'Settlement 1 message Template', N'Dear Customer,
Info from HP Gas Services:
Your 1st settlement amount of Rs.$$Amount will be collected on $$date.
Thank You.', 1)
GO
INSERT [dbo].[MessageTemplate] ([TemplateID], [TemplateCode], [TemplateDesc], [ActualMesage], [IsActive]) VALUES (4, N'INST2', N'Settlement 2 message Template', N'Dear Customer,
Info from HP Gas Services:
Your 2nd settlement amount of Rs.$$Amount will be collected on $$date.
Thank You.', 1)
GO
INSERT [dbo].[MessageTemplate] ([TemplateID], [TemplateCode], [TemplateDesc], [ActualMesage], [IsActive]) VALUES (5, N'INST3', N'Settlement 3 message Template', N'Dear Customer,
Info from HP Gas Services:
Your 3rd settlement amount of Rs.$$Amount will be collected on $$date.
Thank You.', 1)
GO
SET IDENTITY_INSERT [dbo].[MessageTemplate] OFF
GO
SET IDENTITY_INSERT [dbo].[Payment] ON 

GO
INSERT [dbo].[Payment] ([PaymentID], [CustomerID], [InstallmentAmount], [TotalPaid], [TotalPending], [CreatedOn], [ModifiedOn], [AdvanceAmount]) VALUES (1, 7, CAST(3000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x0000A9B400000000 AS DateTime), CAST(0x0000A9B4017089BA AS DateTime), CAST(3000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[Payment] ([PaymentID], [CustomerID], [InstallmentAmount], [TotalPaid], [TotalPending], [CreatedOn], [ModifiedOn], [AdvanceAmount]) VALUES (2, 8, CAST(3900.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x0000A9C400000000 AS DateTime), CAST(0x0000A9C400075716 AS DateTime), CAST(3000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[Payment] ([PaymentID], [CustomerID], [InstallmentAmount], [TotalPaid], [TotalPending], [CreatedOn], [ModifiedOn], [AdvanceAmount]) VALUES (3, 1, CAST(2400.00 AS Decimal(18, 2)), CAST(5300.00 AS Decimal(18, 2)), CAST(1600.00 AS Decimal(18, 2)), CAST(0x0000A9D0017D22A9 AS DateTime), NULL, CAST(4500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[Payment] ([PaymentID], [CustomerID], [InstallmentAmount], [TotalPaid], [TotalPending], [CreatedOn], [ModifiedOn], [AdvanceAmount]) VALUES (4, 2, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x0000A9D10171346D AS DateTime), NULL, CAST(0.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[Payment] ([PaymentID], [CustomerID], [InstallmentAmount], [TotalPaid], [TotalPending], [CreatedOn], [ModifiedOn], [AdvanceAmount]) VALUES (5, 9, CAST(2901.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(6901.00 AS Decimal(18, 2)), CAST(0x0000A9FA00000000 AS DateTime), CAST(0x0000A9FA017548A8 AS DateTime), CAST(4000.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[Payment] OFF
GO
SET IDENTITY_INSERT [dbo].[PaymentDetails] ON 

GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (1, 1, CAST(3000.00 AS Decimal(18, 2)), NULL, NULL, 1, CAST(0x0000A9B4017089BC AS DateTime), CAST(0x0000A9B4017089BC AS DateTime), 0)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (2, 1, CAST(1000.00 AS Decimal(18, 2)), NULL, NULL, 1, CAST(0x0000A9B4017089BC AS DateTime), CAST(0x0000A9B4017089BC AS DateTime), 1)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (3, 1, CAST(1000.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9B4017089BC AS DateTime), CAST(0x0000A9B4017089BC AS DateTime), 2)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (4, 1, CAST(1000.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9B4017089BC AS DateTime), CAST(0x0000A9B4017089BC AS DateTime), 3)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (5, 2, CAST(3000.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9C400075716 AS DateTime), CAST(0x0000A9D10170C042 AS DateTime), 0)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (6, 2, CAST(1300.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9C40007571C AS DateTime), CAST(0x0000A9D10170C043 AS DateTime), 1)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (7, 2, CAST(1300.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9C40007571C AS DateTime), CAST(0x0000A9D10170C043 AS DateTime), 2)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (8, 2, CAST(1300.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9C40007571C AS DateTime), CAST(0x0000A9D10170C043 AS DateTime), 3)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (9, 3, CAST(4500.00 AS Decimal(18, 2)), NULL, NULL, 1, CAST(0x0000A9D0017D22C8 AS DateTime), CAST(0x0000A9D50164E951 AS DateTime), 0)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (10, 3, CAST(800.00 AS Decimal(18, 2)), NULL, NULL, 1, CAST(0x0000A9D0017D22CA AS DateTime), CAST(0x0000A9D50164E952 AS DateTime), 1)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (11, 3, CAST(800.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9D0017D22CA AS DateTime), CAST(0x0000A9D50164E952 AS DateTime), 2)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (12, 3, CAST(800.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9D0017D22CA AS DateTime), CAST(0x0000A9D50164E952 AS DateTime), 3)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (13, 4, CAST(0.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9D10171346D AS DateTime), CAST(0x0000A9D10171346D AS DateTime), 0)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (14, 4, CAST(0.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9D10171346E AS DateTime), CAST(0x0000A9D10171346E AS DateTime), 1)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (15, 4, CAST(0.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9D10171346E AS DateTime), CAST(0x0000A9D10171346E AS DateTime), 2)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (16, 4, CAST(0.00 AS Decimal(18, 2)), NULL, NULL, 0, CAST(0x0000A9D10171346E AS DateTime), CAST(0x0000A9D10171346E AS DateTime), 3)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (17, 5, CAST(4000.00 AS Decimal(18, 2)), CAST(0x553F0B00 AS Date), NULL, 0, CAST(0x0000A9FA015B00A5 AS DateTime), CAST(0x0000A9FA017548A8 AS DateTime), 0)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (18, 5, CAST(967.00 AS Decimal(18, 2)), CAST(0x733F0B00 AS Date), NULL, 0, CAST(0x0000A9FA015B00A5 AS DateTime), CAST(0x0000A9FA017548A8 AS DateTime), 1)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (19, 5, CAST(967.00 AS Decimal(18, 2)), CAST(0x913F0B00 AS Date), NULL, 0, CAST(0x0000A9FA015B00A5 AS DateTime), CAST(0x0000A9FA017548A8 AS DateTime), 2)
GO
INSERT [dbo].[PaymentDetails] ([PaymentDetail_ID], [PaymentID], [PaymentAmount], [DueDate], [PaidOn], [PaymentStatus], [CreatedOn], [ModifiedOn], [InstallmentNo]) VALUES (20, 5, CAST(967.00 AS Decimal(18, 2)), CAST(0xAF3F0B00 AS Date), NULL, 0, CAST(0x0000A9FA015B00A5 AS DateTime), CAST(0x0000A9FA017548A8 AS DateTime), 3)
GO
SET IDENTITY_INSERT [dbo].[PaymentDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[SettingsMaster] ON 

GO
INSERT [dbo].[SettingsMaster] ([SettingsId], [SettingsName], [SettingsValue], [IsActive]) VALUES (1, N'TotalConnectionAmount', N'6900', 1)
GO
SET IDENTITY_INSERT [dbo].[SettingsMaster] OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UC_TemplateCode]    Script Date: 21-02-2019 22:28:06 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MessageTemplate]') AND name = N'UC_TemplateCode')
ALTER TABLE [dbo].[MessageTemplate] ADD  CONSTRAINT [UC_TemplateCode] UNIQUE NONCLUSTERED 
(
	[TemplateCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
