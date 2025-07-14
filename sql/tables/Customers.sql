-- Sample table creation script with Azure SQL best practices
-- File: sql/tables/Customers.sql

USE [YourDatabase]
GO

-- Create Customers table with proper indexing and constraints
CREATE TABLE [dbo].[Customers]
(
    [CustomerID]       [INT]           IDENTITY(1,1) NOT NULL,
    [CustomerCode]     [NVARCHAR](20)  NOT NULL,
    [CompanyName]      [NVARCHAR](100) NOT NULL,
    [ContactFirstName] [NVARCHAR](50)  NULL,
    [ContactLastName]  [NVARCHAR](50)  NULL,
    [Email]            [NVARCHAR](100) NULL,
    [Phone]            [NVARCHAR](20)  NULL,
    [Address]          [NVARCHAR](255) NULL,
    [City]             [NVARCHAR](50)  NULL,
    [StateProvince]    [NVARCHAR](50)  NULL,
    [PostalCode]       [NVARCHAR](20)  NULL,
    [Country]          [NVARCHAR](50)  NULL,
    [IsActive]         [BIT]           NOT NULL DEFAULT 1,
    [CreatedDate]      [DATETIME2](7)  NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate]     [DATETIME2](7)  NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy]        [NVARCHAR](100) NOT NULL DEFAULT SUSER_SNAME(),
    [ModifiedBy]       [NVARCHAR](100) NOT NULL DEFAULT SUSER_SNAME(),

    -- Primary key constraint
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC),

    -- Unique constraints
    CONSTRAINT [UK_Customers_CustomerCode] UNIQUE NONCLUSTERED ([CustomerCode] ASC),
    CONSTRAINT [UK_Customers_Email] UNIQUE NONCLUSTERED ([Email] ASC),

    -- Check constraints
    CONSTRAINT [CK_Customers_Email] CHECK ([Email] LIKE '%_@_%.__%'),
    CONSTRAINT [CK_Customers_CustomerCode] CHECK (LEN([CustomerCode]) >= 3)
)
GO

-- Create non-clustered indexes for common queries
CREATE NONCLUSTERED INDEX [IX_Customers_CompanyName] 
ON [dbo].[Customers] ([CompanyName] ASC)
INCLUDE ([CustomerCode], [Email], [IsActive])
GO

CREATE NONCLUSTERED INDEX [IX_Customers_Location] 
ON [dbo].[Customers] ([Country] ASC, [StateProvince] ASC, [City] ASC)
WHERE [IsActive] = 1
GO

CREATE NONCLUSTERED INDEX [IX_Customers_CreatedDate] 
ON [dbo].[Customers] ([CreatedDate] ASC)
INCLUDE ([CustomerCode], [CompanyName], [IsActive])
GO

-- Add extended properties for documentation
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Customer master table containing all customer information', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'Customers'
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Unique identifier for each customer', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'Customers', 
    @level2type = N'COLUMN', @level2name = N'CustomerID'
GO
