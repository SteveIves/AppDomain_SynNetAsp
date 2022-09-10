using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BusinessLogic;

namespace WebApplication
{
    public partial class PartsList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterAsyncTask(new PageAsyncTask(doGetAllParts));
        }

        private async Task doGetAllParts()
        {
            // ALWAYS use Util.GetAsyncServices() to obtain an AsyncServices object to access the Synergy .NET code. See further comments in Util.cs.
            var result = await Util.GetAsyncServices().ReadAllParts();
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