-- Sample stored procedure with Azure SQL best practices
-- File: sql/procedures/usp_GetCustomerById.sql

USE [YourDatabase]
GO

-- Drop procedure if it exists
IF EXISTS (SELECT
    *
FROM
    sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetCustomerById]') AND type IN (N'P', N'PC'))
    DROP PROCEDURE [dbo].[usp_GetCustomerById]
GO

/*
================================================================================
Procedure Name: usp_GetCustomerById
Description:    Retrieves customer information by Customer ID
Author:         Azure SQL Development Team
Created Date:   2025-07-14
Version:        1.0

Parameters:
    @CustomerID     INT             Customer ID to retrieve
    @IncludeInactive BIT = 0        Include inactive customers (default: No)

Returns:
    Customer information record set

Example Usage:
    EXEC usp_GetCustomerById @CustomerID = 123
    EXEC usp_GetCustomerById @CustomerID = 123, @IncludeInactive = 1

Change History:
    Date        Author                  Description
    ----------  ----------------------  ----------------------------------------
    2025-07-14  Azure SQL Dev Team      Initial creation
================================================================================
*/

CREATE PROCEDURE [dbo].[usp_GetCustomerById]
    @CustomerID INT,
    @IncludeInactive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Input validation
    IF @CustomerID IS NULL OR @CustomerID <= 0
    BEGIN
        RAISERROR('Invalid CustomerID parameter. Must be a positive integer.', 16, 1);
        RETURN -1;
    END

    BEGIN TRY
        -- Main query with proper error handling
        SELECT
        c.CustomerID,
        c.CustomerCode,
        c.CompanyName,
        c.ContactFirstName,
        c.ContactLastName,
        c.Email,
        c.Phone,
        c.Address,
        c.City,
        c.StateProvince,
        c.PostalCode,
        c.Country,
        c.IsActive,
        c.CreatedDate,
        c.ModifiedDate,
        c.CreatedBy,
        c.ModifiedBy
    FROM
        dbo.Customers c WITH (READCOMMITTED)
    WHERE c.CustomerID = @CustomerID
        AND (c.IsActive = 1 OR @IncludeInactive = 1)
    OPTION
    (OPTIMIZE
    FOR
    (@CustomerID
    UNKNOWN));
        
        -- Return status
        IF @@ROWCOUNT = 0
        BEGIN
        RAISERROR('Customer not found with ID: %d', 16, 1, @CustomerID);
        RETURN -1;
    END
        
        RETURN 0; -- Success
        
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @ErrorProcedure NVARCHAR(128) = ISNULL(ERROR_PROCEDURE(), 'usp_GetCustomerById');
        DECLARE @ErrorLine INT = ERROR_LINE();
        
        -- Log error (in real implementation, log to error table)
        RAISERROR('Error in %s at line %d: %s', @ErrorSeverity, @ErrorState, 
                  @ErrorProcedure, @ErrorLine, @ErrorMessage);
        
        RETURN -1;
    END CATCH
END
GO

-- Grant execute permissions to appropriate roles
-- GRANT EXECUTE ON [dbo].[usp_GetCustomerById] TO [db_application_user]
-- GO
