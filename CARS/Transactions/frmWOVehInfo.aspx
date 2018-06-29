<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmWOVehInfo.aspx.vb" Inherits="CARS.frmWOVehInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vehicle Information</title>
    <script type="text/javascript" src="../javascripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui-i18n.min.js"></script>
    <script type="text/javascript" src="../javascripts/json2-min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui.min.js"></script>
     <script type="text/javascript" src="../javascripts/Msg.js"></script>
      <link href= "../CSS/jquery-ui.css" rel="stylesheet" type="text/css"/>
     <link href= "../semantic/semantic.min.css" rel="stylesheet" type="text/css"/>
    <link href= "../CSS/Msg.css" rel="stylesheet" type="text/css"/>
    <script>
        $(document).ready(function () {
            function GetParameterValues() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            }
            var vehId = GetParameterValues()["vid"];
            $(document.getElementById('<%=hdnIdVeh.ClientID%>')).val(vehId);
           
            
            FillVehGrp();
            LoadVehDet(vehId);
        }); //ready func
        function LoadVehDet(vehId) {
            var VehicleId = vehId;
            $.ajax({
                type: "POST",
                url: "frmWOVehInfo.aspx/LoadVehDetails",
                data: "{'VehicleId':'" + VehicleId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    if (Result.d.length != 0) {
                        var Idmake = Result.d[0].Id_Make;
                        FillModel(Idmake);
                        FillRPMpdel(Idmake);
                        if (Result.d[0].Id_Model == 0) {
                            $('#<%=ddlModel.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlModel.ClientID%> option:contains("' + Result.d[0].Id_Model + '")').attr('selected', 'selected');
                        }
                        if (Result.d[0].Id_Model_RP == 0) {
                            $('#<%=ddlRprpkgModel.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlRprpkgModel.ClientID%> option:contains("' + Result.d[0].Id_Model_RP + '")').attr('selected', 'selected');
                        }
                        if (Result.d[0].Veh_Grpdesc == 0) {
                            $('#<%=ddlVehGrp.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlVehGrp.ClientID%> option:contains("' + Result.d[0].Veh_Grpdesc + '")').attr('selected', 'selected');
                        }
                        $('#<%=txtCustomer.ClientID%>').val(Result.d[0].WO_Cust_Name);
                        $('#<%=txtOwnername.ClientID%>').val(Result.d[0].Veh_OwnerName);
                        $('#<%=txtDriver.ClientID%>').val(Result.d[0].Veh_Driver);
                        $('#<%=txtPhonedriver.ClientID%>').val(Result.d[0].Veh_Phone1);
                        $('#<%=txtMobiledriver.ClientID%>').val(Result.d[0].Veh_Mobile);
                        $('#<%=txtEmaildriver.ClientID%>').val(Result.d[0].Veh_Drv_Emailid);
                        $('#<%=txtRegOn.ClientID%>').val(Result.d[0].Dt_Veh_Regn);
                        $('#<%=txtLastregdate.ClientID%>').val(Result.d[0].Dt_Veh_Last_Regn);
                        $('#<%=txtservicetype.ClientID%>').val(Result.d[0].Veh_Srv_Type);
                        $('#<%=txtVehLMil.ClientID%>').val(Result.d[0].WO_Veh_Mileage);
                        $('#<%=txtDatelastMileage.ClientID%>').val(Result.d[0].Dt_Veh_Mil_Regn);
                        $('#<%=txtLasthours.ClientID%>').val(Result.d[0].WO_Veh_Hrs);
                        $('#<%=txtdateLasthours.ClientID%>').val(Result.d[0].Dt_Veh_Hrs_Regn);
                        $('#<%=txtAnnotation.ClientID%>').val(Result.d[0].WO_Annot);
                    }
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillVehGrp() {
            $.ajax({
                type: "POST",
                url: "frmWOVehInfo.aspx/LoadVehGroup",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    debugger;
                    Result = Result.d;
                    $('#<%=ddlVehGrp.ClientID%>').empty();
                    $('#<%=ddlVehGrp.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlVehGrp.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillModel(IdMake) {
            $.ajax({
                type: "POST",
                url: "frmWOVehInfo.aspx/LoadVehModel",
                data: "{'IdMake':'" + IdMake + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlModel.ClientID%>').empty();
                    $('#<%=ddlModel.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlModel.ClientID%>').append($("<option></option>").val(value.Id_Model).html(value.Model_Desc));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillRPMpdel(IdMake) {
            $.ajax({
                type: "POST",
                url: "frmWOVehInfo.aspx/LoadVehRPModel",
                data: "{'IdMake':'" + IdMake + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlRprpkgModel.ClientID%>').empty();
                    $('#<%=ddlRprpkgModel.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlRprpkgModel.ClientID%>').append($("<option></option>").val(value.Id_Model).html(value.Model_Desc));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function UpdateVehInfo() {
            var vehId = $(document.getElementById('<%=hdnIdVeh.ClientID%>')).val();
            $.ajax({
                type: "POST",
                url: "frmWOVehInfo.aspx/UpdateVehInfo",
                data: "{vehId: '" + vehId + "',vehModel: '" + $('#<%=ddlModel.ClientID%>').val() + "', vehRPModel:'" + $('#<%=ddlRprpkgModel.ClientID%>').val() + "', vehGrp:'" + $('#<%=ddlVehGrp.ClientID%>').val() + "', idCustomer:'" + $('#<%=txtCustomer.ClientID%>').val() + "',vehOwner:'" + $('#<%=txtOwnername.ClientID%>').val() + "', vehDriver:'" + $('#<%=txtDriver.ClientID%>').val() + "', vehDrvPhone:'" + $('#<%=txtPhonedriver.ClientID%>').val() + "',vehDrvMobile:'" + $('#<%=txtMobiledriver.ClientID%>').val() + "',vehDrvEmail:'" + $('#<%=txtEmaildriver.ClientID%>').val() + "',dtVehRegn:'" + $('#<%=txtRegOn.ClientID%>').val() + 
                        "',dtLastReg: '" + $('#<%=txtLastregdate.ClientID%>').val() + "', vehHrs:'" + $('#<%=txtLasthours.ClientID%>').val() + "', dtLastHours:'" + $('#<%=txtdateLasthours.ClientID%>').val() + "', vehMil:'" + $('#<%=txtVehLMil.ClientID%>').val() + "', dtLastMileage:'" + $('#<%=txtDatelastMileage.ClientID%>').val() + "', srvType:'" + $('#<%=txtservicetype.ClientID%>').val() + "', vehAnnot:'" + $('#<%=txtAnnotation.ClientID%>').val() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    debugger;
                    if (Result.d[0] == "UPDFLG") {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }


                },
                failure: function () {
                    alert("Failed!");
                }
            });

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
   <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
         <a class="active item" runat="server" id="aAddrComm">Vehicle Information</a>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
       <asp:HiddenField ID="hdnSelect" runat="server" />
        <asp:HiddenField ID="hdnIdVeh" runat="server" />
     </div>
          <div class="ui form">
                <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblModelGroup" runat="server" Text="Model Group"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:DropDownList ID="ddlModel" runat="server" Width="200px"></asp:DropDownList>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblRepr" runat="server" Text="Model Code Repr.Pkg"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:DropDownList ID="ddlRprpkgModel" runat="server" Width="200px"></asp:DropDownList>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblVechgroup" runat="server" Text="Vehicle group"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:DropDownList ID="ddlVehGrp" runat="server" Width="200px"></asp:DropDownList>
                    </div>
             </div>
                <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblCustomer" runat="server" Text="Customer (name)"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtCustomer" runat="server" Width="140px"></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblOwner" runat="server" Text="Owner (name)"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtOwnername" runat="server" Width="140px" ReadOnly="True"></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblDriver" runat="server" Text="Driver"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtDriver" runat="server" Width="140px" ></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblPhonedriver" runat="server" Text="Phone no(driver)"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtPhonedriver" runat="server" Width="140px" ></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblMobiledriver" runat="server" Text="Mobile no (driver)"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtMobiledriver" runat="server" Width="140px" ></asp:TextBox>
                    </div>
             </div>
                <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblEmaildriver" runat="server" Text="E-mail (driver)"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtEmaildriver" runat="server" Width="140px" ></asp:TextBox>
                    </div>
             </div>
                <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblOn" runat="server" Text="Reg.On"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtRegOn" runat="server" Width="140px" ></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblLastregdate" runat="server" Text="Last reg.date"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtLastregdate" runat="server" Width="140px" ></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblVin" runat="server" Text="Service type"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtservicetype" runat="server" Width="140px" ReadOnly="True"></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblLastMileage" runat="server" Text="Last Mileage"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtVehLMil" runat="server" Width="140px" ReadOnly="True"></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblDatelastMileage" runat="server" Text="Date for last Mileage"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtDatelastMileage" runat="server" Width="140px" ReadOnly="True"></asp:TextBox>
                    </div>
             </div>
                <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblLasthours" runat="server" Text="Last hours"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtLasthours" runat="server" Width="140px" ReadOnly="True"></asp:TextBox>
                    </div>
             </div>
                <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lbldateLasthours" runat="server" Text="Date for Last hours"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtdateLasthours" runat="server" Width="140px" ReadOnly="True"></asp:TextBox>
                    </div>
             </div>
               <div class="six fields lbl">
                    <div class="field" style="padding-left:0.55em;width:147px">
                        <asp:Label ID="lblAnnotation" runat="server" Text="Annotation"></asp:Label>
                    </div>
                    <div class="field" style="width:140px">
                         <asp:TextBox ID="txtAnnotation" runat="server" Width="140px" ReadOnly="True"></asp:TextBox>
                    </div>
             </div>
                <div id="divVehInfo" style="text-align:center">
                    <input id="btnUpdate" runat="server" class="ui button"  value="Update" type="button" onclick="UpdateVehInfo()" />
                    <input id="btnClose" runat="server" class="ui button" value="Close" type="button" style="background-color: #E0E0E0" onclick="window.close();"  />
           </div>   
          </div>
    </form>
</body>
</html>
