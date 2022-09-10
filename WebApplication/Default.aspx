<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication.Default" Async="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h1>Demo: Using Synergy .NET in ASP.NET Applications</h1>
        <table style="padding: 30px;">
            <tr>
                <td>Username</td>
                <td><asp:TextBox ID="txtLogin" runat="server">user</asp:TextBox></td>
                <td>The username is user</td>
            </tr>
            <tr>
                <td>Password</td>
                <td><asp:TextBox ID="txtPassword" runat="server">password</asp:TextBox></td>
                <td>The password is password</td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
                    <asp:Label ID="lblErrorText" runat="server" ForeColor="Red"></asp:Label>
                </td>
                <td>Just click login!</td>
        </tr>
        </table>
    </div>
    </form>
</body>
</html>
