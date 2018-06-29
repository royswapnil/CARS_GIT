<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmWODefectNotes.aspx.vb" Inherits="CARS.frmWODefectNotes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Defect Note</title>
    <script type="text/javascript" src="../Scripts/jquery-2.1.4.min.js"></script>
     <script type="text/javascript" src="../javascripts/jquery-ui.js"></script>
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
     <link href= "../CSS/ui.jqgrid.css" rel="stylesheet" type="text/css"/>
     <link href= "../CSS/jquery-ui.css" rel="stylesheet" type="text/css"/>
     <link href= "../Content/semantic.css" rel="stylesheet" type="text/css"/>
    <link href= "../CSS/Msg.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        $(document).ready(function () {
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
            var vehId = getUrlParameter('VID');
            var vehRegNo = getUrlParameter('RegNo');
            var vehInternalNo = getUrlParameter('InternalNo');
            var vehVIN = getUrlParameter('VIN');
            $('#<%=lbl_DefectNote.ClientID%>').text(vehRegNo + "-" + vehInternalNo+ "-" + vehVIN);

           
            var grid = $("#dgdDefectNotes");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var defectNoteData;

            grid.jqGrid({
                datatype: "local",
                data: defectNoteData,
                colNames: ['DefectId', 'Description', 'Status', 'DT_CREATED', 'VehSeq', 'OrderNo', 'isSTATUS'],
                colModel: [
                         { name: 'DefectId', index: 'DefectId', width: 40, sortable: false},
                         { name: 'Description', index: 'Description', width: 180, sorttype: "string" },
                         { name: 'Status', index: 'Status', width: 200, sorttype: "string"},
                         { name: 'DT_CREATED', index: 'DT_CREATED', width: 160, sorttype: "string", hidden: true },
                         { name: 'Id_Veh_Seq_WO', index: 'Id_Veh_Seq_WO', width: 80, sorttype: "string", hidden: true },
                         { name: 'OrderNo', index: 'OrderNo', width: 80, sorttype: "string", hidden: true },
                         { name: 'isSTATUS', index: 'isSTATUS', hidden: true },
                         

                ],
                multiselect: true,
                pager: jQuery('#pagerDefectNotes'),
                rowNum: 5,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                async: false, //Very important,
                subGrid: false

            });
            sortorder: 'asc',
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmWODefectNotes.aspx/Fetch_DefectNotes",
                data: "{'vehicleNo':'" + vehId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        defectNoteData = data;
                        jQuery("#dgdDefectNotes").jqGrid('addRowData', i + 1, defectNoteData.d[i]);

                    }
                }
            });
           
            jQuery("#dgdDefectNotes").setGridParam({ rowNum: 5 }).trigger("reloadGrid");
            $("#dgdDefectNotes").jqGrid("hideCol", "subGrid");
           

            $('#<%=txtSrchVeh.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWOHead.aspx/GetVehicle",
                        data: "{'vehicleRegNo':'" + $('#<%=txtSrchVeh.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0]
                                }
                            }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            <%--$('#systemMSG').hide();--%>
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    $("#<%=txtSrchVeh.ClientID%>").val(i.item.value);
                }
            });

            $('#<%=chkHistory.ClientID%>').click(function (event) {
                if (this.checked) {
                    var myGrid = $('#dgdDefectNotes');
                    var colPos = 3;
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                }
                else
                {
                    var myGrid = $('#dgdDefectNotes');
                    var colPos = 4;
                    myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                }
                
            });
            $('#<%=chkAllVehicles.ClientID%>').click(function (event) {
                if (this.checked) {
                    var myGrid = $('#dgdDefectNotes');
                    var colPos = 4;
                    var colPosn = 5;
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                    myGrid.jqGrid('showCol', myGrid.getGridParam("colModel")[colPosn + 1].name);
                }
                else {
                    var myGrid = $('#dgdDefectNotes');
                    var colPos = 5;
                    var colPosn = 6;
                    myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPos + 1].name);
                    myGrid.jqGrid('hideCol', myGrid.getGridParam("colModel")[colPosn + 1].name);
                }

            });
            $('#<%=btnSearch.ClientID%>').on('click', function () {
                var vehId = $("#<%=txtSrchVeh.ClientID%>").val();
                LoadDefectGrid(vehId);
            });
            $('#<%=btnSave.ClientID%>').on('click', function () {
                if ($("#<%=txtSrchVeh.ClientID%>").val() != "")
                {
                    var vehId = $("#<%=txtSrchVeh.ClientID%>").val();
                    SaveDefects(vehId);
                    $('#<%=lbl_DefectNote.ClientID%>').text("");
                }
                else
                {
                    var vehId = getUrlParameter('VID');
                    SaveDefects(vehId);
                }
                
                LoadDefectGrid(vehId);
            });

            $('#<%=btnCreateWO.ClientID%>').on('click', function () {
                CreateWO();
            });
            
        });

        function CreateWO() {
            var DefectId;
            var DefectNote;
            $('#dgdDefectNotes input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    DefectId = $('#dgdDefectNotes tr ')[row].cells[1].innerText.toString();
                    DefectNote = $('#dgdDefectNotes tr ')[row].cells[2].innerText.toString();
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWODefectNotes.aspx/CreateWO",
                        data: "{DefectId: '" + DefectId + "',DefectNote:'" + DefectNote + "'}",
                        dataType: "json",
                        async: false,
                        success: function (data) {
                            var defect = data.d.toString();
                            window.close();
                        },
                        error: function (result) {
                            alert("Error");
                        }
                    });
                    return true
                }
            });
              
          }


        function SaveDefects(vehId)
        {
            var defectText = $("#<%=txtDefect.ClientID%>").val();
            var userId = '<%= Session("UserID")%>';
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmWODefectNotes.aspx/SaveDefect",
                data: "{idVehicle: '" + vehId + "',defectDesc:'" + defectText + "',userId:'" + userId + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    $("#<%=RTlblError.ClientID%>").text("Saved");
                },
                error: function (result) {
                    alert("Error");
                }
            });
        }
        function LoadDefectGrid(vehId)
        {
            var grid = $("#dgdDefectNotes");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var defectNoteData;

            grid.jqGrid({
                datatype: "local",
                data: defectNoteData,
                colNames: ['DefectId', 'Description', 'Status', 'DT_CREATED', 'VehSeq', 'OrderNo', 'isSTATUS'],
                colModel: [
                         { name: 'DefectId', index: 'DefectId', width: 40, sortable: false },
                         { name: 'Description', index: 'Description', width: 180, sorttype: "string" },
                         { name: 'Status', index: 'Status', width: 200, sorttype: "string" },
                         { name: 'DT_CREATED', index: 'DT_CREATED', width: 160, sorttype: "string", hidden: true },
                         { name: 'Id_Veh_Seq_WO', index: 'Id_Veh_Seq_WO', width: 80, sorttype: "string", hidden: true },
                         { name: 'OrderNo', index: 'OrderNo', width: 80, sorttype: "string", hidden: true },
                         { name: 'isSTATUS', index: 'isSTATUS', hidden: true },


                ],
                multiselect: true,
                pager: jQuery('#pagerDefectNotes'),
                rowNum: 5,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                async: false, //Very important,
                subGrid: false

            });
            sortorder: 'asc',
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmWODefectNotes.aspx/Fetch_DefectNotes",
                data: "{'vehicleNo':'" + vehId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    jQuery("#dgdDefectNotes").jqGrid('clearGridData');
                    if (data.d.length != 0)
                    {
                        for (i = 0; i < data.d.length; i++) {
                            defectNoteData = data;
                            jQuery("#dgdDefectNotes").jqGrid('addRowData', i + 1, defectNoteData.d[i]);

                        }
                    }
                    else
                    {
                        $("#<%=RTlblError.ClientID%>").text("No Records Found.");
                    }
                }
            });

            jQuery("#dgdDefectNotes").setGridParam({ rowNum: 5 }).trigger("reloadGrid");
            $("#dgdDefectNotes").jqGrid("hideCol", "subGrid");
        }
     </script>
    </head>
    <body>
<form id="form1" runat="server">
     <asp:HiddenField ID="hdnPageSize" runat="server"  Value="5"/>
        <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
         <asp:Label ID="lblOrderNotInvoiced" runat="server" Text="Defect Notes"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
     </div>
   <div class="ui form" style="width:100%">
       <div class="four fields">
           <div class="field" style="padding-left:1em;width:200px">
               <asp:CheckBox ID="chkHistory" runat="server" Checked="false" />
               <asp:Label ID="lblHistory" runat="server" Text="Show History"></asp:Label>
            </div>
           <div class="field" style="padding-left:1em;width:200px">
               <asp:CheckBox ID="chkAllVehicles" runat="server" Checked="false"/>
               <asp:Label ID="lblAllVehicles" runat="server" Text="Show All Vehicles Defect List"></asp:Label>
            </div>
       </div>
       <div class="two fields">
           <div class="field" style="padding-left:1em;width:200px">
                <asp:Label ID="lbl_DefectNote" runat="server"></asp:Label>
            </div>
       </div>
    <div class="four fields">
         <table id="dgdDefectNotes" title="Spare Parts"></table>
          <div id="pagerDefectNotes"></div>
    </div>
       <div class="four fields">
           <div class="field">
               </div>
       </div>
     <div class="six fields">
         <div class="field">
               <asp:Label id="lblVehSeq" runat="server" Text="Vehicle Number" style="width:110px"></asp:Label>
               <asp:TextBox ID="txtSrchVeh" CssClass="inp" runat="server" Width="100px"></asp:TextBox>
                <input id="btnSearch" runat="server" class="ui button"  value="Search" type="button"/>
            </div>
     </div>
    <div class="four fields">
         <div class="field">
               <asp:Label id="lblDefect" runat="server" Text="Defect Description" style="width:100px"></asp:Label>
               <asp:TextBox ID="txtDefect" CssClass="inp" runat="server" Width="100px" ></asp:TextBox>
            </div>
     </div>
    <div id="divDefectNote" style="text-align:center">
         <input id="btnSave" runat="server" class="ui button"  value="Save" type="button"/>
        <input id="btnCancel" runat="server" class="ui button"  value="Cancel" type="button" onclick="window.close();" />
        <input id="btnCreateWO" runat="server" class="ui button"  value="CreateWO" type="button"/>
    </div>
           </div>

    </form>
    </body>
    </html>