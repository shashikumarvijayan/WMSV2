<%@ Page Title="" Language="C#" MasterPageFile="~/WMSMaster.Master" AutoEventWireup="true" CodeBehind="001WMSLogin.aspx.cs" Inherits="WMSJJPV_V2._001WMSLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            var tab = document.getElementById('<%= hidTAB.ClientID%>').value;
            $('#ex1 a[href="' + tab + '"]').tab('show');
        });
    </script>
    <script type="text/javascript">
        function showpop(msg, title) {
            toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": false,
                "progressBar": true,
                "positionClass": "toast-top-right",
                "preventDuplicates": true,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "12000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }
            toastr.error(msg, title);
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="hidTAB" runat="server" Value="#pills-login" />
    <!-- Start your project here-->

    <section class="vh-100">
        <div class="container-fluid h-custom">
            <div class="row d-flex justify-content-center align-items-center h-100">
                <div class="col-md-9 col-lg-6 col-xl-5">
                    <img src="ImgSrc/LOGOMAIN.png" class="img-fluid" />
                </div>

                <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1" id="login">
                    <div class="logincontent">
                        <ul class="nav nav-pills nav-justified mb-3" id="ex1" role="tablist">
                            <li class="nav-item" role="presentation">
                                <a class="nav-link active" id="tab-login" data-mdb-toggle="pill"  href="#pills-login" role="tab"
                                aria-controls="pills-login" aria-selected="true">Please Login</a>
                            </li>
                        </ul>
                        <!-- Pills content -->
                        <div class="tab-content">
                            <div class="tab-pane fade show active" id="pills-login" role="tabpanel" aria-labelledby="tab-login">
                                <!-- Email input -->
                                <div class="form-outline  mb-4">
                                    <div class="form-floating mb-3">
                                        <asp:TextBox runat="server" class="form-control" id="untxt" ClientIDMode="Static" placeholder="name@example.com" autocomplete="off" AutoCompleteType="Disabled"></asp:TextBox>
                                        <label for="untxt">User Name</label>
                                    </div>
                                </div>

                                <!-- Password input -->
                                <div class="form-outline  mb-4">
                                    <div class="form-floating mb-3">
                                        <asp:TextBox runat="server" class="form-control" id="pwtxt" ClientIDMode="Static" placeholder="xxxxxxxx" autocomplete="off" AutoCompleteType="Disabled"></asp:TextBox>
                                        <label for="pwtxt">Password</label>
                                    </div>
                                </div>

                                <!-- Submit button -->
                                <asp:Button runat="server" ID="signinbutton" ClientIDMode="Static" class="btn btn-primary btn-block mb-3" Text="Sign In" OnClick="signinbutton_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer>
            <div id="footer1" class="container-fluid" style="bottom:-15px">
                <p class="footerlinks">&copy Developed By Shashi Kumar Vijayan</p>
            </div>
        </footer>
    </section>
    <!-- End your project here-->

</asp:Content>
