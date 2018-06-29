<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmShowReports.aspx.vb" Inherits="CARS.frmShowReports" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692FBEA5521E1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <link href="../CSS/Msg.css" rel="stylesheet" type="text/css" />
       <script src="../javascripts/msg.js" type="text/javascript"></script>
    <script type="text/javascript" src="../crystalreportviewers13/js/crviewer/crv.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Panel runat="server" Width="100%" ID="Panel1">
                <CR:CrystalReportViewer ID="CrViewer1" runat="server" AutoDataBind="true"  EnableDrillDown="true"
                    HasCrystalLogo="False" HasGotoPageButton="False" HasSearchButton="False" BorderStyle="Outset"
                    PrintMode="ActiveX" HasZoomFactorList="false" />
            </asp:Panel>
        </div>
    </form>
</body>
</html>
