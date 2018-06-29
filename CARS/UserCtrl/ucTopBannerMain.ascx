<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ucTopBannerMain.ascx.vb" Inherits="CARS.ucTopBannerMain" %>
<script type="text/javascript">
    window.onload = function () {
        for (var i = 0; i < 155; i++) {
            document.getElementById("<%= Menu1.ClientID %>").getElementsByTagName("a")[i].onmouseover = function (e) {
                if (!e) var e = window.event;
                e.cancelBubble = true;
                if (e.stopPropagation) e.stopPropagation();
            }
        }

    }
</script>
<script type="text/javascript">
    function menuItem() {
        var menuTable = document.getElementById("<%=Menu1.ClientID%>");
        var menuLinks = menuTable.getElementsByTagName("ul");
        for (var j = 0; j < menuLinks.length; j++) {
            menuLinks[j].onclick = function (e) {
                var tagName = menuLinks[j].id;
                if (document.getElementById(j).style.display == "none") {
                    document.getElementById(j).style.display = "block";
                }
             }
        }
    }
</script>
<asp:ScriptManager ID="sm22" runat="server"></asp:ScriptManager>
<div id="topHeader">
    <div id="topBanner">
        <div id="tbBrand">
            <asp:Image ImageUrl="../images/heading_band_05.gif" ID="imgH1" runat="server" AlternateText="Cars Software"/>
        </div>
        <div id="tbDepartment">
            <asp:Label ID="RTlblPageTitle" runat="server" Text="VERKSTED"></asp:Label>
        </div>
        <div id="languages">
            <asp:Button ID="btnNorway" runat="server"  CssClass="flag-NO" onclick="btn_Click" meta:resourcekey="btnNorwayResource1" />
            <asp:Button ID="btnEngland" runat="server"  CssClass="flag-UK" onclick="btn_Click" meta:resourcekey="btnEnglandResource1" />
            <asp:Button ID="btnLituania" runat="server"  meta:resourceKey="btnLituania" CssClass="flag-LT" onclick="btn_Click" />
            
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
        <asp:UpdatePanel ID="upd11" runat="server">
            <ContentTemplate>
        <asp:Menu ID="Menu1" runat="server" DynamicVerticalOffset="0" Orientation="Horizontal" StaticSubMenuIndent="10px" SkipLinkText="" onClick="menuItem()" AutoPostBack="False">
            <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" CssClass="menu_on1" />
            <DynamicHoverStyle CssClass="menu_sub_over1" />
            <DynamicMenuStyle CssClass="menu_on1" />
            <StaticSelectedStyle CssClass="menu_on1" />
            <DynamicSelectedStyle CssClass="menu_on1" />
            <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" CssClass="menu_on1" />
        </asp:Menu>
        
            </ContentTemplate>
                </asp:UpdatePanel>
    </div>
</div>
<asp:Label ID="RTlblExpand" runat="server" Visible="False"></asp:Label>