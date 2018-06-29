<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImportScanDataSettings.aspx.vb" Inherits="CARS.ImportScanDataSettings" MasterPageFile="~/MasterPage.Master" %>

<asp:Content  ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">

    <script type="text/javascript">
        
        $(document).ready(function () {
            loadDept();
            loadScanDataSettings();
        });

        function loadDept() {
            $.ajax({
                type: "POST",
                url: "ImportScanDataSettings.aspx/FetchAllDepartments",
                data:       '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlDept.ClientID%>').empty();
                    $('#<%=ddlDept.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");

                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlDept.ClientID%>').append($("<option></option>").val(value.DeptId).html(value.DeptName));
                    });

                    if (Result.length == 1) {
                        $('#<%=ddlDept.ClientID%>')[0].selectedIndex = 1;
                    } else {
                        $('#<%=ddlDept.ClientID%>')[0].selectedIndex = 0;
                    }
                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

        function loadScanDataSettings() {
            var deptId = $('#<%=ddlDept.ClientID%>').val();

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ImportScanDataSettings.aspx/LoadScanDataSettings",
                data: "{deptId: '" + deptId + "'}",
                dataType: "json",
                async: false,//Very important
                success: function (data) {
                    if (data.d.length > 0) {                        
                        if (data.d[0].Dpt_ScanFlg == "True") {
                            $("#<%=cbScanInt.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbScanInt.ClientID%>").prop('checked', false);
                        }

                        if (data.d[0].Dpt_Sch_ImportFlag == "True") {
                            $("#<%=cbSchImp.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=cbSchImp.ClientID%>").prop('checked', false);
                        }

                    }
                }
            });

        }

        function saveScanDataSettings() {
            var mode = $('#<%=hdnMode.ClientID%>').val();
            var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
            var deptId = $('#<%=ddlDept.ClientID%>').val();
            var dptScanFlag = $('#<%=cbScanInt.ClientID%>').is(':checked');
            var dptSchImportFlag = $('#<%=cbSchImp.ClientID%>').is(':checked');

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ImportScanDataSettings.aspx/SaveScanDataSettings",
                data: "{deptId: '" + deptId + "', dptScanFlag:'" + dptScanFlag + "', dptSchImportFlag:'" + dptSchImportFlag + "'}",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d[0] == "INSERTED") {
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblMessage");
                      
                        loadScanDataSettings();
                    }
                    else {
                        $('#<%=RTlblError.ClientID%>').text(data.d[1]);
                        $('#<%=RTlblError.ClientID%>').removeClass();
                        $('#<%=RTlblError.ClientID%>').addClass("lblErr");
                    }
                },
                error: function (result) {
                    alert("Error");
                }
            });
        }
        
    </script>


     <div class="header1" style="padding-top:0.5em">
         <asp:Label ID="lblHeader" runat="server" Text="Import Scan Data Settings"></asp:Label>
         <asp:Label ID="RTlblError" runat="server"  CssClass="lblErr"></asp:Label>
         <asp:HiddenField ID="hdnPageSize" runat="server" Value="5" />
         <asp:HiddenField ID="hdnSelect" runat="server" />
         <asp:HiddenField ID="hdnEditCap" runat="server" Value="Edit" />
         <asp:HiddenField id="hdnMode" runat="server" />  
     </div>

    <div >
        <div  style="padding-left:2em;padding-bottom:2em;width:100%">
            <div class="ui secondary vertical menu" style="width: 100%; background-color: #c9d7f1">
                <a class="item" id="a2" runat="server">Import Scan Data Settings</a>
            </div>
        </div>
         <div class="ui form">
             <div class="four fields" style="padding-bottom:0.5em;padding-left:2em;">                                 
                <div class="field" style="width:250px;>
                    <asp:Label ID="lblDepartment" runat="server" Text="Department" Width="100px"></asp:Label>
                </div>
                <div class="field" style="width:150px;padding-bottom:1em">
                    <asp:DropDownList ID="ddlDept" runat="server"></asp:DropDownList>
                </div>                    
             </div> 
             <div class="four fields" style="padding-bottom:0.5em;padding-left:2em;">   
                <div class="field" style="width:250px;">
                    <asp:Label ID="lblScanInt" runat="server" Text="Enable Scanner Interface On Orders" Width="250px"></asp:Label>                                 
                </div>
                 <div class="field" style="width:300px;">                      
                    <asp:CheckBox ID="cbScanInt" runat="server" />       
                </div>
             </div>
             <div  class="four fields" style="padding-bottom:0.5em;padding-left:2em;">
                <div class="field" style="width:250px;">                    
                    <asp:Label ID="lblSchImp" runat="server" Text="Enable Screen To Schedule Import" Width="250px"></asp:Label>
                </div>
                <div class="field" style="width:300px;">     
                     <asp:CheckBox ID="cbSchImp" runat="server" />
                </div>
             </div>
             <div class="four fields" style="padding-bottom:0.5em;">
                 <div class="field" style="text-align:left;padding-left:10em;padding-top:2em;">
                    <input id="btnOk" class="ui button" runat="server"  value="Ok" type="button" onclick="saveScanDataSettings()"/>
                    <input id="btnCancel" class="ui button" runat="server"  value="Cancel" type="button" style="background-color: #E0E0E0" onclick="cancelScanDataSettings()" />
                </div>  
             </div>
         </div>
    </div>




</asp:Content>
