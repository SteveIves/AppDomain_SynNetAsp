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
    public partial class Default : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            RegisterAsyncTask(new PageAsyncTask(doLogin));
        }

        private async Task doLogin()
        {
            lblErrorText.Text = "";
            var result = await Util.GetAsyncServices().Login(txtLogin.Text, txtPassword.Text);
            switch (result.Item2)
            {
                case MethodStatus.Success:
                    Response.Redirect("~/MainMenu.aspx", false);
                    break;
                case MethodStatus.Fail:
                    Session.Abandon();
                    lblErrorText.Text = result.Item1;
                    txtPassword.Focus();
                    break;
            }
        }
    }
}