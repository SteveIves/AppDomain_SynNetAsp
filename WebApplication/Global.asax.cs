using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace WebApplication
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {
            /*
             * When using the AppDomain wrapper functionality defined in Util.cs
             * it is CRITICAL that this code exists in the Session_End event
             * handler. The code ensures that the AppDomain created by the first
             * call to Util.GetServices() or Util.GetAsyncServices() is destroyed
             * when the session ends.
             */
            if (Session["SessionAppDomain"] != null)
            {
                AppDomain appDomain = Session["SessionAppDomain"] as AppDomain;
                AppDomain.Unload(appDomain);
            }
        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}