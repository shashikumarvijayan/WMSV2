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

    @Customer_Name NVARCHAR(200) = NULL,
    @Customer_Address NVARCHAR(500) = NULL,
    @Product_No NVARCHAR(64) = NULL,
    @Product_Name NVARCHAR(200) = NULL,
    @Supplier_Name NVARCHAR(200) = NULL,
    @Supplier_Address NVARCHAR(500) = NULL,
    @Model NVARCHAR(100) = NULL,
    @Drawing_Rev NVARCHAR(50) = NULL,
    @CO NVARCHAR(100) = NULL,
    @Importer NVARCHAR(200) = NULL,
    @Address NVARCHAR(500) = NULL,
    @Cavity NVARCHAR(50) = NULL,
    @JJ_Code NVARCHAR(50) = NULL,
    @Die_Line NVARCHAR(50) = NULL,
    @Qty_Per_Packing DECIMAL(18,4) = NULL,
    @UOM NVARCHAR(16) = NULL,
    @Min_Qty DECIMAL(18,4) = NULL,
    @Max_Qty DECIMAL(18,4) = NULL,
    @Default_Storage_Location NVARCHAR(32) = NULL,
    @Division NVARCHAR(16) = NULL,
    @Label_Format NVARCHAR(32) = NULL,
    @Status NVARCHAR(50) = NULL,
    @BomNeeded BIT = NULL,
    @Default BIT = NULL,
    @BrotherSloc NVARCHAR(32) = NULL,
    @QtyPerPallet DECIMAL(18,4) = NULL

    @Status NVARCHAR(50) = NULL

AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'GetAll'
    BEGIN

        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Customer_Sap, Customer_Name, Customer_Address,
               Product_No, Product_Name, Supplier_Name, Supplier_Address, Model, Drawing_Rev, CO,
               Importer, Address, Cavity, JJ_Code, Die_Line, Qty_Per_Packing, UOM, Min_Qty, Max_Qty,
               Default_Storage_Location, Division, Label_Format, Status, BomNeeded, [Default],
               BrotherSloc, QtyPerPallet

        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Customer_Sap, Status
        FROM dbo.ProductInfo
        WHERE DateDataDelete IS NULL;
    END
    ELSE IF @Action = 'GetById'
    BEGIN

        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Customer_Sap, Customer_Name, Customer_Address,
               Product_No, Product_Name, Supplier_Name, Supplier_Address, Model, Drawing_Rev, CO,
               Importer, Address, Cavity, JJ_Code, Die_Line, Qty_Per_Packing, UOM, Min_Qty, Max_Qty,
               Default_Storage_Location, Division, Label_Format, Status, BomNeeded, [Default],
               BrotherSloc, QtyPerPallet

        SELECT FG_Id, FG_SAP_No, SAP_FG_Description, Customer_Sap, Status

        FROM dbo.ProductInfo
        WHERE FG_Id = @FG_Id;
    END
    ELSE IF @Action = 'Save'
    BEGIN
        IF @FG_Id = 0
        BEGIN

            INSERT INTO dbo.ProductInfo(FG_SAP_No, SAP_FG_Description, Customer_Sap, Customer_Name,
                                        Customer_Address, Product_No, Product_Name, Supplier_Name,
                                        Supplier_Address, Model, Drawing_Rev, CO, Importer, Address,
                                        Cavity, JJ_Code, Die_Line, Qty_Per_Packing, UOM, Min_Qty, Max_Qty,
                                        Default_Storage_Location, Division, Label_Format, Status, BomNeeded,
                                        [Default], BrotherSloc, QtyPerPallet, DateDataCreated)
            VALUES(@FG_SAP_No, @SAP_FG_Description, @Customer_Sap, @Customer_Name, @Customer_Address,
                   @Product_No, @Product_Name, @Supplier_Name, @Supplier_Address, @Model, @Drawing_Rev,
                   @CO, @Importer, @Address, @Cavity, @JJ_Code, @Die_Line, @Qty_Per_Packing, @UOM,
                   @Min_Qty, @Max_Qty, @Default_Storage_Location, @Division, @Label_Format, @Status,
                   @BomNeeded, @Default, @BrotherSloc, @QtyPerPallet, SYSUTCDATETIME());

            INSERT INTO dbo.ProductInfo(FG_SAP_No, SAP_FG_Description, Customer_Sap, Status, DateDataCreated)
            VALUES(@FG_SAP_No, @SAP_FG_Description, @Customer_Sap, @Status, SYSUTCDATETIME());

        END
        ELSE
        BEGIN
            UPDATE dbo.ProductInfo
            SET FG_SAP_No = @FG_SAP_No,
                SAP_FG_Description = @SAP_FG_Description,
                Customer_Sap = @Customer_Sap,

                Customer_Name = @Customer_Name,
                Customer_Address = @Customer_Address,
                Product_No = @Product_No,
                Product_Name = @Product_Name,
                Supplier_Name = @Supplier_Name,
                Supplier_Address = @Supplier_Address,
                Model = @Model,
                Drawing_Rev = @Drawing_Rev,
                CO = @CO,
                Importer = @Importer,
                Address = @Address,
                Cavity = @Cavity,
                JJ_Code = @JJ_Code,
                Die_Line = @Die_Line,
                Qty_Per_Packing = @Qty_Per_Packing,
                UOM = @UOM,
                Min_Qty = @Min_Qty,
                Max_Qty = @Max_Qty,
                Default_Storage_Location = @Default_Storage_Location,
                Division = @Division,
                Label_Format = @Label_Format,
                Status = @Status,
                BomNeeded = @BomNeeded,
                [Default] = @Default,
                BrotherSloc = @BrotherSloc,
                QtyPerPallet = @QtyPerPallet,

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
