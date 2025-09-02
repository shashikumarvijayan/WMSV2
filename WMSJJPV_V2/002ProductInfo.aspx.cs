using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using Newtonsoft.Json;

namespace WMSJJPV_V2
{
    public partial class _002ProductInfo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string ProductInfoMaster(string action, ProductModel product)
        {
            if (product == null) product = new ProductModel();
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MES_Master"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand("MES.sp_ProductInfoMaster", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", action ?? "");
                cmd.Parameters.AddWithValue("@FG_Id", product.FG_Id);
                cmd.Parameters.AddWithValue("@FG_SAP_No", (object)product.FG_SAP_No ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@SAP_FG_Description", (object)product.SAP_FG_Description ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Customer_Sap", (object)product.Customer_Sap ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Status", (object)product.Status ?? DBNull.Value);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return JsonConvert.SerializeObject(dt);
        }

        public class ProductModel
        {
            public int FG_Id { get; set; }
            public string FG_SAP_No { get; set; }
            public string SAP_FG_Description { get; set; }
            public string Customer_Sap { get; set; }
            public string Status { get; set; }
        }
    }
}
