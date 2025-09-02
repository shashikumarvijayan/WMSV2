<%@ Page Title="" Language="C#" MasterPageFile="~/Sub.Master" AutoEventWireup="true" CodeBehind="000UserMaster.aspx.cs" Inherits="WMSJJPV_V2._000UserMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- jQuery + DataTables (use your existing local copies as shown) -->
    <script src="WebserviceJSCS/jquery-1.7.js"></script>
    <link href="DataTable/CSS/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="DataTable/JS/jquery.dataTables.min.js"></script>


    <script type="text/javascript">
        var featuresLoaded = false;

        // Load Features into the multi-select (once)
        function loadFeaturesDropdown() {
            if (featuresLoaded) {
                return $.Deferred().resolve().promise();
            }
            return $.ajax({
                type: "POST",
                url: "000UserMaster.aspx/UserMaster",
                data: JSON.stringify({ action: "GetFeatures", user: {} }),
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    var features = JSON.parse(res.d);
                    var ddl = $('#FeaturesInput');
                    ddl.empty();
                    $.each(features, function (i, f) {
                        ddl.append('<option value="' + f.FeatureId + '">' + f.DisplayName + '</option>');
                    });
                    featuresLoaded = true;
                }
            });
        }

        function clearModal() {
            $('#UserIdHidden').val('');
            $('#UsernameInput').val('');
            $('#EmailInput').val('');
            $('#DisplayNameInput').val('');
            $('#PasswordInput').val('');
            $('#StatusInput').val('1');
            $('#FeaturesInput').val([]); // if you use select2, add .trigger('change')
        }

        function editUser(id) {
            // ensure features present before selecting them
            $.when(loadFeaturesDropdown()).then(function () {
                $.ajax({
                    type: "POST",
                    url: "000UserMaster.aspx/UserMaster",
                    data: JSON.stringify({ action: "GetById", user: { UserId: id } }),
                    contentType: "application/json; charset=utf-8",
                    success: function (res) {
                        var arr = JSON.parse(res.d);
                        if (!arr || !arr.length) {
                            new swal("Not found", "User record not found", "warning");
                            return;
                        }
                        var u = arr[0];

                        $('#UserIdHidden').val(u.UserId);
                        $('#UsernameInput').val(u.Username);
                        $('#EmailInput').val(u.Email);
                        $('#DisplayNameInput').val(u.DisplayName);
                        $('#StatusInput').val(u.IsActive ? "1" : "0");
                        $('#PasswordInput').val(''); // leave blank on edit

                        var ids = (u.FeatureIds && u.FeatureIds.length) ? u.FeatureIds.split(',') : [];
                        $('#FeaturesInput').val(ids);

                        $('#userModal').modal('show');
                    },
                    error: function () {
                        new swal("Error", "Failed to load user details", "error");
                    }
                });
            });
        }

        function deleteUser(id) {
            $.ajax({
                type: "POST",
                url: "000UserMaster.aspx/UserMaster",
                data: JSON.stringify({ action: "Delete", user: { UserId: id } }),
                contentType: "application/json; charset=utf-8",
                success: function () {
                    $('#tblUsers').DataTable().ajax.reload(null, false);
                    new swal("Deleted", "User marked inactive", "success");
                },
                error: function () {
                    new swal("Error", "Failed to delete user", "error");
                }
            });
        }

        $(document).ready(function () {
            // preload features
            loadFeaturesDropdown();

            // DataTable
            var table = $('#tblUsers').DataTable({
                "ajax": {
                    "url": "000UserMaster.aspx/UserMaster",
                    "type": "POST",
                    "contentType": "application/json; charset=utf-8",
                    "data": function () {
                        return JSON.stringify({ action: "GetAll", user: {} });
                    },
                    "dataSrc": function (json) {
                        return JSON.parse(json.d);
                    }
                },
                "columns": [
                    { "data": "UserId" },
                    { "data": "Username" },
                    { "data": "Email" },
                    { "data": "DisplayName" },
                    {
                        "data": "IsActive",
                        "render": function (v) { return v ? "Active" : "Inactive"; }
                    },
                    {
                        data: "Features",
                        className: "dt-center",
                        render: function (data) {
                            if (!data) return "";
                            function esc(t) {
                                return t.replace(/[&<>"']/g,
                                    m => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m]));
                            }
                            var items = data.split(',').map(s => s.trim()).filter(Boolean)
                                .map(s => '<li>' + esc(s) + '</li>').join('');
                            return '<div class="feature-wrap"><ul class="feature-list">' + items + '</ul></div>';
                        }
                    },
                    {
                        "data": "UserId", "orderable": false, "searchable": false,
                        "render": function (id) {
                            return '<a class="btn btn-info btn-edit" data-id="' + id + '">Edit</button>';
                        }
                    },
                    {
                        "data": "UserId", "orderable": false, "searchable": false,
                        "render": function (id) {
                            return '<a class="btn btn-info btn-delete" data-id="' + id + '">Delete</button>';
                        }
                    }
                ]
            });

            // delegated handlers so they work on dynamic rows
            $(document).on('click', '.btn-edit', function (e) {
                e.preventDefault(); e.stopPropagation();
                editUser($(this).data('id'));
            });
            $(document).on('click', '.btn-delete', function (e) {
                e.preventDefault(); e.stopPropagation();
                deleteUser($(this).data('id'));
            });

            // Toolbar: Add New User
            $('#btnAddUser').attr('type', 'button').click(function (e) {
                e.preventDefault();
                clearModal();
                $('#userModal').modal('show');
            });

            $(document).on('click', '#userCancelBtn', function (e) {
                e.preventDefault(); e.stopPropagation();
                $('#userModal').modal('hide');
            });

            $(document).on('click', '#userCloseTop', function (e) {
                e.preventDefault(); e.stopPropagation();
                $('#userModal').modal('hide');
            });

            // Save button in modal
            $('#SaveUserBtn').attr('type', 'button').click(function (e) {
                e.preventDefault();

                var uid = parseInt($('#UserIdHidden').val() || '0', 10);

                var user = {
                    UserId: uid,
                    Username: $('#UsernameInput').val(),
                    Email: $('#EmailInput').val(),
                    DisplayName: $('#DisplayNameInput').val(),
                    Password: $('#PasswordInput').val(), // optional on edit
                    Status: parseInt($('#StatusInput').val(), 10),
                    Features: $('#FeaturesInput').val() // array of FeatureId
                };

                $.ajax({
                    type: "POST",
                    url: "000UserMaster.aspx/UserMaster",
                    data: JSON.stringify({ action: "Save", user: user }),
                    contentType: "application/json; charset=utf-8",
                    success: function () {
                        $('#userModal').modal('hide');
                        $('#tblUsers').DataTable().ajax.reload(null, false);
                        new swal("Saved", "User saved successfully", "success");
                    },
                    error: function (xhr) {
                        var msg = (xhr && xhr.responseText) ? xhr.responseText : "Save failed";
                        new swal("Error", msg, "error");
                    }
                });
            });

            var deletedTable = null;

            // open the Deleted list modal
            $('#DeletedUsers').attr('type', 'button').on('click', function (e) {
                e.preventDefault();
                loadDeletedUsers();               // (re)bind the table
                $('#deletedUserModal').modal('show');
            });

            // load / reload the deleted users table
            function loadDeletedUsers() {
                if ($.fn.DataTable.isDataTable('#deletedUsersTable')) {
                    deletedTable.ajax.reload(null, false);
                    return;
                }
                deletedTable = $('#deletedUsersTable').DataTable({
                    "ajax": {
                        "url": "000UserMaster.aspx/UserMaster",
                        "type": "POST",
                        "contentType": "application/json; charset=utf-8",
                        "data": function () {
                            return JSON.stringify({ action: "GetDeleted", user: {} });
                        },
                        "dataSrc": function (json) {
                            return JSON.parse(json.d);
                        }
                    },
                    "columns": [
                        { "data": "UserId" },
                        { "data": "Username" },
                        { "data": "Email" },
                        { "data": "DisplayName" },
                        {
                            "data": "DeletedOn",
                            "render": function (d) { return d ? d : ""; }
                        },
                        {
                            "data": "UserId",
                            "orderable": false,
                            "searchable": false,
                            "render": function (id) {
                                return '<a class="btn btn-info btn-undo" data-id="' + id + '">UNDO</button>';
                            }
                        }
                    ]
                });
            }

            // delegated handler for Undo
            $(document).on('click', '.btn-undo', function (e) {
                e.preventDefault(); e.stopPropagation();
                var id = $(this).data('id');

                $.ajax({
                    type: "POST",
                    url: "000UserMaster.aspx/UserMaster",
                    data: JSON.stringify({ action: "Undo", user: { UserId: id } }),
                    contentType: "application/json; charset=utf-8",
                    success: function () {
                        // refresh both tables
                        if ($.fn.DataTable.isDataTable('#deletedUsersTable')) {
                            $('#deletedUsersTable').DataTable().ajax.reload(null, false);
                        }
                        if ($.fn.DataTable.isDataTable('#tblUsers')) {
                            $('#tblUsers').DataTable().ajax.reload(null, false);
                        }
                        new swal("Restored", "User re-activated successfully", "success");
                    },
                    error: function () {
                        new swal("Error", "Failed to restore user", "error");
                    }
                });
            });

        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Main User Table -->
    <div class="container-fluid">
        <div class="container">
            <div style="text-align: center;">
                <h1>User Management</h1>
            </div>
            <br />

            <!-- Toolbar row (match your style) -->
            <div class="row">
                <div class="col-md-3">
                    <button id="ExportUsers" type="button" class="badge badge-success btn-block" style="margin-top: 15px; font-size: medium;">Export To Excel</button>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <button id="btnAddUser" type="button" class="badge badge-success btn-block" style="margin-top: 15px; font-size: medium;">Add New User</button>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <button id="DeletedUsers" type="button" class="badge badge-danger btn-block" style="margin-top: 15px; font-size: medium;">Deleted User List</button>
                </div>
            </div>
        </div>

        <div id="loadingIndicator" class="loading-indicator"></div>

        <!-- DataTable -->
        <div class="container-fluid" style="margin-top: 10px; margin-bottom: 30px;">
            <div class="row">
                <div class="col-md-12">
                    <table id="tblUsers" class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>UserId</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Display Name</th>
                                <th>Status</th>
                                <th>Features</th>
                                <th style="text-align: center; width: 10px;">Edit</th>
                                <th style="text-align: center; width: 10px;">Delete</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add / Edit User Modal -->
    <div class="modal fade" id="userModal" tabindex="-1" role="dialog" aria-labelledby="userModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="userModalLabel" style="font-size: 1.5em;">User Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="userCloseTop">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <div class="modal-body" style="font-size: 1.2em;">
                    <input type="hidden" id="UserIdHidden" />

                    <!-- Account Info -->
                    <div class="card mb-3">
                        <div class="card-header">Account Information</div>
                        <div class="card-body">
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="UsernameInput">Username:</label>
                                    <input type="text" class="form-control" id="UsernameInput" required>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="EmailInput">Email:</label>
                                    <input type="email" class="form-control" id="EmailInput" required>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="PasswordInput">Password:</label>
                                    <input type="password" class="form-control" id="PasswordInput" placeholder="Leave blank to keep current">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="DisplayNameInput">Display Name:</label>
                                    <input type="text" class="form-control" id="DisplayNameInput" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="StatusInput">Status:</label>
                                    <select class="form-control" id="StatusInput" required>
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Feature Assignment -->
                    <div class="card mb-3">
                        <div class="card-header">Assign Features</div>
                        <div class="card-body">
                            <div class="form-row">
                                <div class="form-group col-md-12">
                                    <label for="FeaturesInput">Features:</label>
                                    <select id="FeaturesInput" multiple class="form-control"></select>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" id="userCancelBtn">Cancel</button>
                    <button type="button" class="btn btn-primary" id="SaveUserBtn">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Deleted User List Modal (skeleton, optional to wire later) -->
 <div class="modal fade" id="deletedUserModal" tabindex="-1" aria-labelledby="deletedUserModalLabel" aria-hidden="true">
  <!-- set width on the dialog -->
  <div class="modal-dialog" style="max-width:90vw;width:90vw;">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deletedUserModalLabel">Deleted User List</h5>
        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close" id="deletedUserCloseTop">
              <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <div class="modal-body">
        <!-- make table responsive & full width -->
        <div class="table-responsive">
          <table id="deletedUsersTable" class="table table-striped table-bordered w-100">
            <thead>
              <tr>
                <th>UserId</th>
                <th>Username</th>
                <th>Email</th>
                <th>Display Name</th>
                <th>Deleted On</th>
                <th style="text-align:center;">Undo</th>
              </tr>
            </thead>
          </table>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="deletedUserCloseBottom">Close</button>
      </div>
    </div>
  </div>
</div>




</asp:Content>
