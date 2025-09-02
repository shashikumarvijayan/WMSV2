USE [MES_Master]
GO

IF OBJECT_ID('MES.sp_CustomerMaster','P') IS NOT NULL
    DROP PROCEDURE MES.sp_CustomerMaster
GO
CREATE PROCEDURE MES.sp_CustomerMaster
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
    IF @Action = 'GetAll'
    BEGIN
        SELECT CId, CustomerSap, CustomerName, Customer_Address, Label_Format, Status
        FROM dbo.Customer
        WHERE DateDataDelete IS NULL;
    END
    ELSE IF @Action = 'GetById'
    BEGIN
        SELECT CId, CustomerSap, CustomerName, Customer_Address, Label_Format, Status
        FROM dbo.Customer
        WHERE CId = @CId;
    END
    ELSE IF @Action = 'Save'
    BEGIN
        IF @CId = 0
        BEGIN
            INSERT INTO dbo.Customer(CustomerSap, CustomerName, Customer_Address, Label_Format, Status, DateDataCreated)
            VALUES(@CustomerSap, @CustomerName, @Customer_Address, @Label_Format, @Status, SYSUTCDATETIME());
        END
        ELSE
        BEGIN
            UPDATE dbo.Customer
            SET CustomerSap = @CustomerSap,
                CustomerName = @CustomerName,
                Customer_Address = @Customer_Address,
                Label_Format = @Label_Format,
                Status = @Status,
                DateDataEdited = SYSUTCDATETIME()
            WHERE CId = @CId;
        END
    END
    ELSE IF @Action = 'Delete'
    BEGIN
        UPDATE dbo.Customer SET DateDataDelete = SYSUTCDATETIME(), Status = 'Inactive' WHERE CId = @CId;
    END
    ELSE IF @Action = 'Undo'
    BEGIN
        UPDATE dbo.Customer SET DateDataDelete = NULL, Status = 'Active' WHERE CId = @CId;
    END
END
GO

IF OBJECT_ID('MES.sp_ProductInfoMaster','P') IS NOT NULL
    DROP PROCEDURE MES.sp_ProductInfoMaster
GO
CREATE PROCEDURE MES.sp_ProductInfoMaster
    @Action NVARCHAR(20),
    @FG_Id INT = 0,
    @FG_SAP_No NVARCHAR(64) = NULL,
    @SAP_FG_Description NVARCHAR(300) = NULL,
    @Customer_Sap NVARCHAR(64) = NULL,
    @Status NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'GetAll'
    BEGIN
        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Customer_Sap, Status
        FROM dbo.ProductInfo
        WHERE DateDataDelete IS NULL;
    END
    ELSE IF @Action = 'GetById'
    BEGIN
        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Customer_Sap, Status
        FROM dbo.ProductInfo
        WHERE FG_Id = @FG_Id;
    END
    ELSE IF @Action = 'Save'
    BEGIN
        IF @FG_Id = 0
        BEGIN
            INSERT INTO dbo.ProductInfo(FG_SAP_No, SAP_FG_Description, Customer_Sap, Status, DateDataCreated)
            VALUES(@FG_SAP_No, @SAP_FG_Description, @Customer_Sap, @Status, SYSUTCDATETIME());
        END
        ELSE
        BEGIN
            UPDATE dbo.ProductInfo
            SET FG_SAP_No = @FG_SAP_No,
                SAP_FG_Description = @SAP_FG_Description,
                Customer_Sap = @Customer_Sap,
                Status = @Status,
                DateDataEdited = SYSUTCDATETIME()
            WHERE FG_Id = @FG_Id;
        END
    END
    ELSE IF @Action = 'Delete'
    BEGIN
        UPDATE dbo.ProductInfo SET DateDataDelete = SYSUTCDATETIME(), Status = 'Inactive' WHERE FG_Id = @FG_Id;
    END
    ELSE IF @Action = 'Undo'
    BEGIN
        UPDATE dbo.ProductInfo SET DateDataDelete = NULL, Status = 'Active' WHERE FG_Id = @FG_Id;
    END
END
GO
