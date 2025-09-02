<%@ Page Title="" Language="C#" MasterPageFile="~/Sub.Master" AutoEventWireup="true" CodeBehind="002ProductInfo.aspx.cs" Inherits="WMSJJPV_V2._002ProductInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="WebserviceJSCS/jquery-1.7.js"></script>
    <link href="DataTable/CSS/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="DataTable/JS/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        function clearModal() {
            $('#ProductIdHidden').val('');
            $('#FGSapInput').val('');
            $('#FGDescInput').val('');
            $('#CustomerSapInput').val('');
            $('#CustomerNameInput').val('');
            $('#CustomerAddressInput').val('');
            $('#ProductNoInput').val('');
            $('#ProductNameInput').val('');
            $('#SupplierNameInput').val('');
            $('#SupplierAddressInput').val('');
            $('#ModelInput').val('');
            $('#DrawingRevInput').val('');
            $('#COInput').val('');
            $('#ImporterInput').val('');
            $('#AddressInput').val('');
            $('#CavityInput').val('');
            $('#JJCodeInput').val('');
            $('#DieLineInput').val('');
            $('#QtyPerPackingInput').val('');
            $('#UOMInput').val('');
            $('#MinQtyInput').val('');
            $('#MaxQtyInput').val('');
            $('#DefaultSLocInput').val('');
            $('#DivisionInput').val('');
            $('#LabelFormatInput').val('');
            $('#StatusInput').val('Active');
            $('#BomNeededInput').val('0');
            $('#DefaultInput').val('0');
            $('#BrotherSlocInput').val('');
            $('#QtyPerPalletInput').val('');
            $('#ProductStatusInput').val('Active');

        }
        function editProduct(id) {
            $.ajax({
                type: 'POST',
                url: '002ProductInfo.aspx/ProductInfoMaster',
                data: JSON.stringify({ action: 'GetById', product: { FG_Id: id } }),
                contentType: 'application/json; charset=utf-8',
                success: function (res) {
                    var arr = JSON.parse(res.d);
                    if (!arr || !arr.length) { new swal('Not found', 'Product not found', 'warning'); return; }
                    var p = arr[0];
                    $('#ProductIdHidden').val(p.FG_Id);
                    $('#FGSapInput').val(p.FG_SAP_No);
                    $('#FGDescInput').val(p.SAP_FG_Description);
                    $('#CustomerSapInput').val(p.Customer_Sap);
                    $('#CustomerNameInput').val(p.Customer_Name);
                    $('#CustomerAddressInput').val(p.Customer_Address);
                    $('#ProductNoInput').val(p.Product_No);
                    $('#ProductNameInput').val(p.Product_Name);
                    $('#SupplierNameInput').val(p.Supplier_Name);
                    $('#SupplierAddressInput').val(p.Supplier_Address);
                    $('#ModelInput').val(p.Model);
                    $('#DrawingRevInput').val(p.Drawing_Rev);
                    $('#COInput').val(p.CO);
                    $('#ImporterInput').val(p.Importer);
                    $('#AddressInput').val(p.Address);
                    $('#CavityInput').val(p.Cavity);
                    $('#JJCodeInput').val(p.JJ_Code);
                    $('#DieLineInput').val(p.Die_Line);
                    $('#QtyPerPackingInput').val(p.Qty_Per_Packing);
                    $('#UOMInput').val(p.UOM);
                    $('#MinQtyInput').val(p.Min_Qty);
                    $('#MaxQtyInput').val(p.Max_Qty);
                    $('#DefaultSLocInput').val(p.Default_Storage_Location);
                    $('#DivisionInput').val(p.Division);
                    $('#LabelFormatInput').val(p.Label_Format);
                    $('#StatusInput').val(p.Status);
                    $('#BomNeededInput').val(p.BomNeeded);
                    $('#DefaultInput').val(p.Default);
                    $('#BrotherSlocInput').val(p.BrotherSloc);
                    $('#QtyPerPalletInput').val(p.QtyPerPallet);
                    $('#ProductStatusInput').val(p.Status);
                    $('#productModal').modal('show');
                },
                error: function () { new swal('Error', 'Failed to load product', 'error'); }
            });
        }
        function deleteProduct(id) {
            $.ajax({
                type: 'POST',
                url: '002ProductInfo.aspx/ProductInfoMaster',
                data: JSON.stringify({ action: 'Delete', product: { FG_Id: id } }),
                contentType: 'application/json; charset=utf-8',
                success: function () { $('#tblProducts').DataTable().ajax.reload(null, false); new swal('Deleted', 'Product deleted', 'success'); },
                error: function () { new swal('Error', 'Failed to delete product', 'error'); }
            });
        }
        $(document).ready(function () {
            var table = $('#tblProducts').DataTable({
                "ajax": {
                    "url": "002ProductInfo.aspx/ProductInfoMaster",
                    "type": "POST",
                    "contentType": "application/json; charset=utf-8",
                    "data": function () { return JSON.stringify({ action: 'GetAll', product: {} }); },
                    "dataSrc": function (json) { return JSON.parse(json.d); }
                },
                "scrollX": true,

                "columns": [
                    { "data": "FG_Id" },
                    { "data": "FG_SAP_No" },
                    { "data": "SAP_FG_Description" },
                    { "data": "Customer_Sap" },
                    { "data": "Customer_Name" },
                    { "data": "Customer_Address" },
                    { "data": "Product_No" },
                    { "data": "Product_Name" },
                    { "data": "Supplier_Name" },
                    { "data": "Supplier_Address" },
                    { "data": "Model" },
                    { "data": "Drawing_Rev" },
                    { "data": "CO" },
                    { "data": "Importer" },
                    { "data": "Address" },
                    { "data": "Cavity" },
                    { "data": "JJ_Code" },
                    { "data": "Die_Line" },
                    { "data": "Qty_Per_Packing" },
                    { "data": "UOM" },
                    { "data": "Min_Qty" },
                    { "data": "Max_Qty" },
                    { "data": "Default_Storage_Location" },
                    { "data": "Division" },
                    { "data": "Label_Format" },
                    { "data": "Status" },
                    { "data": "BomNeeded" },
                    { "data": "Default" },
                    { "data": "BrotherSloc" },
                    { "data": "QtyPerPallet" },
                    { "data": "Status" },
                    { "data": "FG_Id", "render": function (id) { return '<a class="btn btn-info btn-edit" data-id="' + id + '">Edit</a>'; } },
                    { "data": "FG_Id", "render": function (id) { return '<a class="btn btn-info btn-delete" data-id="' + id + '">Delete</a>'; } }
                ]
            });
            $('#btnAddProduct').attr('type', 'button').click(function (e) { e.preventDefault(); clearModal(); $('#productModal').modal('show'); });
            $(document).on('click', '.btn-edit', function (e) { e.preventDefault(); editProduct($(this).data('id')); });
            $(document).on('click', '.btn-delete', function (e) { e.preventDefault(); deleteProduct($(this).data('id')); });
            $('#SaveProductBtn').attr('type', 'button').click(function (e) {
                e.preventDefault();
                var product = {
                    FG_Id: parseInt($('#ProductIdHidden').val() || '0', 10),
                    FG_SAP_No: $('#FGSapInput').val(),
                    SAP_FG_Description: $('#FGDescInput').val(),
                    Customer_Sap: $('#CustomerSapInput').val(),
                    Customer_Name: $('#CustomerNameInput').val(),
                    Customer_Address: $('#CustomerAddressInput').val(),
                    Product_No: $('#ProductNoInput').val(),
                    Product_Name: $('#ProductNameInput').val(),
                    Supplier_Name: $('#SupplierNameInput').val(),
                    Supplier_Address: $('#SupplierAddressInput').val(),
                    Model: $('#ModelInput').val(),
                    Drawing_Rev: $('#DrawingRevInput').val(),
                    CO: $('#COInput').val(),
                    Importer: $('#ImporterInput').val(),
                    Address: $('#AddressInput').val(),
                    Cavity: $('#CavityInput').val(),
                    JJ_Code: $('#JJCodeInput').val(),
                    Die_Line: $('#DieLineInput').val(),
                    Qty_Per_Packing: parseFloat($('#QtyPerPackingInput').val() || '0'),
                    UOM: $('#UOMInput').val(),
                    Min_Qty: parseFloat($('#MinQtyInput').val() || '0'),
                    Max_Qty: parseFloat($('#MaxQtyInput').val() || '0'),
                    Default_Storage_Location: $('#DefaultSLocInput').val(),
                    Division: $('#DivisionInput').val(),
                    Label_Format: $('#LabelFormatInput').val(),
                    Status: $('#StatusInput').val(),
                    BomNeeded: parseInt($('#BomNeededInput').val() || '0', 10),
                    Default: parseInt($('#DefaultInput').val() || '0', 10),
                    BrotherSloc: $('#BrotherSlocInput').val(),
                    QtyPerPallet: parseFloat($('#QtyPerPalletInput').val() || '0')
                    Status: $('#ProductStatusInput').val()
                };
                $.ajax({
                    type: 'POST',
                    url: '002ProductInfo.aspx/ProductInfoMaster',
                    data: JSON.stringify({ action: 'Save', product: product }),
                    contentType: 'application/json; charset=utf-8',
                    success: function () { $('#productModal').modal('hide'); $('#tblProducts').DataTable().ajax.reload(null, false); new swal('Saved', 'Product saved', 'success'); },
                    error: function () { new swal('Error', 'Failed to save product', 'error'); }
                });
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="container-fluid">
     <div class="container">
        <div style="text-align: center;"><h1>Product Information</h1></div>
        <br />
        <div class="row">
            <div class="col-md-3"><button id="btnAddProduct" class="badge badge-success btn-block" style="margin-top: 15px; font-size: medium;">Add Product</button></div>
        </div>
     </div>
     <div class="container-fluid" style="margin-top: 10px; margin-bottom: 30px;">
        <div class="row"><div class="col-md-12">
          <table id="tblProducts" class="table table-bordered table-striped">
            <thead>
              <tr>
                <th>ID</th>
                <th>SAP</th>
                <th>Description</th>
                <th>Customer SAP</th>
                <th>Customer Name</th>
                <th>Customer Address</th>
                <th>Product No</th>
                <th>Product Name</th>
                <th>Supplier Name</th>
                <th>Supplier Address</th>
                <th>Model</th>
                <th>Drawing Rev</th>
                <th>CO</th>
                <th>Importer</th>
                <th>Address</th>
                <th>Cavity</th>
                <th>JJ Code</th>
                <th>Die Line</th>
                <th>Qty/Packing</th>
                <th>UOM</th>
                <th>Min Qty</th>
                <th>Max Qty</th>
                <th>Default SLoc</th>
                <th>Division</th>
                <th>Label Format</th>
                <th>Status</th>
                <th>BOM Needed</th>
                <th>Default</th>
                <th>Brother SLoc</th>
                <th>Qty/Pallet</th>
                <th>FG SAP No</th>
                <th>Description</th>
                <th>Customer SAP</th>
                <th>Status</th>
                <th>Edit</th>
                <th>Delete</th>
              </tr>
            </thead>
          </table>
        </div></div>
     </div>
   </div>
   <div class="modal fade" id="productModal" tabindex="-1" role="dialog" aria-hidden="true">
     <div class="modal-dialog" role="document">
       <div class="modal-content">
         <div class="modal-header"><h5 class="modal-title">Product Details</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
         <div class="modal-body">
           <input type="hidden" id="ProductIdHidden" />
           <div class="form-group"><label for="FGSapInput">SAP:</label><input type="text" class="form-control" id="FGSapInput" required /></div>
           <div class="form-group"><label for="FGDescInput">Description:</label><input type="text" class="form-control" id="FGDescInput" /></div>
           <div class="form-group"><label for="CustomerSapInput">Customer SAP:</label><input type="text" class="form-control" id="CustomerSapInput" /></div>
           <div class="form-group"><label for="CustomerNameInput">Customer Name:</label><input type="text" class="form-control" id="CustomerNameInput" /></div>
           <div class="form-group"><label for="CustomerAddressInput">Customer Address:</label><input type="text" class="form-control" id="CustomerAddressInput" /></div>
           <div class="form-group"><label for="ProductNoInput">Product No:</label><input type="text" class="form-control" id="ProductNoInput" /></div>
           <div class="form-group"><label for="ProductNameInput">Product Name:</label><input type="text" class="form-control" id="ProductNameInput" /></div>
           <div class="form-group"><label for="SupplierNameInput">Supplier Name:</label><input type="text" class="form-control" id="SupplierNameInput" /></div>
           <div class="form-group"><label for="SupplierAddressInput">Supplier Address:</label><input type="text" class="form-control" id="SupplierAddressInput" /></div>
           <div class="form-group"><label for="ModelInput">Model:</label><input type="text" class="form-control" id="ModelInput" /></div>
           <div class="form-group"><label for="DrawingRevInput">Drawing Rev:</label><input type="text" class="form-control" id="DrawingRevInput" /></div>
           <div class="form-group"><label for="COInput">CO:</label><input type="text" class="form-control" id="COInput" /></div>
           <div class="form-group"><label for="ImporterInput">Importer:</label><input type="text" class="form-control" id="ImporterInput" /></div>
           <div class="form-group"><label for="AddressInput">Address:</label><input type="text" class="form-control" id="AddressInput" /></div>
           <div class="form-group"><label for="CavityInput">Cavity:</label><input type="text" class="form-control" id="CavityInput" /></div>
           <div class="form-group"><label for="JJCodeInput">JJ Code:</label><input type="text" class="form-control" id="JJCodeInput" /></div>
           <div class="form-group"><label for="DieLineInput">Die Line:</label><input type="text" class="form-control" id="DieLineInput" /></div>
           <div class="form-group"><label for="QtyPerPackingInput">Qty/Packing:</label><input type="number" step="any" class="form-control" id="QtyPerPackingInput" /></div>
           <div class="form-group"><label for="UOMInput">UOM:</label><input type="text" class="form-control" id="UOMInput" /></div>
           <div class="form-group"><label for="MinQtyInput">Min Qty:</label><input type="number" step="any" class="form-control" id="MinQtyInput" /></div>
           <div class="form-group"><label for="MaxQtyInput">Max Qty:</label><input type="number" step="any" class="form-control" id="MaxQtyInput" /></div>
           <div class="form-group"><label for="DefaultSLocInput">Default SLoc:</label><input type="text" class="form-control" id="DefaultSLocInput" /></div>
           <div class="form-group"><label for="DivisionInput">Division:</label><input type="text" class="form-control" id="DivisionInput" /></div>
           <div class="form-group"><label for="LabelFormatInput">Label Format:</label><input type="text" class="form-control" id="LabelFormatInput" /></div>
           <div class="form-group"><label for="StatusInput">Status:</label><select id="StatusInput" class="form-control"><option>Active</option><option>Inactive</option></select></div>
           <div class="form-group"><label for="BomNeededInput">BOM Needed:</label><select id="BomNeededInput" class="form-control"><option value="0">No</option><option value="1">Yes</option></select></div>
           <div class="form-group"><label for="DefaultInput">Default:</label><select id="DefaultInput" class="form-control"><option value="0">No</option><option value="1">Yes</option></select></div>
           <div class="form-group"><label for="BrotherSlocInput">Brother SLoc:</label><input type="text" class="form-control" id="BrotherSlocInput" /></div>
           <div class="form-group"><label for="QtyPerPalletInput">Qty/Pallet:</label><input type="number" step="any" class="form-control" id="QtyPerPalletInput" /></div>
           <div class="form-group"><label for="FGSapInput">FG SAP No:</label><input type="text" class="form-control" id="FGSapInput" required /></div>
           <div class="form-group"><label for="FGDescInput">Description:</label><input type="text" class="form-control" id="FGDescInput" /></div>
           <div class="form-group"><label for="CustomerSapInput">Customer SAP:</label><input type="text" class="form-control" id="CustomerSapInput" /></div>
           <div class="form-group"><label for="ProductStatusInput">Status:</label><select id="ProductStatusInput" class="form-control"><option>Active</option><option>Inactive</option></select></div>
         </div>
         <div class="modal-footer">
           <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
           <button type="button" class="btn btn-primary" id="SaveProductBtn">Save</button>
         </div>
       </div>
     </div>
   </div>
</asp:Content>
