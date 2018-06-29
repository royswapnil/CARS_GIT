<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmTimeRegistration.aspx.vb" Inherits="CARS.frmTimeRegistration" MasterPageFile="~/MasterPage.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <style type="text/css">
           .ui-state-highlight, .ui-widget-content .ui-state-highlight, .ui-widget-header .ui-state-highlight{
                background:#4c6a9e;
                color:white;
         }
    </style>
    <script type="text/javascript" >
        $(document).ready(function () {
            loadInit();
            function loadInit() {
                setTab('Stempling');
                $('#<%=ddlJobs.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            }

            function setTab(cTab) {
                var tabID = "";

                tabID = $(cTab).data('tab') || cTab; // Checks if click or function call
                var tab;
                (tabID == "") ? tab = cTab : tab = tabID;

                $('.tTab').addClass('hidden'); // Hides all tabs
                $('#tab' + tabID).removeClass('hidden'); // Shows target tab and sets active class
                $('.cTab').removeClass('tabActive'); // Removes the tabActive class for all 
                $("#btn" + tabID).addClass('tabActive'); // Sets tabActive to clicked or active tab
            }

            $('.cTab').on('click', function (e) {
                setTab($(this));
            });


            idwolabSeq = "0";
            jobId = "0";
            trSeq = "0";
            firstName = "";
            $("#<%=btnClockin.ClientID%>").attr('disabled', 'disabled');
            $("#<%=btnClockout.ClientID%>").attr('disabled', 'disabled');
            $('#<%=txtClockinDt.ClientID%>').attr('disabled', 'disabled');
            $('#<%=txtClockinTime.ClientID%>').attr('disabled', 'disabled');
            $('#<%=txtClockoutDt.ClientID%>').attr('disabled', 'disabled');
            $('#<%=txtClockoutTime.ClientID%>').attr('disabled', 'disabled');
            loadUnsoldTime();

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtSearchDate.ClientID%>').datepicker({
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1",
                dateFormat: "dd/mm/yy"
            });

            var labGrid = $("#jobgrid");
            pageSize = $('#<%=hdnPageSize.ClientID%>').val();
            mydata = "";

            //Labour Details Grid
            labGrid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['Job.LineNo', 'Labour Desc', 'IdWoLabSeq'],
                colModel: [
                         { name: 'Job_LineNo', index: 'Job_LineNo', width: 160, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Lab_Desc', index: 'Lab_Desc', width: 490, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Id_WoLab_Seq', index: 'Id_WoLab_Seq', width: 120, sorttype: "string", classes: 'wosearchpointer', hidden: true }

                ],
                multiselect: false,
                pager: jQuery('#pager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "170px",
                caption: "Labour Details",
                async: false, //Very important,
                subgrid: false,
                onSelectRow: function (rowId) {
                    var rowData = $(this).jqGrid("getRowData", rowId);
                    idwolabSeq = rowData.Id_WoLab_Seq;
                    var result;
                    result = rowData.Job_LineNo.split("-");
                    jobId = result[0];
                    MecDetExists();
                }
                
            });

            jQuery("#jobgrid").jqGrid('bindKeys', {
                "onEnter": function (rowid) {
                    $('#<%=btnClockin.ClientID%>').focus();
                }
            });

            //Mechanic Details Grid
            var mechGrid = $("#mechGrid");
            mechGrid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['OrderNo', 'Job', 'LineNo', 'Mechanic Code', 'Mechanic Name', 'Text', 'Clockin Date', 'Clockin Time', 'Clockout Date', 'Clockout Time', 'Total Time','Id_Tr_Seq','Id_WoLab_Seq'],
                colModel: [
                         { name: 'OrderNo', index: 'OrderNo', width: 80, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'JobNo', index: 'JobNo', width: 50, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'LineNo', index: 'LineNo', width: 70, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'IdMech', index: 'IdMech', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'MechName', index: 'MechName', width: 130, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Text', index: 'Text', width: 150, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Dt_clockin', index: 'Dt_clockin', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Time_clockin', index: 'Time_clockin', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Dt_clockout', index: 'Dt_clockout', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Time_clockout', index: 'Time_clockout', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'TotalClockedTime', index: 'TotalClockedTime', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Id_Tr_Seq', index: 'Id_Tr_Seq', width: 120, sorttype: "string", classes: 'wosearchpointer',hidden:true },
                         { name: 'Id_WoLab_Seq', index: 'Id_WoLab_Seq', width: 120, sorttype: "string", classes: 'wosearchpointer',hidden:true },
                ],
                multiselect: false,
                pager: jQuery('#mechpager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "300px",
                caption: "Mechanic Details",
                async: false, //Very important,
                subgrid: false
            });

            //Mechanic Search Grid
            var mechSearchGrid = $("#mechSearchGrid");
            mechSearchGrid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['OrderNo', 'Job', 'LineNo', 'Mechanic Code', 'Mechanic Name', 'Text', 'Clockin Date', 'Clockin Time', 'Clockout Date', 'Clockout Time', 'Total Time', 'Id_Tr_Seq', 'Id_WoLab_Seq'],
                colModel: [
                         { name: 'OrderNo', index: 'OrderNo', width: 80, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'JobNo', index: 'JobNo', width: 50, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'LineNo', index: 'LineNo', width: 70, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'IdMech', index: 'IdMech', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'MechName', index: 'MechName', width: 150, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Text', index: 'Text', width: 150, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Dt_clockin', index: 'Dt_clockin', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Time_clockin', index: 'Time_clockin', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Dt_clockout', index: 'Dt_clockout', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Time_clockout', index: 'Time_clockout', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'TotalClockedTime', index: 'TotalClockedTime', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                         { name: 'Id_Tr_Seq', index: 'Id_Tr_Seq', width: 120, sorttype: "string", classes: 'wosearchpointer', hidden: true },
                         { name: 'Id_WoLab_Seq', index: 'Id_WoLab_Seq', width: 120, sorttype: "string", classes: 'wosearchpointer', hidden: true },
                ],
                multiselect: false,
                pager: jQuery('#mechSearchPager'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "450px",
                caption: "Mechanic Details",
                async: false, //Very important,
                subgrid: false
            });

            //autocomplete mechanic
            var mech = $('#<%=txtMechId.ClientID%>').val();
            $('#<%=txtMechId.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmTimeRegistration.aspx/Mechanic_Search",
                        data: "{'q':'" + $('#<%=txtMechId.ClientID%>').val() + "'}",
                        dataType: "json",

                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.Login_Name ,
                                    val: item.Id_Login,
                                    value: item.Id_Login,
                                    fname: item.Mech_FirstName
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
                    $("#<%=txtMechId.ClientID%>").val(i.item.val);
                    $("#<%=hdnFirstName.ClientID%>").val(i.item.fname);
                    LoadMechanicData(i.item.val);
                    MecDetExists();
                    //$("#<%=btnClockin.ClientID%>").removeAttr("disabled");
                    //$("#<%=btnClockout.ClientID%>").removeAttr("disabled");
                },
            });


            $('#<%=txtOrdNO.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/GetOrder",
                        data: "{'orderNo':'" + $('#<%=txtOrdNO.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2] + "-" + item.split('-')[3] + "-" + item.split('-')[4],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0],
                                    woNo: item.split('-')[0],
                                    woPr: item.split('-')[5]
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
                    $("#<%=txtOrdNO.ClientID%>").val(i.item.woNo);
                    if ($('#<%=ddlUnsoldTime.ClientID%>')[0].selectedIndex != 0) {
                        $('#<%=ddlUnsoldTime.ClientID%>')[0].selectedIndex = 0;
                    }
                   
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmTimeRegistration.aspx/FetchJobDet",
                        data: "{'OrderNo':'" + $('#<%=txtOrdNO.ClientID%>').val() + "'}",
                        dataType: "json",
                        async: false,//Very important
                        success: function (data) {
                            jQuery("#jobgrid").jqGrid('clearGridData');
                            for (i = 0; i < data.d.length; i++) {
                                mydata = data;
                                jQuery("#jobgrid").jqGrid('addRowData', i + 1, mydata.d[i]);
                            }
                        }
                    });

                    jQuery("#jobgrid").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    $("#jobgrid").jqGrid("hideCol", "subgrid");

                    jQuery('#jobgrid').jqGrid('setSelection', 1, true);
                    jQuery('#jobgrid').focus();
                }

            });

            $('#<%=btnClockin.ClientID%>').on('click', function () {
                if (($('#<%=txtOrdNO.ClientID%>').val() != "") && ($('#<%=ddlUnsoldTime.ClientID%>')[0].selectedIndex != 0) )
                {
                    alert('Either Order Number or unsold Time can be used for clockin');
                    $('#<%=txtOrdNO.ClientID%>').val('');
                    jQuery("#jobgrid").jqGrid('clearGridData');
                }                
                else {
                    clockIn();
                }
            });

            $('#<%=btnClockOut.ClientID%>').on('click', function () {
                clockOut();
            });

 
            $('#<%=ddlUnsoldTime.ClientID%>').change(function (e) {
                if ($('#<%=ddlUnsoldTime.ClientID%>')[0].selectedIndex > 0) {
                    if ($('#<%=txtOrdNO.ClientID%>').val() != ""){
                        $('#<%=txtOrdNO.ClientID%>').val('');
                    }
                    $('#<%=btnClockin.ClientID%>').removeAttr("disabled");
                }
                else {
                    $("#<%=btnClockout.ClientID%>").attr('disabled', 'disabled');
                }
            });
            
            $('#<%=btnManClockin.ClientID%>').on('click', function (e) {
                var bool = fnClientValidate();
                if (bool == true) {
                    var mid = $('#<%=txtMechId.ClientID%>').val();
                    var page = "../Transactions/frmTRegPopUp.aspx?MechanicId=" + mid
                    var $dialog = $('<div id="testdialog" style="width:100%;height:100%"></div>')
                                   .html('<iframe id="testifr" style="border: 0px; overflow:scroll" src="' + page + '" width="100%" height="100%"></iframe>')
                                   .dialog({
                                       autoOpen: false,
                                       modal: true,
                                       height: 500,
                                       width: 800,
                                       title: "Manual Clock-In"
                                   });
                    $dialog.dialog('open');
                }
            });

            $('#<%=txtSearchOrderNo.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/GetOrder",
                        data: "{'orderNo':'" + $('#<%=txtSearchOrderNo.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2] + "-" + item.split('-')[3] + "-" + item.split('-')[4],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0],
                                    woNo: item.split('-')[0],
                                    woPr: item.split('-')[5]
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
                    $("#<%=txtSearchOrderNo.ClientID%>").val(i.item.woNo);

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmTimeRegistration.aspx/FetchJobs",
                        data: "{'OrderNo':'" + $('#<%=txtSearchOrderNo.ClientID%>').val() + "'}",
                        dataType: "json",
                        async: false,//Very important
                        success: function (Result) {
                            $('#<%=ddlJobs.ClientID%>').empty();
                            $('#<%=ddlJobs.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                            Result = Result.d;
                            $.each(Result, function (key, value) {
                                $('#<%=ddlJobs.ClientID%>').append($("<option></option>").val(value.JobNo).html(value.JobNo));
                                $('#<%=ddlJobs.ClientID%>')[0].selectedIndex = 1;
                            });
                        }
                    });
                }
            });

            $('#<%=btnSearch.ClientID%>').on('click', function () {
                searchMechDetails();
            });

            $('#<%=btnReset.ClientID%>').on('click', function () {
                clearSearchFields();
            });

            $('#<%=btnPrint.ClientID%>').on('click', function () {
                printSearchReport();
            });

            $('#<%=btnMechPrint.ClientID%>').on('click', function () {
                if ($('#<%=txtMechId.ClientID%>').val() == "") {
                    alert("Mechanic cannot be blank.")
                    return false;
                } else {
                    printMechReport();
                }                

            });

            //autocomplete mechanic search
            var mech = $('#<%=txtSearchMech.ClientID%>').val();
            $('#<%=txtSearchMech.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmTimeRegistration.aspx/Mechanic_Search",
                        data: "{'q':'" + $('#<%=txtSearchMech.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.Login_Name,
                                    val: item.Id_Login,
                                    value: item.Id_Login,
                                    mechName: item.Mech_FirstName
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
                    $("#<%=hdnMechName.ClientID%>").val(i.item.mechName);
                }
            });
            


        }); //end of ready


        function fnClientValidate() {
            if ($('#<%=txtMechId.ClientID%>').val() == "") {
                alert("Mechanic cannot be blank.")
                return false;
            }
            if (($('#<%=txtOrdNo.ClientID%>').val() != "") && ($('#<%=ddlUnsoldTime.ClientID%>')[0].selectedIndex == 0)) {
                var selRowIds = $("#jobGrid").jqGrid("getGridParam", "selarrrow");
                //if ($.inArray(rowId, selRowIds) == 0) {
                //    alert("Select atleast one labour line before clockin. ")
                //    return false;
                //}
            }
            return true;
        }
        function clockIn()
        {
            var bool = fnClientValidate();
            if (bool == true)
            {
                var reasCode = $('#<%=cbReasCode.ClientID%>').is(':checked');
                var mechId = $('#<%=txtMechId.ClientID%>').val();
                var ordNo = $('#<%=txtOrdNo.ClientID%>').val();
                var jobNo = jobId;
                var dtClockin = $('#<%=txtClockinDt.ClientID%>').val();
                var timeClockin = $('#<%=txtClockinTime.ClientID%>').val();
                var clockIn = "C";
                var id_tr_seq = "0";
                var WoLabSeq = idwolabSeq;
                var unsoldTime = $('#<%=ddlUnsoldTime.ClientID%>').val();
                //var reas_code = "";
                var comp_per = "0";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmTimeRegistration.aspx/MechClockIn",
                    data: "{'mechId':'" + mechId + "','ordNo':'" + ordNo + "','jobNo':'" + jobNo + "','dtClockin':'" + dtClockin + "','timeClockin':'" + timeClockin + "','clockIn':'" + clockIn + "','id_tr_seq':'" + id_tr_seq + "','reas_code':'" + reasCode + "','comp_per':'" + comp_per + "','idWoLabSeq':'" + WoLabSeq + "','unsoldTime':'" + unsoldTime + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (Result) {
                        if (Result.d.length > 0) {
                            $('#<%=RTlblError.ClientID%>').text('Clocked In Successfully');
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            loadClockinData(mechId, ordNo, jobNo, WoLabSeq);
                            LoadMechanicData(mechId);
                            $('#<%=txtMechId.ClientID%>').focus();
                            $('#<%=txtMechId.ClientID%>').val('');
                            $('#<%=txtOrdNo.ClientID%>').val('');
                            $('#<%=ddlUnsoldTime.ClientID%>')[0].selectedIndex = 0;
                            jQuery("#jobgrid").jqGrid('clearGridData');
                        }
                    }
                });
            }
            
        }

        function clockOut() {
            var bool = fnClientValidate();
            if (bool == true) {
                var reasCode = $('#<%=cbReasCode.ClientID%>').is(':checked');
                var mechId = $('#<%=txtMechId.ClientID%>').val();
                var ordNo = $('#<%=txtOrdNO.ClientID%>').val();
                var jobNo = jobId;
                var dtClockin = $('#<%=txtClockinDt.ClientID%>').val();
                var timeClockin = $('#<%=txtClockinTime.ClientID%>').val();
                var clockIn = "L";
                var id_tr_seq = "0";
                //var reas_code = "94";
                var comp_per = "100";
                var WoLabSeq = idwolabSeq;
                var unsoldTime = $('#<%=ddlUnsoldTime.ClientID%>').val();
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmTimeRegistration.aspx/MechClockIn",
                    data: "{'mechId':'" + mechId + "','ordNo':'" + ordNo + "','jobNo':'" + jobNo + "','dtClockin':'" + dtClockin + "','timeClockin':'" + timeClockin + "','clockIn':'" + clockIn + "','id_tr_seq':'" + id_tr_seq + "','reas_code':'" + reasCode + "','comp_per':'" + comp_per + "','idWoLabSeq':'" + WoLabSeq + "','unsoldTime':'" + unsoldTime + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (Result) {
                        if (Result.d.length > 0) {
                            $('#<%=RTlblError.ClientID%>').text('Clocked Out Successfully');
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            LoadMechanicData();
                            $('#<%=txtMechId.ClientID%>').focus();
                            $('#<%=txtMechId.ClientID%>').val('');
                            $('#<%=txtOrdNo.ClientID%>').val('');
                            $('#<%=ddlUnsoldTime.ClientID%>')[0].selectedIndex = 0;
                            jQuery("#jobgrid").jqGrid('clearGridData');
                        }
                    }
                });
            }
        }

        function searchMechDetails() {
            var id = "";
            var mechId = $('#<%=txtSearchMech.ClientID%>').val();
            var mechName = $('#<%=hdnMechName.ClientID%>').val();
            var searchDate = $('#<%=txtSearchDate.ClientID%>').val();
            var ordNo = $('#<%=txtSearchOrderNo.ClientID%>').val();
            var jobNo = $('#<%=ddlJobs.ClientID%>').val();
            var flgOrders = $('#<%=chkorder.ClientID%>').is(':checked');
            var flgUnsold = $('#<%=chkdags.ClientID%>').is(':checked');

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmTimeRegistration.aspx/SearchMechanicDetails",
                data: "{'mechId':'" + mechId + "','ordNo':'" + ordNo + "','jobNo':'" + jobNo + "','mechName':'" + mechName + "','searchDate':'" + searchDate + "','flgOrders':'" + flgOrders + "','flgUnsold':'" + flgUnsold + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    jQuery("#mechSearchGrid").jqGrid('clearGridData');
                    if (Result.d.length > 1) {
                        for (i = 0; i < Result.d[0].length; i++) {
                            mydata = Result.d[0];
                            jQuery("#mechSearchGrid").jqGrid('addRowData', i + 1, mydata[i]);
                        }

                        jQuery("#mechSearchGrid").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $("#mechSearchGrid").jqGrid("hideCol", "subgrid");

                        $('#<%=RTlblError.ClientID%>').text('');
                        $('#<%=RTlblError.ClientID%>').removeClass();

                        var totTimeOnOrder = Result.d[1][0].TotalTimeOnOrder;
                        var totTimeUnsold = Result.d[1][0].TotalTimeUnsold;
                        $('#<%=txtTotOrder.ClientID%>').val(Result.d[1][0].TotalTimeOnOrder);
                        $('#<%=txtTotUnsold.ClientID%>').val(Result.d[1][0].TotalTimeUnsold);
                    } else {
                        $('#<%=RTlblError.ClientID%>').text('No Records found');
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
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
                    $('#<%=ddlUnsoldTime.ClientID%>').empty();
                    $('#<%=ddlUnsoldTime.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;

                    $.each(Result, function (key, value) {
                        $('#<%=ddlUnsoldTime.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));
                    });
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function MecDetExists()
        {
            var ordNo = $('#<%=txtOrdNo.ClientID%>').val();
            var mechId = $('#<%=txtMechId.ClientID%>').val();
            var jobNo = jobId;
            var woLabSeq = idwolabSeq;
            $.ajax({
                type: "POST",
                url: "frmTimeRegistration.aspx/MecDetExists",
                data: "{'mechId':'" + mechId + "','ordNo':'" + ordNo + "','jobNo':'" + jobNo + "','idWoLabSeq':'" + woLabSeq + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d[0].Id_Tr_Seq == null)
                    {
                        $('#<%=txtClockinDt.ClientID%>').val(data.d[0].Dt_clockin);
                        $('#<%=txtClockinTime.ClientID%>').val(data.d[0].Time_clockin);
                        $('#<%=txtClockoutDt.ClientID%>').val('');
                        $('#<%=txtClockoutTime.ClientID%>').val('');
                        $('#<%=btnClockin.ClientID%>').removeAttr("disabled");
                        $("#<%=cbReasCode.ClientID%>").attr('disabled', 'disabled');
                        $('#<%=btnClockout.ClientID%>').attr('disabled', 'disabled');
                    }
                    else {
                        if (data.d[0].Id_Tr_Seq == "0") {
                            $('#<%=txtClockoutDt.ClientID%>').val('');
                            $('#<%=txtClockoutTime.ClientID%>').val('');
                            $('#<%=txtClockinDt.ClientID%>').val('');
                            $('#<%=txtClockinTime.ClientID%>').val('');
                            $('#<%=btnClockin.ClientID%>').removeAttr("disabled");
                            //$('#<%=btnClockin.ClientID%>').show();
                            $('#<%=btnClockout.ClientID%>').attr('disabled', 'disabled');
                        }
                        else {
                            trSeq = data.d[0].Id_Tr_Seq;
                            if (data.d[0].Id_UnsoldTime == "") {
                                if (data.d[0].Id_WoLab_Seq == woLabSeq) {
                                    $('#<%=txtClockinDt.ClientID%>').val(data.d[0].Dt_clockin);
                                    $('#<%=txtClockinTime.ClientID%>').val(data.d[0].Time_clockin);
                                    $('#<%=txtClockoutDt.ClientID%>').val(data.d[0].Dt_clockout);
                                    $('#<%=txtClockoutTime.ClientID%>').val(data.d[0].Time_clockout);
                                }
                                else {
                                    $('#<%=txtClockinDt.ClientID%>').val(data.d[0].Dt_clockin);
                                    $('#<%=txtClockinTime.ClientID%>').val(data.d[0].Time_clockin);
                                    $('#<%=txtClockoutDt.ClientID%>').val('');
                                    $('#<%=txtClockoutTime.ClientID%>').val('');
                                }
                            }
                            else {
                                $('#<%=txtClockinDt.ClientID%>').val(data.d[0].Dt_clockin);
                                $('#<%=txtClockinTime.ClientID%>').val(data.d[0].Time_clockin);
                                $('#<%=txtClockoutDt.ClientID%>').val(data.d[0].Dt_clockout);
                                $('#<%=txtClockoutTime.ClientID%>').val(data.d[0].Time_clockout);
                            }

                            //$('#<%=ddlUnsoldTime.ClientID%>').val(data.d[0].Id_UnsoldTime);
                            $('#<%=btnClockin.ClientID%>').removeAttr("disabled");
                            $('#<%=btnClockout.ClientID%>').removeAttr("disabled");
                            $("#<%=cbReasCode.ClientID%>").removeAttr("disabled");
                        }
                    }                 
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function loadClockinData(mechId, ordNo, jobNo, WoLabSeq)
        {
            MecDetExists();
            if (ordNo != "")
            {
                FetchJobGrid(ordNo);
            }
        }

        function FetchJobGrid(ordNo)
        {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmTimeRegistration.aspx/FetchJobDet",
                data: "{'OrderNo':'" + ordNo + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    jQuery("#jobgrid").jqGrid('clearGridData');
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#jobgrid").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            jQuery("#jobgrid").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            $("#jobgrid").jqGrid("hideCol", "subgrid");
        }

        function ClearAll()
        {
            $('#<%=txtClockoutDt.ClientID%>').val('');
            $('#<%=txtClockoutTime.ClientID%>').val('');
            $('#<%=txtClockinDt.ClientID%>').val('');
            $('#<%=txtClockinTime.ClientID%>').val('');
            $('#<%=txtMechId.ClientID%>').val('');
            $('#<%=txtOrdNo.ClientID%>').val('');
            $('#jobgrid').hide();
             $("#<%=ddlUnsoldTime.ClientID%>").attr('disabled', 'disabled');
        }

        function LoadMechanicData() {
            var mechId = $('#<%=txtMechId.ClientID%>').val();
            $.ajax({
                type: "POST",
                url: "frmTimeRegistration.aspx/FetchMechanicDetails",
                data: "{'mechId':'" + mechId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    //debugger;
                    jQuery("#mechGrid").jqGrid('clearGridData');
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#mechGrid").jqGrid('addRowData', i + 1, mydata.d[i]);
                        $('#<%=txtTUTime.ClientID%>').val(data.d[i].TotalTimeUnsold);
                        $('#<%=txtTOrdTime.ClientID%>').val(data.d[i].TotalTimeOnOrder);
                    }
                    jQuery("#mechGrid").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    $("#mechGrid").jqGrid("hideCol", "subgrid");

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function clearSearchFields() {
            $('#<%=txtSearchDate.ClientID%>').val('');
            $('#<%=txtSearchMech.ClientID%>').val('');
            $('#<%=txtSearchOrderNo.ClientID%>').val('');
            $('#<%=ddlJobs.ClientID%>').empty();
            $('#<%=ddlJobs.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
            jQuery("#mechSearchGrid").jqGrid('clearGridData');
            $('#<%=hdnMechName.ClientID%>').val('');
        }

        function printSearchReport() {
            var fromDate = $('#<%=txtSearchDate.ClientID%>').val();
            var toDate = $('#<%=txtSearchDate.ClientID%>').val();
            var mechId = $('#<%=txtSearchMech.ClientID%>').val();
            var mechName = $('#<%=hdnMechName.ClientID%>').val();
            var orderNo = $('#<%=txtSearchOrderNo.ClientID%>').val();
            var jobNo = $('#<%=ddlJobs.ClientID%>').val();
            var flgOrders = $('#<%=chkorder.ClientID%>').is(':checked');
            var flgUnsold = $('#<%=chkdags.ClientID%>').is(':checked');

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmTimeRegistration.aspx/PrintSearchReport",
                data: "{'mechId':'" + mechId + "','mechName':'" + mechName + "','orderNo':'" + orderNo + "','jobNo':'" + jobNo + "','fromDate':'" + fromDate + "','toDate':'" + toDate + "','flgOrders':'" + flgOrders + "','flgUnsold':'" + flgUnsold + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    if (Result.d.length > 0) {
                        var strValue = Result.d;
                        if (strValue != "") {
                            var Url = strValue;
                            window.open(Url, 'Reports', "menubar=no,location=no,status=no,scrollbars=yes,resizable=yes");
                        }
                    }
                }
            });
        }

        function printMechReport() {
            var fromDate = $('#<%=txtSearchDate.ClientID%>').val();
            var toDate = $('#<%=txtSearchDate.ClientID%>').val();
            var mechId = $('#<%=txtMechId.ClientID%>').val();
            var mechName = $('#<%=hdnFirstName.ClientID%>').val();
            var orderNo = "";//$('#<%=txtOrdNo.ClientID%>').val();
            var jobNo = "0";//jobId;
            var flgOrders = 'true'; //$('#<%=chkorder.ClientID%>').is(':checked');
            var flgUnsold = 'true';// $('#<%=chkdags.ClientID%>').is(':checked');

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmTimeRegistration.aspx/PrintMechReport",
                data: "{'mechId':'" + mechId + "','mechName':'" + mechName + "','orderNo':'" + orderNo + "','jobNo':'" + jobNo + "','fromDate':'" + fromDate + "','toDate':'" + toDate + "','flgOrders':'" + flgOrders + "','flgUnsold':'" + flgUnsold + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    if (Result.d.length > 0) {
                        var strValue = Result.d;
                        if (strValue != "") {
                            var Url = strValue;
                            window.open(Url, 'Reports', "menubar=no,location=no,status=no,scrollbars=yes,resizable=yes");
                        }
                    }
                }
            });
        }
       
     </script>
    <div class="ui form">
         <asp:HiddenField ID="hdnPageSize" runat="server" />
        <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnFirstName" runat="server" />
         <asp:HiddenField ID="hdnMechName" runat="server" />
        <asp:Label ID="RTlblError" runat="server" CssClass="lblErr"></asp:Label>
        <div class="inline fields">
            <input type="button" value="Stempling" id="btnStempling" class="ui btn cTab" data-tab="Stempling" />
            <input type="button" value="Stemplinger" id="btnStemplinger" class="ui btn cTab" data-tab="Stemplinger" />
        </div>
    </div>
       <div id="tabStempling" class="tTab" style="height:800px;border:solid;border-width:0.10px;">
        <div class="ui stackable grid">
            <div class="four wide column">
                <div class="ui form">
                    <div style="padding-left:10px;padding-top:1em">
                        <asp:Label ID="lblMechId" Text="Mekaniker" runat="server" Width="150px"></asp:Label>
                        <asp:TextBox ID="txtMechId" runat="server" CssClass="texttest" Width="200px" ></asp:TextBox>
                    </div>
                    <br />
                    <div style="padding-left:10px">
                        <asp:Label ID="lblOrdNo" Text="Order No" runat="server" Width="100px"></asp:Label><br />
                        <asp:TextBox ID="txtOrdNo" runat="server" CssClass="texttest" Width="200px"></asp:TextBox>
                    </div>
                    <br />
                    <div style="padding-left:10px">
                        <asp:Label ID="lblUnsoldTime" Text="Unsold Time" runat="server" Width="100px"></asp:Label><br />
                         <asp:DropDownList ID="ddlUnsoldTime" CssClass="dropdowns" runat="server" Width="200px"></asp:DropDownList>
                    </div>
                    <br />
                    <div style="padding-left:10px">
                        <asp:Label ID="lblClkInDt" Text="Clockin date" runat="server" Width="100px"></asp:Label><br />
                        <asp:TextBox ID="txtClockinDt" runat="server" CssClass="texttest" Width="200px"></asp:TextBox>
                    </div>
                    <br />
                    <div style="padding-left:10px">
                        <asp:Label ID="lblClkOutDt" Text="Clockout date" runat="server" Width="100px"></asp:Label><br />
                        <asp:TextBox ID="txtClockoutDt" runat="server" CssClass="texttest" Width="200px"></asp:TextBox>
                    </div>
                    <br />
                    <div style="padding-left:10px">
                    <label>
                    </label>
                </div>
                </div>
            </div>

            <div class="three wide column">
                 <div class="ui form ">
                    <div style="padding-left:10px;padding-top:1em">
                        <asp:Label ID="Label1" Text="" runat="server"></asp:Label><br />
                        <asp:Label ID="Label4" Text="" runat="server"></asp:Label><br />
                    </div>
                      <br />
                    <div>
                        <asp:Label ID="Label2" Text="" runat="server"></asp:Label><br />
                        <asp:Label ID="Label5" Text="" runat="server"></asp:Label><br />
                    </div>
                      <br />
                    <div>
                        <asp:Label ID="Label3" Text="" runat="server"></asp:Label><br />
                        <asp:Label ID="Label6" Text="" runat="server"></asp:Label><br />
                    </div>
                      <br />
                    <div style="margin-top:10px">
                        <asp:Label ID="lblClkInTime" Text="Clockin Time" runat="server" Width="100px" ></asp:Label><br />
                        <asp:TextBox ID="txtClockinTime" runat="server" CssClass="texttest" Width="200px" ></asp:TextBox>
                    </div>
                      <br />
                    <div>
                        <asp:Label ID="lblClkOutTime" Text="Clockout Time" runat="server" Width="100px" ></asp:Label><br />
                        <asp:TextBox ID="txtClockoutTime" runat="server" CssClass="texttest" Width="200px" ></asp:TextBox>
                    </div>
                 </div>
             </div>
          
            <div class="two wide column" style="padding-top:32px">
                <table id="jobgrid"></table>
                <div id="pager"></div>
            </div>
        </div>
            <div style="padding:0.5em"></div>

           <div class="ui grid">
            <div class="two wide column">
                <div class="ui form ">
                    <div class="inline field" style="padding-left:1em">
                   <input id="btnManClockin" runat="server" class="ui button" value="Man.Clockin" type="button"  />
                </div>  
                </div>
            </div> 
            <div class="four wide column">
                <div class="ui form ">
                    <input id="btnMechPrint" runat="server" class="ui button" value="Skriv Ut" type="button"  />
                </div>
            </div> 
            <div class="three wide column">
                <div class="ui form ">
                    
                </div>
            </div> 
            <div class="two wide column">
                <div class="ui checkbox" style="padding-top:10px">
                    <asp:CheckBox ID="cbReasCode" runat="server" Text="CompletedStatus" />
                </div>
            </div>
             
            <div class="five wide column">
                <div class="inline field">
                    <input id="btnClockin" runat="server" class="ui button" value="Clock-In" type="button" />
                    <input id="btnClockout" runat="server" class="ui button" value="Clock-Out" type="button" />
                </div>  
            </div>  
        </div>

        <div style="padding:0.5em"></div>
        <div style="padding-left:10px;padding-right:10px">
            <table id="mechGrid"></table>
            <div id="mechpager"></div>
        </div>
        <div style="padding:0.5em"></div>
         <div class="ui grid">
             <div class="seven wide column">
                <div></div>
             </div>
            <div class="three wide column">
                <div></div>
             </div>

             <div class="three wide column">
                <div>
                    <asp:Label ID="LblTUTime" Text="Sum tid dag" runat="server" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtTUTime" runat="server" CssClass="texttest" Width="75px" style="text-align: center;" ></asp:TextBox>
                </div>
            </div>
            <div class="three wide column">
                <div>
                    <asp:Label ID="lblTOrdTime" Text="Sum tid order" runat="server" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtTOrdTime" runat="server" CssClass="texttest" Width="75px" style="text-align: center;"></asp:TextBox>
                </div>
            </div>
        </div>
       
    </div>

    <div id="tabStemplinger" class="tTab" style="height:850px;border:solid;border-width:0.10px;">
        <div class="ui stackable grid">
          <div class="two wide column">
                <div class="ui form">
                    <div style="padding-left:1em;padding-top:1em">
                        <asp:Label ID="lblSearchMechanic" Text="Mekaniker" runat="server" Width="120px"></asp:Label>
                        <asp:TextBox ID="txtSearchMech" runat="server" CssClass="texttest" Width="150px" ></asp:TextBox>
                    </div>
                </div>
              <br />
                <div class="ui form">
                   <div style="padding-left:1em;">
                        <asp:Label ID="lblSearchOrder" Text="Ordernr" runat="server" Width="120px"></asp:Label>
                        <asp:TextBox ID="txtSearchOrderNo" runat="server" CssClass="texttest" Width="150px" ></asp:TextBox>
                    </div>
                </div>
              <br />
                <div class="ui form">
                    <div style="padding-left:1em;">
                        <asp:Label ID="lblSearchDate" Text="Innstemplet Dato" runat="server" Width="120px"></asp:Label><br />
                        <asp:TextBox ID="txtSearchDate" runat="server" CssClass="texttest" Width="150px"></asp:TextBox>
                    </div>
                </div>
          </div>
          <div class="two wide column">
              <div class="ui form">
                    <div></div>
                    <div></div>
              </div>
              <div class="ui form" style="padding-bottom:3.3em">
                    <div></div>
                    <div></div>
              </div>
              <div class="ui form" style="padding-left:5px">
                  <div>
                      <asp:Label ID="Label7" Text="Jobnr " runat="server" Width="150px"></asp:Label><br />
                  </div>
                  <div>
                      <asp:DropDownList ID="ddlJobs" runat="server" Width="120px" class="dropdowns"></asp:DropDownList>
                  </div>
                </div>
                <div class="ui form" style="padding-bottom:2.7em">
                    <div></div>
               </div>
               <div class="ui form">
                  <asp:CheckBox ID="chkdags" runat="server" Text="Kun dagstemplinger" CssClass="ui checkbox" Width="150px" Checked="true" />
               </div>
          </div>
          <div class="three wide column">
              <div class="ui form" style="padding-bottom:3em">
                 <div></div>
              </div>
              <div class="ui form" style="padding-bottom:3em">
                 <div></div>
              </div>
              <div class="ui form" style="padding-bottom:4.2em">
                 <div></div>
              </div>
              <div class="ui form" >
                 <asp:CheckBox ID="chkorder" runat="server" Text="Kun ordrestemplinger" CssClass="ui checkbox" Checked="true" />
              </div>
          </div>
          <div class="five wide column">
            <div class="inline field">
                
            </div>  
          </div>
          <div class="two wide column">
            <div class="inline field">
                
            </div>  
          </div>    
          <div class="five wide column">
            <div class="inline field" style="padding-left:1em">
                <input id="btnSearch" runat="server" class="ui button" value="Search" type="button" />               
                <input id="btnReset" runat="server" class="ui button" value="Reset" type="button" />
                <input id="btnPrint" runat="server" class="ui button" value="Skriv Ut" type="button" />
            </div>
          </div>
          <div class="two wide column">
                
          </div>    
        </div>
        <br />
        <div style="padding-left:1em;padding-right:2em;padding-bottom:2em">
            <table id="mechSearchGrid"></table>
            <div id="mechSearchPager"></div>
        </div> 
        <div class="ui grid">
             <div class="seven wide column">
                <div></div>
             </div>
            <div class="three wide column">
                <div></div>
             </div>

             <div class="three wide column">
                <div>
                    <asp:Label ID="lblTotUnsold" Text="Sum tid dag" runat="server" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtTotUnsold" runat="server" CssClass="texttest" Width="75px" style="text-align: center;" ></asp:TextBox>
                </div>
            </div>
            <div class="three wide column">
                <div>
                    <asp:Label ID="lblTotOrder" Text="Sum tid order" runat="server" Width="100px"></asp:Label>
                    <asp:TextBox ID="txtTotOrder" runat="server" CssClass="texttest" Width="75px" style="text-align: center;"></asp:TextBox>
                </div>
            </div>
        </div>
       
    </div>
    
</asp:Content>

