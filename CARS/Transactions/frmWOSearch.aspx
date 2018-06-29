<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmWOSearch.aspx.vb" Inherits="CARS.frmWOSearch" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <style>
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
        $(document).ready(function () {
            var fn;
            $(document).bind('keydown', function (e) { // BIND ESCAPE TO CLOSE
                if (e.which == 27) {
                    overlay('off', '');
                }
            });
            $(".modClose").on('click', function (e) {
                overlay('off', '');
            });

            function overlay(state, mod) {
                $('body').focus();
                if (state == "") {
                    $('.overlayHide').toggleClass('ohActive');
                } else if (state == "on") {
                    $('.overlayHide').addClass('ohActive');
                } else {
                    $('.overlayHide').removeClass('ohActive');
                }
            }

            $('#btnOrderList').on('click', function () {
                //$('#modOrder').removeClass('hidden');
                //$('.overlayHide').addClass('ohActive');
                $('#systemMSG').show();
            });

            $('#btnCustList, #LeftMenuStatic_a2').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $("[id*=grd] tr").not($("[id*=grd] tr:first-child")).remove();
                var custId = $('#<%=txtCustomer.ClientID%>').val();

                $('#systemMSG').show();
                if (fetchCustomer($('#<%=txtCustomer.ClientID%>').val()) == true) {
                    overlay('on', 'modCustomer');
                    $('#mcSearch').val($('#<%=txtCustomer.ClientID%>').val()).focus().select();
                }
            });
            $('.overlayHide').on('click', function () {
                overlay('off', '');
            });

            $('#btnSpareList').on('click', function ()
            {
                console.log("calling openspare..");
                openSparepartGridWindow("frmWOSearch"); //cars.js
            });

            
            


            /* ------------------------------------------------------------------
            VEHICLE SEARCH FUNCTIONS
            -------------------------------------------------------------------*/
            var regNoLink = '';
            //----------Autocomplete code for the vehicle search---------------//
            $('#<%=txtVehicle.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/Vehicle_Search",
                        data: "{q:'" + $('#<%=txtVehicle.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt kjøretøyregister. Trykk enter for å opprette nytt kjøretøy.', value: '0', val: 'new' }]);
                                regNoLink = "&regno=" + $("#<%=txtVehicle.ClientID %>").val();
                            } else
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.VehRegNo + " - " + item.IntNo + " - " + item.VehVin + " - " + item.CustomerName,
                                        val: item.IntNo,
                                        value: item.VehRegNo + " - " + item.IntNo + " - " + item.VehVin
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    window.location.replace("../master/frmVehicleDetail.aspx?refno=" + i.item.val + regNoLink);

                }
            });
            $('#btnVehList').on('click', function (e) {
                var txt_Vehicle = '#<%=txtVehicle.ClientID%>';
                var search_String = $(txt_Vehicle).val();
                var searchId = $(txt_Vehicle).val();
                //e.preventDefault();
                //e.stopPropagation();
                //$('#modVehicle').removeClass('hidden');
                //$('.overlayHide').addClass('ohActive');
                //$('#mvSearch').val(search_String).focus().select();
                //fetchVehicle(search_String);
                //overlay('on', 'modVehicle');
                var page = "../Transactions/frmWOSearchPopup.aspx?Search=Vehicle"
                var $dialog = $('<div id="testdialog" style="width:100%;height:100%"></div>')
                               .html('<iframe id="testifr" style="border: 0px; overflow:scroll" src="' + page + '" width="100%" height="100%"></iframe>')
                               .dialog({
                                   autoOpen: false,
                                   modal: true,
                                   height: 700,
                                   width: 1100,
                                   title: "Kjøretøysøk"
                               });
                $dialog.dialog('open');
            });


            /* ------------------------------------------------------------------
            SPAREPART SEARCH FUNCTIONS
            -------------------------------------------------------------------*/
            
            //----------Autocomplete code for the vehicle search---------------//
            $('#<%=txtSpare.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWOSearch.aspx/SparePart_Search",
                        data: "{q:'" + $('#<%=txtSpare.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager. Trykk enter for å sjekke non-stock registeret.', value: '0', val: 'new' }]);
                                
                            } else
                                response($.map(data.d, function (item) {
                                    imake = item.ID_MAKE;
                                    iid = item.ID_ITEM;
                                    iwh = '1';
                                    return {
                                        label: item.ID_MAKE + " - " + item.ID_ITEM + " - " + item.ITEM_DESC + " - " + item.LOCATION + " - " + item.ID_WH_ITEM,
                                        val: item.ID_ITEM,
                                        value: item.ITEM_DESC,
                                        make: item.ID_MAKE,
                                        warehouse: item.ID_WH_ITEM
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    window.location.replace("../ss3/LocalSPDetail.aspx?id_make=" + i.item.make + "&id_item=" + i.item.val + "&id_wh_item=" + i.item.warehouse);

                }
            });

            /* ------------------------------------------------------------------
            CUSTOMER SEARCH FUNCTIONS
            -------------------------------------------------------------------*/
            $('#<%=txtCustomer.ClientID%>').autocomplete({
                
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/Customer_Search",
                        data: "{q:'" + $('#<%=txtCustomer.ClientID%>').val() + "', 'isPrivate': '" + true + "', 'isCompany': '" + true + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtCustomer.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt kunderegister. Opprette ny?', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.ID_CUSTOMER + " - " + item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME,
                                        val: item.ID_CUSTOMER,
                                        value: item.ID_CUSTOMER + " - " + item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }
                    });
                },
                select: function (e, i) {
                    window.location.replace("../master/frmCustomerDetail.aspx?cust=" + i.item.val);

                }
            });

            $('#btnCustList').on('click', function (e) {
                var txt_Customer = '#<%=txtCustomer.ClientID%>';
                var search_String = $(txt_Customer).val();
                var searchId = $(txt_Customer).val();
                
                var page = "../Transactions/frmWOSearchPopup.aspx?Search=Customer"
                var $dialog = $('<div id="testdialog" style="width:100%;height:100%"></div>')
                               .html('<iframe id="testifr" style="border: 0px; overflow:scroll" src="' + page + '" width="100%" height="100%"></iframe>')
                               .dialog({
                                   autoOpen: false,
                                   modal: true,
                                   height: 700,
                                   width: 1100,
                                   title: "Kundesøk"
                               });
                $dialog.dialog('open');
            });

            function fetchCustomer(s) {
                var isPrivate = true;
                var isCompany = true;
                var pageSize = document.getElementById('<%=hdnPageSize.ClientID%>').value;
                console.log("Running fetchCustomer");
                var grd_Customer = $("#grdCustomer");
                var txt_Order = '#<%=txtOrder.ClientID%>';
                var customer_Data;
                grd_Customer.jqGrid("clearGridData");
                grd_Customer.jqGrid({
                    datatype: "local",
                    data: customer_Data,
                    sortable: true,
                    colNames: ['CustNo', 'CUST_NAME', 'ADDRESS', 'ZIPCODE', 'CITY', 'annen adresse'],
                    colModel: [{ name: 'ID_CUSTOMER', index: 'ID_CUSTOMER', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                                { name: 'CUST_NAME', index: 'CUST_NAME', width: 400, sorttype: "string", classes: 'wosearchpointer' },
                                { name: 'CUST_PERM_ADD1', index: 'CUST_PERM_ADD1', width: 220, sorttype: "string", classes: 'wosearchpointer' },
                                { name: 'ID_CUST_PERM_ZIPCODE', index: 'ID_CUST_PERM_ZIPCODE', width: 120, sorttype: "string", classes: 'wosearchpointer' },
                                { name: 'CUST_PERM_CITY', index: 'CUST_PERM_CITY', width: 220, sorttype: "string", classes: 'wosearchpointer' },
                                { name: 'CUST_VISIT_ADDRESS', index: 'CUST_VISIT_ADDRESS', width: 220, sorttype: "string", classes: 'wosearchpointer' }],
                    gridview: true,
                    viewrecords: true,
                    multselect: true,
                    height: 350,
                    autoWidth: true,
                    shrinkToFit: true,
                    sortorder: "desc",
                    sortname: 'CustNo',
                    caption: "S&oslash;keresultat",
                    async: false,
                    pager: jQuery('#pagerCustomer'),
                    rowNum: pageSize,//can fetch from webconfig
                    rowList: 5
                });

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmWOSearch.aspx/Customer_Search",
                    data: "{q: '" + s + "', 'isPrivate': '" + isPrivate + "', 'isCompany': '" + isCompany + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        for (i = 0; i < data.d.length; i++) {
                            customer_Data = data;
                            console.log(customer_Data.d[i]);
                            grd_Customer.jqGrid('addRowData', i + 1, customer_Data.d[i]);
                        }
                        grd_Customer.setGridParam({ rowNum: pageSize }).trigger("reloadGrid");
                    }
                });
                
            }

            //------------------------------------ORDER functions-------------------------------------------------

            $('#<%=txtOrder.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmWoSearch.aspx/GetOrder",
                        data: "{'orderNo':'" + $('#<%=txtOrder.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0] + "-" + item.split('-')[1] + "-" + item.split('-')[2] + "-" + item.split('-')[3] + "-" + item.split('-')[4],
                                    val: item.split('-')[0],
                                    value: item.split('-')[1],
                                    woNo: item.split('-')[0],
                                    woPr: item.split('-')[5],
                                    mode: 'Edit',
                                    flag: encodeURIComponent('Ser')

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
                    $("#<%=txtOrder.ClientID%>").val(i.item.val);
                    window.parent.window.location.assign("../Transactions/frmWOJobDetails.aspx?Wonumber=" + i.item.woNo + "&WOPrefix=" + i.item.woPr + "&Mode=" + i.item.mode + "&TabId=" + 2 + "&Flag=" + i.item.flag + "&blWOsearch=" + true);
                }

            });
           

            //$(function () {
            //    var widthRatio = $('#testdialog').width() / $(window).width();
            //    $(window).resize(function () {
            //        $('#testdialog').css({ width: $(window).width() * widthRatio });
            //    });
            //});


            $('#btnOrderList').on('click', function (e) {
                var txt_Order = '#<%=txtOrder.ClientID%>';
                var search_String = $(txt_Order).val();
                var searchId = $(txt_Order).val();
                //e.preventDefault();
                //e.stopPropagation();
                //$('#modOrder').removeClass('hidden');
                //$('.overlayHide').addClass('ohActive');
                //$('#moSearch').val(search_String).focus().select();
                //fetchOrder(search_String);
                //overlay('on', 'modOrder');
                var page = "../Transactions/frmWOSearchPopup.aspx?Search=Order"
                var $dialog = $('<div id="testdialog" style="width:100%;height:100%"></div>')
                               .html('<iframe id="testifr" style="border: 0px; overflow:scroll" src="' + page + '" width="100%" height="100%"></iframe>')
                               .dialog({
                                   autoOpen: false,
                                   modal: true,
                                   width: '80%',
                                   height: 700,
                                   title: "Ordresøk"
                               });
                $dialog.dialog('open');
            });

           

        }); //end of reaady

        $('.ui-widget-overlay').live("click", function () {
            console.log('Execute close command on dialog');
            $dialog.dialog("close");
        });



    </script>

    <div class="overlayHide"></div>
    <div class="ui grid content-width">
        <div class="four wide column">
        </div>
        <div class="six wide column">
            <h3 class="ui dividing header">
                <asp:Literal runat="server" Text="Ordresøk"></asp:Literal></h3>
            <div class="field">
                <div class="ui action input mini">
                    <asp:TextBox ID="txtOrder" runat="server" CssClass="inp" Width="300px" MaxLength="50" PlaceHolder="Ordrenr, kundenr, regnr etc."></asp:TextBox>
                    <input id="btnOrderList" type="button" value="S&oslash;k" class="ui btn" width="90px" value="Work Order Search" />
                    <a href="frmWOJobDetails.aspx" class="ui btn" title="Ny ordre">Ny</a>
                </div>
            </div>
            <asp:HiddenField ID="HiddenField1" runat="server" Value="Work Order Search" />
             <asp:HiddenField id="hdnPageSize" runat="server" />  
            <h3 class="ui dividing header">
                <asp:Literal runat="server" Text="Kundesøk"></asp:Literal></h3>
            <div class="field">
                <div class="ui action input mini">
                    <asp:TextBox ID="txtCustomer" runat="server" CssClass="inp" Width="300px" MaxLength="50" PlaceHolder="Kundenr, navn, addresse etc."></asp:TextBox>
                    <input id="btnCustList" type="button" value="S&oslash;k" class="ui btn" width="90px" />
                    <a href="../master/frmCustomerDetail.aspx" class="ui btn" title="Ny kunde">Ny</a>
                </div>
            </div>
            <h3 class="ui dividing header">
                <asp:Literal runat="server" Text="Kjøretøysøk"></asp:Literal></h3>
            <div class="field">
                <div class="ui action input mini">
                    <asp:TextBox ID="txtVehicle" runat="server" CssClass="inp" Width="300px" MaxLength="50" PlaceHolder="Regnr, Internnr, Chassisnr etc."></asp:TextBox>
                    <input id="btnVehList" type="button" value="S&oslash;k" class="ui btn" width="90px" value="Work Order Search" />
                    <a href="../master/frmVehicleDetail.aspx" class="ui btn" title="Ny kunde">Ny</a>
                </div>

            </div>
            <h3 class="ui dividing header">
                <asp:Literal runat="server" Text="Varesøk"></asp:Literal></h3>
            <div class="field">
                <div class="ui action input mini">
                    <asp:TextBox ID="txtSpare" runat="server" CssClass="inp" Width="300px" MaxLength="50" PlaceHolder="Spareno, sparename, location, supplier etc."></asp:TextBox>
                    <input id="btnSpareList" type="button" value="S&oslash;k" class="ui btn" width="90px" value="Spare Part Search" />
                    <a href="../ss3/LocalSPDetail.aspx" class="ui btn" title="Ny vare">Ny</a>
                </div>

            </div>

        </div>
        <div class="six wide column">
        </div>
        <div class="four wide column">
        </div>
    </div>
</asp:Content>

