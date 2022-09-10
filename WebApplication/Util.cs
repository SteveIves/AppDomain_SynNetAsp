using System;
using System.Web;
using System.Web.SessionState;
using System.IO;
using BusinessLogic;

namespace WebApplication
{
    /// <summary>
    /// This class contains the mechanisms used to ensure that the
    /// Synergy .NET code is loaded into a protected AppDomain
    /// </summary>
    public static class Util
    {
        /// <summary>
        /// Retrieve an AsyncServices object. The AsyncServices class exposes
        /// ASYNCHRONOUS versions of all of the applications Synergy .NET methods
        /// to client applications. In an ASP.NET application it is CRITICAL that
        /// whenever you need to use an AsyncServices object, you obtain it by
        /// calling this method. This will ensure that the Synergy .NET code is
        /// isolated into a per-session AppDomain.
        /// </summary>
        /// <returns>A Services object loaded into a session-specific AppDomain</returns>
        public static AsyncServices GetAsyncServices()
        {
            HttpSessionState session = HttpContext.Current.Session;

            if (session["AsyncServices"] == null)
            {
                var protectedServices = GetSessionAppDomain().CreateInstanceFromAndUnwrap(typeof(Services).Assembly.CodeBase, typeof(Services).FullName) as Services;
                var asyncServices = new AsyncServices(protectedServices);
                session["AsyncServices"] = asyncServices;
                return asyncServices;
            }
            else
            {
                return session["AsyncServices"] as AsyncServices;
            }
        }

        private static AppDomain GetSessionAppDomain()
        {
            /*
             * The AppDomain must be stored seperately in the ASP.NET Session object
             * because there is code in Global.Session_End() that ensures the AppDomain
             * is unlloaded when a session ends
             */

            HttpSessionState Session = HttpContext.Current.Session;

            if (Session["SessionAppDomain"] == null)
            {
                var appFolder = Path.GetDirectoryName(typeof(Services).Assembly.CodeBase);
                var appDomain = AppDomain.CreateDomain(Guid.NewGuid().ToString());
                Session["SessionAppDomain"] = appDomain;
                return appDomain;
            }
            else
            {
                return Session["SessionAppDomain"] as AppDomain;
            }
        }

    }
}