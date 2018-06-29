<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SupplierDetail.aspx.vb" Inherits="CARS.SupplierDetail" MasterPageFile="~/MasterPage.Master" meta:resourcekey="PageResource2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">

    
   <script type="text/javascript">
       var custvar = {};
       var contvar = {};
       $(document).ready(function () {
           var debug = true;
           var mode = 'add';
           loadInit();
           function loadInit() {
               setTab('Supplier');
           }
           // START GEN MOD SCRIPTS
           function overlay(state, mod) {
               $('body').focus();
               if (mod == "") {
                   $('.modal').addClass('hidden');
               }
               else {
                   $('#' + mod).removeClass('hidden');
               }
               if (state == "") {
                   $('.overlayHide').toggleClass('ohActive');
               } else if (state == "on") {
                   $('.overlayHide').addClass('ohActive');
               } else {
                   $('.overlayHide').removeClass('ohActive');
               }
           }
           $(document).bind('keydown', function (e) { // BIND ESCAPE TO CLOSE
               if (e.which == 27) {
                   overlay('off', '');
               }
           });
           $(".modClose").on('click', function (e) {
               overlay('off', '');
           });
           function collectGroupData(dataTag) {
               dataCollection = {};
               $('[data-' + dataTag + ']').each(function (index, elem) {
                   var st = $(elem).data(dataTag);
                   var dv = '';
                   var elemType = $(elem).prop('nodeName');
                   switch (elemType) {
                       case 'INPUT':
                           dv = $(elem).val();
                           break;
                       case 'TEXTAREA':
                           dv = $(elem).val();
                           break;
                       case 'SELECT':
                           dv = $(elem).val();
                           break;
                       case 'LABEL':
                           dv = $(elem).html();
                           break;
                       case 'SPAN':
                           if ($(elem).children('input').is(':checked')) {
                               dv = '1';
                           } else {
                               dv = '0';
                           }
                           break;
                       default:
                           dv = '01';
                   }
                   if (debug) {
                       console.log(index + ' Added ' + dataTag + ': ' + st + ' with value: ' + dv + ' and type: ' + elemType);
                   }
                   dataCollection[st] = $.trim(dv);
               });
               return dataCollection;
           }
           // END GEN MOD SCRIPTS
           function setTab(cTab)
           {
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

            /* ------------------------------------------------------------------
                       SUPPLIER SEARCH FUNCTIONS
                        -------------------------------------------------------------------*/
            
           $('#<%=txtSupplierSearch.ClientID%>').autocomplete({


                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "SupplierDetail.aspx/Supplier_Search",
                        data: "{q:'" + $('#<%=txtSupplierSearch.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtSupplierSearch.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager', value: " ", val: 'new' }]);
                                
                            } else
                                response($.map(data.d, function (item) {
                                    
                                    return {
                                        label: item.SUPP_CURRENTNO + " - " + item.SUP_Name + " - " + item.SUP_CITY + " - " + item.ID_SUPPLIER,
                                        val: item.SUPP_CURRENTNO,
                                        value: item.ITEM_DESC
                                       
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

                    console.log("item value : " + i.item.val);
                   
                    if (i.item.val != 'new')
                    {                      
                        FetchSupplierDetails(i.item.val);
                    }
                    else
                    {
                        $('#aspnetForm')[0].reset();
                        $('#<%=txtSupplierName.ClientID%>').focus();
                        
                    }
                                      
                }
            });

           function FetchSupplierDetails(ID_SUPPLIER) {
                cpChange = '';
                $.ajax({
                    type: "POST",
                    url: "SupplierDetail.aspx/FetchSupplierDetail",
                    data: "{ID_SUPPLIER: '" + ID_SUPPLIER + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        console.log(data.d[0]);
                        $('#<%=txtSupplierId.ClientID%>').val(data.d[0].SUPP_CURRENTNO);
                        $('#<%=txtSupplierName.ClientID%>').val(data.d[0].SUP_Name);
                        $('#<%=txtPermAdd1.ClientID%>').val(data.d[0].SUP_Address1);
                        $('#<%=txtPermZip.ClientID%>').val(data.d[0].SUP_Zipcode);
                        $('#<%=txtPermCity.ClientID%>').val(data.d[0].SUP_CITY);
                        $('#<%=txtPermCounty.ClientID%>').val(data.d[0].SUP_REGION);
                        $('#<%=txtPermCountry.ClientID%>').val(data.d[0].SUP_COUNTRY);
                        $('#<%=txtSupplierMail.ClientID%>').val(data.d[0].SUP_ID_Email);
                        $('#<%=txtSupplierPhone.ClientID%>').val(data.d[0].SUP_Phone_Off);
                        $('#<%=txtAdvSupplierId.ClientID%>').val(data.d[0].ID_SUPPLIER);
                        $('#<%=txtSupplierContactPerson.ClientID%>').val(data.d[0].SUP_Contact_Name);
                        $('#<%=lblSupplierDateCreated.ClientID%>').html(data.d[0].DT_CREATED + " by " + data.d.CREATED_BY);
                        $('#<%=txtBillAdd1.ClientID%>').val(data.d[0].SUP_BILLAddress1);
                        $('#<%=txtBillZip.ClientID%>').val(data.d[0].SUP_BILLZipcode);
                        $('#<%=txtBillCity.ClientID%>').val(data.d[0].SUP_BILL_CITY);
                        $('#<%=txtBillCountry.ClientID%>').val(data.d[0].SUP_BILL_COUNTRY);
                        if (data.d[0].FLG_SAME_ADDRESS === 'True') {
                            $("#<%=chkSameAdd.ClientID%>").prop('checked', true);
                        } else {
                            $("#<%=chkSameAdd.ClientID%>").prop('checked', false);
                        }
                        $('#<%=txtSupplierWebPage.ClientID%>').val(data.d[0].SUP_WEBPAGE);

                        if (data.d[0].CURRENCY_CODE != '') {
                            FetchCurrencyDetails(data.d[0].CURRENCY_CODE);
                        }

                        $('#<%=txtAdvCurrencyId.ClientID%>').val(data.d[0].CURRENCY_CODE);
                                                         
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                
           };

           function saveSupplier()
           {
               
               var sup = collectGroupData('submit');
               
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "SupplierDetail.aspx/InsertSupplier",                   
                    data: "{Supplier:'" + JSON.stringify(sup) + "'}",
                    dataType: "json",
                    //async: false,//Very important
                    success: function (data)
                    {
                        $('.loading').removeClass('loading');
                        
                        if (data.d[0] == "INSFLG")
                        {
                            //if we have a parentwindow in background that needs input values to be set
                            if (window.parent != undefined && window.parent != null && window.parent.length > 0)
                            {                                                     
                                saveInputBackToParentWindow(data.d[1]);                            
                                window.parent.$('.ui-dialog-content:visible').dialog('close');
                            }
                            else
                            {    
                                $('#<%=txtSupplierId.ClientID%>').val(data.d[1]);
                            }
                            systemMSG('success', 'The spare part has been saved!', 4000);
                            
                        }
                        else if (data.d[0] == "UPDFLG")
                        {
                            //if we have a parentwindow in background that needs input values to be set
                            if (window.parent != undefined && window.parent != null && window.parent.length > 0) {
                                saveInputBackToParentWindow(data.d[1]);
                                window.parent.$('.ui-dialog-content:visible').dialog('close');
                            }
                            
                            systemMSG('success', 'Spare Part post has been updated!', 4000);                           
                            
                        }
                        else if (data.d[0] == "ERRFLG")
                        {
                            systemMSG('error', 'An error occured while trying to save the spare part, please check input data.', 4000);
                        }
                        
                    },
                    error: function (xhr, ajaxOptions, thrownError)
                    {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
           }

           function saveInputBackToParentWindow(supplierId)
           {

               console.log("suppid is " + supplierId);
               window.parent.document.getElementById('ctl00_cntMainPanel_txtInfoSupplier').value = supplierId;
               window.parent.document.getElementById('ctl00_cntMainPanel_txtInfoSupplierName').value = $('#<%=txtSupplierName.ClientID%>').val();
           }

           $('#ID_SUPPLIER_WRAPPER').on('click', function () {
                if ($('#<%=txtSupplierId.ClientID%>').prop('disabled') && $('#<%=txtSupplierId.ClientID%>').val().length == 0) {
                    console.log('read only true');
                    $('#modSupplierLock').modal('setting', {
                        onDeny: function () {
                            $('#<%=txtSupplierSearch.ClientID%>').focus();
                        },
                        onApprove: function () {
                            $('#<%=txtSupplierId.ClientID%>').removeAttr('disabled').removeAttr('readonly').focus();
                            console.log('Enabled the #ID_SUPPLIER field');
                        },
                        onShow: function () {
                            $(this).children('ui.button.ok.positive').focus();
                        }
                    }).modal('show');
                }
           });

           $('#<%=txtSupplierId.ClientID%>').on('blur', function () {
              
                $.ajax({
                    type: "POST",
                    url: "SupplierDetail.aspx/FetchSupplierDetail",
                    data: "{ID_SUPPLIER: '" + $('#<%=txtSupplierId.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        console.log(data.d[0]);
                        if (data.d[0] == null) {
                            console.log('OK');
                        } else {
                            console.log('Error');
                            $('#mseMSG').html('Nummer er allerede i bruk på ' + data.d[0].SUP_Name + ', vil du åpne leverandør for redigering eller vil du prøve et annet nummer?')
                            $('#modSupplierExists').modal('setting', {
                                onDeny: function () {
                                    $('#<%=txtSupplierId.ClientID%>').val('');
                                    $('#<%=txtSupplierId.ClientID%>').focus();
                                },
                                onApprove: function () {
                                    FetchSupplierDetails($('#<%=txtSupplierId.ClientID%>').val());
                                }
                            }).modal('show');
                        }
                    }
                });
               
           });

           //autocomplete for listing of the currency
          
            $('#<%=txtAdvCurrencyId.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "SupplierDetail.aspx/Currency_Search",
                        data: "{q:'" + $('#<%=txtAdvCurrencyId.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtAdvCurrencyId.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i leveradør register. Opprette ny?', value: '0', val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    
                                    return {
                                        label: item.ID_CURRENCY + " - " + item.CURRENCY_CODE + " - " + item.CURRENCY_DESCRIPTION,
                                        val: item.CURRENCY_CODE,
                                        value: item.CURRENCY_CODE,
                                        currencyName: item.CURRENCY_DESCRIPTION,
                                        currencyRate: item.CURRENCY_RATE
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
                    //window.location.replace("../master/frmCustomerDetail.aspx?cust=" + i.item.ID_ITEM);
                    $('#<%=txtAdvCurrencyId.ClientID%>').val(i.item.val);
                    //$('#<%=lblAdvCurrencyDesc.ClientID%>').html(i.item.currencyName + " - Rate: " + i.item.currencyRate);
                    //$('#<%=txtAdvCurrencyId.ClientID%>').focus();
                    FetchCurrencyDetails($('#<%=txtAdvCurrencyId.ClientID%>').val());
                }
            });

           function FetchCurrencyDetails(CURRENCY_CODE) {
               console.log(CURRENCY_CODE);
                cpChange = '';
                $.ajax({
                    type: "POST",
                    url: "SupplierDetail.aspx/FetchCurrencyDetail",
                    data: "{CURRENCY_CODE: '" + CURRENCY_CODE + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        console.log(data.d);
                      
                        $('#<%=txtAdvCurrencyId.ClientID%>').val(data.d.CURRENCY_CODE);
                        $('#<%=lblAdvCurrencyDesc.ClientID%>').html(data.d.CURRENCY_DESCRIPTION + " - Rate: " + data.d.CURRENCY_RATE);
                        //$('#<%=txtAdvCurrencyId.ClientID%>').focus();

                       
                     
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                
           };


           $("#btnSupEmptyScreen").on('click', function (e) {
                $(this).addClass('loading');
                $('#aspnetForm')[0].reset();
                $('.loading').removeClass('loading');
            });

           $('#btnSupSave').on('click', function (e) {

               console.log('button clicked');
               if (requiredFields(true, 'data-submit') === true) {
                   $(this).addClass('loading');
                   saveSupplier();

               }
           });

           $('#<%=btnSupplierOpenMail.ClientID%>').on('click', function (e) {
               var email = $('#<%=txtSupplierMail.ClientID%>').val();
               //var subject = '';
               //var emailBody = '';
               //var attach = 'path';
            
               document.location = "mailto:" + email;
           });
           $('#<%=btnOpenWebPage.ClientID%>').on('click', function (e) {
                var url = $('#<%=txtSupplierWebPage.ClientID%>').val();
                window.open(url, '_blank');
           });

           $('#<%=chkSameAdd.ClientID%>').on('click', function (e) {
                setBillAdd();
           });

           function sameAdressIsChecked() {
                if ($('#<%=chkSameAdd.ClientID%>').is(':checked'))
                    return true;
                else
                    return false;
           }

           function setBillAdd() {
                if (sameAdressIsChecked()) {
                    $('#<%=txtBillAdd1.ClientID%>').val($('#<%=txtPermAdd1.ClientID%>').val()).prop('disabled', true);
                    $('#<%=txtBillAdd2.ClientID%>').val($('#<%=txtPermAdd2.ClientID%>').val()).prop('disabled', true);
                    $('#<%=txtBillZip.ClientID%>').val($('#<%=txtPermZip.ClientID%>').val()).prop('disabled', true);
                    $('#<%=txtBillCity.ClientID%>').val($('#<%=txtPermCity.ClientID%>').val()).prop('disabled', true);
                    $('#<%=txtBillCounty.ClientID%>').val($('#<%=txtPermCounty.ClientID%>').val()).prop('disabled', true);
                    $('#<%=txtBillCountry.ClientID%>').val($('#<%=txtPermCountry.ClientID%>').val()).prop('disabled', true);
                }
                else {
                    $('#<%=txtBillAdd1.ClientID%>').prop('disabled', false);
                    $('#<%=txtBillAdd2.ClientID%>').prop('disabled', false);
                    $('#<%=txtBillZip.ClientID%>').prop('disabled', false);
                    $('#<%=txtBillCity.ClientID%>').prop('disabled', false);
                    $('#<%=txtBillCounty.ClientID%>').prop('disabled', false);
                    $('#<%=txtBillCountry.ClientID%>').prop('disabled', false);
                }
            }
            
       });


        window.onbeforeunload = confirmExit;
        function confirmExit() {
            if (checkSaveVar()) {

            } else {
                return "Det kan være ulagrede endringer på siden, er du sikker på at du vil lukke siden?";
            }
        }
        function setSaveVar() {
            supvar = collectGroupData('submit');
            
        }
        function checkSaveVar() {
            contvar = collectGroupData('submit');
            //if (JSON.stringify(custvar) === JSON.stringify(contvar)) {
            if(objectEquals(supvar, contvar)){
                return true;
            }
            else {
                return false;
            }
        }
        function clearSaveVar() {
            supvar = {};
        }
       
   

    </script>
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <div class="overlayHide"></div>
    <div id="systemMessage" class="ui message"> </div>
    
    <%-- Modal for sjekking av eksisterende kundenummer --%>
    <div id="modSupplierExists" class="ui modal">
        <div class="header">
            Advarsel!
        </div>
        <div class="image content">
            <div class="image">
                <i class="warning icon"></i>
            </div>
            <div class="description">
                <p id="mseMSG"></p>
            </div>
        </div>
        <div class="actions">
            <div class="ui button ok">Se på leverandør</div>
            <div class="ui button cancel">Prøv nytt nummer</div>
        </div>
    </div>
    <div id="modSupplierLock" class="ui modal">
        <div class="header">
            <asp:Literal runat="server" ID="SupplierLockHead" meta:resourcekey="SupplierLockHeadResource1" Text="Advarsel!"></asp:Literal>
        </div>
        <div class="image content">
            <div class="image">
                <i class="warning icon"></i>
            </div>
            <div class="description">
                <p><asp:Label runat="server" ID="SupplierLock1" meta:resourcekey="SupplierLock1Resource1" Text="Leverandørnummer er låst for manuell inntasting. Dette nummeret blir automatisk tildelt ved lagring av leverandør."></asp:Label></p>
                <p><asp:Literal runat="server" ID="SupplierLock2" meta:resourcekey="SupplierLock2Resource1" Text="Ønsker du å søke opp leverandør, trykk avbryt og bruk søkefeltet til høyre."></asp:Literal></p>
                <p><asp:Literal runat="server" ID="SupplierLock3" meta:resourcekey="SupplierLock3Resource1" Text="For å tildele manuelt leverandørnummer, velg &quot;lås opp&quot; for å låse opp feltet for inntasting."></asp:Literal></p>
            </div>
        </div>
        <div class="actions">
            <div class="ui button ok positive"><asp:Literal runat="server" ID="SupplierLockOK" meta:resourcekey="SupplierLockOKResource1" Text="Lås opp"></asp:Literal></div>
            <div class="ui button cancel negative"><asp:Literal runat="server" ID="SupplierLockCancel" meta:resourcekey="SupplierLockCancelResource1" Text="Avbryt"></asp:Literal></div>
        </div>
    </div>

    <%-- Modal for sjekking av eksisterende kundenummer --%>
    <div id="modCustomerExists" class="ui modal">
        <div class="header">
            Advarsel!
        </div>
        <div class="image content">
            <div class="image">
                <i class="warning icon"></i>
            </div>
            <div class="description">
                <p id="mceMSG"></p>
            </div>
        </div>
        <div class="actions">
            <div class="ui button ok">Se på leverandør</div>
            <div class="ui button cancel">Prøv nytt nummer</div>
        </div>
    </div>
    <%-- Modal for Eniro search pop up --%>
    <div id="modNewCust" class="modal hidden">
        <div class="modHeader">
            <h2 id="H1" runat="server">Find Customer</h2>
            <div class="modCloseCust"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <%-- <div class="ui form">
                    <div class="field">
                        <label class="sr-only">Nytt kjøretøy</label>
                        <div class="ui small info message">
                            <p id="P1" runat="server">Velg bilstatus før du går videre</p>
                        </div>
                    </div>
                </div>--%>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form ">
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="Label1" Text="Søk etter leverandør (Tlf, navn, sted, etc.)" runat="server" meta:resourcekey="Label1Resource1"></asp:Label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <asp:TextBox ID="txtEniro" runat="server" meta:resourcekey="txtEniroResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnEniroFetch" runat="server" class="ui mini icon input" value="Fetch" style="width: 50%" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <label id="Label3" runat="server">Customer</label>
                                <select id="CustSelect" runat="server" size="13" class="wide dropdownList">
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="ui form">
        <div class="inline fields">
            <input type="button" value="Leverandør" id="btnSupplier" class="ui btn cTab" data-tab="Supplier" />
            <input type="button" value="Avansert" id="btnAdvanced" class="ui btn cTab" data-tab="Advanced" />
            <input type="button" value="Rabatter" id="btnDiscount" class="ui btn cTab" data-tab="Discount" />
            <input type="button" value="Div" id="btnVehicle" class="ui btn cTab" data-tab="Vehicle" />

        </div>
    </div>
    <h2 class="ui top attached small header">Supplier Details</h2>
    <div class="ui form attached segment">
        <div class="ui stackable grid">
            <div id="ID_SUPPLIER_WRAPPER" class="four wide computer four wide tablet column">
                <div class="inline fields">
                    <label for="txtSupplierId" id="lblSupplierId" runat="server"><asp:Label ID="lblsuppId" runat="server" Text="Leverandørnr." meta:resourcekey="lHeadResource1"></asp:Label></label>
                    <asp:TextBox ID="txtSupplierId" runat="server" data-submit="SUPP_CURRENTNO" Enabled="False" CssClass="eight char field" meta:resourcekey="txtCustomerIdResource1"></asp:TextBox>
                </div>
            </div> <!-- /# id_customer_wrapper column -->
            <div class="six wide computer eight wide tablet column ">
               <div class="inline fields">
                    <label for="txtSuppId"><asp:Label ID="lblHead" runat="server" Text="Leverandørsøk" meta:resourcekey="lHeadResource1"></asp:Label></label>
                    <asp:TextBox ID="txtSupplierSearch" runat="server" meta:resourcekey="txtCustIdResource1" placeholder="søk etter tlf, navn, addresse..."></asp:TextBox>
                    <input type="button" id="btnSearchSupplier" runat="server" value="Søk" class="ui btn mini" />
                </div>
            </div> <!-- /column -->
             <!-- /column -->
        </div>
    </div>
 

        <%--########################################## SUPPLIER ##########################################--%>
    <div id="tabSupplier" class="tTab">
        <div class="ui grid">
            <div class="eleven wide column">
                <div class="ui form">
                    <h3 id="lblCustomerPanel" class="ui top attached tiny header">Details</h3>
                    <div class="ui attached segment">
                        <%--Customer info panel--%>
                        <label>
                            <asp:CheckBox ID="chkPrivOrSub" runat="server" Text="Company" CssClass="inHeaderCheckbox" data-submit="FLG_PRIVATE_COMP" meta:resourcekey="chkPrivOrSubResource1" />
                        </label>

                        <div class="ui stackable grid" id="priv">

                            <div class="ten wide column" data-type="po">
                                <asp:Label ID="lblSupplierName" Text="Supplier name" runat="server" meta:resourcekey="lblSuppliernameResource1"></asp:Label>
                                <asp:TextBox ID="txtSupplierName" runat="server" data-submit="SUP_Name" data-required="REQUIRED" meta:resourcekey="txtFirstnameResource1"></asp:TextBox>
                            </div>
                            <div class="six wide column" data-type="po">
                               
                            </div>
                        </div>
                        <div class="fields">
                            <div class="ui grid">
                                <div id="panelPermAdd" class="sixteen wide computer sixteen wide tablet sixteen wide mobile column">
                                    <div class="column">
                                        <asp:Label ID="lblPermAdd" Text="Visit address" runat="server" meta:resourcekey="lblPermAddResource1"></asp:Label>
                                        <asp:TextBox ID="txtPermAdd1" runat="server" data-submit="SUP_Address1" meta:resourcekey="txtPermAdd1Resource1"></asp:TextBox>
                                        <asp:TextBox ID="txtPermAdd2" runat="server" Visible="False" data-submit="CUST_PERM_ADD2" CssClass="mt3" meta:resourcekey="txtPermAdd2Resource1"></asp:TextBox>
                                    </div>
                                    <div class="column">
                                        <div class="ui two column stackable grid">
                                            <div class="column">
                                                <div class="ui grid">
                                                    <div class="five wide column">
                                                        <asp:Label ID="lblPermZip" Text="Zipcode" runat="server" meta:resourcekey="lblPermZipResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermZip" runat="server" data-submit="SUP_Zipcode" meta:resourcekey="txtPermZipResource1"></asp:TextBox>
                                                    </div>
                                                    <div class="eleven wide column">
                                                        <asp:Label ID="lblPermCity" Text="City" runat="server" meta:resourcekey="lblPermCityResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermCity" runat="server" data-submit="SUP_CITY" meta:resourcekey="txtPermCityResource1"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="column">
                                                <div class="ui two column grid">
                                                    <div class="column">
                                                        <asp:Label ID="lblPermCounty" Text="County(fyl)" runat="server" meta:resourcekey="lblPermCountyResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermCounty" runat="server" data-submit="SUP_REGION" meta:resourcekey="txtPermCountyResource1"></asp:TextBox>
                                                    </div>
                                                    <div class="column">
                                                        <asp:Label ID="lblPermCountry" Text="Country" runat="server" meta:resourcekey="lblPermCountryResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermCountry" runat="server" data-submit="SUP_COUNTRY" meta:resourcekey="txtPermCountryResource1"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="panelBillAdd" class="sixteen wide computer sixteen wide tablet sixteen wide mobile column">
                                    <div class="column">
                                        <asp:Label ID="lblBillAdd" Text="Postal address" runat="server" meta:resourcekey="lblBillAddResource1"></asp:Label>
                                        <label>
                                            <asp:CheckBox ID="chkSameAdd" runat="server" Text="Same as visit address" CssClass="inLblCheckbox" data-submit="FLG_SAME_ADDRESS" meta:resourcekey="chkSameAddResource1" />
                                        </label>
                                        <asp:TextBox ID="txtBillAdd1" runat="server" data-submit="SUP_BILLAddress1" meta:resourcekey="txtBillAdd1Resource1"></asp:TextBox>
                                        <asp:TextBox ID="txtBillAdd2" runat="server" Visible="False" data-submit="CUST_BILL_ADD2" CssClass="mt3" meta:resourcekey="txtBillAdd2Resource1"></asp:TextBox>
                                    </div>
                                    <div class="column">
                                        <div class="ui two column stackable grid">
                                            <div class="column">
                                                <div class="ui grid">
                                                    <div class="five wide column">
                                                        <asp:Label ID="lblBillZip" Text="Zipcode" runat="server" meta:resourcekey="lblBillZipResource1"></asp:Label>
                                                        <asp:TextBox ID="txtBillZip" runat="server" data-submit="SUP_BILLZipcode" meta:resourcekey="txtBillZipResource1"></asp:TextBox>
                                                    </div>
                                                    <div class="eleven wide column">
                                                        <asp:Label ID="lblBillCity" Text="City" runat="server" meta:resourcekey="lblBillCityResource1"></asp:Label>
                                                        <asp:TextBox ID="txtBillCity" runat="server" data-submit="SUP_BILL_CITY" meta:resourcekey="txtBillCityResource1"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="column">
                                                <div class="ui two column grid">
                                                    <div class="column">
                                                        <asp:Label ID="lblBillCounty" Text="County(fyl)" runat="server" meta:resourcekey="lblBillCountyResource1"></asp:Label>
                                                        <asp:TextBox ID="txtBillCounty" runat="server" meta:resourcekey="txtBillCountyResource1"></asp:TextBox>
                                                    </div>
                                                    <div class="column">
                                                        <asp:Label ID="lblBillCountry" Text="Country" runat="server" meta:resourcekey="lblBillCountryResource1"></asp:Label>
                                                        <asp:TextBox ID="txtBillCountry" runat="server" data-submit="SUP_BILL_COUNTRY" meta:resourcekey="txtBillCountryResource1"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Menu pricing / EPC Program path</h3>
                    <div class="ui attached segment">
                            <div class="ui form ">
                                <div class="fields">
                                    <div class="four wide field">
                                        <asp:Label ID="lblCompanyPersonFind" Text="Menu pricing:" runat="server"  meta:resourcekey="lblCompanyPersonFindResource1"></asp:Label>
                                        </div>
                                    <div class="eight wide field">
                                        <asp:TextBox ID="txtCompanyPersonFind" runat="server"  meta:resourcekey="txtCompanyPerson2Resource1"></asp:TextBox>
                                        </div>
                                    <div class="four wide field">
                                        <input type="button" id="btnSupplierMenuPricing" runat="server" class="ui btn" value="Finn mål" meta:resourcekey="btnCompanyPersonResource1" />
                                    </div>
                                    </div>
                                    <div class="fields">
                                    <div class="four wide field">
                                        <asp:Label ID="lblSupplierEPC" Text="Electronic parts catalogue:" runat="server"  meta:resourcekey="lblCompanyPersonFindResource1"></asp:Label>
                                    </div>
                                        <div class="eight wide field">
                                        <asp:TextBox ID="txtSupplierEPC" runat="server" CssClass="texttest" meta:resourcekey="txtCompanyPerson2Resource1"></asp:TextBox>
                                        </div>
                                        <div class="four wide field">
                                            <input type="button" id="btnSupplierEPC" runat="server" class="ui btn" value="Finn mål" meta:resourcekey="btnCompanyPersonResource1" />
                                        </div>
                                    </div>
                                <div class="fields">
                                    <div class="four wide field">
                                        <asp:Label ID="lblSupplierEAC" Text="Electronic accessories Catalogue:" runat="server"  meta:resourcekey="lblCompanyPersonFindResource1"></asp:Label>
                                    </div>
                                    <div class="eight wide field">
                                        <asp:TextBox ID="txtSupplierEAC" runat="server" CssClass="texttest" meta:resourcekey="txtCompanyPerson2Resource1"></asp:TextBox>
                                    </div>
                                    <div class="four wide field">
                                            <input type="button" id="btnSupplierEAC" runat="server" class="ui btn" value="Finn mål" meta:resourcekey="btnCompanyPersonResource1" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

          
            
            <%-- End Left Column --%>

            <div class="five wide column">
                <%-- Start Right Column --%>
                <div class="ui form">
                    <h3 id="lblContribution" class="ui top attached tiny header" runat="server">Bidrag:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="ten wide field">
                                <label id="lblSupplierContactPerson" runat="server">Contact person</label>
                                <asp:TextBox ID="txtSupplierContactPerson" runat="server" data-submit="SUP_Contact_Name" meta:resourcekey="txtEcoSalespriceNetResource1"></asp:TextBox>
                            </div>
                            <div class="six wide field">
                                <label id="lblSupplierPhone" runat="server">Phone number</label>
                                <asp:TextBox ID="txtSupplierPhone" runat="server" data-submit="SUP_Phone_Off" meta:resourcekey="txtEcoSalesSaleResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="fourteen wide field">
                                <label id="lblSupplierMail" runat="server">Mail</label>
                                <asp:TextBox ID="txtSupplierMail" runat="server" data-submit="SUP_ID_Email" CssClass="texttest fixed" meta:resourcekey="txtEcoSalesEquipmentResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label>&nbsp;</label>
                                <input type="button" id="btnSupplierOpenMail" runat="server" value="Åpne" class="ui btn mini" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="fourteen wide field">
                                <label id="lblSupplierWebPage" runat="server">WebPage</label>
                                <asp:TextBox ID="txtSupplierWebPage" runat="server" data-submit="SUP_WEBPAGE" Text="Http://www." CssClass="texttest fixed" meta:resourcekey="txtEcoRegCostResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label>&nbsp;</label>
                                <input type="button" id="btnOpenWebPage" runat="server" value="Åpne" class="ui btn mini" />
                            </div>
                        </div>
                        
                    </div>
                    <h3 class="ui top attached tiny header">Supplier options:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <asp:Label ID="lblSupplierDateCreatedInfo" Text="Date created:" runat="server" meta:resourcekey="lblAdvVendorNoResource1"></asp:Label>
                                </div>
                            <div class="twelve wide field">
                                <asp:Label ID="lblSupplierDateCreated" Text="28/12/2016" runat="server" meta:resourcekey="lblAdvVendorNoResource1"></asp:Label>
                                </div>
                            </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label><asp:CheckBox ID="cbSupplierFinance" runat="server" Text="Finance supplier" /></label>
                                </div>
                            <div class="eight wide field">
                                <label><asp:CheckBox ID="cbSupplierStockQtyDelivered" runat="server" Text="Stock qty delivered" /></label>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label><asp:CheckBox ID="cbSupplierInvJournalFTP" runat="server" Text="Invoice journal to FTP" /></label>
                                </div>
                            <div class="eight wide field">
                                <label><asp:CheckBox ID="cbSupplierNonStockSale" runat="server" Text="Non-stock sale" /></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%-- End right column --%>
    <%-- ############################### ADVANCED ##########################################--%>

    <div id="tabAdvanced" class="tTab">
        <div class="ui grid">
            <div class="eight wide column">
                <div class="ui form">
                    <h3 id="lblTechnicalData" runat="server" class="ui top attached tiny header">Vehicle model:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="three wide field">
                                <label id="lblAdvSupplierId" runat="server">Supplier ID</label>
                                <asp:TextBox ID="txtAdvSupplierId" data-submit="ID_SUPPLIER" runat="server"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <asp:Literal ID="liAdvSupplierIdDesc" runat="server" Text="Default" ></asp:Literal>
                            </div>
                            <div class="three wide field">
                                <label id="lblAdvCurrencyId" runat="server">Currency code</label>
                                <asp:TextBox ID="txtAdvCurrencyId" data-submit="CURRENCY_CODE" runat="server"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <asp:Label ID="lblAdvCurrencyDesc" runat="server" Text="Default" ></asp:Label>
                            </div>
                            
                        </div>
                        <div class="fields">
                            <div class="three wide field">
                                <label id="lblAdvProductCode" runat="server">Product code</label>
                                <asp:TextBox ID="txtAdvProductCode" runat="server"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>&nbsp;</label>
                                <asp:Literal ID="liAdvProductCodeDesc" runat="server" Text="Default" ></asp:Literal>
                            </div>
                            <div class="three wide field">
                                <label id="lblAdvSparePrefix" runat="server">Spare prefix</label>
                                <asp:TextBox ID="txtAdvSparePrefix" runat="server"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label id="lblAdvDeliveryTime" runat="server">Delivery time</label>
                                <asp:TextBox ID="txtAdvDeliveryTime" runat="server"></asp:TextBox>
                            </div>
                            <div class="three wide field">
                                <label id="lblAdvNSCCode" runat="server">NSC code</label>
                                <asp:TextBox ID="txtAdvNSCCode" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <h3 id="lblDetails" class="ui top attached tiny header" runat="server">FTP-Server for pris oppdatering:</h3>

                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblAdvFTPHostName" runat="server">Host name</label>
                                <asp:TextBox ID="txtAdvFTPHostName" runat="server" meta:resourcekey="txtTechWarehouseResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblAdvFTPPathFolder" runat="server">folder path</label>
                                <asp:TextBox ID="txtAdvFTPPathFolder" runat="server" meta:resourcekey="txtTechWarehouseNameResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblAdvFTPUserName" runat="server">User name</label>
                                <asp:TextBox ID="txtAdvFTPUserName" runat="server" meta:resourcekey="txtTechControlFormResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblAdvFTPPassword" runat="server">Password</label>
                                <asp:TextBox ID="txtAdvFTPPassword" runat="server" meta:resourcekey="txtTechWarehouseNameResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 id="lblPkkServiceData" class="ui top attached tiny header" runat="server">Web login / Ekstern FTP-Server for ordrer:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblAdvWebHostName" runat="server">Host name</label>
                                <asp:TextBox ID="txtAdvWebHostName" runat="server" meta:resourcekey="txtTechWarehouseResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblAdvWebPathFolder" runat="server">folder path</label>
                                <asp:TextBox ID="txtAdvWebPathFolder" runat="server" meta:resourcekey="txtTechWarehouseNameResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblAdvWebUserName" runat="server">User name</label>
                                <asp:TextBox ID="txtAdvWebUserName" runat="server" meta:resourcekey="txtTechControlFormResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblAdvWebPassword" runat="server">Password</label>
                                <asp:TextBox ID="txtAdvWebPassword" runat="server" meta:resourcekey="txtTechWarehouseNameResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="eight wide column">
                <div class="ui form">
                    <h3 id="lblVehicleDateMileage" class="ui top attached tiny header" runat="server">Automatic update:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="five wide field">
                                <label><asp:CheckBox ID="cbAdvUpdateDescription" runat="server" Text="Description" /></label>
                                </div>
                            <div class="five wide field">
                                <label><asp:CheckBox ID="cbAdvUpdateProductGroup" runat="server" Text="Product group" /></label>
                            </div>
                            <div class="five wide field">
                                <label><asp:CheckBox ID="cbAdvUpdateDiscount" runat="server" Text="Discount code" /></label>
                            </div>
                            <div class="one wide field">
                                
                            </div>
                        </div>
                        <div class="fields">
                            <div class="five wide field">
                                <label><asp:CheckBox ID="cbAdvUpdateCostPrice" runat="server" Text="Cost price" /></label>
                                </div>
                            <div class="five wide field">
                                <label><asp:CheckBox ID="cbAdvUpdateNetPrice" runat="server" Text="Net Price" /></label>
                            </div>
                            <div class="five wide field">
                                <label><asp:CheckBox ID="cbAdvUpdateNonStock" runat="server" Text="Non-Stock" /></label>
                            </div>
                            <div class="one wide field">
                           
                            </div>
                        </div>
                    </div>
                    <div class="fields">
                    <div class="six wide field">
                    <h3 id="measuresData" runat="server" class="ui top attached tiny header">Vehicle price margin:</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblAdvBaseMargin" runat="server">Base margin</label>
                                <asp:TextBox ID="txtAdvBaseMargin" runat="server" meta:resourcekey="txtTechLengthResource1"></asp:TextBox>
                            </div>
                            <div class="eight wide field">
                                <label id="lblAdvFranchiseMargin" runat="server">Franchise margin</label>
                                <asp:TextBox ID="txtAdvFranchiseMargin" runat="server" meta:resourcekey="txtTechWidthResource1"></asp:TextBox>
                            </div>
                        </div>
                        </div>

                    </div>
                    <div class="ten wide field">
                    <h3 id="H10" runat="server" class="ui top attached tiny header">Calculation on update:</h3>
                    <div class="ui attached segment">
                        
                        <div class="fields">
                            <div class="four wide field">
                                <label id="lblEffectKw" runat="server">Frakt %</label>
                                <asp:TextBox ID="txtTechEffect" runat="server" meta:resourcekey="txtTechEffectResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblPistonDisp" runat="server">Frakt > Kr.</label>
                                <asp:TextBox ID="txtTechPistonDisp" runat="server" meta:resourcekey="txtTechPistonDispResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="lblRoundMin" runat="server">Time %</label>
                                <asp:TextBox ID="txtTechRoundperMin" runat="server" meta:resourcekey="txtTechRoundperMinResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label id="Label8" runat="server">Frakt %</label>
                                  <asp:TextBox ID="txtAdvShippingPercent" runat="server"></asp:TextBox>
                            </div>
                            </div>
                          </div>  
                        </div>
                       </div>

                    
                    <h3 id="interiorData" class="ui top attached tiny header" runat="server">Diverse:</h3>
                    <div class="ui attached segment">

                        <div class="ui form">
                            <div class="fields">
                             
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>



    <%--                    ############################### BOTTOM ##########################################--%>
    <div id="tabBottom">
        <div class="ui divider"></div>
        <div class="ui grid">
            <div class="sixteen wide column">
                <div class="ui form">
                    <div class="fields">
                        <div class="three wide field">
                            <button type="button" id="btnSupEmptyScreen" class="ui button btn">Tøm</button>
                        </div>
                        <div class="three wide field">
                            <button type="button" id="btnSupLog" class="btnconst">Log</button>
                        </div>
                        <div class="three wide field">
                            <button type="button" id="btnSupNewSupplier" class="ui button btn">Ny leverandør</button>
                        </div>
                        <div class="three wide field">
                            <button type="button" id="btnSupSave" class="ui button btn">Lagre</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <%-- Customer notes Modal --%>
    <div id="modUpdateCustTemp" class="modal hidden">
        <div class="modHeader">
            <h2 id="H9" runat="server">Customer template update</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Customer template update</label>
                    <div class="ui small info message">
                        <p id="PasswordMsg" runat="server">Write the password to update the template and click OK.</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label for="txtPassword">
                                    <asp:Literal ID="liPassword" Text="Password" runat="server" meta:resourcekey="liPasswordResource1"></asp:Literal>
                                </label>
                                <asp:TextBox ID="txtCustTempPassword" TextMode="Password" runat="server" meta:resourcekey="txtCustTempPasswordResource1" ></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            &nbsp;
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnSaveTemplate" runat="server" class="ui btn wide" value="OK" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnCancelTemplate" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

     <%-- WashCustomer Modal --%>
    <div id="modWashCustomer" class="ui modal">
        <i class="close icon"></i>
        <div class="header">
            Wash Customer
        </div>
        <div class="content">
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="inline fields">
                            <div class="four wide field">
                                 &nbsp;
                            </div>
                            <div class="five wide field">
                                Local data
                            </div>
                            <div class="five wide field">
                                Eniro data
                            </div>
                            <div class="two wide field">
                                Oppdatere?
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                                <label><asp:Label ID="lblWashLastName" Text="Last name/ Subsidiary" runat="server" meta:resourcekey="lblWashLastNameResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalLastName" runat="server" meta:resourcekey="txtWashLocalLastNameResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashEniroLastName" runat="server" meta:resourcekey="txtWashEniroLastNameResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <span class="ui checkbox">
                                    <asp:CheckBox ID="chkWashLastName" runat="server" meta:resourcekey="chkWashLastNameResource1"></asp:CheckBox>
                                    <label for="ctl00_cntMainPanel_chkContactType"></label>
                                </span>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                                <label><asp:Label ID="lblWashFirstName" Text="First name" runat="server" meta:resourcekey="lblWashFirstNameResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalFirstName" runat="server" meta:resourcekey="txtWashLocalFirstNameResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                              <asp:TextBox ID="txtWashEniroFirstName" runat="server" meta:resourcekey="txtWashEniroFirstNameResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashFirstName" runat="server" meta:resourcekey="chkWashFirstNameResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashMiddleName" Text="Middle name" runat="server" meta:resourcekey="lblWashMiddleNameResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                               <asp:TextBox ID="txtWashLocalMiddleName" runat="server" meta:resourcekey="txtWashLocalMiddleNameResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                            <asp:TextBox ID="txtWashEniroMiddleName" runat="server" meta:resourcekey="txtWashEniroMiddleNameResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashMiddleName" runat="server" meta:resourcekey="chkWashMiddleNameResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashVisitAdress" Text="Visit address" runat="server" meta:resourcekey="lblWashVisitAdressResource1"></asp:Label></label>
                               <label></label>
                            </div>
                            <div class="five wide field">
                               <asp:TextBox ID="txtWashLocalVisitAddress" runat="server" meta:resourcekey="txtWashLocalVisitAddressResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                              <asp:TextBox ID="txtWashEniroVisitAddress" runat="server" meta:resourcekey="txtWashEniroVisitAddressResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashVisitAddress" runat="server" meta:resourcekey="chkWashVisitAddressResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashBillAddress" Text="Bill address" runat="server" meta:resourcekey="lblWashBillAddressResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalBillAddress" runat="server" meta:resourcekey="txtWashLocalBillAddressResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                            <asp:TextBox ID="txtWashEniroBillAddress" runat="server" meta:resourcekey="txtWashEniroBillAddressResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashBillAddress" runat="server" meta:resourcekey="chkWashBillAddressResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashZipCode" Text="Postnr" runat="server" meta:resourcekey="lblWashZipCodeResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalZipCode" runat="server" meta:resourcekey="txtWashLocalZipCodeResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                            <asp:TextBox ID="txtWashEniroZipCode" runat="server" meta:resourcekey="txtWashEniroZipCodeResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashZipCode" runat="server" meta:resourcekey="chkWashZipCodeResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashZipPlace" Text="Sted" runat="server" meta:resourcekey="lblWashZipPlaceResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalZipPlace" runat="server" meta:resourcekey="txtWashLocalZipPlaceResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                              <asp:TextBox ID="txtWashEniroZipPlace" runat="server" meta:resourcekey="txtWashEniroZipPlaceResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashZipPlace" runat="server" meta:resourcekey="chkWashZipPlaceResource1"></asp:CheckBox>
                            </div>
                        </div>

                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashPhone" Text="Telefon" runat="server" meta:resourcekey="lblWashPhoneResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalPhone" runat="server" meta:resourcekey="txtWashLocalPhoneResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                            <asp:TextBox ID="txtWashEniroPhone" runat="server" meta:resourcekey="txtWashEniroPhoneResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashPhone" runat="server" meta:resourcekey="chkWashPhoneResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashMobile" Text="Mobil" runat="server" meta:resourcekey="lblWashMobileResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalMobile" runat="server" meta:resourcekey="txtWashLocalMobileResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                            <asp:TextBox ID="txtWashEniroMobile" runat="server" meta:resourcekey="txtWashEniroMobileResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashMobile" runat="server" meta:resourcekey="chkWashMobileResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashBorn" Text="Born" runat="server" meta:resourcekey="lblWashBornResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalBorn" runat="server" meta:resourcekey="txtWashLocalBornResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                            <asp:TextBox ID="txtWashEniroBorn" runat="server" meta:resourcekey="txtWashEniroBornResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashBorn" runat="server" meta:resourcekey="chkWashBornResource1"></asp:CheckBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <div class="four wide field">
                               <label><asp:Label ID="lblWashSsnNo" Text="SSN No" runat="server" meta:resourcekey="lblWashSsnNoResource1"></asp:Label></label>
                            </div>
                            <div class="five wide field">
                                <asp:TextBox ID="txtWashLocalSsnNo" runat="server" meta:resourcekey="txtWashLocalSsnNoResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                            <asp:TextBox ID="txtWashEniroSsnNo" runat="server" meta:resourcekey="txtWashEniroSsnNoResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <asp:CheckBox ID="chkWashSsnNo" runat="server" meta:resourcekey="chkWashSsnNoResource1"></asp:CheckBox>
                            </div>
                        </div>
                </div>
            </div>
        </div>

    </div>
    <div class="actions">
        <div class="ui button ok positive">Oppdater</div>
        <div class="ui button cancel negative">Avbryt</div>
    </div>
    </div>



    <%-- Customer notes Modal --%>
    <div id="modCustNotes" class="modal hidden">
        <div class="modHeader">
            <h2 id="H8" runat="server">Notat</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Notat</label>
                    <div class="ui small info message">
                        <p id="P1" runat="server">Legg inn notater på leverandøren.</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label for="txtNotes">
                                    <asp:Literal ID="liNotes" Text="Notes" runat="server" meta:resourcekey="liNotesResource1"></asp:Literal>
                                </label>
                                <asp:TextBox runat="server" ID="txtNotes" TextMode="MultiLine" CssClass="texttest" Height="181px" data-submit="CUST_NOTES" meta:resourcekey="txtNotesResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            &nbsp;
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnCustNotesSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnCustNotesCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Salesman Modal --%>
    <div id="modAdvSalesman" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblAdvSalesman" runat="server">Salesman</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Nytt kjøretøy</label>
                    <div class="ui small info message">
                        <p id="lblAdvSalesmanStatus" runat="server">Salesman status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblNewUsed" runat="server">New/Used*</label>
                                <select id="drpSalesman" runat="server" size="13" class="wide dropdownList"></select>
                                <%--<select id="ddlSalesman" runat="server" size="13" class="wide dropdownList">
                                    <option value="0" id="ddlItemNewVehicle">Nytt kjøretøy</option>
                                    <option value="1" id="ddlItemNewImportVehicle">Import Bil</option>
                                    <option value="2" selected="selected" id="ddlItemUsedVehicle">Brukt Bil</option>
                                    <option value="3" id="ddlItemNewElVehicle">Ny Elbil</option>
                                    <option value="4" id="ddlItemNewMachine">Ny maskin</option>
                                    <option value="5" id="ddlItemUsedMachine">Brukt maskin</option>
                                    <option value="6" id="ddlItemNewBoat">Ny Båt</option>
                                    <option value="7" id="ddlItemUsedBoat">Brukt Båt</option>
                                    <option value="8" id="ddlItemNewHouseCar">Ny Bobil</option>
                                    <option value="9" id="ddlItemUsedHouseCar">Brukt Bobil</option>
                                    <option value="10" id="ddlItemRentalVehicle">Leiebil</option>
                                    <option value="11" id="ddlItemCommisionUsed">Kommisjon brukt</option>
                                    <option value="12" id="ddlItemCommissionNew">Kommisjon ny</option>
                                </select>--%>
                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanCode" Text="Kode" runat="server" meta:resourcekey="lblAdvSalesmanCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesmanLogin" runat="server" meta:resourcekey="txtAdvSalesmanLoginResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanFname" Text="First name" runat="server" meta:resourcekey="lblAdvSalesmanFnameResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesmanFname" runat="server" meta:resourcekey="txtAdvSalesmanFnameResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanLname" Text="Last name" runat="server" meta:resourcekey="lblAdvSalesmanLnameResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesmanLname" runat="server" meta:resourcekey="txtAdvSalesmanLnameResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanDept" Text="Department" runat="server" meta:resourcekey="lblAdvSalesmanDeptResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesmanDept" runat="server" meta:resourcekey="txtAdvSalesmanDeptResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanPassword" Text="Password" runat="server" meta:resourcekey="lblAdvSalesmanPasswordResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesmanPassword" runat="server" meta:resourcekey="txtAdvSalesmanPasswordResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanPhone" Text="Telefon" runat="server" meta:resourcekey="lblAdvSalesmanPhoneResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesmanPhone" runat="server" meta:resourcekey="txtAdvSalesmanPhoneResource1"></asp:TextBox>
                                </div>

                                <div class="two fields">
                                    <div class="field">
                                        <input type="button" id="btnAdvSalesmanNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnAdvSalesmanDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                                <div class="fields">
                                    &nbsp;    
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnAdvSalesmanSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnAdvSalesmanCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- Branch Modal --%>
    <div id="modAdvBranch" class="modal hidden">
        <div class="modHeader">
            <h2 id="H2" runat="server">Branch</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Nytt yrke</label>
                    <div class="ui small info message">
                        <p id="lblAdvBranchStatus" runat="server">Yrke status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="Label2" runat="server">Yrke</label>
                                <select id="drpBranch" runat="server" size="10" class="wide dropdownList"></select>
                                <%--<select id="Select1" runat="server" size="13" class="wide dropdownList">
                                    <option value="0" id="ddlItemBranch">bransjeliste</option>
                                    
                                </select>--%>
                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvBranchCode" Text="Kode" runat="server" meta:resourcekey="lblAdvBranchCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvBranchCode" runat="server" meta:resourcekey="txtAdvBranchCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvBranchText" Text="Tekst" runat="server" meta:resourcekey="lblAdvBranchTextResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvBranchText" runat="server" meta:resourcekey="txtAdvBranchTextResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvBranchNote" Text="Merk" runat="server" meta:resourcekey="lblAdvBranchNoteResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvBranchNote" runat="server" meta:resourcekey="txtAdvBranchNoteResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvBranchRef" Text="Referanse" runat="server" meta:resourcekey="lblAdvBranchRefResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvBranchRef" runat="server" meta:resourcekey="txtAdvBranchRefResource1"></asp:TextBox>
                                </div>

                                <div class="two fields">
                                    <div class="field">
                                        <input type="button" id="btnAdvBranchNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnAdvBranchDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                                <div class="field">
                                    &nbsp;    
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnAdvBranchSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnAdvBranchCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- Category Modal --%>
    <div id="modAdvCategory" class="modal hidden">
        <div class="modHeader">
            <h2 id="H3" runat="server">Category</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Ny kategori</label>
                    <div class="ui small info message">
                        <p id="lblAdvCategoryStatus" runat="server">Kategori status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="Label4" runat="server">Category list</label>
                                <select id="drpAdvCategory" runat="server" size="10" class="wide dropdownList"></select>
                                <%--<select id="Select2" runat="server" size="13" class="wide dropdownList">
                                    <option value="0" id="ddlItemCategory">God kunde</option>
                                </select>--%>
                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCategoryCode" Text="Kode" runat="server" meta:resourcekey="lblAdvCategoryCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCategoryCode" runat="server" meta:resourcekey="txtAdvCategoryCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCategoryText" Text="Tekst" runat="server" meta:resourcekey="lblAdvCategoryTextResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCategoryText" runat="server" meta:resourcekey="txtAdvCategoryTextResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCategoryNote" Text="Merk" runat="server" meta:resourcekey="lblAdvCategoryNoteResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCategoryNote" runat="server" meta:resourcekey="txtAdvCategoryNoteResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCategoryRef" Text="Referanse" runat="server" meta:resourcekey="lblAdvCategoryRefResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCategoryRef" runat="server" meta:resourcekey="txtAdvCategoryRefResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    &nbsp;    
                                </div>
                                <div class="two fields">
                                    <div class="field">
                                        <input type="button" id="btnAdvCategoryNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnAdvCategoryDelete" runat="server" class="ui btn wide" value="Slett" />

                                    </div>
                                </div>
                                <div class="field">
                                    &nbsp;    
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnAdvCategorySave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnAdvCategoryCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- Salesgroup Modal --%>
    <div id="modAdvSalesGroup" class="modal hidden">
        <div class="modHeader">
            <h2 id="H4" runat="server">Sales group</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Salgsgruppe</label>
                    <div class="ui small info message">
                        <p id="lblAdvSalesGroupStatus" runat="server">Salgsgruppe status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="lblAdvSalesGroupList" runat="server">Sales group list</label>
                                <select id="drpAdvSalesGroup" runat="server" size="13" class="wide dropdownList"></select>
                                <%--<select id="Select3" runat="server" size="13" class="wide dropdownList">
                                    <option value="0" id="ddlItemSalesGroup0">10 - Salg deler</option>
                                    <option value="1" id="ddlItemSalesGroup1">20 - Salg verksted</option>
                                    <option value="2" id="ddlItemSalesGroup2">30 - Salg brukte biler</option>
                                </select>--%>
                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesGroupCode" Text="Kode" runat="server" meta:resourcekey="lblAdvSalesGroupCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesGroupCode" runat="server" meta:resourcekey="txtAdvSalesGroupCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesGroupText" Text="Tekst" runat="server" meta:resourcekey="lblAdvSalesGroupTextResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesGroupText" runat="server" meta:resourcekey="txtAdvSalesGroupTextResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesGroupInv" Text="Inv." runat="server" meta:resourcekey="lblAdvSalesGroupInvResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesGroupInv" runat="server" meta:resourcekey="txtAdvSalesGroupInvResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesGroupVat" Text="Fri/Pl./Utl." runat="server" meta:resourcekey="lblAdvSalesGroupVatResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesGroupVat" runat="server" meta:resourcekey="txtAdvSalesGroupVatResource1"></asp:TextBox>
                                </div>

                                <div class="two fields">
                                    <div class="field">
                                        <input type="button" id="btnAdvSalesGroupNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>

                                    <div class="field">
                                        <input type="button" id="btnAdvSalesGroupDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                                <div class="fields">
                                    &nbsp;    
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnAdvSalesGroupSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnAdvSalesGroupCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- Payment Terms Modal --%>
    <div id="modAdvPaymentTerms" class="modal hidden">
        <div class="modHeader">
            <h2 id="H5" runat="server">Payment terms</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Bet.betingelser</label>
                    <div class="ui small info message">
                        <p id="lblAdvPayTermsStatus" runat="server">Bet.betingelser status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="Label5" runat="server">Payment terms</label>
                                <select id="drpAdvPaymentTerms" runat="server" size="13" class="wide dropdownList"></select>

                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvPayTermsCode" Text="Kode" runat="server" meta:resourcekey="lblAdvPayTermsCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvPayTermsCode" runat="server" meta:resourcekey="txtAdvPayTermsCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvPayTermsText" Text="Tekst" runat="server" meta:resourcekey="lblAdvPayTermsTextResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvPayTermsText" runat="server" meta:resourcekey="txtAdvPayTermsTextResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvPayTermsDays" Text="Dager" runat="server" meta:resourcekey="lblAdvPayTermsDaysResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvPayTermsDays" runat="server" meta:resourcekey="txtAdvPayTermsDaysResource1"></asp:TextBox>
                                </div>

                                <div class="two fields">
                                    <div class="field">
                                        <input type="button" id="btnAdvPayTermsNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnAdvPayTermsDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnAdvPayTermsSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnAdvPayTermsCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- Credit Card Modal --%>
    <div id="modAdvCreditCardType" class="modal hidden">
        <div class="modHeader">
            <h2 id="H6" runat="server">Credit card type</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Credit card type</label>
                    <div class="ui small info message">
                        <p id="lblAdvCreditCardStatus" runat="server">Kred.kort type status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="Label6" runat="server">Kred.kort type</label>
                                <select id="drpAdvCardType" runat="server" size="10" class="wide dropdownList"></select>

                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCredCardTypeCode" Text="Kode" runat="server" meta:resourcekey="lblAdvCredCardTypeCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCredCardTypeCode" runat="server" meta:resourcekey="txtAdvCredCardTypeCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCredCardTypeText" Text="Tekst" runat="server" meta:resourcekey="lblAdvCredCardTypeTextResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCredCardTypeText" runat="server" meta:resourcekey="txtAdvCredCardTypeTextResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCredCardTypeCustNo" Text="Kundenr" runat="server" meta:resourcekey="lblAdvCredCardTypeCustNoResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCredCardTypeCustNo" runat="server" meta:resourcekey="txtAdvCredCardTypeCustNoResource1"></asp:TextBox>
                                </div>

                                <div class="two fields">

                                    <div class="field">
                                        <input type="button" id="btnAdvCredCardTypeNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnAdvCredCardTypeDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                                <div class="field">
                                    &nbsp;    
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnAdvCredCardTypeSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnAdvCredCardTypeCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- Currency Code Modal --%>
    <div id="modAdvCurrencyCode" class="modal hidden">
        <div class="modHeader">
            <h2 id="H7" runat="server">Currency code</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Currency code</label>
                    <div class="ui small info message">
                        <p id="lblAdvCurrencyStatus" runat="server">Valutakode status</p>
                    </div>
                </div>
            </div>
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form">
                        <div class="fields">
                            <div class="eight wide field">
                                <label id="Label7" runat="server">Kred.kort type</label>
                                <select id="drpAdvCurrencyType" runat="server" size="10" class="wide dropdownList"></select>

                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCurCodeCode" Text="Kode" runat="server" meta:resourcekey="lblAdvCurCodeCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCurCodeCode" runat="server" meta:resourcekey="txtAdvCurCodeCodeResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCurCodeText" Text="Tekst" runat="server" meta:resourcekey="lblAdvCurCodeTextResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCurCodeText" runat="server" meta:resourcekey="txtAdvCurCodeTextResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvCurCodeValue" Text="Nkr." runat="server" meta:resourcekey="lblAdvCurCodeValueResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvCurCodeValue" runat="server" meta:resourcekey="txtAdvCurCodeValueResource1"></asp:TextBox>
                                </div>
                                <div class="two fields">

                                    <div class="field">
                                        <input type="button" id="btnAdvCurCodeNew" runat="server" class="ui btn wide" value="Ny" />
                                    </div>
                                    <div class="field">
                                        <input type="button" id="btnAdvCurCodeDelete" runat="server" class="ui btn wide" value="Slett" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="eight wide field">
                                <input type="button" id="btnAdvCurCodeSave" runat="server" class="ui btn wide" value="Lagre" />
                            </div>
                            <div class="eight wide field">
                                <input type="button" id="btnAdvCurCodeCancel" runat="server" class="ui btn wide" value="Avbryt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- Modal for adding contact information --%>
    <div id="modContact" class="ui small modal">
        <i class="close icon"></i>
        <div class="header">
            New contact information
        </div>
        <div class="content">
            <div class="description">
                <div class="ui action input">
                    <div class="inline three field">
                    <input id="txtContactType" type="text" runat="server" />
                        <asp:DropDownList ID="drpContactType" CssClass="ui compact selection dropdown" runat="server" meta:resourcekey="drpContactTypeResource1"></asp:DropDownList>
                        <asp:CheckBox ID="chkContactType" CssClass="ui checkbox" Text="Standard?" runat="server" meta:resourcekey="chkContactTypeResource1" />
                    </div>
                </div>

            </div>
        </div>
        <div class="actions">
            <div class="ui red button cancel">
                <i class="remove icon"></i>
                Cancel
            </div>
            <div class="ui green button ok">
                <i class="checkmark icon"></i>
                Save
            </div>
        </div>
    </div>
</asp:Content>
 