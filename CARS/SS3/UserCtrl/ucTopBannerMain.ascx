<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ucTopBannerMain.ascx.vb" Inherits="CARS.ucTopBannerMain1" %>
<div id="topHeader">
    <div id="topBanner">
        <div id="tbBrand">
            <asp:Image ImageUrl="../../images/heading_band_05.gif" ID="imgH1" runat="server" AlternateText="Cars Software"/>
        </div>
        <div id="tbDepartment">
            <asp:Label ID="RTlblPageTitle" runat="server" Text="VERKSTED"></asp:Label>
        </div>
        <div id="tbUserInfo">
            <div class="tbUser">
                <asp:Label ID="RTLblUser" runat="server" Text="pv45"></asp:Label>
            </div>
            <div class="tbVersion">
                <asp:Label ID="RTLblVersion" runat="server"  Text="Version"></asp:Label>
                <asp:Label ID="RTlblver" runat="server" Text="4.5"></asp:Label>
            </div>
            <div class="tbLanguage">
                <asp:Label ID="RTlblLanguage" runat="server" Text="Norsk"></asp:Label>
            </div>
            <div class="tbLogOut">
                <asp:HyperLink runat="Server" ID="hlnkMSGLogout">Logout</asp:HyperLink>
            </div>
        </div>
    </div>
    <div id="topNav">
        <asp:Menu ID="Menu1" runat="server" DynamicVerticalOffset="0" Orientation="Horizontal" StaticSubMenuIndent="10px" SkipLinkText="">
            <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" CssClass="menu_on1" />
            <DynamicHoverStyle CssClass="menu_sub_over1" />
            <DynamicMenuStyle CssClass="menu_on1" />
            <StaticSelectedStyle CssClass="menu_on1" />
            <DynamicSelectedStyle CssClass="menu_on1" />
            <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" CssClass="menu_on1" />
        </asp:Menu>
    </div>
</div>
<asp:Label ID="RTlblExpand" runat="server" Visible="False"></asp:Label>