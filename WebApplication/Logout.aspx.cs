using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
             * When using the AppDomain wrapper functionality defined in Util.cs
             * it is CRITICAL that your Web application destroys the ASP.NET session
             * as part of its "logout" functionality. Doing a Session.Abandon() causes
             * the Global class's Session_End event handler to fire and ensures that
             * the session-sepecifc AppDomain is destroyed.
             */
            if (!IsPostBack)
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx");
            }

        }
    }
}