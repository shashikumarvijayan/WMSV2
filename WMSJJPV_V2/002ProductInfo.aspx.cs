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
                cmd.Parameters.AddWithValue("@Customer_Name", (object)product.Customer_Name ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Customer_Address", (object)product.Customer_Address ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Product_No", (object)product.Product_No ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Product_Name", (object)product.Product_Name ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Supplier_Name", (object)product.Supplier_Name ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Supplier_Address", (object)product.Supplier_Address ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Model", (object)product.Model ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Drawing_Rev", (object)product.Drawing_Rev ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@CO", (object)product.CO ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Importer", (object)product.Importer ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Address", (object)product.Address ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Cavity", (object)product.Cavity ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@JJ_Code", (object)product.JJ_Code ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Die_Line", (object)product.Die_Line ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Qty_Per_Packing", (object)product.Qty_Per_Packing ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@UOM", (object)product.UOM ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Min_Qty", (object)product.Min_Qty ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Max_Qty", (object)product.Max_Qty ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Default_Storage_Location", (object)product.Default_Storage_Location ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Division", (object)product.Division ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Label_Format", (object)product.Label_Format ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Status", (object)product.Status ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@BomNeeded", product.BomNeeded);
                cmd.Parameters.AddWithValue("@Default", product.Default);
                cmd.Parameters.AddWithValue("@BrotherSloc", (object)product.BrotherSloc ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@QtyPerPallet", (object)product.QtyPerPallet ?? DBNull.Value);
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
            public string Customer_Name { get; set; }
            public string Customer_Address { get; set; }
            public string Product_No { get; set; }
            public string Product_Name { get; set; }
            public string Supplier_Name { get; set; }
            public string Supplier_Address { get; set; }
            public string Model { get; set; }
            public string Drawing_Rev { get; set; }
            public string CO { get; set; }
            public string Importer { get; set; }
            public string Address { get; set; }
            public string Cavity { get; set; }
            public string JJ_Code { get; set; }
            public string Die_Line { get; set; }
            public decimal? Qty_Per_Packing { get; set; }
            public string UOM { get; set; }
            public decimal? Min_Qty { get; set; }
            public decimal? Max_Qty { get; set; }
            public string Default_Storage_Location { get; set; }
            public string Division { get; set; }
            public string Label_Format { get; set; }
            public string Status { get; set; }
            public int BomNeeded { get; set; }
            public int Default { get; set; }
            public string BrotherSloc { get; set; }
            public decimal? QtyPerPallet { get; set; }
        }
    }
}
