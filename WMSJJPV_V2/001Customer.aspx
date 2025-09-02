<%@ Page Title="" Language="C#" MasterPageFile="~/Sub.Master" AutoEventWireup="true" CodeBehind="001Customer.aspx.cs" Inherits="WMSJJPV_V2._001Customer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="WebserviceJSCS/jquery-1.7.js"></script>
    <link href="DataTable/CSS/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="DataTable/JS/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        function clearModal() {
            $('#CustomerIdHidden').val('');
            $('#CustomerSapInput').val('');
            $('#CustomerNameInput').val('');
            $('#AddressInput').val('');
            $('#LabelFormatInput').val('');
            $('#StatusInput').val('Active');
        }
        function editCustomer(id) {
            $.ajax({
                type: 'POST',
                url: '001Customer.aspx/CustomerMaster',
                data: JSON.stringify({ action: 'GetById', customer: { CId: id } }),
                contentType: 'application/json; charset=utf-8',
                success: function (res) {
                    var arr = JSON.parse(res.d);
                    if (!arr || !arr.length) {
                        new swal('Not found', 'Customer not found', 'warning');
                        return;
                    }
                    var c = arr[0];
                    $('#CustomerIdHidden').val(c.CId);
                    $('#CustomerSapInput').val(c.CustomerSap);
                    $('#CustomerNameInput').val(c.CustomerName);
                    $('#AddressInput').val(c.Customer_Address);
                    $('#LabelFormatInput').val(c.Label_Format);
                    $('#StatusInput').val(c.Status);
                    $('#customerModal').modal('show');
                },
                error: function () {
                    new swal('Error', 'Failed to load customer', 'error');
                }
            });
        }
        function deleteCustomer(id) {
            $.ajax({
                type: 'POST',
                url: '001Customer.aspx/CustomerMaster',
                data: JSON.stringify({ action: 'Delete', customer: { CId: id } }),
                contentType: 'application/json; charset=utf-8',
                success: function () {
                    $('#tblCustomers').DataTable().ajax.reload(null, false);
                    new swal('Deleted', 'Customer marked inactive', 'success');
                },
                error: function () {
                    new swal('Error', 'Failed to delete customer', 'error');
                }
            });
        }
        $(document).ready(function () {
            var table = $('#tblCustomers').DataTable({
                'ajax': {
                    'url': '001Customer.aspx/CustomerMaster',
                    'type': 'POST',
                    'contentType': 'application/json; charset=utf-8',
                    'data': function () { return JSON.stringify({ action: 'GetAll', customer: {} }); },
                    'dataSrc': function (json) { return JSON.parse(json.d); }
                },
                'columns': [
                    { 'data': 'CId' },
                    { 'data': 'CustomerSap' },
                    { 'data': 'CustomerName' },
                    { 'data': 'Customer_Address' },
                    { 'data': 'Label_Format' },
                    { 'data': 'Status' },
                    {
                        'data': 'CId', 'orderable': false, 'searchable': false,
                        'render': function (id) { return '<a class="btn btn-info btn-edit" data-id="' + id + '">Edit</a>'; }
                    },
                    {
                        'data': 'CId', 'orderable': false, 'searchable': false,
                        'render': function (id) { return '<a class="btn btn-info btn-delete" data-id="' + id + '">Delete</a>'; }
                    }
                ]
            });
            $('#btnAddCustomer').attr('type', 'button').click(function (e) {
                e.preventDefault();
                clearModal();
                $('#customerModal').modal('show');
            });
            $(document).on('click', '.btn-edit', function (e) {
                e.preventDefault();
                editCustomer($(this).data('id'));
            });
            $(document).on('click', '.btn-delete', function (e) {
                e.preventDefault();
                deleteCustomer($(this).data('id'));
            });
            $('#customerCancelBtn, #customerCloseTop').click(function (e) {
                e.preventDefault();
                $('#customerModal').modal('hide');
            });
            $('#SaveCustomerBtn').attr('type', 'button').click(function (e) {
                e.preventDefault();
                var cid = parseInt($('#CustomerIdHidden').val() || '0', 10);
                var customer = {
                    CId: cid,
                    CustomerSap: $('#CustomerSapInput').val(),
                    CustomerName: $('#CustomerNameInput').val(),
                    Address: $('#AddressInput').val(),
                    LabelFormat: $('#LabelFormatInput').val(),
                    Status: $('#StatusInput').val()
                };
                $.ajax({
                    type: 'POST',
                    url: '001Customer.aspx/CustomerMaster',
                    data: JSON.stringify({ action: 'Save', customer: customer }),
                    contentType: 'application/json; charset=utf-8',
                    success: function () {
                        $('#customerModal').modal('hide');
                        $('#tblCustomers').DataTable().ajax.reload(null, false);
                        new swal('Saved', 'Customer saved successfully', 'success');
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
                <h1>Customer Management</h1>
            </div>
            <br />
            <div class="row">
                <div class="col-md-3">
                    <button id="btnAddCustomer" type="button" class="badge badge-success btn-block" style="margin-top: 15px; font-size: medium;">Add Customer</button>
                </div>
            </div>
        </div>
        <div class="container-fluid" style="margin-top: 10px; margin-bottom: 30px;">
            <div class="row">
                <div class="col-md-12">
                    <table id="tblCustomers" class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>SAP</th>
                                <th>Name</th>
                                <th>Address</th>
                                <th>Label Format</th>
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

    <div class="modal fade" id="customerModal" tabindex="-1" role="dialog" aria-labelledby="customerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="customerModalLabel" style="font-size: 1.5em;">Customer Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="customerCloseTop">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="font-size: 1.2em;">
                    <input type="hidden" id="CustomerIdHidden" />
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="CustomerSapInput">SAP:</label>
                            <input type="text" class="form-control" id="CustomerSapInput" required>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="CustomerNameInput">Name:</label>
                            <input type="text" class="form-control" id="CustomerNameInput" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="AddressInput">Address:</label>
                            <input type="text" class="form-control" id="AddressInput">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="LabelFormatInput">Label Format:</label>
                            <input type="text" class="form-control" id="LabelFormatInput">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="StatusInput">Status:</label>
                            <select class="form-control" id="StatusInput">
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" id="customerCancelBtn">Cancel</button>
                    <button type="button" class="btn btn-primary" id="SaveCustomerBtn">Save</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
