using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Collections.Generic;
using System.Xml.Linq;

namespace WMSJJPV_V2
{
    public partial class _001WMSLogin : System.Web.UI.Page
    {


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
            }
        }

        protected void signinbutton_Click(object sender, EventArgs e)
        {
            DoLogin();
        }

        private void DoLogin()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["MES_Master"].ConnectionString))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand("MES.sp_LoginUser", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", untxt.Text.Trim());
                    cmd.Parameters.AddWithValue("@PlainPassword", pwtxt.Text.Trim());

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read() || Convert.ToBoolean(reader["IsExist"]) == false)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Invalid Username or Password');", true);
                            return;
                        }

                        long userId = Convert.ToInt64(reader["UserId"]);
                        string displayName = reader["DisplayName"].ToString();

                        // TODO: password hash verify using PasswordHash, PasswordSalt, etc.

                        Session["UserId"] = userId;
                        Session["Name"] = displayName;

                        // go to 2nd result set: modules
                        reader.NextResult();
                        List<string> modules = new List<string>();
                        while (reader.Read())
                        {
                            modules.Add(reader["ModuleKey"].ToString());
                        }
                        Session["Modules"] = modules;

                        string script = "swal({ " +
                          "title: 'Welcome', " +
                          "text: '" + displayName + "', " +
                          "icon: 'success' " +
                      "}).then(function() { " +
                          "window.location = '002WMSMain.aspx'; " +
                      "});";


                        ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlertSuccess", script, true);



                    }

                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Login error: {ex.Message}');", true);
            }
        }

    }
}
