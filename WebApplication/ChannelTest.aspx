<%@ Page Title="Channel Test" Language="C#" MasterPageFile="~/LoggedIn.Master" AutoEventWireup="true" CodeBehind="ChannelTest.aspx.cs" Inherits="WebApplication.ChannelTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Channel Test</h2>
    <p>
        This page can be used to verify that AppDomain isolation is in place. If you use this page in
        multiple browsers then each browser (user login) should maintain its own list of open channels.
    </p>
    <p>
        Without AppDomain protection, channels would be common across all browsers (user logins).
    </p>
    <p>
        Each time you click the "Open a Channel" button you should see another channel number
        listed, starting at channel 1024 and working down.
    </p>
    <asp:Button ID="btnOpenChannel" runat="server" Text="Open a Channel" OnClick="btnOpenChannel_Click" />
    <asp:Button ID="btnCloseChannels" runat="server" Text="Close All Channels" OnClick="btnCloseChannels_Click" />
    <br />
    <asp:GridView ID="grid" runat="server"></asp:GridView>
</asp:Content>
