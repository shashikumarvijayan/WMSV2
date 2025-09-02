-- Stored procedures for Customer and ProductInfo tables

/****** Object:  StoredProcedure [MES].[sp_CustomerMaster] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [MES].[sp_CustomerMaster]
    @Action NVARCHAR(20),
    @CId INT = 0,
    @CustomerSap NVARCHAR(64) = NULL,
    @CustomerName NVARCHAR(200) = NULL,
    @Customer_Address NVARCHAR(500) = NULL,
    @Label_Format NVARCHAR(32) = NULL,
    @Status NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @Action = 'GetAll'
    BEGIN
        SELECT CId, CustomerSap, CustomerName, Customer_Address, Label_Format, Status
        FROM dbo.Customer
        WHERE ISNULL(Status,'Active') <> 'Inactive';
        RETURN;
    END

    IF @Action = 'GetById'
    BEGIN
        SELECT CId, CustomerSap, CustomerName, Customer_Address, Label_Format, Status
        FROM dbo.Customer
        WHERE CId = @CId;
        RETURN;
    END

    IF @Action = 'GetDeleted'
    BEGIN
        SELECT CId, CustomerSap, CustomerName, Customer_Address, Label_Format, Status
        FROM dbo.Customer
        WHERE Status = 'Inactive';
        RETURN;
    END

    IF @Action = 'Undo'
    BEGIN
        UPDATE dbo.Customer
        SET Status = 'Active', WhoUnDelete = SYSTEM_USER, DateDataUnDelete = SYSUTCDATETIME()
        WHERE CId = @CId;
        RETURN;
    END

    IF @Action = 'Save'
    BEGIN
        IF @CId = 0
        BEGIN
            INSERT INTO dbo.Customer (CustomerSap, CustomerName, Customer_Address, Label_Format, Status, WhoCreated, DateDataCreated)
            VALUES (@CustomerSap, @CustomerName, @Customer_Address, @Label_Format, @Status, SYSTEM_USER, SYSUTCDATETIME());
            SET @CId = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE dbo.Customer
            SET CustomerSap = @CustomerSap,
                CustomerName = @CustomerName,
                Customer_Address = @Customer_Address,
                Label_Format = @Label_Format,
                Status = @Status,
                WhoEdited = SYSTEM_USER,
                DateDataEdited = SYSUTCDATETIME()
            WHERE CId = @CId;
        END
        SELECT @CId AS CId;
        RETURN;
    END

    IF @Action = 'Delete'
    BEGIN
        UPDATE dbo.Customer
        SET Status = 'Inactive', WhoDeleted = SYSTEM_USER, DateDataDelete = SYSUTCDATETIME()
        WHERE CId = @CId;
        RETURN;
    END
END
GO

/****** Object:  StoredProcedure [MES].[sp_ProductInfoMaster] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [MES].[sp_ProductInfoMaster]
    @Action NVARCHAR(20),
    @FG_Id INT = 0,
    @FG_SAP_No NVARCHAR(64) = NULL,
    @SAP_FG_Description NVARCHAR(300) = NULL,
    @Product_No NVARCHAR(64) = NULL,
    @Product_Name NVARCHAR(200) = NULL,
    @Status NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @Action = 'GetAll'
    BEGIN
        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Product_No, Product_Name, Status
        FROM dbo.ProductInfo
        WHERE ISNULL(Status,'Active') <> 'Inactive';
        RETURN;
    END

    IF @Action = 'GetById'
    BEGIN
        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Product_No, Product_Name, Status
        FROM dbo.ProductInfo
        WHERE FG_Id = @FG_Id;
        RETURN;
    END

    IF @Action = 'GetDeleted'
    BEGIN
        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Product_No, Product_Name, Status
        FROM dbo.ProductInfo
        WHERE Status = 'Inactive';
        RETURN;
    END

    IF @Action = 'Undo'
    BEGIN
        UPDATE dbo.ProductInfo
        SET Status = 'Active', WhoUnDelete = SYSTEM_USER, DateDataUnDelete = SYSUTCDATETIME()
        WHERE FG_Id = @FG_Id;
        RETURN;
    END

    IF @Action = 'Save'
    BEGIN
        IF @FG_Id = 0
        BEGIN
            INSERT INTO dbo.ProductInfo (FG_SAP_No, SAP_FG_Description, Product_No, Product_Name, Status, WhoCreated, DateDataCreated)
            VALUES (@FG_SAP_No, @SAP_FG_Description, @Product_No, @Product_Name, @Status, SYSTEM_USER, SYSUTCDATETIME());
            SET @FG_Id = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE dbo.ProductInfo
            SET FG_SAP_No = @FG_SAP_No,
                SAP_FG_Description = @SAP_FG_Description,
                Product_No = @Product_No,
                Product_Name = @Product_Name,
                Status = @Status,
                WhoEdited = SYSTEM_USER,
                DateDataEdited = SYSUTCDATETIME()
            WHERE FG_Id = @FG_Id;
        END
        SELECT @FG_Id AS FG_Id;
        RETURN;
    END

    IF @Action = 'Delete'
    BEGIN
        UPDATE dbo.ProductInfo
        SET Status = 'Inactive', WhoDeleted = SYSTEM_USER, DateDataDelete = SYSUTCDATETIME()
        WHERE FG_Id = @FG_Id;
        RETURN;
    END
END
GO
