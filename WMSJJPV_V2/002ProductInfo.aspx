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
                "columns": [
                    { "data": "FG_Id" },
                    { "data": "FG_SAP_No" },
                    { "data": "SAP_FG_Description" },
                    { "data": "Customer_Sap" },
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
