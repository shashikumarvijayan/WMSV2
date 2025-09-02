using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using Newtonsoft.Json;

namespace WMSJJPV_V2
{
    public partial class _001Customer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string CustomerMaster(string action, CustomerModel customer)
        {
            if (customer == null) customer = new CustomerModel();
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MES_Master"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand("MES.sp_CustomerMaster", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", action ?? "");
                cmd.Parameters.AddWithValue("@CId", customer.CId);
                cmd.Parameters.AddWithValue("@CustomerSap", (object)customer.CustomerSap ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@CustomerName", (object)customer.CustomerName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Customer_Address", (object)customer.Customer_Address ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Label_Format", (object)customer.Label_Format ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Status", (object)customer.Status ?? DBNull.Value);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return JsonConvert.SerializeObject(dt);
        }

        public class CustomerModel
        {
            public int CId { get; set; }
            public string CustomerSap { get; set; }
            public string CustomerName { get; set; }
            public string Customer_Address { get; set; }
            public string Label_Format { get; set; }
            public string Status { get; set; }
        }
    }
}
