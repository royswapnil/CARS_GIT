<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="frmCfUserdetail.aspx.vb" Inherits="CARS.frmCfUserdetail" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="cntMainPanel" > 

    <script type="text/javascript">
        $(document).ready(function () {
            $('#divUserDetails').hide();
            $('#divDetails').hide();
            var grid = $("#dgdUserDetails");
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $(document.getElementById('<%=hdnCommonMechId.ClientID%>')).val("");
            var mydata;
            loadSub();
            loadRole(0, 0);
            loadDept(0);
            loadEmailAccnt(0);


            $('#<%=ddlSubsidiary.ClientID%>').change(function (e) {
                var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
                $('#<%=ddlDept.ClientID%>').empty();
                $('#<%=ddlEAccnt.ClientID%>').empty();
                loadDept(subId);
                loadEmailAccnt(subId);
                loadRole(subId, 0);
            });

            $('#<%=ddlDept.ClientID%>').change(function (e) {
                var subId = $('#<%=ddlSubsidiary.ClientID%>').val();
                var deptId = $('#<%=ddlDept.ClientID%>').val();
                $('#<%=ddlRole.ClientID%>').empty();
                loadRole(subId,deptId);
            });

            $('#<%=txtLoginName.ClientID%>').change(function (e) {
                var loginId = $('#<%=txtLoginName.ClientID%>').val();
                edt(loginId);
            });

            $(document).on('click', '#<%=cbMech.ClientID%>', function () {
                $('#<%=cbMech.ClientID%>').attr("checked", function () {
                    if (this.checked == true) {
                        $("#<%=cbMechActive.ClientID%>").removeAttr("disabled");
                        $("#<%=rdbAutoCorr.ClientID%>").removeAttr("disabled");
                        $('#<%=txtCommonMechId.ClientID%>').removeAttr("disabled");
                    }
                    else {
                        $("#<%=cbMechActive.ClientID%>").attr('disabled', 'disabled');
                        $("#<%=rdbAutoCorr.ClientID%>").attr('disabled', 'disabled'); 
                        $('#<%=txtCommonMechId.ClientID%>').attr("disabled", "disabled"); 
                    }
                });
            });

            grid.jqGrid({
                datatype: "local",
                data: mydata,
                colNames: ['First Name', 'Subsidiary', 'Department', 'Role', 'Login Name', 'Telephone','Email',''],
                colModel: [
                         { name: 'First_Name', index: 'First_Name', width: 60, sorttype: "string" },
                         { name: 'Id_Subsidery_User', index: 'Id_Subsidery_User', width: 90, sorttype: "string" },
                         { name: 'Id_Dept', index: 'Id_Dept', width: 120, sorttype: "string" },
                         { name: 'Id_Role_User', index: 'Id_Role_User', width: 90, sorttype: "string" },
                         { name: 'Id_Login', index: 'Id_Login', width: 90, sorttype: "string" },
                         { name: 'Phone', index: 'Phone', width: 90, sorttype: "string" },
                         { name: 'Id_Email', index: 'Id_Email', width: 90, sorttype: "string" },
                         { name: 'ID_Login', index: 'ID_Login', sortable: false, formatter: displayButtons }
                ],
                multiselect: true,
                pager: jQuery('#pager1'),
                rowNum: pageSize,//can fetch from webconfig
                rowList: 5,
                sortorder: 'asc',
                viewrecords: true,
                height: "50%",
                caption: "User Details",
                async: false, //Very important,
                subgrid: false

            });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfUserdetail.aspx/LoadUsers",
                data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdUserDetails").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            jQuery("#dgdUserDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            getGridHeaders();
            $("#dgdUserDetails").jqGrid("hideCol", "subgrid");
            
            $('#<%=txtZipCode.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCfUserdetail.aspx/GetZipCodes",
                        data: "{'zipCode':'" + $('#<%=txtZipCode.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[3],
                                    val: item.split('-')[0],
                                    value: item.split('-')[0],
                                    country: item.split('-')[1],
                                    state: item.split('-')[2],
                                    city: item.split('-')[3],
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
                    $("#<%=txtZipCode.ClientID%>").val(i.item.val);
                    $("#<%=txtCountry.ClientID%>").val(i.item.country);
                    $("#<%=txtState.ClientID%>").val(i.item.state);
                    $("#<%=txtCity.ClientID%>").val(i.item.city);
                },
            });

        }); //end of ready function

        function getGridHeaders() {
            $("#dgdUserDetails").setCaption($('#<%=aheader.ClientID%>')[0].innerText);
            $('#dgdUserDetails').jqGrid("setLabel", "First_Name", $('#<%=lblFName.ClientID%>')[0].innerText);
            $('#dgdUserDetails').jqGrid("setLabel", "Id_Subsidery_User", $('#<%=lblSubsidiary.ClientID%>')[0].innerText);
            $('#dgdUserDetails').jqGrid("setLabel", "Id_Dept", $('#<%=lblDepartment.ClientID%>')[0].innerText);
            $('#dgdUserDetails').jqGrid("setLabel", "Id_Role_User", $('#<%=lblRole.ClientID%>')[0].innerText);
            $('#dgdUserDetails').jqGrid("setLabel", "Id_Login", $('#<%=lblLogin.ClientID%>')[0].innerText);
            $('#dgdUserDetails').jqGrid("setLabel", "Phone", $('#<%=lblTelNoPerson.ClientID%>')[0].innerText);
            $('#dgdUserDetails').jqGrid("setLabel", "Id_Email", $('#<%=lblEmail.ClientID%>')[0].innerText);
            //$('#dgdUserDetails')[0].p.prmNames.page="page_N"
        }

        function addUserDetails(recordStatus) {
            $('#<%=txtLoginName.ClientID%>').val("");
            $('#<%=txtPassword.ClientID%>').val("");
            $('#<%=txtConfirm.ClientID%>').val("");
            $('#<%=txtUserId.ClientID%>').val("");
            $('#<%=txtTelNoPersonal.ClientID%>').val("");
            $('#<%=txtMobile.ClientID%>').val("");
            $('#<%=txtFName.ClientID%>').val("");
            $('#<%=txtLName.ClientID%>').val("");
            $('#<%=txtAddrLine1.ClientID%>').val("");
            $('#<%=txtAddrLine2.ClientID%>').val("");
            $('#<%=txtAddrLine2.ClientID%>').val("");
            $('#<%=txtCommonMechId.ClientID%>').val("");
            $('#<%=txtFaxNo.ClientID%>').val("");
            $('#<%=txtEmail.ClientID%>').val("");
            $('#<%=txtCity.ClientID%>').val("");
            $('#<%=txtCountry.ClientID%>').val("");
            $('#<%=txtSSN.ClientID%>').val("");
            $('#<%=txtState.ClientID%>').val("");
            $('#<%=txtCommonMechId.ClientID%>').val("");
            $('#<%=txtCity.ClientID%>').val("");
            $('#<%=txtCountry.ClientID%>').val("");
            $('#<%=txtState.ClientID%>').val("");
            if (recordStatus != "New")
            {
                $('#<%=ddlDept.ClientID%>').empty();
                $('#<%=ddlDept.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                $('#<%=ddlSubsidiary.ClientID%>')[0].selectedIndex = 0;
                $('#<%=ddlDept.ClientID%>')[0].selectedIndex = 0;
                loadRole(0, 0);
                $('#<%=ddlRole.ClientID%>')[0].selectedIndex = 0;
            }
            loadEmailAccnt(0);
            $('#<%=ddlEAccnt.ClientID%>')[0].selectedIndex = 0;
            $('#<%=ddlLang.ClientID%>')[0].selectedIndex = 0;
            $('#divUserDetails').show();
            $('#divDetails').hide();
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
            $('#<%=txtZipCode.ClientID%>').val("");
            $("#<%=txtUserId.ClientID%>")[0].readOnly = false;
            $("#<%=cbMech.ClientID%>").attr('checked', false);
            $("#<%=cbMechActive.ClientID%>").attr('checked', false);
            $("#<%=cbWrkHrs.ClientID%>").attr('checked', false);
            $("#<%=cbDuser.ClientID%>").attr('checked', false);
            $('#<%=rdbAutoCorr.ClientID%> :radio[value="0"]').attr('checked', true);
            $("#<%=rdbAutoCorr.ClientID%>").attr('disabled', 'disabled'); 
            $('#<%=ddlSubsidiary.ClientID%>').focus();
        }

        function resetUserDet() {
            var msg = GetMultiMessage('0161', '', ''); 
            var r = confirm(msg); 
            if (r == true) {
                $('#divUserDetails').hide();
                $('#divDetails').hide();
                $(document.getElementById('<%=hdnMode.ClientID%>')).val("");
            }           
        }

        function displayButtons(cellvalue, options, rowObject) {
            var loginId = rowObject.Id_Login.toString();
            var strOptions = cellvalue;
            var hdEdit = document.getElementById('<%=hdnEditCap.ClientID%>').value;
            $(document.getElementById('<%=hdnMode.ClientID%>')).val("Edit");
            var edit = "<input style='...' type='button' value='" + hdEdit + "' onclick=edt(" + "'" + loginId + "'" + "); />";
            return edit;
        }

        function edt(loginId) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfUserdetail.aspx/FetchUser",
                data: "{loginId: '" + loginId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    debugger;
                    if (data.d.length > 0)
                    {
                        mydata = data;
                        $('#<%=txtLoginName.ClientID%>').val(data.d[0].Id_Login);
                        $('#<%=txtFName.ClientID%>').val(data.d[0].First_Name);
                        $('#<%=txtLName.ClientID%>').val(data.d[0].Last_Name);
                        $('#<%=txtAddrLine1.ClientID%>').val(data.d[0].Address1);
                        $('#<%=txtAddrLine2.ClientID%>').val(data.d[0].Address2);
                        $('#<%=txtPassword.ClientID%>').val(data.d[0].Password);
                        $('#<%=txtMobile.ClientID%>').val(data.d[0].Mobileno);
                        $('#<%=txtFaxNo.ClientID%>').val(data.d[0].FaxNo);
                        $('#<%=txtEmail.ClientID%>').val(data.d[0].Id_Email);
                        $('#<%=txtCommonMechId.ClientID%>').val(data.d[0].Common_Mechanic_Id);
                        $('#<%=txtCountry.ClientID%>').val(data.d[0].Id_Country);
                        $('#<%=txtCity.ClientID%>').val(data.d[0].Id_City);
                        $('#<%=txtConfirm.ClientID%>').val(data.d[0].Confirm_Password);
                        $('#<%=txtSSN.ClientID%>').val(data.d[0].Social_Security_Num);
                        $('#<%=txtWorkHrsFrm.ClientID%>').val(data.d[0].Workhrs_Frm);
                        $('#<%=txtWorkHrsTo.ClientID%>').val(data.d[0].Workhrs_To);
                        $('#<%=txtTelNoPersonal.ClientID%>').val(data.d[0].Phone);
                        $('#<%=txtUserId.ClientID%>').val(data.d[0].Userid);
                        $('#<%=txtZipCode.ClientID%>').val(data.d[0].Id_Zip_Users);
                        $('#<%=lblUser.ClientID%>').text(data.d[0].Created_By);
                        $('#<%=lblDate.ClientID%>').text(data.d[0].Dt_Created);
                        $('#<%=lblChangedBy.ClientID%>').text(data.d[0].Modified_By);
                        $('#<%=lblChangedDate.ClientID%>').text(data.d[0].Dt_Modified);

                        if (data.d[0].Id_Lang == 0) {
                            $('#<%=ddlLang.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlLang.ClientID%>').val(data.d[0].Id_Lang);
                        }
                        if (data.d[0].Id_Subsidery_User == 0 || data.d[0].Id_Subsidery_User == "") {
                            $('#<%=ddlSubsidiary.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlSubsidiary.ClientID%>').val(data.d[0].Id_Subsidery_User);
                            $('#<%=ddlDept.ClientID%>').empty(); 
                            $('#<%=ddlEAccnt.ClientID%>').empty(); 
                            loadDept(data.d[0].Id_Subsidery_User)
                            loadEmailAccnt(data.d[0].Id_Subsidery_User)
                        }
                        if (data.d[0].Id_Dept == 0 || data.d[0].Id_Dept == "") {
                            $('#<%=ddlDept.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlDept.ClientID%>').val(data.d[0].Id_Dept);
                        }
                        if (data.d[0].Id_Email_Acct == 0) {
                            $('#<%=ddlEAccnt.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlEAccnt.ClientID%>').val(data.d[0].Id_Email_Acct);
                        }

                        loadRole($('#<%=ddlSubsidiary.ClientID%>').val(), $('#<%=ddlDept.ClientID%>').val());

                        if (data.d[0].Id_Role_User == 0) {
                            $('#<%=ddlRole.ClientID%>')[0].selectedIndex = 0;
                        }
                        else {
                            $('#<%=ddlRole.ClientID%>').val(data.d[0].Id_Role_User);
                        }

                        if (data.d[0].Flg_Use_Idletime == false) {
                            $('#<%=rdbAutoCorr.ClientID%> :radio[value="0"]').attr('checked', true);
                        }
                        else {
                            $('#<%=rdbAutoCorr.ClientID%> :radio[value="1"]').attr('checked', true);
                        }

                        if (data.d[0].Flg_Mechanic == 0) {
                            $("#<%=cbMech.ClientID%>").attr('checked', false);
                            $("#<%=cbMechActive.ClientID%>").attr('disabled', 'disabled');     
                            $("#<%=rdbAutoCorr.ClientID%>").attr('disabled', 'disabled');     
                        }
                        else {
                            $("#<%=cbMech.ClientID%>").attr('checked', true);
                            $("#<%=cbMechActive.ClientID%>").removeAttr("disabled");
                            $("#<%=rdbAutoCorr.ClientID%>").removeAttr("disabled");
                        }
                        if (data.d[0].Flg_Mech_Isactive == 0) {
                            $("#<%=cbMechActive.ClientID%>").attr('checked', false);
                        }
                        else {
                            $("#<%=cbMechActive.ClientID%>").attr('checked', true);
                        }

                        if (data.d[0].Flg_Workhrs == 0) {
                            $("#<%=cbWrkHrs.ClientID%>").attr('checked', false);
                        }
                        else {
                            $("#<%=cbWrkHrs.ClientID%>").attr('checked', true);
                        }

                        if (data.d[0].Flg_Duser == 0) {
                            $("#<%=cbDuser.ClientID%>").attr('checked', false);
                        }
                        else {
                            $("#<%=cbDuser.ClientID%>").attr('checked', true);
                        }

                        $("#<%=txtUserId.ClientID%>")[0].readOnly = true;
                        $('#divUserDetails').show();
                        $('#divDetails').show();
                        $('#<%=ddlSubsidiary.ClientID%>').focus();
                    }
                    else
                    {
                        addUserDetails("New");
                        $(document.getElementById('<%=hdnMode.ClientID%>')).val("Add");
                        $("#<%=txtLoginName.ClientID%>").val(loginId);
                    }                    
                }
            });            
        }

        function loadSub()
        {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfUserdetail.aspx/LoadSubsidiary",
                data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    $('#<%=ddlSubsidiary.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlSubsidiary.ClientID%>').append($("<option></option>").val(value.SubsidiaryID).html(value.SubsidiaryName));
                    });
                }
            });
        }

        function loadDept(subId)
        {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfUserdetail.aspx/LoadDepartment",
                data: "{'subId':'" + subId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    $('#<%=ddlDept.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlDept.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));
                    });
                }
            });
        }

        function loadEmailAccnt(subId) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfUserdetail.aspx/LoadEmailAccnt",
                data: "{'subId':'" + subId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    $('#<%=ddlEAccnt.ClientID%>').empty();
                    $('#<%=ddlEAccnt.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlEAccnt.ClientID%>').append($("<option></option>").val(value.Id_Email_Acct).html(value.Setting_Name));
                    });
                }
            });
        }

        function loadRole(subId, deptId) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfUserdetail.aspx/LoadRole",
                data: "{'subId':'" + subId + "',deptId:'" + deptId +"'}",
                dataType: "json",
                async: false,//Very important
                success: function (Result) {
                    $('#<%=ddlRole.ClientID%>').empty();
                    $('#<%=ddlRole.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlRole.ClientID%>').append($("<option></option>").val(value.Id_Role).html(value.Nm_Role));
                    });
                }
            });
        }

        function saveUserDetails() {
           var hdnCmid =  document.getElementById('<%=hdnCommonMechId.ClientID%>').value;
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var dept = '';
            var eaccnt = '';
            var lang = '';
            var role = '';
            var subsidiary = '';

            var result = fnClientValidate();
            if (result == true) {

                if ($('#<%=ddlDept.ClientID%>')[0].selectedIndex != 0) {
                    dept = $('#<%=ddlDept.ClientID%>').val();
                }
                if ($('#<%=ddlEAccnt.ClientID%>')[0].selectedIndex != 0) {
                    eaccnt = $('#<%=ddlEAccnt.ClientID%>').val();
                }
                if ($('#<%=ddlLang.ClientID%>')[0].selectedIndex != 0) {
                    lang = $('#<%=ddlLang.ClientID%>').val();
                }
                if ($('#<%=ddlRole.ClientID%>')[0].selectedIndex != 0) {
                    role = $('#<%=ddlRole.ClientID%>').val();
                }
                if ($('#<%=ddlSubsidiary.ClientID%>')[0].selectedIndex != 0) {
                    subsidiary = $('#<%=ddlSubsidiary.ClientID%>').val();
                }

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfUserdetail.aspx/SaveUserDetails",
                    data: "{subId: '" + subsidiary + "', deptId:'" + dept + "', roleId:'" + role + "', flgMech:'" + $('#<%=cbMech.ClientID%>').is(':checked') + "', flgMechInactive:'" + $('#<%=cbMechActive.ClientID%>').is(':checked') + "', loginName:'" + $('#<%=txtLoginName.ClientID%>').val() + "', userId:'" + $('#<%=txtUserId.ClientID%>').val() + "', fName:'" + $('#<%=txtFName.ClientID%>').val() + "', lName:'" + $('#<%=txtLName.ClientID%>').val() + "', pwd:'" + $('#<%=txtPassword.ClientID%>').val() + "', confPwd:'" + $('#<%=txtConfirm.ClientID%>').val() + "', lang:'" + lang + "', teleNo:'" + $('#<%=txtTelNoPersonal.ClientID%>').val() + "', mobile:'" + $('#<%=txtMobile.ClientID%>').val() + "', fax:'" + $('#<%=txtFaxNo.ClientID%>').val() + "', email:'" + $('#<%=txtEmail.ClientID%>').val() + "', cmmid:'" + $('#<%=txtCommonMechId.ClientID%>').val() + "', autocorrection:'" + $('#<%=rdbAutoCorr.ClientID%>').find(":checked").val() + "', ssn:'" + $('#<%=txtSSN.ClientID%>').val() + "', worksfrom:'" + $('#<%=txtWorkHrsFrm.ClientID%>').val() +
                            "',worksto: '" + $('#<%=txtWorkHrsTo.ClientID%>').val() + "',emailaccnt: '" + eaccnt + "',flgworkhrs: '" + $('#<%=cbWrkHrs.ClientID%>').is(':checked') + "',flgDuser: '" + $('#<%=cbDuser.ClientID%>').is(':checked') + "',addrline1: '" + $('#<%=txtAddrLine1.ClientID%>').val() + "',addrline2: '" + $('#<%=txtAddrLine2.ClientID%>').val() + "' ,zipcode: '" + $('#<%=txtZipCode.ClientID%>').val() + "',country: '" + $('#<%=txtCountry.ClientID%>').val() + "',city: '" + $('#<%=txtCity.ClientID%>').val() + "', state:'" + $('#<%=txtState.ClientID%>').val() + "', mode:'" + $('#<%=hdnMode.ClientID%>').val() + "', hdnCmid:'" + $('#<%=hdnCommonMechId.ClientID%>').val() + "'}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d == 'PUID' || data.d == 'INSFLG' || data.d == 'UPDFLG') {
                            jQuery("#dgdUserDetails").jqGrid('clearGridData');
                            loadUserDetails();
                            jQuery("#dgdUserDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                            $('#divUserDetails').hide();
                            $('#divDetails').hide();
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('MSG126', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                            $(document.getElementById('<%=hdnCommonMechId.ClientID%>')).val("");
                        }
                        else if (data.d == 'UPDERR' || data.d == 'PLOGINIED' || data.d == 'CMID' || data.d == 'PLOGINIED') {
                            $('#<%=RTlblError.ClientID%>').text(GetMultiMessage('0006', '', ''));
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                        }
                        else if (data.d == 'CMID_N_Dept') {
                            //Need to show pop-up The Common Mechanic Id entered does not exist. Do you want to continue?
                            var r = confirm(GetMultiMessage('CMMID_N_DEPT', '', ''));
                            if (r == true) {
                                $(document.getElementById('<%=hdnCommonMechId.ClientID%>')).val("True");
                                saveUserDetails();
                            }
                            else {
                                $(document.getElementById('<%=hdnCommonMechId.ClientID%>')).val("");
                            }
                        }
                        else if (data.d == 'CMID_Y_Dept') {
                            //Need to show pop-up The Common Mechanic Id entered already exists in another Department. Do you want to continue?
                            var r = confirm(GetMultiMessage('CMMID_Y_DEPT', '', ''));
                            if (r == true) {
                                $(document.getElementById('<%=hdnCommonMechId.ClientID%>')).val("True");
                                saveUserDetails();
                            }
                            else {
                                $(document.getElementById('<%=hdnCommonMechId.ClientID%>')).val("");
                            }
                        }
                    },
                    error: function (result) {
                        alert("Error");
                    }
                });
            }            
        }

        function loadUserDetails()
        {
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "frmCfUserdetail.aspx/LoadUsers",
                data: '{}',
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    for (i = 0; i < data.d.length; i++) {
                        mydata = data;
                        jQuery("#dgdUserDetails").jqGrid('addRowData', i + 1, mydata.d[i]);
                    }
                }
            });

            jQuery("#dgdUserDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
            getGridHeaders();
            $("#dgdUserDetails").jqGrid("hideCol", "subgrid");
        }

        function delUserDetails() {
            var userId = "";
            $('#dgdUserDetails input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    userId = $('#dgdUserDetails tr ')[row].cells[6].innerHTML.toString();
                }
            });

            if (userId != "")
            {
                var msg = GetMultiMessage('0016', '', '');
                var r = confirm(msg);
                if (r == true) {
                    deleteUser();
                } 
            }
            else
            {
                var msg = GetMultiMessage('SelectRecord', '', '');
                alert(msg);
            }
        }

        function deleteUser()
        {
            var row;
            var userId;
            var userName;
            var userIdxml;
            var userIdxmls = "";
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;

            $('#dgdUserDetails input:checkbox').attr("checked", function () {
                if (this.checked) {
                    row = $(this).closest('td').parent()[0].sectionRowIndex;
                    userId = $('#dgdUserDetails tr ')[row].cells[6].innerHTML.toString();
                    userName = $('#dgdUserDetails tr ')[row].cells[2].innerHTML.toString();
                    userIdxml = "<Master><LOGINID>" + userId + "</LOGINID>" + "<FIRSTNAME>" + userName + "</FIRSTNAME></Master>";
                    userIdxmls += userIdxml;
                }
            });

            if (userIdxmls != "") {
                userIdxmls = "<ROOT>" + userIdxmls + "</ROOT>";
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCfUserdetail.aspx/DeleteUserDetails",
                    data: "{userid: '" + userIdxmls + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        jQuery("#dgdUserDetails").jqGrid('clearGridData');
                        loadUserDetails();
                        jQuery("#dgdUserDetails").setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                        $('#divUserDetails').hide();
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        if (data.d[0]== "DEL")
                        {
                            $('#<%=RTlblError.ClientID%>').removeClass();
                            $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                        }
                        else if (data.d[0] == "NDEL")
                        {
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

        function fnClientValidate() {
            var zipCode = $('#<%=txtZipCode.ClientID%>').val();
            if ($('#<%=ddlRole.ClientID%>')[0].selectedIndex == 0) {
                var msg = GetMultiMessage('0007', GetMultiMessage('0130', '', ''), '');
                alert(msg);
                $('#<%=ddlRole.ClientID%>').focus();
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtLoginName.ClientID%>'), '0131'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtLoginName.ClientID%>'), '0131'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtUserId.ClientID%>'), '0132'))) {
                return false;
            }
            if (!(gfi_ValidateAlphaSpace($('#<%=txtUserId.ClientID%>'), '0132'))) {
                return false;
            }
            if (!(gfb_ValidateAlphabets($('#<%=txtUserId.ClientID%>'), '0132'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtFName.ClientID%>'), '0133'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtFName.ClientID%>'), '0133'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtLName.ClientID%>'), '0134'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtLName.ClientID%>'), '0134'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtPassword.ClientID%>'), '0135'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtPassword.ClientID%>'), '0135'))) {
                return false;
            }
            if (!(gfi_CheckEmpty($('#<%=txtConfirm.ClientID%>'), '0136'))) {
                return false;
            }

            if (!(gfb_ValidateAlphabets($('#<%=txtConfirm.ClientID%>'), '0136'))) {
                return false;
            }

            if ($('#<%=txtPassword.ClientID%>').val() != $('#<%=txtConfirm.ClientID%>').val() || $('#<%=txtPassword.ClientID%>').length != $('#<%=txtConfirm.ClientID%>').length) {
                var msg = GetMultiMessage('0137', '', '');
                alert(msg);
                $('#<%=txtConfirm.ClientID%>').val("");
                $('#<%=txtConfirm.ClientID%>').focus();
                return false;
            }

            if (!(gfi_ValidatePhoneNumber($('#<%=txtTelNoPersonal.ClientID%>'), '0117'))) {
                return false;
            }
            if (!(gfi_ValidatePhoneNumber($('#<%=txtMobile.ClientID%>'), '0041'))) {
                return false;
            }
            if (!(gfi_ValidatePhoneNumber($('#<%=txtFaxNo.ClientID%>'), '0120'))) {
                return false;
            }
            if (!(gfi_ValidateEmail($('#<%=txtEmail.ClientID%>'), ''))) {
                return false;
            }
            if (!(gfb_ValidateAlphabets($('#<%=txtAddrLine1.ClientID%>'), '0115'))) {
                return false;
            }
            if (!(gfb_ValidateAlphabets($('#<%=txtAddrLine2.ClientID%>'), '0115'))) {
                return false;
            }

            if (zipCode != "") {
                if (!(gfb_ValidateAlphabets($('#<%=txtCity.ClientID%>'), '0194'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtCountry.ClientID%>'), '0192'))) {
                    return false;
                }
                if (!(gfb_ValidateAlphabets($('#<%=txtState.ClientID%>'), '0193'))) {
                    return false;
                }
            }

            return true;

            window.scrollTo(0, 0);
        }

    </script>

        <div class="header1 two fields" style="padding-top:0.5em">
              <asp:Label ID="lblHead" runat="server" Text="User Details" ></asp:Label>
              <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
              <asp:HiddenField ID="hdnMode" runat="server" />
              <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
              <asp:HiddenField ID="hdnPageSize" runat="server" />
              <asp:HiddenField ID="hdnSelect" runat="server" />
              <asp:HiddenField ID="hdnCommonMechId" runat="server" />            
        </div>
        <div style="text-align:center">
            <input id="btnAddT" runat="server" type="button" value="Add" class="ui button" onclick="addUserDetails()"/>
            <input id="btnDeleteT" runat="server" type="button" value="Delete" class="ui button" onclick="delUserDetails()" />
            <input id="btnPrintT" runat="server" type="button" value="Print" class="ui button" />
        </div>
        <div>
            <div>
                <table id="dgdUserDetails" title="User Details"></table>
                <div id="pager1"></div>
            </div>
            <div style="text-align:center">
                <input id="btnAddB" runat="server" type="button" value="Add" class="ui button" onclick="addUserDetails()"/>
                <input id="btnDeleteB" runat="server" type="button" value="Delete" class="ui button" onclick="delUserDetails()" />
                <input id="btnPrintB" runat="server" type="button" value="Print" class="ui button"  />
            </div>
            <div id="divUserDetails" class="ui raised segment signup inactive">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" id="aheader" runat="server" >Users</a>
                </div>     
                
                <div class="ui form" style="width: 100%;">
                    <div class="fields">
                        <div class="four wide field">
                            <asp:Label ID="lblSubsidiary" runat="server" Text="Subsidiary"></asp:Label>
                            <asp:DropDownList runat="server" ID="ddlSubsidiary"></asp:DropDownList>
                        </div>
                        <div class="four wide field">
                            <asp:Label ID="lblDepartment" runat="server" Text="Department"></asp:Label>
                            <asp:DropDownList runat="server" ID="ddlDept"></asp:DropDownList>
                        </div>
                        <div class="four wide field">
                            <asp:Label ID="lblRole" runat="server" Text="Role"></asp:Label>
                            <asp:DropDownList runat="server" ID="ddlRole"></asp:DropDownList>             
                        </div>
                        <div class="four wide field"></div>
                         <div class="four wide field"></div>
                        <div>
                            <asp:CheckBox runat="server" ID="cbMech"  Text=" Is Mechanic" ></asp:CheckBox>
                            <asp:CheckBox runat="server" ID="cbMechActive"  Text="InActive" ></asp:CheckBox>
                        </div>
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblLogin" runat="server" Text="Login Name"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtLoginName"  padding="0em" runat="server" ></asp:TextBox>
                        </div>
                        <div class="field" style="width:50px" ></div>                                              
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label id="lblUserId" runat="server" Text="User Id"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtUserId" runat="server" ></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblFName" runat="server" Text="First Name"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtFName" runat="server"></asp:TextBox>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label id="lblLName" runat="server" Text="Last Name"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtLName" runat="server" ></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                           <asp:Label id="lblPassword" runat="server" Text="Password" ></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" ></asp:TextBox>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:180px">
                           <asp:Label id="lblConfirm" runat="server" Text="Confirm Password"></asp:Label><span class="mand">*</span>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password"></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblLang" runat="server" Text="Language"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                              <asp:DropDownList runat="server" ID="ddlLang"></asp:DropDownList>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label id="lblTelNoPerson" runat="server" Text="Telephone No.(Personal)"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtTelNoPersonal" runat="server"></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblMobileNo" runat="server" Text="Mobile No"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtMobile" runat="server"></asp:TextBox>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label id="lblFax" runat="server" Text="Fax No."></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtFaxNo" runat="server"></asp:TextBox>
                        </div>                    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblEmail" runat="server" Text="Email"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:180px">
                            <asp:Label id="lblCommonMechId" runat="server" Text="Common Mechanic ID."></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtCommonMechId" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div  class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px">
                            <asp:Label id="lblAutoCorrectionTime" runat="server" Text="Auto Correction Time?"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                           <asp:RadioButtonList ID="rdbAutoCorr" runat="server" Width="100px" CellSpacing="10" CssClass="optionlist" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1">Yes </asp:ListItem>
                                <asp:ListItem Value="0">No </asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:180px">
                             <asp:Label id="lblSSN" runat="server" Text="Social Security Number"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtSSN" runat="server"></asp:TextBox>
                        </div>    
                    </div>
                    <div  class="four fields">
                        <div class="field" style="padding-left:0.55em;width:180px;margin-top:14px">
                             <asp:Label id="lblWorkHrsFrm" runat="server" Text="Work Hours From"></asp:Label>
                        </div>
                        <div class="field" style="width:200px;margin-top:14px">
                            <asp:TextBox ID="txtWorkHrsFrm" runat="server"></asp:TextBox>
                        </div>   
                        <div class="field" style="width:50px;margin-top:14px" ></div>  
                        <div class="field" style="padding-left:1em;width:180px;margin-top:14px">
                             <asp:Label id="lblWorkHrsTo" runat="server" Text="Work Hours To"></asp:Label>
                        </div>
                        <div class="field" style="width:200px;margin-top:14px">
                            <asp:TextBox ID="txtWorkHrsTo" runat="server"></asp:TextBox>
                        </div>    
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:1em;width:180px">
                             <asp:Label id="lblEAccnt" runat="server" Text="E-mail Account"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:DropDownList runat="server" ID="ddlEAccnt"></asp:DropDownList>
                        </div> 
                    </div>
                    <div class="four fields">
                        <div class="field" style="padding-left:1em;width:180px">
                             <asp:Label id="lblWrkHrs" runat="server" Text="Fetch Work Hours from Day Plan"></asp:Label>
                        </div>
                        <div class="field" style="width:200px;margin-top:14px">
                            <asp:CheckBox runat="server" ID="cbWrkHrs"></asp:CheckBox>
                        </div> 
                        <div class="field" style="padding-left:1em;width:180px">
                             <asp:Label id="lblDuser" runat="server" Text="Dummy User"></asp:Label>
                        </div>
                        <div class="field" style="width:200px;margin-top:14px">
                            <asp:CheckBox runat="server" ID="cbDuser"></asp:CheckBox>
                        </div> 
                    </div>
                </div>
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" runat="server" id="aAddrCom">Address for Communication</a>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblAddrLine1" Text="Address Line 1"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtAddrLine1" runat="server" ></asp:TextBox>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblAddrLine2" Text="Address Line 2"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtAddrLine2" runat="server"  ></asp:TextBox>
                        </div>                    
                    </div>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblZipCode" Text="ZipCode"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <input type="text" runat="server" id="txtZipCode" />
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblCity" Text="City"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtCity" runat="server"  ></asp:TextBox>
                        </div>                    
                    </div>
                </div>
                <div class="ui form" style="width: 100%;">
                    <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblCountry" Text="Country"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtCountry" runat="server" ></asp:TextBox>
                        </div>
                        <div class="field" style="width:50px" ></div>  
                        <div class="field" style="padding-left:1em;width:150px">
                            <asp:Label runat="server" id="lblState" Text="State"></asp:Label>
                        </div>
                        <div class="field" style="width:200px">
                            <asp:TextBox ID="txtState" runat="server"  ></asp:TextBox>
                        </div>                    
                    </div>
                </div>
                <div style="text-align:center">
                    <input id="btnSave" class="ui button" runat="server"  value="Save" type="button" onclick="saveUserDetails()" />
                    <input id="btnReset" class="ui button" runat="server"  value="Reset" type="button" style="background-color: #E0E0E0" onclick="resetUserDet()" />
                </div>               
             </div>
            <div id="divDetails" class="ui form" style="width: 100%;">
                <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                    <a class="active item" runat="server" id="adetails">Details</a>
                </div>
                <div class="four fields">
                    <div class="field" style="padding-left:0.55em;width:150px">
                        <asp:Label runat="server" id="lblCrtdBy" Text="Created By:"></asp:Label>
                    </div>
                    <div class="field" style="text-align:center">
                        <asp:Label runat="server" id="lblUser" style="background-color:#e0e0e0;width:250px" Text=""></asp:Label>
                    </div>
                    <div class="field" style="padding-left:5em;width:150px">
                        <asp:Label runat="server" id="lblOn" Text="On"></asp:Label>
                    </div>
                    <div class="field" style="width:200px;text-align:center">
                        <asp:Label runat="server" id="lblDate" style="background-color:#e0e0e0;width:250px" ></asp:Label>
                    </div>                    
                </div>
                <div class="four fields">
                        <div class="field" style="padding-left:0.55em;width:150px">
                            <asp:Label runat="server" id="lblLastChngBy" Text="Last Changed By:"></asp:Label>
                        </div>
                        <div class="field" style="text-align:center">
                            <asp:Label runat="server" id="lblChangedBy" style="background-color:#e0e0e0;width:250px" Text="Changed By:"></asp:Label>
                        </div>
                        <div class="field" style="padding-left:5em;width:150px">
                            <asp:Label runat="server" id="lblOn1" Text="On"></asp:Label>
                        </div>
                        <div class="field" style="width:200px;text-align:center">
                            <asp:Label runat="server" id="lblChangedDate" style="background-color:#e0e0e0;width:250px" ></asp:Label>
                        </div>                    
               </div>
             </div>
        </div>
</asp:Content>

