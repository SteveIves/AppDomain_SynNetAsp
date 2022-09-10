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
    public partial class Suppliers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Suppliers"]==null)
                RegisterAsyncTask(new PageAsyncTask(doGetSuppliers));
            else
            {
                grid.DataSource = Session["Suppliers"];
                grid.DataBind();
            }
        }

        private async Task doGetSuppliers()
        {
            // ALWAYS use Util.GetAsyncServices() to obtain an AsyncServices object to access the Synergy .NET code. See further comments in Util.cs.
            var result = await Util.GetAsyncServices().ReadAllSuppliers();
            switch (result.Item1)
            {
                case MethodStatus.Success:
                    grid.DataSource = result.Item2;
                    grid.DataBind();
                    Session["Suppliers"] = result.Item2;
                    lblMessage.Text = String.Format("{0} matching suppliers", result.Item2.Count);
                    break;
                case MethodStatus.FatalError:
                    lblMessage.Text = "Fatal error!";
                    break;
            }
        }
    }
}