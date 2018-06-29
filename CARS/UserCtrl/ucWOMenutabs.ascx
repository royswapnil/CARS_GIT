<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ucWOMenutabs.ascx.vb" Inherits="CARS.ucWOMenutabs" %>
<link href="../CSS/Msg.css" rel="stylesheet" type="text/css" />
<asp:Repeater id="RptrMainTabs" runat="server">
	<HeaderTemplate>
		<table id="tabsOut" cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr>
				<td>
				   <table border="0" cellspacing="0" cellpadding="0" id="tabs">
					<tr>
	</HeaderTemplate>
	<ItemTemplate> 
		<td>

		    <asp:HyperLink ID="HLlnkMainLinks"   Runat="server" NavigateUrl='<%#DataBinder.Eval(Container.DataItem, ("urlname"))%>' TabIndex='<%#DataBinder.Eval(Container.DataItem, ("IDTAB"))%>' CssClass ="lvl12Lnnrm" text='<%#DataBinder.Eval(Container.DataItem, ("TabName"))%>'  ></asp:HyperLink></td> 
		    </td> 
		</td>
	</ItemTemplate>
</asp:Repeater>
<table width="98%" cellspacing="0" cellpadding="0" border="0" >
<tr style="height: 20px; height: 10px;">
<td style="width: 99%;height: 10px;"><asp:Image ImageUrl="~/Images/Type_Band1.jpg" ID="imgH1" runat="server" width="100%" height="10px" AlternateText="" BorderStyle="None"/>
</td>
</tr>
</table>