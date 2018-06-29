<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ScanDataImportScheduler.aspx.vb" Inherits="CARS.ScanDataImportScheduler" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">

        function fnClientValidate() {
            if (!(gfi_CheckEmpty($('#<%=txtImportName.ClientID%>'), 'FUIMPORTNAME'))) {
                $('#<%=txtImportName.ClientID%>').focus();
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%= txtFileLocation.ClientID%>'), 'FU032'))) {
                $('#<%= txtFileLocation.ClientID%>').focus();
                return false;
            }

            if ((document.getElementById('<%= rbtnDaily.ClientID%>').checked == false) && (document.getElementById('<%= rbtnWeekly.ClientID%>').checked == false) && (document.getElementById('<%= rbtnMonthly.ClientID%>').checked == false)) {
                alert(GetMultiMessage('FU034', '', ''))
                return false;
            }
            if (document.getElementById('<%= rbtnDaily.ClientID%>').checked == true) {
                if (!(gfi_CheckEmpty($('#<%= txtDailyEvery.ClientID%>'), '0532'))) {
                    $('#<%= txtDailyEvery.ClientID%>').focus();
                    return false;
                }

                if ($('#<%= txtDailyEvery.ClientID%>').val() == "0") {
                    msg = GetMultiMessage('1779', '', '');
                    alert(msg);
                    $('#<%= txtDailyEvery.ClientID%>').focus();
                    return false;
                }

                if (!(gfi_ValidateNumber($('#<%= txtDailyEvery.ClientID%>'), '0532'))) {
                    $('#<%= txtDailyEvery.ClientID%>').focus();
                    return false;
                }

                if (document.getElementById('<%= drpdailyHM.ClientID %>').selectedIndex == 0 && document.getElementById('<%= txtDailyEvery.ClientID%>').value > 24) {
                    msg = GetMultiMessage('1775', '', '');
                    alert(msg);
                    document.getElementById('<%= drpdailyHM.ClientID %>').focus();
                    return false
                }

                if (document.getElementById('<%= drpdailyHM.ClientID %>').selectedIndex == 1 && document.getElementById('<%= txtDailyEvery.ClientID%>').value > 60) {
                    msg = GetMultiMessage('1776', '', '');
                    alert(msg);
                    document.getElementById('<%= drpdailyHM.ClientID %>').focus();
                    return false
                }

                if (!(gfi_CheckEmpty($('#<%= txtDailyStTime.ClientID%>'), '0532'))) {
                    document.getElementById('<%= txtDailyStTime.ClientID %>').focus();
                    return false;
                }

                if (!(IsValidTime(document.getElementById('<%= txtDailyStTime.ClientID%>').value))) {
                    document.getElementById('<%= txtDailyStTime.ClientID%>').value = "";
                    document.getElementById('<%= txtDailyStTime.ClientID%>').focus();
                    return false;
                }

                if (!(gfi_CheckEmpty($('#<%= txtDailyEndTime.ClientID%>'), '0532'))) {
                    $('#<%= txtDailyEndTime.ClientID%>').focus();
                    return false;
                }

                if (!(IsValidTime(document.getElementById('<%= txtDailyEndTime.ClientID %>').value))) {
                    document.getElementById('<%= txtDailyEndTime.ClientID%>').value = "";
                    document.getElementById('<%= txtDailyEndTime.ClientID %>').focus();
                    return false;
                }
            }
            if (document.getElementById('<%= rbtnWeekly.ClientID%>').checked == true) {
                if (!(gfi_CheckEmpty($('#<%= txtWeeklyTime.ClientID%>'), '0532'))) {
                    $('#<%= txtWeeklyTime.ClientID%>').focus();
                    return false;
                }

                if (!(IsValidTime(document.getElementById('<%= txtWeeklyTime.ClientID%>').value))) {
                    document.getElementById('<%= txtWeeklyTime.ClientID%>').value = "";
                    document.getElementById('<%= txtWeeklyTime.ClientID%>').focus();
                    return false;
                }
            }
            if (document.getElementById('<%= rbtnMonthly.ClientID%>').checked == true) {
                if (!(gfi_CheckEmpty($('#<%= txtMonthlyTime.ClientID%>'), '0532'))) {
                    $('#<%= txtMonthlyTime.ClientID%>').focus();
                    return false;
                }

                if (!(IsValidTime(document.getElementById('<%= txtMonthlyTime.ClientID%>').value))) {
                    document.getElementById('<%= txtMonthlyTime.ClientID%>').value = "";
                    document.getElementById('<%= txtMonthlyTime.ClientID%>').focus();
                    return false;
                }
            }
            return true;
        }


        $(document).ready(function () {
            var mydata;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var grid = $("#dgdScheduler");

            $('#divScheduler').hide();

            $(document).on('click', '#<%=rbtnDaily.ClientID%>', function () {
                fnChangeMode();
            });

            $(document).on('click', '#<%=rbtnWeekly.ClientID%>', function () {
                fnChangeMode();
            });

            $(document).on('click', '#<%=rbtnMonthly.ClientID%>', function () {
                fnChangeMode();
            });

            //Scheduler
            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Import Name','File','Description','Schedule','ScheduleId', ''],
                colModel: [
                         { name: 'Import_Name', index: 'Import_Name', width: 160, sorttype: "string" },
                         { name: 'FileLocation', index: 'FileLocation', width: 160, sorttype: "string" },
                         { name: 'Import_Description', index: 'Import_Description', width: 160, sorttype: "string" },
                         { name: 'Sch_Base', index: 'Sch_Base', width: 160, sorttype: "string" },
                         { name: 'Sch_Id', index: 'Sch_Id', sortable: false,hidden:true},
                         { name: 'Sch_Id', index: 'Sch_Id', sortable: false, formatter: editSchedule }
                ],
                multiselect: true,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "Schedule",
                async: false, //Very important,
                subgrid: false

            });
            loadScanDataImpSch();

            function fnChangeMode() {
                if (document.getElementById('<%=rbtnDaily.ClientID%>').checked == true) {
                    enableDisableDaily(false)
                    enableDisableWeek(true)
                    enableDisableMonth(true)
                }
                if (document.getElementById('<%=rbtnWeekly.ClientID%>').checked == true) {
                    enableDisableDaily(true)
                    enableDisableWeek(false)
                    enableDisableMonth(true)
                }
                if (document.getElementById('<%=rbtnMonthly.ClientID%>').checked == true) {
                    enableDisableDaily(true)
                    enableDisableWeek(true)
                    enableDisableMonth(false)
                }
            }

            $('#<%=txtDailyStTime.ClientID%>').change(function (e) {
                if ($('#<%=txtDailyStTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtDailyStTime.ClientID%>'));
                }
            });

            $('#<%=txtDailyEndTime.ClientID%>').change(function (e) {
                if ($('#<%=txtDailyEndTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtDailyEndTime.ClientID%>'));
                }

                if ($('#<%=txtDailyEndTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtDailyEndTime.ClientID%>'));
                    if (!(IsValidTime($('#<%=txtDailyEndTime.ClientID%>').val()))) {
                        $('#<%=txtDailyEndTime.ClientID%>').val("");
                        $('#<%=txtDailyEndTime.ClientID%>').focus();
                        return false;
                    }
                }
            });

            $('#<%=txtWeeklyTime.ClientID%>').change(function (e) {
                if ($('#<%=txtWeeklyTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtWeeklyTime.ClientID%>'));
                }

                if ($('#<%=txtWeeklyTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtWeeklyTime.ClientID%>'));
                    if (!(IsValidTime($('#<%=txtWeeklyTime.ClientID%>').val()))) {
                        $('#<%=txtWeeklyTime.ClientID%>').val("");
                        $('#<%=txtWeeklyTime.ClientID%>').focus();
                        return false;
                    }
                }
            });

            $('#<%=txtMonthlyTime.ClientID%>').change(function (e) {
                if ($('#<%=txtMonthlyTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtMonthlyTime.ClientID%>'));
                }

                if ($('#<%=txtMonthlyTime.ClientID%>').val() != '') {
                    Validatetime($('#<%=txtMonthlyTime.ClientID%>'));
                    if (!(IsValidTime($('#<%=txtMonthlyTime.ClientID%>').val()))) {
                        $('#<%=txtMonthlyTime.ClientID%>').val("");
                        $('#<%=txtMonthlyTime.ClientID%>').focus();
                        return false;
                    }
                }
            });

        });//end of ready


        function loadScanDataImpSch() {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ScanDataImportScheduler.aspx/LoadScanDataImpSch",
                data: "{}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {
                        jQuery("#dgdScheduler").jqGrid('clearGridData');
                        for (i = 0; i < data.d.length; i++) {
                            mydata = data;
                            jQuery("#dgdScheduler").jqGrid('addRowData', i + 1, mydata.d[i]);
                        }
                        jQuery("#dgdScheduler").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#dgdScheduler").jqGrid("hideCol", "subgrid");
                    }
                }
            });
        }

        function editSchedule(cellvalue, options, rowObject) {
            var schId = rowObject.Sch_Id.toString();

            $(document.getElementById('<%=hdnEditCap.ClientID%>')).val("Edit"); //Need to be set based on language
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=editScheduleDetails(" + "'" + schId + "'" + "); />";
            return edit;
        }

        function editScheduleDetails(schId) {
            $('#divScheduler').show();
            $('#<%=hdnIdScheduler.ClientID%>').val(schId);
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $('#<%=hdnMode.ClientID%>').val("Edit");

            getScheduleDetails(schId);
        }

        function getScheduleDetails(schId) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ScanDataImportScheduler.aspx/FetchScheduleDetails",
                data: "{schId: '" + schId + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d.length > 0) {
                        data = data.d[0];

                        $('#<%=txtFileLocation.ClientID%>').val(data.FileLocation);
                        $('#<%=txtImportName.ClientID%>').val(data.Import_Name);
                        $('#<%=txtDescription.ClientID%>').val(data.Import_Description);

                        if (data.Sch_Basis == "D") {
                            enableDisableDaily(false);
                            enableDisableWeek(true);
                            enableDisableMonth(true);
                            $('#<%=rbtnDaily.ClientID%>').attr('checked', true);
                            $('#<%=txtDailyEvery.ClientID%>').val(data.Sch_Daily_Interval_mins);
                            $('#<%=txtDailyStTime.ClientID%>').val(data.Sch_Daily_STime);
                            $('#<%=txtDailyEndTime.ClientID%>').val(data.Sch_Daily_ETime);
                            $('#<%=drpdailyHM.ClientID%> option:contains("' + data.Sch_TimeFormat + '")').attr('selected', 'selected');
                        } else if (data.Sch_Basis == "M") {
                            enableDisableDaily(true);
                            enableDisableWeek(true);
                            enableDisableMonth(false);
                            $('#<%=rbtnMonthly.ClientID%>').attr('checked', true);
                            $('#<%=txtMonthlyTime.ClientID%>').val(data.Sch_Month_Time);
                            $('#<%=ddlMonthly.ClientID%>')[0].selectedIndex = data.Sch_Month_Day;

                        } else if (data.Sch_Basis == "W") {
                            enableDisableDaily(true);
                            enableDisableWeek(false);
                            enableDisableMonth(true);
                            $('#<%=rbtnWeekly.ClientID%>').attr('checked', true);
                            $('#<%=ddlWeeklyEvery.ClientID%>')[0].selectedIndex = data.Sch_Week_Day;
                            $('#<%=txtWeeklyTime.ClientID%>').val(data.Sch_Week_Time);
                        }
                    }
                },
                error: function (result) {
                    alert("Error");
                }
            });
        }


        function enableDisableDaily(VisibleType) {
            document.getElementById('<%=txtDailyEvery.ClientID%>').disabled = VisibleType;
            document.getElementById('<%=txtDailyStTime.ClientID%>').disabled = VisibleType;
            document.getElementById('<%=txtDailyEndTime.ClientID%>').disabled = VisibleType;
        }

        function enableDisableWeek(VisibleType) {
            document.getElementById('<%=ddlWeeklyEvery.ClientID%>').disabled = VisibleType;
            document.getElementById('<%=txtWeeklyTime.ClientID%>').disabled = VisibleType;
        }

        function enableDisableMonth(VisibleType) {
            document.getElementById('<%=ddlMonthly.ClientID%>').disabled = VisibleType;
            document.getElementById('<%=txtMonthlyTime.ClientID%>').disabled = VisibleType;
        }

        function addScheduler() {
            $('#divScheduler').show();
            $('#<%=txtImportName.ClientID%>').val("");
            $('#<%=txtFileLocation.ClientID%>').val("");
            $('#<%=txtDescription.ClientID%>').val("");
            $('#<%=txtWeeklyTime.ClientID%>').val("");
            $('#<%=txtMonthlyTime.ClientID%>').val("");
            $('#<%=btnAddT.ClientID%>').hide();
            $('#<%=btnDelT.ClientID%>').hide();
            $('#<%=btnAddB.ClientID%>').hide();
            $('#<%=btnDelB.ClientID%>').hide();
            $('#<%=btnSave.ClientID%>').show();
            $('#<%=btnReset.ClientID%>').show();
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
            $('#<%=hdnIdScheduler.ClientID%>').val("");
            $('#<%=txtImportName.ClientID%>').focus();
            enableDisableDaily(false);
            enableDisableWeek(true);
            enableDisableMonth(true);
            $('#<%=rbtnDaily.ClientID%>').attr('checked', true);
        }

        function resetScheduler() {
            var msg = GetMultiMessage('0161', '', '');
            var r = confirm(msg);
            if (r == true) {
                $('#divScheduler').hide();
                $('#<%=txtImportName.ClientID%>').val("");
                $('#<%=txtFileLocation.ClientID%>').val("");
                $('#<%=txtDescription.ClientID%>').val("");
                $('#<%=btnAddT.ClientID%>').show();
                $('#<%=btnDelT.ClientID%>').show();
                $('#<%=btnAddB.ClientID%>').show();
                $('#<%=btnDelB.ClientID%>').show();
                $('#<%=btnSave.ClientID%>').hide();
                $('#<%=btnReset.ClientID%>').hide();
                $('#<%=hdnIdScheduler.ClientID%>').val("");
            }
        }

        function saveScheduler() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var result = fnClientValidate();
            if (result == true) {
                var importName = $('#<%=txtImportName.ClientID%>').val();
                var fileLocation = $('#<%=txtFileLocation.ClientID%>').val();
                var description = $('#<%=txtDescription.ClientID%>').val();
                var schBasis, schDailyTimeFormat, schDailyIntMins, schDailyStTime, schDailyEndTime, schWeekDay, schWeekTime, schMonthDay, schMonthTime;
                var schId = $('#<%=hdnIdScheduler.ClientID%>').val();

                fileLocation = fileLocation.replace(/\\/g, "/");

                if ($("#<%=rbtnDaily.ClientID%>").is(':checked')) {
                    schBasis = "D";
                    schDailyTimeFormat = $("#<%=drpdailyHM.ClientID%>").val();
                    schDailyIntMins = $("#<%=txtDailyEvery.ClientID%>").val();
                    schDailyStTime = $("#<%=txtDailyStTime.ClientID%>").val();
                    schDailyEndTime = $("#<%=txtDailyEndTime.ClientID%>").val();
                    schWeekDay = "0";
                    schWeekTime = "";
                    schMonthDay = "0";
                    schMonthTime = "";

                } else if ($("#<%=rbtnWeekly.ClientID%>").is(':checked')) {
                    schBasis = "W";
                    schWeekDay = $('#<%=ddlWeeklyEvery.ClientID%>')[0].selectedIndex;
                    schWeekTime = $("#<%=txtWeeklyTime.ClientID%>").val();
                    schDailyTimeFormat = "";
                    schDailyIntMins = "0";
                    schDailyStTime = "";
                    schDailyEndTime = "";
                    schMonthDay = "1";
                    schMonthTime = "";
                } else if ($("#<%=rbtnMonthly.ClientID%>").is(':checked')) {
                    schBasis = "M";
                    schMonthDay = $("#<%=ddlMonthly.ClientID%>").val();
                    schMonthTime = $("#<%=txtMonthlyTime.ClientID%>").val();
                    schWeekDay = "0";
                    schWeekTime = "";
                    schDailyTimeFormat = "";
                    schDailyIntMins = "0";
                    schDailyStTime = "";
                    schDailyEndTime = "";
                }               


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ScanDataImportScheduler.aspx/SaveScanDataImpScheduler",
                    data: "{fileLocation:'" + fileLocation + "', importName:'" + importName + "', description:'" + description + 
                        "', schBasis:'" + schBasis + "', schDailyTimeFormat:'" + schDailyTimeFormat + "', schDailyIntMins:'" + schDailyIntMins + "', schDailyStTime:'" + schDailyStTime +
                        "', schDailyEndTime:'" + schDailyEndTime + "', schWeekDay:'" + schWeekDay + "', schWeekTime:'" + schWeekTime + "', schMonthDay:'" + schMonthDay + "', schMonthTime:'" + schMonthTime + "', schId:'" + schId + "', mode:'" + mode +
                         "'}",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        //data = data.d[0];
                        if (data.d.length > 0) {
                            if (data.d[0] == "0") {
                                $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                                loadScanDataImpSch();
                                $('#divScheduler').hide();
                                $('#<%=btnAddT.ClientID%>').show();
                                $('#<%=btnDelT.ClientID%>').show();
                                $('#<%=btnAddB.ClientID%>').show();
                                $('#<%=btnDelB.ClientID%>').show();

                            }
                            else if (data.d[0] == "Invalid") {
                                $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('FLNV', '', ''));
                                $('#<%=RTlblError.ClientID%>').removeClass();
                                $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                            }
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }
        }
        
        function delScheduler() {
            var schId = "";
            $('#dgdScheduler input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    schId = $('#dgdScheduler tr ')[row].cells[5].innerHTML.toString();
                }
            });

            if (schId != "") {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteScheduler();
                }
            }
            else {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteScheduler() {
            var row;
            var schId;
            var schIdxml;
            var schIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var schIdarr = [pageSize];
            var i = 0;

            $('#dgdScheduler input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    schId = $('#dgdScheduler tr ')[row].cells[5].innerHTML.toString();
                    schIdxml = '<delete><SchId= "' + schId + '"/></delete>';
                    schIdxmls += schIdxml;
                    schIdarr[i] = schId;
                    i=i+1;
                }
            });

            if (schIdxmls != "") {
                schIdxmls = "<root>" + schIdxmls + "</root>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ScanDataImportScheduler.aspx/DeleteScheduler",
                    data: "{delschIds: '" + schIdarr + "'}",
                    dataType: "json",
                    success: function (data) {
                        jQuery("#dgdScheduler").jqGrid('clearGridData');
                        jQuery("#dgdScheduler").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $('#divScheduler').hide();
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        if (data.d[0] == "0") {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            loadScanDataImpSch();
                        }
                        else {
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


     <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblHeader" runat="server" Text="Scan Data Import Scheduler"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />
         <asp:HiddenField id="hdnIdScheduler" runat="server" />  
     </div>

     <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1;">
         <a class="item" id="a2" runat="server" >Scan Data Import Scheduler</a>
     </div> 
     <div> 
        <div style="text-align:left;padding-left:20em;padding-bottom:1em;">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button"  onclick="addScheduler()"/>
            <input id="btnDelT" runat="server" type="button" value="Delete" class="ui button" onclick="delScheduler()"/>
        </div>  
        <div >
            <table id="dgdScheduler" title="Scan Data Import Scheduler" ></table>
            <div id="pager"></div>
        </div>         
        <div style="text-align:left;padding-left:20em;padding-top:1em;">
            <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addScheduler()"/>
            <input id="btnDelB" runat="server" type="button" value="Delete" class="ui button" onclick="delScheduler()"/>
        </div>
        <div id="divScheduler">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="active item" id="aheader" runat="server" >Scan Data Import Scheduler</a>
            </div>
            <div class="ui form" style="width: 100%;padding-left:1em;">
                <div class="four fields">
                    <div class="field" style="width:160px;padding-left:1em;">
                        <asp:Label ID="lblImportName" runat="server" Text="Import Name"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:TextBox ID="txtImportName"  padding="0em" runat="server" MaxLength="20"></asp:TextBox>
                    </div>  
                     <div class="field" style="width:180px;padding-left:4em;">
                        <asp:Label ID="lblDescription" runat="server" Text="Description"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:TextBox ID="txtDescription"  padding="0em" runat="server" MaxLength="20"></asp:TextBox>
                    </div>  
                     <div class="field" style="width:180px;padding-left:4em;">
                        <asp:Label ID="lblFileLocation" runat="server" Text="File Location"></asp:Label>
                    </div>
                    <div class="field" style="width:200px">
                        <asp:TextBox ID="txtFileLocation"  padding="0em" runat="server" MaxLength="100"></asp:TextBox>
                    </div>                            
                </div>
             <div class="ui form" style="padding-left:1em;">
                <div class="ui secondary vertical menu" style="width: 90%; background-color: #c9d7f1;">
                    <a id="A8" runat="server" class="active item">Schedule</a>  
                </div>
                <div class="four fields">
                    <div class="field" style="width:100px">
                        <asp:RadioButton ID="rbtnDaily" GroupName="grpSchedule" runat="server" Text="Daily" Width="60px"  />
                    </div>
                    <div class="field" style="width:70px">
                        <asp:Label ID="lblEvery" runat="server" Text="Every" Width="60px"></asp:Label>
                    </div>    
                    <div class="field" style="width:100px">
                        <asp:TextBox ID="txtDailyEvery" runat="server" Width="80px" ></asp:TextBox>
                    </div>
                    <div class="field" style="width:150px">
                        <asp:DropDownList ID="drpdailyHM" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                    </div> 
                    <div class="field" style="width:70px">
                        <asp:Label ID="lblStartTime" runat="server" Text="Start Time" Width="80px"></asp:Label>
                    </div>    
                    <div class="field" style="width:100px">
                        <asp:TextBox ID="txtDailyStTime" runat="server" Width="80px" ></asp:TextBox>
                    </div>  
                    <div class="field" style="width:70px">
                        <asp:Label ID="lblEndTime" runat="server" Text="End Time" Width="60px"></asp:Label>
                    </div>    
                    <div class="field" style="width:100px">
                        <asp:TextBox ID="txtDailyEndTime" runat="server" Width="80px" ></asp:TextBox>
                    </div>                         
               </div>
               <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnWeekly" GroupName="grpSchedule" runat="server" Text="Weekly" Width="63px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblEvery2" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlWeeklyEvery" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblTime" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtWeeklyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
             </div>
             <div class="four fields">
                <div class="field" style="width:100px">
                    <asp:RadioButton ID="rbtnMonthly" GroupName="grpSchedule" runat="server" Text="Monthly" Width="68px"/>
                </div>
                <div class="field" style="width:70px">
                    <asp:Label ID="lblEvery3" runat="server" Text="Every" Width="60px"></asp:Label>
                </div>    
                <div class="field" style="width:250px">
                    <asp:DropDownList ID="ddlMonthly" runat="server" Width="100px" style="display:inline" ></asp:DropDownList>
                </div> 
                <div class="field" style="width:70px">
                    <asp:Label ID="lblTime2" runat="server" Text="Time" Width="80px"></asp:Label>
                </div>    
                <div class="field" style="width:100px">
                    <asp:TextBox ID="txtMonthlyTime" runat="server" Width="80px" ></asp:TextBox>
                </div>
              </div>
            </div>  


            </div>             

            <div style="text-align:center">
                <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveScheduler()"/>
                <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetScheduler()" />
            </div>               
        </div>
     </div>


</asp:Content>