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
    public partial class ProductGroupParts : System.Web.UI.Page
    {
        private string productGroup;

        protected void Page_Load(object sender, EventArgs e)
        {
            productGroup = Request.QueryString["productGroup"];

            RegisterAsyncTask(new PageAsyncTask(doGetParts));
        }

        private async Task doGetParts()
        {
            // ALWAYS use Util.GetAsyncServices() to obtain an AsyncServices object to access the Synergy .NET code. See further comments in Util.cs.
            var result = await Util.GetAsyncServices().GetProductGroupParts(productGroup);
            switch (result.Item1)
            {
                case MethodStatus.Success:
                    grid.DataSource = result.Item2;
                    grid.DataBind();
                    Session["CACHE"] = result.Item2;
                    lblMessage.Text = String.Format("{0} matching parts", result.Item2.Count);
                    break;
                case MethodStatus.FatalError:
                    lblMessage.Text = "Fatal error!";
                    break;
            }
        }
    }
}