<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCfNewStation.aspx.vb" Inherits="CARS.frmCfNewStation" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 

    <script type="text/javascript">

        function fnClientValidate() {
            if (!(gfi_CheckEmpty($('#<%=txtStatName.ClientID%>'), '0209'))) {
                return false;
            }
            if (!gfb_ValidateAlphabets($('#<%=txtStatName.ClientID%>'), '0209')) {
                return false;
            }
            if ($('#<%=ddlStationType.ClientID%>')[0].selectedIndex == 0) {
                var msg = GetMultiMessage('0007', GetMultiMessage('0196', '', ''), '');
                alert(msg);
                $('#<%=ddlStationType.ClientID%>').focus();
                return false;
            }

            return true;
        }

        $(document).ready(function () {            
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var grid = $("#dgdStation");
            $('#divStation').hide();
            var currentDept = '<%= Session("UserDept")%>';
            var currentDeptName = '<%= Session("DeptName")%>'; 

            if (currentDeptName != "") {
                $('#<%=lblDeptName.ClientID%>').text(currentDeptName);
                $('#<%=btnAddStationT.ClientID%>').removeAttr("disabled");
                $('#<%=btnAddStationB.ClientID%>').removeAttr("disabled");
                $('#<%=btnDelStationT.ClientID%>').removeAttr("disabled");
                $('#<%=btnDelStationB.ClientID%>').removeAttr("disabled");
            } else {
                $('#<%=lblDeptName.ClientID%>').text("");
                $('#<%=btnAddStationT.ClientID%>').attr("disabled", "disabled");
                $('#<%=btnAddStationB.ClientID%>').attr("disabled", "disabled");
                $('#<%=btnDelStationT.ClientID%>').attr("disabled", "disabled");
                $('#<%=btnDelStationB.ClientID%>').attr("disabled", "disabled");
            }




            //Station details
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Station Name', 'Station Type','Id_Station','Id_StationType', ''],
                colModel: [
                         { name: 'Station_Name', index: 'Station_Name', width: 160, sorttype: "string" },
                         { name: 'StationType', index: 'StationType', width: 160, sorttype: "string" },
                         { name: 'Id_Station', index: 'Id_Station', sortable: false, hidden: true },
                         { name: 'Id_StationType', index: 'Id_StationType', sortable: false, hidden: true },
                         { name: 'Id_Station', index: 'Id_Station', sortable: false, formatter:editStation }
                ],
                multiselect: true,
                pager: jQuery('#pagerStation'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Station Details",
                async: false, //Very important,
                subgrid: false

            });

            //LoadDepartment(currentDept);
            LoadStations();
            LoadStationTypes();


            <%--$('#<%=ddlDepartment.ClientID%>').change(function (e) {
                if ($('#<%=ddlDepartment.ClientID%>')[0].selectedIndex > 0) {
                    LoadStations();
                } 
            });--%>

        });//end of ready


        <%--function LoadDepartment(currentDept) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfNewStation.aspx/LoadDepartment",
                data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    $('#<%=ddlDepartment.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlDepartment.ClientID%>').append($("<option></option>").val(value.Id_Dept).html(value.DeptName));
                    });
                }
            });
            $('#<%=ddlDepartment.ClientID%>').val(currentDept);
        }--%>

        function LoadStationTypes() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfNewStation.aspx/LoadStationTypes",
                data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    $('#<%=ddlStationType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlStationType.ClientID%>').append($("<option></option>").val(value.Id_StationType).html(value.StationType));
                    });
                }
            });
        }

        function LoadStations() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var deptId = '<%= Session("UserDept")%>';

            <%--if ($('#<%=ddlDepartment.ClientID%>')[0].selectedIndex == 0) {
                deptId = 0;
            } else { deptId = $('#<%=ddlDepartment.ClientID%>').val(); }--%>

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfNewStation.aspx/LoadStations",
                data: "{deptId:'" + deptId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    jQuery("#dgdStation").jqGrid('clearGridData');
                    if (data.d.length > 0) {                        
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data.d;
                            jQuery("#dgdStation").jqGrid('addRowData', i + 1, mydata[i]);
                        }
                        jQuery("#dgdStation").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdStation").jqGrid("hideCol", "subgrid");
                    }
                }
            });

        }

        function addStation() {
            $('#divStation').show();
            $('#<%=hdnStationId.ClientID%>').val("");
            $('#<%=txtStatName.ClientID%>').val("");
            //$('#<%=ddlStationType.ClientID%>').val("");
            $('#<%=btnAddStationT.ClientID%>').hide();
            $('#<%=btnDelStationT.ClientID%>').hide();
            $('#<%=btnAddStationB.ClientID%>').hide();
            $('#<%=btnDelStationB.ClientID%>').hide();
            $('#<%=btnSaveStation.ClientID%>').show();
            $('#<%=btnResetStation.ClientID%>').show();
            $('#<%=ddlStationType.ClientID%>')[0].selectedIndex = 0;
            $('#<%=hdnMode.ClientID%>').val("Add");
        }

        function resetStation() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divStation').hide();
                $('#<%=txtStatName.ClientID%>').val("");
                $('#<%=btnAddStationT.ClientID%>').show();
                $('#<%=btnAddStationB.ClientID%>').show();
                $('#<%=btnDelStationT.ClientID%>').show();
                $('#<%=btnDelStationB.ClientID%>').show();
                $('#<%=btnSaveStation.ClientID%>').hide();
                $('#<%=btnResetStation.ClientID%>').hide();
                $('#<%=hdnStationId.ClientID%>').val("");
            }
        }

        function editStation(cellvalue, options, rowObject) {
            var idStation = rowObject.Id_Station.toString();
            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            //var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editCompLevelDetails(" + "'" + idCompt + "','" + compLevelDesc + "'" + "); />";
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editStationDetails(" + "'" + idStation + "'" + "); />";
            return edit;
        }

        function editStationDetails(idStation) {
            getStationDetails(idStation);
           // $('#<%=txtStatName.ClientID%>').val(idCompt);
            $('#<%=hdnStationId.ClientID%>').val(idStation);
            
            $('#divStation').show();
            $('#<%=btnAddStationT.ClientID%>').hide();
            $('#<%=btnDelStationT.ClientID%>').hide();
            $('#<%=btnAddStationB.ClientID%>').hide();
            $('#<%=btnDelStationB.ClientID%>').hide();
            $('#<%=btnSaveStation.ClientID%>').show();
            $('#<%=btnResetStation.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");

        }

        function getStationDetails(idStation) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfNewStation.aspx/GetStationDetails",
                data: "{idStation: '" + idStation + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        $('#<%=txtStatName.ClientID%>').val(data.d[0].Station_Name);
                        $('#<%=ddlStationType.ClientID%>').val(data.d[0].Id_StationType);
                    }
                }
            });
        }

        function saveStation() {
            var stationName = $('#<%=txtStatName.ClientID%>').val();
            var idstationType = $('#<%=ddlStationType.ClientID%>').val();
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var idstation = $('#<%=hdnStationId.ClientID%>').val();
            //var idDept = $('#<%=ddlDepartment.ClientID%>').val();
            var idDept = '<%= Session("UserDept")%>';
            var stationType = $('#<%=ddlStationType.ClientID%> option:selected').text();

            var result = fnClientValidate();
            if (result == true) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfNewStation.aspx/SaveStationDetails",
                    data: "{idStation: '" + idstation + "', stationName:'" + stationName + "', idstationType:'" + idstationType + "', idDept:'" + idDept + "', stationType:'" + stationType + "', mode:'" + mode + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        if (data.d[0] == "SAVED" || data.d[0] == "UPDATED") {
                            $('#divStation').hide();
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $('#<%=btnAddStationT.ClientID%>').show();
                            $('#<%=btnAddStationB.ClientID%>').show();
                            $('#<%=btnDelStationT.ClientID%>').show();
                            $('#<%=btnDelStationB.ClientID%>').show();
                            jQuery("#dgdStation").jqGrid('clearGridData');
                            LoadStations();
                            jQuery("#dgdStation").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        }
                        else {
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                    }
                });
            }
        }

        function delStation() {
            var station = "";
            $('#dgdStation input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    station = $('#dgdStation tr ')[row].cells[1].innerHTML.toString();//1-name,3-id
                }
            });

            if (station != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteStationDetails();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteStationDetails() {
            var row;
            var stationid;
            var stationdesc;
            var stationidxml;
            var stationidxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            //var deptId = $('#<%=ddlDepartment.ClientID%>').val();
            var deptId = '<%= Session("UserDept")%>';

            $('#dgdStation input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    stationid = $('#dgdStation tr ')[row].cells[3].innerHTML.toString();
                    stationdesc = $('#dgdStation tr ')[row].cells[1].innerHTML.toString();
                    stationidxml = '<DELETE ID_DEPT= "' + deptId + '" ID_STATION= "' + stationid + '" NAME_STATION= "' + stationdesc + '"></DELETE>';
                    stationidxmls += stationidxml;
                }
            });

            if (stationidxmls != "") {
                stationidxmls = "<ROOT>" + stationidxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfNewStation.aspx/DeleteStation",
                    data: "{delxml: '" + stationidxmls + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d[0] == "DEL") {
                            $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            jQuery("#dgdStation").jqGrid('clearGridData');
                            LoadStations();
                            jQuery("#dgdStation").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divStation').hide();
                        }
                        else if (data.d[0] == "NDEL") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }


    </script>




     <div class="header1 two fields" style="padding-top:0.5em">
        <asp:Label ID="lblHead" runat="server" Text="Station Master Configuration" ></asp:Label>
        <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
        <asp:HiddenField id="hdnPageSize" runat="server" />                
        <asp:HiddenField id="hdnMode" runat="server" /> 
        <asp:HiddenField id="hdnSelect" runat="server" />  
        <asp:HiddenField id="hdnStationId" runat="server" />  
        <asp:HiddenField id="hdnEditCap" runat="server" />
    </div>
    
    <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
        <a class="item" id="a2" runat="server" >Station Details</a>
    </div>
    <div>
        <div>
            <asp:Label ID="lblDepartment" runat="server" Text="Department : " ></asp:Label>
            <asp:Label ID="lblDeptName" runat="server" Text="" ></asp:Label>
            <asp:DropDownList runat="server" ID="ddlDepartment" Visible="false"></asp:DropDownList>
        </div>
    </div> 
    <div> 
        <div style="text-align:left;padding-left:5em;padding-top:2em;padding-bottom:1em;">
            <input id="btnAddStationT" runat="server" type="button" value="Add" class="ui button"  onclick="addStation()"/>
            <input id="btnDelStationT" runat="server" type="button" value="Delete" class="ui button" onclick="delStation()"/>
        </div>  
        <div>
            <table id="dgdStation" title="Station Details" ></table>
            <div id="pagerStation"></div>
        </div>         
        <div style="text-align:left;padding-left:5em;padding-top:1em;">
            <input id="btnAddStationB" runat="server" type="button" value="Add" class="ui button" onclick="addStation()"/>
            <input id="btnDelStationB" runat="server" type="button" value="Delete" class="ui button" onclick="delStation()"/>
        </div>
        <div id="divStation" style="text-align:left;padding-top:2em;">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server" >Station Details</a>
            </div>
            <div class="ui form" style="width: 100%;">
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblStatName" runat="server" Text="Station Name"></asp:Label><span class="mand">*</span>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:TextBox ID="txtStatName"  padding="0em" runat="server"></asp:TextBox>
                    </div>                            
                </div>
                <div class="four fields">
                    <div class="field" style="width:180px">
                        <asp:Label ID="lblStationType" runat="server" Text="Station Type"></asp:Label><span class="mand">*</span>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:DropDownList runat="server" ID="ddlStationType"></asp:DropDownList>
                    </div>                            
                </div>
            </div>             

            <div style="text-align:left;padding-left:10em;padding-top:2em;">
                <input id="btnSaveStation" class="ui button" runat="server"  value="Save" type="button" onclick="saveStation()"/>
                <input id="btnResetStation" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetStation()" />
            </div>               
        </div>
    </div>



</asp:Content>