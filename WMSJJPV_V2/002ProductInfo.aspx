<%@ Page Title="" Language="C#" MasterPageFile="~/Sub.Master" AutoEventWireup="true" CodeBehind="002ProductInfo.aspx.cs" Inherits="WMSJJPV_V2._002ProductInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="WebserviceJSCS/jquery-1.7.js"></script>
    <link href="DataTable/CSS/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="DataTable/JS/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        function clearModal() {
            $('#ProductIdHidden').val('');
            $('#SapInput').val('');
            $('#DescriptionInput').val('');
            $('#ProductNoInput').val('');
            $('#ProductNameInput').val('');
            $('#ProductStatusInput').val('Active');
        }

        function productDetailsHtml(data) {
            return `SAP No : ${data.FG_SAP_No}<br style='margin-bottom:10px;'>` +
                `Description : ${data.SAP_FG_Description}<br style='margin-bottom:10px;'>` +
                `Product No : ${data.Product_No}<br style='margin-bottom:10px;'>` +
                `Product Name : ${data.Product_Name}<br style='margin-bottom:10px;'>` +
                `Model : ${data.Model}<br style='margin-bottom:10px;'>` +
                `Drawing Rev : ${data.Drawing_Rev}<br style='margin-bottom:10px;'>` +
                `JJ Code : ${data.JJ_Code}<br style='margin-bottom:10px;'>` +
                `Cavity : ${data.Cavity}<br style='margin-bottom:10px;'>` +
                `Die Line : ${data.Die_Line}`;
        }

        function customerHtml(data) {
            return `Name : ${data.Customer_Name}<br style='margin-bottom:10px;'>` +
                `Address : ${data.Customer_Address}`;
        }

        function supplierHtml(data) {
            return `Name : ${data.Supplier_Name}<br style='margin-bottom:10px;'>` +
                `Address : ${data.Supplier_Address}<br style='margin-bottom:10px;'>` +
                `C/O : ${data.CO}<br style='margin-bottom:10px;'>` +
                `Importer : ${data.Importer}`;
        }

        function packagingHtml(row) {
            const fmt = v => v == null ? '' : parseFloat(v).toLocaleString();
            return `Qty / Packing : ${fmt(row.Qty_Per_Packing)}<br style='margin-bottom:10px;'>` +
                `UOM : ${row.UOM}<br style='margin-bottom:10px;'>` +
                `Min QTY : ${fmt(row.Min_Qty)}<br style='margin-bottom:10px;'>` +
                `Max QTY : ${fmt(row.Max_Qty)}<br style='margin-bottom:10px;'>` +
                `Default Storage Location : ${row.Default_Storage_Location}<br style='margin-bottom:10px;'>` +
                `Division : ${row.Division}<br style='margin-bottom:10px;'>` +
                `Label Format : ${row.Label_Format}<br style='margin-bottom:10px;'>` +
                `Brother Storage Location : ${row.BrotherSLOC}<br style='margin-bottom:10px;'>` +
                `Qty / Pallet : ${fmt(row.QtyPerPallet)}`;
        }
        function editProduct(id) {
            $.ajax({
                type: 'POST',
                url: '002ProductInfo.aspx/ProductInfoMaster',
                data: JSON.stringify({ action: 'GetById', product: { FG_Id: id } }),
                contentType: 'application/json; charset=utf-8',
                success: function (res) {
                    var arr = JSON.parse(res.d);
                    if (!arr || !arr.length) {
                        new swal('Not found', 'Product not found', 'warning');
                        return;
                    }
                    var p = arr[0];
                    $('#ProductIdHidden').val(p.FG_Id);
                    $('#SapInput').val(p.FG_SAP_No);
                    $('#DescriptionInput').val(p.SAP_FG_Description);
                    $('#ProductNoInput').val(p.Product_No);
                    $('#ProductNameInput').val(p.Product_Name);
                    $('#ProductStatusInput').val(p.Status);
                    $('#productModal').modal('show');
                },
                error: function () {
                    new swal('Error', 'Failed to load product', 'error');
                }
            });
        }
        function deleteProduct(id) {
            $.ajax({
                type: 'POST',
                url: '002ProductInfo.aspx/ProductInfoMaster',
                data: JSON.stringify({ action: 'Delete', product: { FG_Id: id } }),
                contentType: 'application/json; charset=utf-8',
                success: function () {
                    $('#tblProducts').DataTable().ajax.reload(null, false);
                    new swal('Deleted', 'Product marked inactive', 'success');
                },
                error: function () {
                    new swal('Error', 'Failed to delete product', 'error');
                }
            });
        }
        $(document).ready(function () {
            var table = $('#tblProducts').DataTable({
                ajax: {
                    url: '002ProductInfo.aspx/ProductInfoMaster',
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: function () { return JSON.stringify({ action: 'GetAll', product: {} }); },
                    dataSrc: function (json) { return JSON.parse(json.d); }
                },
                columns: [
                    { data: 'FG_Id' },
                    { data: null, render: productDetailsHtml, width: '400px' },
                    { data: null, render: customerHtml, width: '200px' },
                    { data: null, render: supplierHtml, width: '400px' },
                    { data: null, render: function (data, type, row) { return packagingHtml(row); } },
                    { data: 'Status' },
                    {
                        data: 'FG_Id', orderable: false, searchable: false,
                        render: function (id) { return '<a class="btn btn-info btn-edit" data-id="' + id + '">Edit</a>'; }
                    },
                    {
                        data: 'FG_Id', orderable: false, searchable: false,
                        render: function (id) { return '<a class="btn btn-info btn-delete" data-id="' + id + '">Delete</a>'; }
                    }
                ]
            });
            $('#btnAddProduct').attr('type', 'button').click(function (e) {
                e.preventDefault();
                clearModal();
                $('#productModal').modal('show');
            });
            $(document).on('click', '.btn-edit', function (e) {
                e.preventDefault();
                editProduct($(this).data('id'));
            });
            $(document).on('click', '.btn-delete', function (e) {
                e.preventDefault();
                deleteProduct($(this).data('id'));
            });
            $('#productCancelBtn, #productCloseTop').click(function (e) {
                e.preventDefault();
                $('#productModal').modal('hide');
            });
            $('#SaveProductBtn').attr('type', 'button').click(function (e) {
                e.preventDefault();
                var pid = parseInt($('#ProductIdHidden').val() || '0', 10);
                var product = {
                    FG_Id: pid,
                    FG_SAP_No: $('#SapInput').val(),
                    SAP_FG_Description: $('#DescriptionInput').val(),
                    Product_No: $('#ProductNoInput').val(),
                    Product_Name: $('#ProductNameInput').val(),
                    Status: $('#ProductStatusInput').val()
                };
                $.ajax({
                    type: 'POST',
                    url: '002ProductInfo.aspx/ProductInfoMaster',
                    data: JSON.stringify({ action: 'Save', product: product }),
                    contentType: 'application/json; charset=utf-8',
                    success: function () {
                        $('#productModal').modal('hide');
                        $('#tblProducts').DataTable().ajax.reload(null, false);
                        new swal('Saved', 'Product saved successfully', 'success');
                    },
                    error: function () {
                        new swal('Error', 'Save failed', 'error');
                    }
                });
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="container">
            <div style="text-align: center;">
                <h1>Product Information</h1>
            </div>
            <br />
            <div class="row">
                <div class="col-md-3">
                    <button id="btnAddProduct" type="button" class="badge badge-success btn-block" style="margin-top: 15px; font-size: medium;">Add Product</button>
                </div>
            </div>
        </div>
        <div class="container-fluid" style="margin-top: 10px; margin-bottom: 30px;">
            <div class="row">
                <div class="col-md-12">
                    <table id="tblProducts" class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>Product Details</th>
                                <th>Customer</th>
                                <th>Supplier</th>
                                <th>Packaging</th>
                                <th>Status</th>
                                <th style="text-align: center; width: 10px;">Edit</th>
                                <th style="text-align: center; width: 10px;">Delete</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="productModal" tabindex="-1" role="dialog" aria-labelledby="productModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productModalLabel" style="font-size: 1.5em;">Product Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="productCloseTop">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="font-size: 1.2em;">
                    <input type="hidden" id="ProductIdHidden" />
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="SapInput">SAP:</label>
                            <input type="text" class="form-control" id="SapInput" required>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="DescriptionInput">Description:</label>
                            <input type="text" class="form-control" id="DescriptionInput">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="ProductNoInput">Product No:</label>
                            <input type="text" class="form-control" id="ProductNoInput">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="ProductNameInput">Product Name:</label>
                            <input type="text" class="form-control" id="ProductNameInput">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="ProductStatusInput">Status:</label>
                            <select class="form-control" id="ProductStatusInput">
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" id="productCancelBtn">Cancel</button>
                    <button type="button" class="btn btn-primary" id="SaveProductBtn">Save</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
