<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmTRegPopUp.aspx.vb" Inherits="CARS.frmTRegPopUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manual Clock-In</title>
    <script type="text/javascript" src="../Scripts/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-ui-1.11.4.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui-i18n.min.js"></script>
    <script type="text/javascript" src="../semantic/semantic.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-migrate-1.2.1.js"></script>
    <script type="text/javascript" src="../javascripts/grid.locale-no.js"></script>
    <script type="text/javascript" src="../javascripts/jquery.jqGrid.js"></script>
    <script type="text/javascript" src="../javascripts/jquery.jqGrid.min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery.jqGrid.src.js"></script>
    <script type="text/javascript" src="../javascripts/json2-min.js"></script>
    <script type="text/javascript" src="../javascripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../javascripts/Msg.js"></script>
    <link href="../Content/ui.jqgrid.css" rel="stylesheet" />
    <link href="../Content/themes/base/all.css" rel="stylesheet" />
    <link href="../Content/semantic.css" rel="stylesheet" />
    <link href="../CSS/cars.css" rel="stylesheet" type="text/css" />
    <script src="../Scripts/jquery.contextMenu.min.js"></script>
    <link href="../CSS/jquery.contextMenu.min.css" rel="stylesheet" type="text/css"  />
    <script src="../Scripts/cars.js"></script>
    <style type="text/css">
                .ui-dialog .ui-dialog-titlebar-close span {
                    display: block;
                    margin-bottom: 0px;
                    padding: 0px;
                    margin-left: -9px;
                    margin-top: -9px;
                }

                .ui-dialog .ui-dialog-titlebar button.ui-button:focus,
                .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-focus,
                .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-active,
                .ui-dialog .ui-dialog-titlebar button.ui-button.ui-state-hover  {
                    outline:none;
                }

                .ui-dialog .ui-dialog-content{
                    overflow:hidden;
                }

 </style>
    <script type="text/javascript">
        function fnClientValidate() {
            if (!(gfi_CheckEmpty($('#<%=txtCInTime.ClientID%>'), GetMultiMessage('0299', '', '')))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtCInDt.ClientID%>'), GetMultiMessage('0300', '', '')))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtCOutTime.ClientID%>'), GetMultiMessage('0301', '', '')))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtCOutDt.ClientID%>'), GetMultiMessage('0306', '', '')))) {
                return false;
            }
            return true;
        }
        $(document).ready(function () {
            $('#<%=txtOrderNo.ClientID%>').focus();
            idWoLabSeq = "";
            OrdNo = "";
            jobId = "0";

            var dateFormat = "";
            if ($('#<%=hdnDateFormat.ClientID%>').val() == "dd.MM.yyyy") {
                dateFormat = "dd.mm.yy"
            }
            else {
                dateFormat = "dd/mm/yy"
            }

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtCInDt.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat,
                onSelect: function () {
                    $('#<%=txtCOutDt.ClientID%>').val($('#<%=txtCInDt.ClientID%>').val())
                }

            });

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtCOutDt.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: dateFormat

            });
            loadUnsoldTime();
            $('#<%=ddlJob.ClientID%>').empty();
            $('#<%=ddlJob.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            $('#<%=txtCInTime.ClientID%>').change(function (e) {
                fnValidateCInTime();
            });
            $('#<%=txtCOutTime.ClientID%>').change(function (e) {
                fnValidateCOutTime();
            });
            function fnValidateCInTime() {
                if ($('#<%=txtCInTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtCInTime.ClientID%>'));
                }
            }
            function fnValidateCOutTime() {
                if ($('#<%=txtCOutTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtCOutTime.ClientID%>'));
                }
            }


            var getUrlParameter = function getUrlParameter(sParam) {
                var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                    sURLVariables = sPageURL.split('&'),
                    sParameterName,
                    i;

                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('=');

                    if (sParameterName[0] === sParam) {
                        return sParameterName[1] === undefined ? true : sParameterName[1];
                    }
                }
            };
            var mechId = getUrlParameter('MechanicId');
            $('#<%=txtMId.ClientID%>').val(mechId);

            $('#<%=btnCancel.ClientID%>').on('click', function () {
                window.parent.$('.ui-dialog-content:visible').dialog('close');
            });

            $('#<%=btnSave.ClientID%>').on('click', function () {
                var bool;
                bool = fnClientValidate();
                if (bool == true) {
                    var mechId = $('#<%=txtMId.ClientID%>').val();
                    var ordNo = $('#<%=txtOrderNo.ClientID%>').val();
                    var jobNo = jobId;
                    var dtClockIn = $('#<%=txtCInDt.ClientID%>').val();
                    var timeClockIn = $('#<%=txtCInTime.ClientID%>').val();
                    var dtClockOut = $('#<%=txtCOutDt.ClientID%>').val();
                    var timeClockOut = $('#<%=txtCOutTime.ClientID%>').val();
                    var WoLabSeq = idWoLabSeq;
                    var unsoldTime;
                    if ($('#<%=ddlUtime.ClientID%>')[0].selectedIndex == "0") {
                        unsoldTime = "0"
                    }
                    else {
                        unsoldTime = $("#<%=ddlUtime.ClientID%> option:selected").text(); //$('#<%=ddlUtime.ClientID%>').val();

                    }
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmTRegPopUp.aspx/Add_ManualTRDet",
                        data: "{'mechId':'" + mechId + "','ordNo':'" + ordNo + "','jobNo':'" + jobNo + "','dtClockin':'" + dtClockIn + "','timeClockin':'" + timeClockIn + "','dtClockout':'" + dtClockOut + "','timeClockout':'" + timeClockOut + "','idWoLabSeq':'" + WoLabSeq + "','unsoldTime':'" + unsoldTime + "'}",
                        dataType: "json",
                        async: false,//Very important
                        success: function (Result) {
                            var msg;
                            if (Result.d == "TRUE") {
                                $('#<%=RTlblError.ClientID%>').text('Clocked In Successfully');
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                window.parent.$('.ui-dialog-content:visible').dialog('close');
                                window.parent.LoadMechanicData();

                            }
                            else if (Result.d == "TODATE_LESS_FROMDATE") {
                                msg = GetMultiMessage('TODATE_LESS_FROMDATE', '', '');
                                alert(msg);
                            }
                            else if (Result.d == "TODATE_GRTR_DAY") {
                                msg = GetMultiMessage('TODATE_GRTR_DAY', '', '');
                                alert(msg);
                            }
                            else if (Result.d == "TOTIME_GRTR_FRMTIME") {
                                msg = GetMultiMessage('TOTIME_GRTR_FRMTIME', '', '');
                                alert(msg);
                            }
                            else {
                                alert(Result.d);
                            }
                        }
                    });
                }
               
            });

            $('#<%=txtOrderNo.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/GetOrder",
                        data: "{'orderNo':'" + $('#<%=txtOrderNo.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2] + "-" + item.split('-')[3] + "-" + item.split('-')[4],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0],
                                    woNo: item.split('-')[0],
                                    woPr: item.split('-')[5],
                                    Regno: item.split('-')[2],
                                    CustName: item.split('-')[1]
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error Response ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtOrderNo.ClientID%>").val(i.item.woNo);
                    ordNo = $("#<%=txtOrderNo.ClientID%>").val();
                    $("#<%=txtVehicle.ClientID%>").val(i.item.Regno);
                    $("#<%=txtCustomer.ClientID%>").val(i.item.CustName);
                    FetchJobDet(i.item.woNo);
                    if ($('#<%=ddlUtime.ClientID%>')[0].selectedIndex > 0) {
                        $('#<%=ddlUtime.ClientID%>')[0].selectedIndex = 0;
                    }
                }

            });

            var mname = window.parent.document.getElementById('ctl00_cntMainPanel_hdnFirstName').value;
            $('#<%=txtMechName.ClientID%>').val(mname);

            $('#<%=ddlJob.ClientID%>').change(function (e) {
                if ($('#<%=ddlJob.ClientID%>')[0].selectedIndex > 0) {
                    idWoLabSeq = $('#<%=ddlJob.ClientID%>').val();
                    var result;
                    result = $("#<%=ddlJob.ClientID%> option:selected").text();
                    jobId = result[0];
                    FetchInvTime(ordNo, idWoLabSeq);
                }
            });

            $('#<%=ddlUtime.ClientID%>').change(function (e) {
                if ($('#<%=ddlUtime.ClientID%>')[0].selectedIndex > 0) {
                    $('#<%=txtOrderNo.ClientID%>').val('');
                    $('#<%=ddlJob.ClientID%>')[0].selectedIndex = 0;
                    jobId = "0";

                }
            });

          

            $('#<%=txtCOutTime.ClientID%>').change(function (e) {
                var clkIntime = $('#<%=txtCInTime.ClientID%>').val();
                var clkOutTime = $('#<%=txtCOutTime.ClientID%>').val();
                var clkInDt = $('#<%=txtCInDt.ClientID%>').val();
                var clkOutDt = $('#<%=txtCOutDt.ClientID%>').val();

                var clockIn = clkInDt + ' ' + clkIntime
                var clockOut = clkOutDt + ' ' + clkOutTime
                FetchClockTime(clockIn, clockOut);
            });

        });//end of ready

        function FetchJobDet(ordNo)
        {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmTimeRegistration.aspx/FetchJobDet",
                data: "{'OrderNo':'" + ordNo + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    $('#<%=ddlJob.ClientID%>').empty();
                    $('#<%=ddlJob.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlJob.ClientID%>').append($("<option></option>").val(value.Id_WoLab_Seq).html(value.Job_LineNo));
                    });
                    
                }
            });
        }

        function FetchInvTime(ordNo, idWoLabSeq)
        {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmTRegPopUp.aspx/FetchInvoiceTime",
                data: "{'ordNo':'" + ordNo + "','idWoLabSeq':'" + idWoLabSeq + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    debugger;
                    if (Result.d.length > 0) {
                        $('#<%=txtInvTime.ClientID%>').val(Result.d[0].Wo_Lab_Hrs);
                    }
                }
            });
        }

        function FetchClockTime(clockIn, clockOut)
        {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmTRegPopUp.aspx/FetchClktime",
                data: "{'clockIn':'" + clockIn + "','clockOut':'" + clockOut + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    if (Result.d.length > 0) {
                        $('#<%=txtClkTime.ClientID%>').val(Result.d[0].Clocked_Time);
                    }
                }
            });
        }
        function loadUnsoldTime() {
            $.ajax({
                type: "POST",
                url: "frmTimeRegistration.aspx/LoadUnsoldTime",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlUtime.ClientID%>').empty();
                    $('#<%=ddlUtime.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;

                    $.each(Result, function (key, value) {
                        $('#<%=ddlUtime.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                    });
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
       <asp:HiddenField ID="hdnSelect" runat="server" />
       <asp:HiddenField ID="hdnDateFormat" Value="<%$ appSettings:DateFormatValidate %>" runat="server"/>
       <asp:Label ID="RTlblError" runat="server" CssClass="lblErr"></asp:Label>
    <div id="modclkinPopup">
         <div class="content" style="margin-left:20px">
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="inline fields">
                            <div class="two wide field">
                                <label>
                                    <asp:Label ID="lblMId" Text="MechId" runat="server"></asp:Label></label>
                            </div>
                            <div class="two wide field">
                                 <asp:TextBox ID="txtMId" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                           
                            <div class="two wide field">
                            </div>
                               <div class="two wide field">
                                     <label><asp:Label ID="lblMech" Text="Mekaniker" runat="server"></asp:Label></label>
                            </div>
                            <div class="four wide field">
                                   <asp:TextBox ID="txtMechName" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        <div class="inline fields">
                          <div class="two wide field">
                                 <label>
                                    <asp:Label ID="lblOrderNo" Text="Order No" runat="server"></asp:Label></label>
                            </div>
                            <div class="three wide field">
                                <asp:TextBox ID="txtOrderNo" runat="server"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                            </div>
                            <div class="two wide field">
                                 <label>
                                    <asp:Label ID="lblJobNo" Text="JobNo" runat="server"></asp:Label>
                                  </label>
                            </div>
                            <div class="four wide field">
                                <asp:DropDownList ID="ddlJob" CssClass="dropdowns" runat="server" Width="200px"></asp:DropDownList>
                            </div>
                        </div> 
                         <div class="inline fields">
                          <div class="two wide field">
                                 <label>
                                    <asp:Label ID="lblVeh" Text="Vehicle No" runat="server"></asp:Label>
                                 </label>
                            </div>
                            <div class="three wide field">
                                <asp:TextBox ID="txtVehicle" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                            </div>
                            <div class="two wide field">
                                 <label>
                                    <asp:Label ID="lblCustomer" Text="CustomerName" runat="server"></asp:Label>
                                  </label>
                            </div>
                            <div class="four wide field">
                                <asp:TextBox ID="txtCustomer" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>                        
                          <div style="padding:0.5em"></div>
                        <div class="twelve fields">
                         <asp:Label ID="lblCInDt" runat="server" Text="Clock-In Date" Width="100px"></asp:Label>
                        <asp:Label ID="Label10" runat="server" Text="" Width="80px"></asp:Label>
                         <asp:Label ID="lblCInTime" runat="server" Text="Clock-In Time" Width="100px"></asp:Label>
                            <asp:Label ID="Label11" runat="server" Text="" Width="80px"></asp:Label>
                        <asp:Label ID="lblCOutDt" runat="server" Text="Clock-Out Date" Width="100px"></asp:Label>
                            <asp:Label ID="Label12" runat="server" Text="" Width="80px"></asp:Label>
                        <asp:Label ID="lblCOutTime" runat="server" Text="Clock-Out Time" Width="100px"></asp:Label>

                        </div>
                        <div class="twelve fields">
                             <asp:TextBox ID="txtCInDt" runat="server" Width="100px"></asp:TextBox>
                            <asp:Label ID="Label16" runat="server" Text="" Width="80px"></asp:Label>
                             <asp:TextBox ID="txtCInTime" runat="server" Width="100px"></asp:TextBox>
                            <asp:Label ID="Label18" runat="server" Text="" Width="80px"></asp:Label>
                            <asp:TextBox ID="txtCOutDt" runat="server" Width="100px" ></asp:TextBox>
                            <asp:Label ID="Label19" runat="server" Text="" Width="80px"></asp:Label>
                           <asp:TextBox ID="txtCOutTime" runat="server" Width="100px" ></asp:TextBox>
                                                   
                        </div>
                         <div class="twelve fields">
                         <asp:Label ID="LblInvoiceTime" runat="server" Text="Invoice Time" Width="100px"></asp:Label>
                        <asp:Label ID="Label8" runat="server" Text="" Width="80px"></asp:Label>
                         <asp:Label ID="lblOverTime" runat="server" Text="Over Time" Width="100px"></asp:Label>
                            <asp:Label ID="Label13" runat="server" Text="" Width="80px"></asp:Label>
                        <asp:Label ID="lblClkTime" runat="server" Text="Clock Time" Width="100px"></asp:Label>
                            <asp:Label ID="Label15" runat="server" Text="" Width="80px"></asp:Label>
                        <asp:Label ID="LblReason" runat="server" Text="Reason" Width="100px"></asp:Label>

                        </div>
                        <div class="twelve fields">
                             <asp:TextBox ID="txtInvTime" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                            <asp:Label ID="Label20" runat="server" Text="" Width="80px"></asp:Label>
                             <asp:TextBox ID="txtOverTime" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                            <asp:Label ID="Label21" runat="server" Text="" Width="80px"></asp:Label>
                            <asp:TextBox ID="txtClkTime" runat="server" Width="100px" ReadOnly="true" ></asp:TextBox>
                            <asp:Label ID="Label22" runat="server" Text="" Width="80px"></asp:Label>
                           <asp:TextBox ID="txtReason" runat="server" Width="100px" ReadOnly="true" ></asp:TextBox>
                                                   
                        </div>
                      <div style="padding:0.5em"></div>
                     <div class="twelve fields">
                          <asp:Label ID="lblUTime" runat="server" Text="UnsoldTime" Width="100px"></asp:Label>
                      </div>
                     <div class="twelve fields">
                          <asp:DropDownList ID="ddlUtime" CssClass="dropdowns" runat="server" Width="200px"></asp:DropDownList>
                    </div>
                         <div style="padding:0.5em"></div>
                        <div style="text-align:right">
                             <input id="btnSave" runat="server" class="ui button ok positive" value="Save" type="button" />
                             <input id="btnCancel" runat="server" class="ui button cancel negative" value="Avbryt" type="button" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div> 
    </form>
</body>
</html>
