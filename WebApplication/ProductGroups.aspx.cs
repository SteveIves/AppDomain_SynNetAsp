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
    public partial class ProductGroups : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["ProductGroups"]==null)
                RegisterAsyncTask(new PageAsyncTask(doGetProductGroups));
            else
            {
                grid.DataSource = Session["ProductGroups"];
                grid.DataBind();
            }
        }

        private async Task doGetProductGroups()
        {
            // ALWAYS use Util.GetAsyncServices() to obtain an AsyncServices object to access the Synergy .NET code. See further comments in Util.cs.
            var result = await Util.GetAsyncServices().ReadAllProductGroups();
            switch (result.Item1)
            {
                case MethodStatus.Success:
                    grid.DataSource = result.Item2;
                    grid.DataBind();
                    Session["ProductGroups"] = result.Item2;
                    lblMessage.Text = String.Format("{0} matching product groups", result.Item2.Count);
                    break;
                case MethodStatus.FatalError:
                    lblMessage.Text = "Fatal error!";
                    break;
            }
        }

    }
}