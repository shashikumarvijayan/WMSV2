using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using Newtonsoft.Json;

namespace WMSJJPV_V2
{
    public partial class _000UserMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // optional: session check here if needed
        }

        [WebMethod]
        public static string UserMaster(string action, UserModel user)
        {
            // Defensive null
            if (user == null) user = new UserModel();

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MES_Master"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand("MES.sp_UserMaster", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Required param
                cmd.Parameters.AddWithValue("@Action", action ?? "");

                // All inputs (use DBNull for nulls)
                cmd.Parameters.AddWithValue("@UserId", user.UserId);
                cmd.Parameters.AddWithValue("@Username", (object)user.Username ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Email", (object)user.Email ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@DisplayName", (object)user.DisplayName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@PlainPassword", (object)user.Password ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@IsActive", user.Status);

                if (user.Features != null && user.Features.Count > 0)
                    cmd.Parameters.AddWithValue("@Features", string.Join(",", user.Features));
                else
                    cmd.Parameters.AddWithValue("@Features", DBNull.Value);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return JsonConvert.SerializeObject(dt);
        }

        public class UserModel
        {
            public int UserId { get; set; } = 0;
            public string Username { get; set; }
            public string Email { get; set; }
            public string DisplayName { get; set; }
            public string Password { get; set; }
            public int Status { get; set; } = 1;
            public List<string> Features { get; set; }  // list of FeatureId values as strings
        }
    }
}
