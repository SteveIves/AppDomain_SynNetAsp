using BusinessLogic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication
{
    public partial class ViewSupplier : System.Web.UI.Page
    {
        String supplierId;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                lblErrorMessage.Text = "";
            }
            else
            {
                supplierId = Request.QueryString["id"];
                RegisterAsyncTask(new PageAsyncTask(getSupplier));
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            RegisterAsyncTask(new PageAsyncTask(saveSupplier));
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            removeCache();
            Response.Redirect("~/Suppliers.aspx", false);
        }

        private async Task getSupplier()
        {
            try
            {
                var result = await Util.GetAsyncServices().ReadSupplier(supplierId);
                switch (result.Item1)
                {
                    case MethodStatus.Success:
                        showSupplier(result.Item2, result.Item3);
                        break;
                    case MethodStatus.FatalError:
                        lblErrorMessage.Text = "Service method ReadSupplier_0 returned a fatal error notification!";
                        break;
                }
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "Service method call failed with error: " + ex.Message;
            }
        }

        private void showSupplier(Supplier supplier, String grfa)
        {
            createCache(supplier, grfa);

            txtSupplierId.Text = supplier.SupplierId;
            txtName.Text = supplier.Name;
            txtAddress1.Text = supplier.Address1;
            txtAddress2.Text = supplier.Address2;
            txtAddress3.Text = supplier.Address3;
            txtCity.Text = supplier.City;
            txtPostalCode.Text = supplier.PostalCode;
            txtWebAddress.Text = supplier.WebAddress;
        }

        private async Task saveSupplier()
        {
            //Cache the supplier object
            Supplier supplier = Session["LastSupplier"] as Supplier;

            //Cache the GRFA
            String grfa = Session["LastGrfa"] as String;

            //Update the data from the UI
            supplier.Name = txtName.Text;
            supplier.Address1 = txtAddress1.Text;
            supplier.Address2 = txtAddress2.Text;
            supplier.Address3 = txtAddress3.Text;
            supplier.City = txtCity.Text;
            supplier.PostalCode = txtPostalCode.Text;
            supplier.WebAddress = txtWebAddress.Text;

            //Save the daya to the server
            try
            {
                var result = await Util.GetAsyncServices().UpdateSupplier(supplier, grfa);
                switch (result.Item1)
                {
                    case MethodStatus.Success:
                        Response.Redirect("~/Suppliers.aspx", false);
                        break;
                    case MethodStatus.FatalError:
                        lblErrorMessage.Text = "Service method UpdateSupplier returned a fatal error notification!";
                        break;
                }
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "Service method call failed with error: " + ex.Message;
            }
            removeCache();
        }

        private void createCache(Supplier supplier, String grfa)
        {
            Session["LastSupplier"] = supplier;
            Session["LastGrfa"] = grfa;
        }

        private void removeCache()
        {
            Session.Remove("LastSupplier");
            Session.Remove("LastGrfa");
        }

    }
}