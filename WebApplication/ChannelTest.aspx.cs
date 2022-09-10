using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BusinessLogic;

namespace WebApplication
{
    public partial class ChannelTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                showOpenChannels();
        }

        protected void btnOpenChannel_Click(object sender, EventArgs e)
        {
            /* ALWAYS use Util.GetServices() or Util.GetAsyncServices() to
             * obtain a Services or AsyncServices object to access the
             * Synergy .NET code. See further comments in Util.cs
             */
            Util.GetAsyncServices().OpenChannel();
            showOpenChannels();
        }

        protected void btnCloseChannels_Click(object sender, EventArgs e)
        {
            /* ALWAYS use Util.GetServices() or Util.GetAsyncServices() to
             * obtain a Services or AsyncServices object to access the
             * Synergy .NET code. See further comments in Util.cs
             */
            Util.GetAsyncServices().CloseAllChannels();
            showOpenChannels();
        }

        private void showOpenChannels()
        {
            /* ALWAYS use Util.GetServices() or Util.GetAsyncServices() to
             * obtain a Services or AsyncServices object to access the
             * Synergy .NET code. See further comments in Util.cs
             */
            List<String> channels = Util.GetAsyncServices().GetOpenChannels().Result;
            grid.DataSource = channels;
            grid.DataBind();
        }
    }
}