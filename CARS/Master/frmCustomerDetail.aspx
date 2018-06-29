<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmCustomerDetail.aspx.vb" Inherits="CARS.frmCustomerDetail" MasterPageFile="~/MasterPage.Master" meta:resourcekey="PageResource2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">

    
   <script type="text/javascript">
       var custvar = {};
       var contvar = {};
        $(document).ready(function () {
            var debug = true;
            if (debug) {
                console.log('Debug is active');
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

            //Check the page name from where it is called before hiding the banners
            var pageNameFrom = getUrlParameter('pageName');

            if ((pageNameFrom == "OrderHead" || pageNameFrom == "Vehicle") && pageNameFrom != undefined) {
                $('#topBanner').hide();
                $('#topNav').hide();
                $('#carsSideBar').hide();

            }

            var cust = getUrlParameter('cust');
            var fetchFLG = false;
            loadInit();
            function loadInit() {
                setCustomerType();
                setTab('Customer');
                setBillAdd();
                FillCustGroup();
                FillPayType();
                FillPayTerms();
                //LoadBrreg();
                loadSalesman();
                loadBranch();
                loadCategory();
                loadSalesGroup();
                loadPaymentTerms();
                loadCardType();
                loadCurrencyType();
                loadContactType();
                loadNewUsedCode();
                LoadCustomerTemplate();
                requiredFields('','');
                $('#ctl00_cntMainPanel_ddlCustomerTemplate option[value="01"]').prop('selected', true);
                var tempId = $('#<%=ddlCustomerTemplate.ClientID%>').val();
                FetchCustomerTemplate(tempId);
                FetchCustomerDetails(cust);
                setSaveVar();
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
            // Context menu test 
            $.contextMenu({
                selector: '#<%=txtAdvSsnNo.ClientID%>',
                items: {
                    copy: {
                        name: "Kopier",
                        callback: function (key, opt) {
                            alert($(this).attr('id'));
                        }
                    },
                    brreg: {
                        name: "Åpne i Brønnøysundregistrene",
                        callback: function (key, opt) {
                            window.open('https://w2.brreg.no/enhet/sok/detalj.jsp?orgnr=' + $(this).val());
                        }
                    },
                    proff: {
                        name: "Åpne i Proff",
                        callback: function (key, opt) {
                            window.open('http://www.proff.no/bransjes%C3%B8k?q=' + $(this).val());
                        }
                    },
                    sub: {
                        "name": "Sub group",
                        "items": {
                        copy: {
                            name: "Kopier",
                            callback: function (key, opt) {
                                alert($(this).attr('id'));
                            }
                        },
                        brreg: {
                            name: "Åpne i Brønnøysundregistrene",
                            callback: function (key, opt) {
                                window.open('https://w2.brreg.no/enhet/sok/detalj.jsp?orgnr=' + $(this).val());
                            }
                        },
                        proff: {
                            name: "Åpne i Proff",
                            callback: function (key, opt) {
                                window.open('http://www.proff.no/bransjes%C3%B8k?q=' + $(this).val());
                            }
                        }
                        }
                    }
                }
            });
            var testt=  1;
            $.contextMenu({
                selector: '#<%=ddlContactPerson.ClientID%>',
                items: {
                    contactPerson: {
                        name: 'Add new contact person',
                        callback: function (key, opt) {
                            clearFormElements('#modContactPerson');
                            modContactPersonShow();
                        }
                    },
                    editContact: {
                        name: 'View/ edit contact information',
                        disabled: function (key, opt) {
                            if($('#<%=ddlContactPerson.ClientID%>').val() === '' ||  $('#<%=ddlContactPerson.ClientID%> > option[value!=""]').length === 0){
                                return !this.data('editContactDisabled');
                            }
                        },
                        callback: function (key, opt) {
                            clearFormElements('#modContactPerson');
                            viewEditCustomerContactPerson($(this).val());
                            modContactPersonShow();
                        }
                    },
                    deleteContact: {
                        name: 'Delete contact person',
                        disabled: function (key, opt) {
                            if($('#<%=ddlContactPerson.ClientID%>').val() === '' ||  $('#<%=ddlContactPerson.ClientID%> > option[value!=""]').length === 0){
                                return !this.data('deleteContactDisabled');
                            }
                        },
                        callback: function (key, opt) {
                            clearFormElements('#modContactPerson');
                            deleteCustomerContactPerson($(this).val())
                        }
                    }
                }
            });
            function modContactPersonShow() {
                $("#modContactPerson").modal('setting', {
                    autofocus: false,
                    onShow: function () {
                        cpChange = $('#<%=ddlContactPerson.ClientID%>').val();
                    },
                    onDeny: function () {
                        if (debug) { console.log('modContactPerson abort mod executed'); }

                    },
                    onApprove: function () {
                        if (debug) { console.log('modContactPerson ok mod executed'); }
                        if (requiredFields(true, 'data-cp-submit') === true) {
                            var contactPerson = collectGroupData('cp-submit');
                            saveCustomerContactPerson(contactPerson);
                        } else {
                            return false;

                        }
                    }
                })
                .modal('show')
            }
            $('.coupled.modal')
              .modal({
                  allowMultiple: true
              })
                        ;
            $("#<%=txtCPBirthday.ClientID%>").datepicker({
                showWeek: true,
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-110:-16" // D.O.B. must range between 16 and 110 years old.
            });

            $("#<%=txtCPBirthday.ClientID%>").next(".calendar").on('click', function () {
                $("#<%=txtCPBirthday.ClientID%>").focus();
            });
            function saveCustomerContactPerson(contactPerson) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddCustomerContactPerson",
                    data: "{'CustomerCP': '" + JSON.stringify(contactPerson) + "'}",
                    dataType: "json",
                    //async: false,//Very important
                    success: function (data) {
                        $('.loading').removeClass('loading');
                        if (data.d == "INSFLG") {
                            systemMSG('success', 'The contact person has been saved!', 4000);
                        }
                        else if (data.d == "UPDFLG") {
                            systemMSG('success', 'The contact person has been updated!', 4000);
                            setSaveVar();
                        }
                        else if (data.d == "ERRFLG") {
                            systemMSG('error', 'An error occured while trying to save the contact person, please check input data.', 4000);
                        }
                        loadCustomerContactPerson('', $('#<%=txtCustomerId.ClientID%>').val());
                        console.log('textvalue' + $('#<%=txtCustomerId.ClientID%>').val());
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }
            var cpChange = '';
            function loadCustomerContactPerson(ID_CP, CP_CUSTOMER_ID) {
                console.log(CP_CUSTOMER_ID);
                if ($('#<%=txtCustomerId.ClientID%>').length > 0) {
                    
                    if (debug) {
                        console.log('Running loadCustomerContactPerson(' + ID_CP + ',' + CP_CUSTOMER_ID + ')');
                    }
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCustomerDetail.aspx/FetchCustomerContactPerson",
                        data: "{'ID_CP': '" + ID_CP + "', 'CP_CUSTOMER_ID': '" + CP_CUSTOMER_ID + "'}",
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            $('#<%=ddlContactPerson.ClientID%>').empty().prop('disabled', false);;
                            result = result.d;
                            $('#<%=ddlContactPerson.ClientID%>').prepend('<option selected="selected" value="">-- select contact person --</option>');
                            $.each(result, function (key, value) {
                                $('#<%=ddlContactPerson.ClientID%>').append($("<option></option>").val(value.ID_CP).html(value.CP_FIRST_NAME + " " + value.CP_MIDDLE_NAME + " " + value.CP_LAST_NAME));
                                if (cpChange  === '') {
                                    $('#<%=ddlContactPerson.ClientID%>').val(value.CUSTOMER_CONTACT_PERSON);
                                } else {
                                    $('#<%=ddlContactPerson.ClientID%>').val(cpChange);
                                    console.log('I should NOT run');                                }
                            });
                        },
                        error: function (xhr, ajaxOptions, thrownError) {
                            console.log(xhr.status);
                            console.log(xhr.responseText);
                            console.log(thrownError);
                        }
                    });
                } else {
                    <%--$('#<%=ddlContactPerson.ClientID%>').empty();
                    $('#<%=ddlContactPerson.ClientID%>').prepend('<option selected="selected" value="">-- select contact person --</option>');
                    $.each(contactPersonList, function (key, value) {
                        $('#<%=ddlContactPerson.ClientID%>').append($("<option></option>").val('').html(contactPersonList[key].CP_FIRST_NAME + " " + contactPersonList[key].CP_MIDDLE_NAME + " " + contactPersonList[key].CP_LAST_NAME));
                    });--%>
                    $('#<%=ddlContactPerson.ClientID%>').empty().prop('disabled', true);
                }
            }
            function viewEditCustomerContactPerson(ID_CP) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/FetchCustomerContactPerson",
                    data: "{'ID_CP': '" + ID_CP + "', 'CP_CUSTOMER_ID': ''}",
                    dataType: "json",
                    success: function (result) {
                        r = result.d[0];
                        $('#<%=txtCPID.ClientID%>').val(r.ID_CP);
                        $('#<%=txtCPFirstName.ClientID%>').val(r.CP_FIRST_NAME);
                        $('#<%=txtCPMiddleName.ClientID%>').val(r.CP_MIDDLE_NAME);
                        $('#<%=txtCPLastname.ClientID%>').val(r.CP_LAST_NAME);
                        $('#<%=txtCPPostalAddress.ClientID%>').val(r.CP_PERM_ADD);
                        $('#<%=txtCPVisitAddress.ClientID%>').val(r.CP_VISIT_ADD);
                        $('#<%=txtCPZip.ClientID%>').val(r.CP_ZIP_CODE);
                        $('#<%=txtCPZipCity.ClientID%>').val(r.CP_ZIP_CITY);
                        $('#<%=txtCPEmail.ClientID%>').val(r.CP_EMAIL);
                        $('#<%=txtCPTitleCode.ClientID%>').val(r.CP_TITLE_CODE);
                        if (r.CP_TITLE_CODE.length > 0) {
                            fetchCPTitle(r.CP_TITLE_CODE, function (result) {
                                $('#<%=txtCPTitle.ClientID%>').val(result);
                            });
                        }
                        if (r.CP_FUNCTION_CODE.length > 0) {
                            fetchCPTitle(r.CP_FUNCTION_CODE, function (result) {
                                $('#<%=txtCPFunction.ClientID%>').val(result);
                            });
                        }
                        $('#<%=txtCPFunction.ClientID%>').val(r.CP_FUNCTION_CODE);
                        $('#<%=txtCPPhonePrivate.ClientID%>').val(r.CP_PHONE_PRIVATE);
                        $('#<%=txtCPPhoneMobile.ClientID%>').val(r.CP_PHONE_MOBILE);
                        $('#<%=txtCPPhoneFax.ClientID%>').val(r.CP_PHONE_FAX);
                        $('#<%=txtCPPhoneWork.ClientID%>').val(r.CP_PHONE_WORK);
                        $('#<%=txtCPBirthday.ClientID%>').val(r.CP_BIRTH_DATE);
                        $('#<%=txtCPNotes.ClientID%>').val(r.CP_NOTES);
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }
            $('#btnCPDelete').on('click', function (e) {
                e.preventDefault;
                deleteCustomerContactPerson($('#<%=txtCPID.ClientID%>').val());
                $('#modContactPerson').modal('hide');
            });

            function deleteCustomerContactPerson(ID_CP) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/DeleteCustomerContactPerson",
                    data: "{'ID_CP': '" + ID_CP + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d == 'DELFLG') {
                            systemMSG('success', 'Customer contact person was successfully deleted', 4000);
                        }
                        else if (data.d == 'ERRFLG') {
                            systemMSG('error', 'Something went wrong with the deletion process, please try again', 4000);
                        }
                        loadCustomerContactPerson('', $('#<%=txtCustomerId.ClientID%>').val())
                    },
                    failure: function () {
                        systemMSG('error', 'Something went wrong with the deletion process, please try again', 4000);
                        loadCustomerContactPerson('', $('#<%=txtCustomerId.ClientID%>').val())
                    }
                });
            }

            function fetchCPTitle(id, result) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/Fetch_CCP_Title",
                    data: "{q:'" + id + "'}",
                    dataType: "json",
                    success: function (data) {
                        result(data.d[0].TITLE_DESCRIPTION);
                    },
                    error: function (xhr, status, error) {
                        alert("Error" + error);
                        var err = eval("(" + xhr.responseText + ")");
                        alert('Error: ' + err.Message);
                    }
                });
            }
            function fetchCPFunction(id, result) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/Fetch_CCP_Function",
                    data: "{q:'" + id + "'}",
                    dataType: "json",
                    success: function (data) {
                        result(data.d[0].FUNCTION_DESCRIPTION);
                    },
                    error: function (xhr, status, error) {
                        alert("Error" + error);
                        var err = eval("(" + xhr.responseText + ")");
                        alert('Error: ' + err.Message);
                    }
                });
            }
            $('.disable-tab').on('keydown', function (e) {
                if (e.keyCode == 9 || e.keyCode == 13) {
                    if(e.preventDefault) {
                        e.preventDefault();
                    }
                    $(this).blur();
                    return false;
                }
            });
            var retCount = 0;
            $('#<%=txtCPTitleCode.ClientID%>').autocomplete({ // Autocomplete function for searching title_code
                autoFocus: true,
                selectFirst: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCustomerDetail.aspx/Fetch_CCP_Title",
                        data: "{q:'" + $('#<%=txtCPTitleCode.ClientID%>').val() + "'}",
                        dataType: "json",
                        minLength: 0,
                        success: function (data) {
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                retCount = 0;
                                response([{ label: 'Cannot find this title code, add new?', value: $('#<%=txtCPTitleCode.ClientID%>').val(), val: '' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    retCount = 1;
                                    return {
                                        label: item.TITLE_CODE + ' - ' + item.TITLE_DESCRIPTION,
                                        value: item.TITLE_CODE,
                                        titleID: item.ID_CP_TITLE,
                                        titleCode: item.TITLE_CODE,
                                        titleDescription: item.TITLE_DESCRIPTION,
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
                    if (retCount === 1) {
                        $('#<%=txtCPTitleCode.ClientID%>').val(i.item.titleCode);
                        $('#<%=txtCPTitle.ClientID%>').val(i.item.titleDescription);
                    } else {
                        CCP_TitleADD();
                    }
                    var TABKEY = 9;
                    if (event.keyCode == TABKEY) {
                        event.preventDefault();
                    }
                }
            }).focus(function () { $(this).find('input').select(); $(this).select(); });

            $('#<%=txtCPFunctionCode.ClientID%>').autocomplete({ // Autocomplete function for searching title_code
                autoFocus: true,
                selectFirst: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "frmCustomerDetail.aspx/Fetch_CCP_Function",
                        data: "{q:'" + $('#<%=txtCPFunctionCode.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                retCount = 0;
                                response([{ label: 'Cannot find this function code, add new?', value: $('#<%=txtCPFunctionCode.ClientID%>').val(), val: '' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    retCount = 1;
                                    return {
                                        label: item.FUNCTION_CODE + ' - ' + item.FUNCTION_DESCRIPTION,
                                        value: item.FUNCTION_CODE,
                                        functionID: item.ID_CP_FUNCTION,
                                        functionCode: item.FUNCTION_CODE,
                                        functionDescription: item.FUNCTION_DESCRIPTION,
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
                    if (retCount === 1) {
                        $('#<%=txtCPFunctionCode.ClientID%>').val(i.item.functionCode);
                        $('#<%=txtCPFunction.ClientID%>').val(i.item.functionDescription);
                    } else {
                        CCP_FunctionADD();
                    }
                    var TABKEY = 9;
                    if (event.keyCode == TABKEY) {
                        event.preventDefault();
                    }
                }
            }).focus(function() { $(this).find('input').select(); $(this).select(); });

            var FunctionADD = 0;
            var TitleADD = 0;
            function CCP_FunctionADD() {
                $('#<%=txtCPFunction.ClientID%>').val('').prop('disabled', false).prop('readonly', false).focus();
                FunctionADD = 1;
            }
            function CCP_TitleADD() {
                $('#<%=txtCPTitle.ClientID%>').val('').prop('disabled', false).prop('readonly', false).focus();
                TitleADD = 1
            }
            function CCP_SaveCode(type, code, description) { // For adding new title and function codes
                var typeDef = '';
                var service = '';
                switch (type) {
                    case 'f':
                        typeDef = 'function';
                        service = 'InsertCCPFunction';
                        break;
                    case 't':
                        typeDef = 'title';
                        service = 'InsertCCPTitle';
                        break;
                    default:
                        return false;
                }
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/" + service,
                    data: "{'code': '" + code + "', 'description': '" + description + "'}",
                    dataType: "json",
                    //async: false,//Very important
                    success: function (data) {
                        $('.loading').removeClass('loading');
                        if (data.d[0] == "INSFLG") {
                            systemMSG('success', 'The ' + typeDef + ' code has been added', 4000);
                        }
                        else if (data.d[0] == "ERRFLG") {
                            systemMSG('error', 'An error occured while trying to add this ' + typeDef +'.', 4000);
                        }
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }
            $('#<%=txtCPTitleCode.ClientID%>').on('focus', function () { // Does a blank search when focusing code
                $('#<%=txtCPTitleCode.ClientID%>').autocomplete("search", "%");
            });
            $('#<%=txtCPTitleCode.ClientID%>').on('blur', function () { // Clears descripton field when clearing out the code field
                if ($('#<%=txtCPTitleCode.ClientID%>').val().length <= 0) {
                    $('#<%=txtCPTitle.ClientID%>').val('');
                }
            });

            $('#<%=txtCPFunctionCode.ClientID%>').on('focus', function () { // Does a blank search when focusing code
                $('#<%=txtCPFunctionCode.ClientID%>').autocomplete("search", "%");
            });
            $('#<%=txtCPFunctionCode.ClientID%>').on('blur', function () { // Clears descripton field when clearing out the code field
                if ($('#<%=txtCPFunctionCode.ClientID%>').val().length <= 0) {
                    $('#<%=txtCPFunction.ClientID%>').val('');
                }
            });
            $('#<%=txtCPFunction.ClientID%>, #<%=txtCPTitle.ClientID%>').on('blur', function (e) { // When user tabs out of the description field
                var type = $(this).data('ccp-type');
                var code = '';
                switch (type) {
                    case 'f':
                        code = $('#<%=txtCPFunctionCode.ClientID%>');
                        $('#custCPAddType').text('function');
                        break;
                    case 't':
                        code = $('#<%=txtCPTitleCode.ClientID%>');
                        $('#custCPAddType').text('title');
                        break;
                    default:
                        return false;
                }
                var description = $(this);
                $('#custCPAddCode').text(code.val());
                console.log('asdasd ' + code.val());
                $('#custCPAddDescription').text(description.val())
                if (FunctionADD = 1) {
                    $('#modContactPersonConfirm').modal('setting', {
                        closable: false,
                        allowMultiple: true,
                        onDeny: function () {
                            description.prop('disabled', true).prop('readonly', true).val('');
                            code.focus();
                        },
                        onApprove: function () {
                            description.prop('disabled', true).prop('readonly', true);
                            CCP_SaveCode(type, code.val(), description.val());
                        }
                    }).modal('show');
                    functionAdd = 0;
                }
            });

            $.contextMenu({
                selector: '#updCustomerTemplate',
                items: {
                    mal: {
                        name: "Oppdater mal",
                        callback: function (key, opt) {
                            overlay('on', 'modUpdateCustTemp');
                            $('#<%=txtCustTempPassword.ClientID%>').focus();
                            
                        }
                    }
                }
            });
            

            $('#<%=txtCPZip.ClientID%>').autocomplete({ // Autocomplete function for searching zip code
                autoFocus: true,
                selectFirst: true,
                source: function (request, callback) {
                    el = this.element;
                    zipSearch($(el).val(), callback)
                },
                select: function (e, i) {
                    $("#<%=txtCPZip.ClientID%>").val(i.item.val);
                    $("#<%=txtCPZipCity.ClientID%>").val(i.item.city);
                },
            });


            function zipSearch(zipcode, response) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmVehicleDetail.aspx/GetZipCodes",
                    data: "{'zipCode':'" + zipcode + "'}",
                    dataType: "json",
                    success: function (data) {
                        response($.map(data.d, function (item){ 
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
                })
            }
            $.contextMenu({
                selector: '#<%=drpSalesman.ClientID%> option',
                items: {
                    copy: {
                        name: "Kopier",
                        callback: function (key, opt) {
                            alert($(this).val());
                        }
                    }
                }
            });

            $.contextMenu({
                selector: '#<%=ddlVehicleList.ClientID%> option',
                items: {
                    view: {
                        name: "Se bil",
                        callback: function (key, opt) {
                            //alert($(this).val()+ " er verdien på den bilen du vil se på!");
                            window.open("../master/frmVehicleDetail.aspx?veh=" + $(this).val(), '_blank');
                        }
                    },
                    new: {
                    name: "Ny bil",
                    callback: function (key, opt) {
                    window.open("../master/frmVehicleDetail.aspx", '_blank');
                }
                    },
                    update: {
                        name: "Oppdater liste",
                        callback: function (key, opt) {
                            loadCustVehicle();
                        }
                    }
                }

            });
            $.contextMenu({
                selector: '[data-contact="contact"]',
                items: {
                    delete: {
                        name: "Fjern kontaktinformasjon",
                        icon: "delete",
                        callback: function (key, opt) {
                            deleteContactField($(this).prop('id'));
                        }
                    },
                    standard: {
                        name: "Sett som standard",
                        icon: "edit",
                        callback: function (key, opt) {
                            standardContact($(this));
                        }
                    },
                    sms: {
                        name: "Send SMS",
                        icon: "edit",
                        callback: function (key, opt) {
                            alert('SMS has been sent!');
                        }
                    },
                    homepage: {
                        name: "View homepage",
                        icon: "edit",
                        callback: function (key, opt) {
                            window.open($(this).val());
                        }
                    }
                }

            });
            
            function LoadCustomerTemplate() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadCustomerTemplate",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        Result = Result.d;
                        $('#<%=ddlCustomerTemplate.ClientID%>').empty();
                        $.each(Result, function (key, value) {
                            $('#<%=ddlCustomerTemplate.ClientID%>').append($("<option></option>").val(value.ID_CUSTOMER).html(value.CUST_NAME));
                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }
            var contactCount = 0;
            var contactPersonList = {};

            function FetchCustomerTemplate(tempId) {
                if (debug) { console.log('Length CID: ' + $('#<%=txtCustomerId.ClientID%>').length);}
                if ($('#<%=txtCustomerId.ClientID%>').val().length == 0) {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/FetchCustomerTemplate",
                        data: "{tempId: '" + tempId + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (data) {

                            //$('#<%=txtCustomerId.ClientID%>').val(data.d[0].ID_CUSTOMER);
                            if (data.d[0].ID_CUSTOMER.length > 0) {
                                $('#<%=txtCustomerId.ClientID%>').prop('disabled', true);
                            }
                            $('#<%=txtBillAdd1.ClientID%>').val(data.d[0].CUST_BILL_ADD1);
                            $('#<%=txtBillAdd2.ClientID%>').val(data.d[0].CUST_BILL_ADD2);
                            $('#<%=txtBillZip.ClientID%>').val(data.d[0].ID_CUST_BILL_ZIPCODE);
                            $('#<%=txtBillCity.ClientID%>').val(data.d[0].CUST_BILL_CITY);
                            $('#<%=txtPermAdd1.ClientID%>').val(data.d[0].CUST_PERM_ADD1);
                            $('#<%=txtPermAdd2.ClientID%>').val(data.d[0].CUST_PERM_ADD2);
                            $('#<%=txtPermZip.ClientID%>').val(data.d[0].ID_CUST_PERM_ZIPCODE);
                            $('#<%=txtPermCity.ClientID%>').val(data.d[0].CUST_PERM_CITY);
                            $('#<%=txtFirstname.ClientID%>').val(data.d[0].CUST_FIRST_NAME);
                            $('#<%=txtMiddlename.ClientID%>').val(data.d[0].CUST_MIDDLE_NAME);
                            $('#<%=txtLastname.ClientID%>').val(data.d[0].CUST_LAST_NAME);
                            $('#<%=txtNotes.ClientID%>').val(data.d[0].CUST_NOTES);
                            if ($('#<%=txtNotes.ClientID%>').val() != '') {
                                $('#<%=btnCustNotes.ClientID%>').addClass('warningAN');
                            }
                            else {
                                $('#<%=btnCustNotes.ClientID%>').removeClass('warningAN');
                            }
                            $('#<%=txtCompanyPerson.ClientID%>').val(data.d[0].CUST_COMPANY_NO);
                            $('#lblCompanyPersonName').html(data.d[0].CUST_COMPANY_DESCRIPTION);
                            if (data.d[0].CUST_COMPANY_NO.length > 0) {
                                loadCompanyList(data.d[0].CUST_COMPANY_NO);
                            }
                            else {
                                loadCompanyList(data.d[0].ID_CUSTOMER);
                            }
                            $('#<%=ddlCustGroup.ClientID()%>').val(data.d[0].ID_CUST_GROUP);
                            $('#<%=ddlPayTerms.ClientID()%>').val(data.d[0].ID_CUST_PAY_TERM);
                            $('#<%=ddlPayType.ClientID()%>').val(data.d[0].ID_CUST_PAY_TYPE);
                            $('#<%=txtAdvSparesDiscount.ClientID()%>').val(data.d[0].CUST_DISC_SPARES);
                            $('#<%=txtAdvLabourDiscount.ClientID()%>').val(data.d[0].CUST_DISC_LABOUR);
                            $('#<%=txtAdvGeneralDiscount.ClientID()%>').val(data.d[0].CUST_DISC_GENERAL);
                            $('#<%=txtBirthDate.ClientID()%>').val(data.d[0].CUST_BORN);
                            $('#<%=txtEniroId.ClientID()%>').val(data.d[0].ENIRO_ID);

                            if (data.d[0].FLG_PRIVATE_COMP == 'True') {
                                $("#<%=chkPrivOrSub.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkPrivOrSub.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].ISSAMEADDRESS == 'True') {
                                $("#<%=chkSameAdd.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkSameAdd.ClientID%>").prop('checked', false);
                            }
                            // GEN > DETAILS
                            if (data.d[0].FLG_EINVOICE == 'True') {
                                $("#<%=chkEinvoice.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkEinvoice.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_INV_EMAIL == 'True') {
                                $("#<%=chkInvEmail.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkInvEmail.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_ORDCONF_EMAIL == 'True') {
                                $("#<%=chkOrdconfEmail.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkOrdconfEmail.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_SMS == 'True') {
                                $("#<%=chkNoSms.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoSms.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_EMAIL == 'True') {
                                $("#<%=chkNoEmail.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoEmail.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_MARKETING == 'True') {
                                $("#<%=chkNoMarketing.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoMarketing.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_HUMANEORG == 'True') {
                                $("#<%=chkNoHumaneorg.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoHumaneorg.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_PHONESALE == 'True') {
                                $("#<%=chkNoPhonesale.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoPhonesale.ClientID%>").prop('checked', false);
                            }
                            // ADVANCED TAB
                            if (data.d[0].FLG_CUST_IGNOREINV == 'False') {
                                $("<%=chkAdvCustIgnoreInv.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustIgnoreInv.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_CUST_FACTORING == 'True') {
                                $("#<%=chkAdvCustFactoring.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustFactoring.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_CUST_BATCHINV == 'True') {
                                $("#<%=chkAdvCustBatchInv.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustBatchInv.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_GM == 'True') {
                                $("#<%=chkAdvNoGm.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvNoGm.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_CUST_INACTIVE == 'True') {
                                $("#<%=chkAdvCustInactive.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustInactive.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_ENV_FEE == 'True') {
                                $("#<%=chkAdvNoEnv.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvNoEnv.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_PROSPECT == 'True') {
                                $("#<%=chkProspect.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkProspect.ClientID%>").prop('checked', false);
                            }
                            clearSaveVar();
                            setSaveVar();
                            loadBranch();
                            setCustomerType();
                            setBillAdd();
                        },
                        failure: function () {
                            alert("Failed!");
                        }
                    });
                }
            }

            function updateCustomerTemplate() {
                var customer = collectGroupData('submit');
                console.log(customer);
                console.log(customer.CUST_FIRST_NAME);
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/InsertCustomerTemplate",
                    data: "{'Customer': '" + JSON.stringify(customer) + "'}",
                    dataType: "json",
                    //async: false,//Very important
                    success: function (data) {
                        console.log('success' + data.d);
                        console.log(data.d[0]);
                        console.log(data.d[1]); //custid
                        $('.loading').removeClass('loading');
                        if (data.d[0] == "UPDFLG") {
                            systemMSG('success', 'Customer template has been updated!', 4000);
                        }
                        else if (data.d[0] == "ERRFLG") {

                            systemMSG('error', 'An error occured while saving the customer template, check input data.', 4000);
                        }
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }

            //Contact function for drop down list
            function loadContactType() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadContactType",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpContactType.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpContactType.ClientID%>').append($("<option></option>").val(value.CONTACT_TYPE).html(value.CONTACT_DESCRIPTION));

                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            $('#<%=ddlCustGroup.ClientID%>').change(function (e) {
                var custGrpId = $('#<%=ddlCustGroup.ClientID%>').val();
                FillPayDet(custGrpId);
            });

            function FillPayDet(IdCustGrp)
           {
               $.ajax({
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   url: "../Transactions/frmWOHead.aspx/FillPaymentDet",
                   data: "{IdCustGrp: '" + IdCustGrp + "'}",
                   dataType: "json",
                   success: function (data) {
                       if (data.d.length > 0)
                       {
                           if (data.d[0].Pay_Type == 0) {
                               $('#<%=ddlPayType.ClientID%>')[0].selectedIndex = 0;
                           }
                           else {
                               //$('#<%=ddlPayType.ClientID%>').val(data.d[0].Pay_Type);
                               $('#<%=ddlPayType.ClientID%> option:contains("' + data.d[0].Pay_Type + '")').attr('selected', 'selected');
                               $("#<%=ddlPayType.ClientID%>").attr('disabled', 'disabled');
                           }

                           if (data.d[0].Pay_Term == 0) {
                               $('#<%=ddlPayTerms.ClientID%>')[0].selectedIndex = 0;
                           }
                           else {
                               //$('#<%=ddlPayTerms.ClientID%>').val(data.d[0].Pay_Term);
                               $('#<%=ddlPayTerms.ClientID%> option:contains("' + data.d[0].Pay_Term + '")').attr('selected', 'selected');
                               //$("#<%=ddlPayTerms.ClientID%>").attr('disabled', 'disabled');
                           }
                       }
                      
                   },
                   error: function (result) {
                       alert("Error");
                   }
               });
            }

            function FillCustGroup() {
            $.ajax({
                type: "POST",
                url: "../Transactions/frmWOHead.aspx/LoadCustGroup",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    Result = Result.d;
                    $('#<%=ddlCustGroup.ClientID%>').empty();
                    $('#<%=hdnSelect.ClientID%>').val('-- Velg --');
                    $('#<%=ddlCustGroup.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    $.each(Result, function (key, value) {
                        $('#<%=ddlCustGroup.ClientID%>').append($("<option></option>").val(value.Id_Cust_Group_Seq).html(value.Cust_Group));
                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }

            function FillPayType() {
            $.ajax({
                type: "POST",
                url: "../Transactions/frmWOHead.aspx/LoadPayTypes",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlPayType.ClientID%>').empty();
                    $('#<%=hdnSelect.ClientID%>').val('-- Velg --');
                    $('#<%=ddlPayType.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlPayType.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        function FillPayTerms() {
            $.ajax({
                type: "POST",
                url: "../Transactions/frmWOHead.aspx/LoadPayTerms",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (Result) {
                    $('#<%=ddlPayTerms.ClientID%>').empty();
                    $('#<%=hdnSelect.ClientID%>').val('-- Velg --');
                    $('#<%=ddlPayTerms.ClientID%>').prepend("<option value='0'>" + $('#<%=hdnSelect.ClientID%>').val() + "</option>");
                    Result = Result.d;
                    $.each(Result, function (key, value) {
                        $('#<%=ddlPayTerms.ClientID%>').append($("<option></option>").val(value.Id_Settings).html(value.Description));

                    });

                },
                failure: function () {
                    alert("Failed!");
                }
            });
        }
        
            $('#<%=btnSaveTemplate.ClientID%>').on('click', function () {
                
                if ($('#<%=txtCustTempPassword.ClientID%>').val() == "nironi") {
                    updateCustomerTemplate();
                    $('.overlayHide').removeClass('ohActive');
                    $('#modUpdateCustTemp').addClass('hidden');
                }
                else {
                    alert('Your password was incorrect! Please try again.')
                }
            });
            $('#<%=btnCancelTemplate.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modUpdateCustTemp').addClass('hidden');
                $('#<%=txtCustTempPassword.ClientID%>').val('');
            });

            $('#<%=btnCustNotes.ClientID%>').on('click', function () {
                overlay('on', 'modCustNotes');
            });
            $('#<%=btnCustNotesSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modCustNotes').addClass('hidden');
                if ($('#<%=txtNotes.ClientID%>').val() != "") {
                    $('#<%=btnCustNotes.ClientID%>').addClass('warningAN');
                }
                else {
                    $('#<%=btnCustNotes.ClientID%>').removeClass('warningAN');
                }
            });
            $('#<%=btnCustNotesCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modCustNotes').addClass('hidden');
                $('#<%=txtNotes.ClientID%>').val('');
            });


            //MODAL SCRIPTS FOR ADVANCED TAB PAGE
            //Salesman
            $('#<%=btnAdvSalesman.ClientID%>').on('click', function () {
                overlay('on', 'modAdvSalesman');
            });
            $('#<%=btnAdvSalesmanSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvSalesman').addClass('hidden');
            });
            $('#<%=btnAdvSalesmanCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvSalesman').addClass('hidden');
            });
            $('#<%=btnAdvSalesmanNew.ClientID%>').on('click', function () {
                $('#<%=txtAdvSalesmanLogin.ClientID%>').val('');
                $('#<%=txtAdvSalesmanFname.ClientID%>').val('');
                $('#<%=txtAdvSalesmanLname.ClientID%>').val('');
                $('#<%=txtAdvSalesmanDept.ClientID%>').val('');
                $('#<%=txtAdvSalesmanPassword.ClientID%>').val('')
                $('#<%=txtAdvSalesmanPhone.ClientID%>').val('')
                $('#<%=lblAdvSalesmanStatus.ClientID%>').html('Oppretter ny selger.')
            });

            //Branch
            $('#<%=btnAdvBranch.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modAdvBranch').removeClass('hidden');
            });
            $('#<%=btnAdvBranchSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvBranch').addClass('hidden');
            });
            $('#<%=btnAdvBranchCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvBranch').addClass('hidden');
            });
            $('#<%=btnAdvBranchNew.ClientID%>').on('click', function () {
                $('#<%=txtAdvBranchCode.ClientID%>').val('');
                $('#<%=txtAdvBranchText.ClientID%>').val('');
                $('#<%=txtAdvBranchNote.ClientID%>').val('');
                $('#<%=txtAdvBranchRef.ClientID%>').val('');
                $('#<%=txtAdvBranchCode.ClientID%>').focus();
            });

            //Category
            $('#<%=btnAdvCategory.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modAdvCategory').removeClass('hidden');
            });
            $('#<%=btnAdvCategorySave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvCategory').addClass('hidden');
            });
            $('#<%=btnAdvCategoryCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvCategory').addClass('hidden');
            });
            $('#<%=btnAdvCategoryNew.ClientID%>').on('click', function () {
                $('#<%=txtAdvCategoryCode.ClientID%>').val('');
                $('#<%=txtAdvCategoryText.ClientID%>').val('');
                $('#<%=txtAdvCategoryNote.ClientID%>').val('');
                $('#<%=txtAdvCategoryRef.ClientID%>').val('');
                $('#<%=txtAdvCategoryCode.ClientID%>').focus();

            });
            //Sales group
            $('#<%=btnAdvSalesgroup.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modAdvSalesGroup').removeClass('hidden');
            });
            $('#<%=btnAdvSalesGroupSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvSalesGroup').addClass('hidden');
            });
            $('#<%=btnAdvSalesGroupCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvSalesGroup').addClass('hidden');
            });
            $('#<%=btnAdvSalesGroupNew.ClientID%>').on('click', function () {
                $('#<%=txtAdvSalesGroupCode.ClientID%>').val('');
                $('#<%=txtAdvSalesGroupText.ClientID%>').val('');
                $('#<%=txtAdvSalesGroupInv.ClientID%>').val('');
                $('#<%=txtAdvSalesGroupVat.ClientID%>').val('');
                $('#<%=txtAdvSalesGroupCode.ClientID%>').focus();

            });
            //Payment terms
            $('#<%=btnAdvPayterms.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modAdvPaymentTerms').removeClass('hidden');
            });
            $('#<%=btnAdvPayTermsSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvPaymentTerms').addClass('hidden');
            });
            $('#<%=btnAdvPayTermsCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvPaymentTerms').addClass('hidden');
            });
            $('#<%=btnAdvPayTermsNew.ClientID%>').on('click', function () {
                $('#<%=txtAdvPayTermsCode.ClientID%>').val('');
                $('#<%=txtAdvPayTermsText.ClientID%>').val('');
                $('#<%=txtAdvPayTermsDays.ClientID%>').val('');
                $('#<%=txtAdvPayTermsCode.ClientID%>').focus();
            });
            //Credit card type
            $('#<%=btnAdvCardtype.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modAdvCreditCardType').removeClass('hidden');
            });
            $('#<%=btnAdvCredCardTypeSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvCreditCardType').addClass('hidden');
            });
            $('#<%=btnAdvCredCardTypeCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvCreditCardType').addClass('hidden');
            });
            $('#<%=btnAdvCredCardTypeNew.ClientID%>').on('click', function () {
                $('#<%=txtAdvCredCardTypeCode.ClientID%>').val('');
                $('#<%=txtAdvCredCardTypeText.ClientID%>').val('');
                $('#<%=txtAdvCredCardTypeCustNo.ClientID%>').val('');
                $('#<%=txtAdvCredCardTypeCode.ClientID%>').focus();
            });

            //Currency Code
            $('#<%=btnAdvCurrcode.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modAdvCurrencyCode').removeClass('hidden');
                alert($('#<%=txtAdvCurrcode.ClientID%>').value);
            });
            $('#<%=btnAdvCurCodeSave.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvCurrencyCode').addClass('hidden');
            });
            $('#<%=btnAdvCurCodeCancel.ClientID%>').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modAdvCurrencyCode').addClass('hidden');
            });
            $('#<%=btnAdvCurCodeNew.ClientID%>').on('click', function () {
                $('#<%=txtAdvCurCodeCode.ClientID%>').val('');
                $('#<%=txtAdvCurCodeText.ClientID%>').val('');
                $('#<%=txtAdvCurCodeValue.ClientID%>').val('');
                $('#<%=txtAdvCurCodeCode.ClientID%>').focus();
            });

            function loadSalesman() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadSalesman",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpSalesman.ClientID%>').empty();
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            $('#<%=drpSalesman.ClientID%>').append($("<option></option>").val(value.USER_LOGIN).html(value.USER_FIRST_NAME + " " + value.USER_LAST_NAME));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpSalesman.ClientID%>').change(function () {
                var loginId = this.value;
                getSalesman(loginId);
            });

            function getSalesman(loginId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/GetSalesman",
                    data: "{loginId: '" + loginId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=txtAdvSalesmanLogin.ClientID%>').val(Result.d[0].USER_LOGIN);
                        $('#<%=txtAdvSalesmanFname.ClientID%>').val(Result.d[0].USER_FIRST_NAME);
                        $('#<%=txtAdvSalesmanLname.ClientID%>').val(Result.d[0].USER_LAST_NAME);
                        $('#<%=txtAdvSalesmanDept.ClientID%>').val(Result.d[0].USER_DEPARTMENT);
                        $('#<%=txtAdvSalesmanPassword.ClientID%>').val(Result.d[0].USER_PASSWORD);
                        $('#<%=txtAdvSalesmanPhone.ClientID%>').val(Result.d[0].USER_PHONE);

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
            /*------------END OF SALESMAN CODE-------------------------------------------------------------------------------------------*/

            function loadBranch() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadBranch",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpBranch.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpBranch.ClientID%>').append($("<option></option>").val(value.BRANCH_CODE).html(value.BRANCH_TEXT));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpBranch.ClientID%>').change(function () {
                var branchId = this.value;
                getBranch(branchId);
            });

            function getBranch(branchId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/GetBranch",
                    data: "{branchId: '" + branchId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=txtAdvBranchCode.ClientID%>').val(Result.d[0].BRANCH_CODE);
                    $('#<%=txtAdvBranchText.ClientID%>').val(Result.d[0].BRANCH_TEXT);
                    $('#<%=txtAdvBranchNote.ClientID%>').val(Result.d[0].BRANCH_NOTE);
                    $('#<%=txtAdvBranchRef.ClientID%>').val(Result.d[0].BRANCH_ANNOT);

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }

            $('#<%=btnAdvBranchSave.ClientID%>').on('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddBranch",
                    data: "{branchCode: '" + $('#<%=txtAdvBranchCode.ClientID%>').val() + "', branchText:'" + $('#<%=txtAdvBranchText.ClientID%>').val() + "', branchNote:'" + $('#<%=txtAdvBranchNote.ClientID%>').val() + "', branchAnnot:'" + $('#<%=txtAdvBranchRef.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                             if (data.d == "INSFLG") {
                                 var res = 'Yrkeskode er lagt til.';
                                 alert(res);
                             }
                             else if (data.d == "UPDFLG") {
                                 var res = 'Yrkeskode er oppdatert.';
                                 alert(res);
                             }
                         },
                         error: function (result) {
                             alert("Error. Something wrong happened!");
                         }
                     });
                loadBranch();
            });

            $('#<%=btnAdvBranchDelete.ClientID%>').on('click', function () {
                if ($('#<%=txtAdvBranchCode.ClientID%>').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeleteBranch",
                        data: "{branchId: '" + $('#<%=txtAdvBranchCode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=lblAdvBranchStatus.ClientID%>').html($('#<%=txtAdvBranchCode.ClientID%>').val() + " er slettet.");
                    $('#<%=txtAdvBranchCode.ClientID%>').val('');
                    $('#<%=txtAdvBranchText.ClientID%>').val('');
                    $('#<%=txtAdvBranchNote.ClientID%>').val('');
                    $('#<%=txtAdvBranchRef.ClientID%>').val('');
                    loadBranch();

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
        else {
            $('#<%=lblAdvBranchStatus.ClientID%>').html('Vennligst først velg yrkeskoden i listen til venstre før du klikker slett.');
                }


            });

            /*------------END OF BRANCH CODE-------------------------------------------------------------------------------------------*/

            function loadCategory() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadCategory",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpAdvCategory.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpAdvCategory.ClientID%>').append($("<option></option>").val(value.CATEGORY_CODE).html(value.CATEGORY_TEXT));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpAdvCategory.ClientID%>').change(function () {
                var categoryId = this.value;
                getCategory(categoryId);
            });

            function getCategory(categoryId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/GetCategory",
                    data: "{categoryId: '" + categoryId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=txtAdvCategoryCode.ClientID%>').val(Result.d[0].CATEGORY_CODE);
                    $('#<%=txtAdvCategoryText.ClientID%>').val(Result.d[0].CATEGORY_TEXT);
                    $('#<%=txtAdvCategoryRef.ClientID%>').val(Result.d[0].CATEGORY_ANNOT);

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }

            $('#<%=btnAdvCategorySave.ClientID%>').on('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddCategory",
                    data: "{categoryCode: '" + $('#<%=txtAdvCategoryCode.ClientID%>').val() + "', categoryText:'" + $('#<%=txtAdvCategoryText.ClientID%>').val() + "', categoryAnnot:'" + $('#<%=txtAdvCategoryRef.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                             if (data.d == "INSFLG") {
                                 var res = 'Kategori er lagt til.';
                                 alert(res);
                             }
                             else if (data.d == "UPDFLG") {
                                 var res = 'Kategori er oppdatert.';
                                 alert(res);
                             }
                         },
                         error: function (result) {
                             alert("Error. Something wrong happened!");
                         }
                     });
                loadCategory();
            });

            $('#<%=btnAdvCategoryDelete.ClientID%>').on('click', function () {
                if ($('#<%=txtAdvCategoryCode.ClientID%>').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeleteCategory",
                        data: "{categoryId: '" + $('#<%=txtAdvCategoryCode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=lblAdvCategoryStatus.ClientID%>').html($('#<%=txtAdvCategoryCode.ClientID%>').val() + " er slettet.");
                    $('#<%=txtAdvCategoryCode.ClientID%>').val('');
                    $('#<%=txtAdvCategoryText.ClientID%>').val('');
                    $('#<%=txtAdvCategoryNote.ClientID%>').val('');
                    $('#<%=txtAdvCategoryRef.ClientID%>').val('');
                    loadCategory();

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
        else {
            $('#<%=lblAdvCategoryStatus.ClientID%>').html('Vennligst først velg kategori i listen til venstre før du klikker slett.');
                }


            });

            /*------------END OF CATEGORY CODE-------------------------------------------------------------------------------------------*/

            function loadSalesGroup() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadSalesGroup",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpAdvSalesGroup.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpAdvSalesGroup.ClientID%>').append($("<option></option>").val(value.SALESGROUP_CODE).html(value.SALESGROUP_CODE + ' - ' + value.SALESGROUP_TEXT));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpAdvSalesGroup.ClientID%>').change(function () {
                var salesgroupId = this.value;
                getSalesGroup(salesgroupId);
            });

            function getSalesGroup(salesgroupId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/GetSalesGroup",
                    data: "{salesgroupId: '" + salesgroupId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=txtAdvSalesGroupCode.ClientID%>').val(Result.d[0].SALESGROUP_CODE);
                    $('#<%=txtAdvSalesGroupText.ClientID%>').val(Result.d[0].SALESGROUP_TEXT);
                    $('#<%=txtAdvSalesGroupInv.ClientID%>').val(Result.d[0].SALESGROUP_INVESTMENT);
                    $('#<%=txtAdvSalesGroupVat.ClientID%>').val(Result.d[0].SALESGROUP_VAT);

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }

            $('#<%=btnAdvSalesGroupSave.ClientID%>').on('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddSalesGroup",
                    data: "{salesgroupCode: '" + $('#<%=txtAdvSalesGroupCode.ClientID%>').val() + "', salesgroupText:'" + $('#<%=txtAdvSalesGroupText.ClientID%>').val() + "', salesgroupInv:'" + $('#<%=txtAdvSalesGroupInv.ClientID%>').val() + "', salesgroupVat:'" + $('#<%=txtAdvSalesGroupVat.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                             if (data.d == "INSFLG") {
                                 var res = 'Salgsgruppe er lagt til.';
                                 alert(res);
                             }
                             else if (data.d == "UPDFLG") {
                                 var res = 'Salgsgruppe er oppdatert.';
                                 alert(res);
                             }
                         },
                         error: function (result) {
                             alert("Error. Something wrong happened!");
                         }
                     });
                 loadSalesGroup();
             });

            $('#<%=btnAdvSalesGroupDelete.ClientID%>').on('click', function () {
                if ($('#<%=txtAdvSalesGroupCode.ClientID%>').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeleteSalesGroup",
                        data: "{salesgroupId: '" + $('#<%=txtAdvSalesGroupCode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=lblAdvSalesGroupStatus.ClientID%>').html($('#<%=txtAdvSalesGroupCode.ClientID%>').val() + " er slettet.");
                    $('#<%=txtAdvSalesGroupCode.ClientID%>').val('');
                    $('#<%=txtAdvSalesGroupText.ClientID%>').val('');
                    $('#<%=txtAdvSalesGroupInv.ClientID%>').val('');
                    $('#<%=txtAdvSalesGroupVat.ClientID%>').val('');
                    loadSalesGroup();

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
        else {
            $('#<%=lblAdvSalesGroupStatus.ClientID%>').html('Vennligst først velg salgsgruppen i listen til venstre før du klikker slett.');
                }


            });

            /*------------END OF SALES GROUP CODE-------------------------------------------------------------------------------------------*/

            function loadPaymentTerms() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadPaymentTerms",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpAdvPaymentTerms.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpAdvPaymentTerms.ClientID%>').append($("<option></option>").val(value.PAYMENT_TERMS_CODE).html(value.PAYMENT_TERMS_CODE + ' - ' + value.PAYMENT_TERMS_TEXT + ' - ' + value.PAYMENT_TERMS_DAYS + ' day(s)'));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpAdvPaymentTerms.ClientID%>').change(function () {
                var paymentTermsId = this.value;
                getPaymentTerms(paymentTermsId);
            });

            function getPaymentTerms(paymentTermsId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/GetPaymentTerms",
                    data: "{paymentTermsId: '" + paymentTermsId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=txtAdvPayTermsCode.ClientID%>').val(Result.d[0].PAYMENT_TERMS_CODE);
                    $('#<%=txtAdvPayTermsText.ClientID%>').val(Result.d[0].PAYMENT_TERMS_TEXT);
                    $('#<%=txtAdvPayTermsDays.ClientID%>').val(Result.d[0].PAYMENT_TERMS_DAYS);

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }

            $('#<%=btnAdvPayTermsSave.ClientID%>').on('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddPaymentTerms",
                    data: "{paytermsCode: '" + $('#<%=txtAdvPayTermsCode.ClientID%>').val() + "', paytermsText:'" + $('#<%=txtAdvPayTermsText.ClientID%>').val() + "', paytermsDays:'" + $('#<%=txtAdvPayTermsDays.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                             if (data.d == "INSFLG") {
                                 var res = 'Bet.betingelser er lagt til.';
                                 alert(res);
                             }
                             else if (data.d == "UPDFLG") {
                                 var res = 'Bet.betingelser er oppdatert.';
                                 alert(res);
                             }
                         },
                         error: function (result) {
                             alert("Error. Something wrong happened!");
                         }
                     });
                loadPaymentTerms();
            });

            $('#<%=btnAdvPayTermsDelete.ClientID%>').on('click', function () {
                if ($('#<%=txtAdvPayTermsCode.ClientID%>').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeletePaymentTerms",
                        data: "{paymenttermsId: '" + $('#<%=txtAdvPayTermsCode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=lblAdvPayTermsStatus.ClientID%>').html($('#<%=txtAdvPayTermsCode.ClientID%>').val() + " er slettet.");
                    $('#<%=txtAdvPayTermsCode.ClientID%>').val('');
                    $('#<%=txtAdvPayTermsText.ClientID%>').val('');
                    $('#<%=txtAdvPayTermsDays.ClientID%>').val('');

                    loadPaymentTerms();

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
        else {
            $('#<%=lblAdvPayTermsStatus.ClientID%>').html('Vennligst først velg salgsgruppen i listen til venstre før du klikker slett.');
                }


            });

            /*------------END OF PAYMENT TERMS CODE-------------------------------------------------------------------------------------------*/

            function loadCardType() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadCardType",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpAdvCardType.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpAdvCardType.ClientID%>').append($("<option></option>").val(value.CARD_TYPE_CODE).html(value.CARD_TYPE_CODE + ' - ' + value.CARD_TYPE_TEXT));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpAdvCardType.ClientID%>').change(function () {
                var cardTypeId = this.value;
                getCardType(cardTypeId);
            });

            function getCardType(cardTypeId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/GetCardType",
                    data: "{cardTypeId: '" + cardTypeId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        console.log(Result);
                        $('#<%=txtAdvCredCardTypeCode.ClientID%>').val(Result.d[0].CARD_TYPE_CODE);
                    $('#<%=txtAdvCredCardTypeText.ClientID%>').val(Result.d[0].CARD_TYPE_TEXT);
                    $('#<%=txtAdvCredCardTypeCustNo.ClientID%>').val(Result.d[0].CARD_TYPE_CUSTNO);

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }

            $('#<%=btnAdvCredCardTypeSave.ClientID%>').on('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddCardType",
                    data: "{cardtypeCode: '" + $('#<%=txtAdvCredCardTypeCode.ClientID%>').val() + "', cardtypeText:'" + $('#<%=txtAdvCredCardTypeText.ClientID%>').val() + "', cardtypeCustno:'" + $('#<%=txtAdvCredCardTypeCustNo.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                             if (data.d == "INSFLG") {
                                 var res = 'Kredittkortopplysninger er lagt til.';
                                 alert(res);
                             }
                             else if (data.d == "UPDFLG") {
                                 var res = 'Kredittkortopplysninger er oppdatert.';
                                 alert(res);
                             }
                         },
                         error: function (result) {
                             alert("Error. Something wrong happened!");
                         }
                     });
                loadCardType();
            });

            $('#<%=btnAdvCredCardTypeDelete.ClientID%>').on('click', function () {
                if ($('#<%=txtAdvCredCardTypeCode.ClientID%>').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeleteCardType",
                        data: "{cardtypeId: '" + $('#<%=txtAdvCredCardTypeCode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=lblAdvCreditCardStatus.ClientID%>').html($('#<%=txtAdvCredCardTypeCode.ClientID%>').val() + " er slettet.");
                    $('#<%=txtAdvCredCardTypeCode.ClientID%>').val('');
                    $('#<%=txtAdvCredCardTypeText.ClientID%>').val('');
                    $('#<%=txtAdvCredCardTypeCustNo.ClientID%>').val('');

                    loadCardType();

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
        else {
            $('#<%=lblAdvCreditCardStatus.ClientID%>').html('Vennligst først velg kredittkorttype i listen til venstre før du klikker slett.');
                }


            });

            /*------------END OF CARD TYPE CODE-------------------------------------------------------------------------------------------*/

            function loadCurrencyType() {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadCurrencyType",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=drpAdvCurrencyType.ClientID%>').empty();

                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=drpAdvCurrencyType.ClientID%>').append($("<option></option>").val(value.CURRENCY_TYPE_CODE).html(value.CURRENCY_TYPE_CODE + ' - ' + value.CURRENCY_TYPE_TEXT));
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }

            $('#<%=drpAdvCurrencyType.ClientID%>').change(function () {
                var currencyId = this.value;
                getCurrencyType(currencyId);
            });

            function getCurrencyType(currencyId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/GetCurrencyType",
                    data: "{currencyId: '" + currencyId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        console.log(Result);
                        $('#<%=txtAdvCurCodeCode.ClientID%>').val(Result.d[0].CURRENCY_TYPE_CODE);
                        $('#<%=txtAdvCurCodeText.ClientID%>').val(Result.d[0].CURRENCY_TYPE_TEXT);
                        $('#<%=txtAdvCurCodeValue.ClientID%>').val(Result.d[0].CURRENCY_TYPE_RATE);

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            $('#<%=btnAdvCurCodeSave.ClientID%>').on('click', function () {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddCurrencyType",
                    data: "{currencyCode: '" + $('#<%=txtAdvCurCodeCode.ClientID%>').val() + "', currencyText:'" + $('#<%=txtAdvCurCodeText.ClientID%>').val() + "', currencyRate:'" + $('#<%=txtAdvCurCodeValue.ClientID%>').val() + "'}",
                         dataType: "json",
                         success: function (data) {
                             if (data.d == "INSFLG") {
                                 var res = 'Valutakode er lagt til.';
                                 alert(res);
                             }
                             else if (data.d == "UPDFLG") {
                                 var res = 'Valutakode er oppdatert.';
                                 alert(res);
                             }
                         },
                         error: function (result) {
                             alert("Error. Something wrong happened!");
                         }
                     });
                    loadCurrencyType();
                });

            $('#<%=btnAdvCurCodeDelete.ClientID%>').on('click', function () {
                if ($('#<%=txtAdvCurCodeCode.ClientID%>').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeleteCurrency",
                        data: "{currencyId: '" + $('#<%=txtAdvCurCodeCode.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        //console.log(Result);
                        $('#<%=lblAdvCurrencyStatus.ClientID%>').html($('#<%=txtAdvCurCodeCode.ClientID%>').val() + " er slettet.");
                    $('#<%=txtAdvCurCodeCode.ClientID%>').val('');
                    $('#<%=txtAdvCurCodeText.ClientID%>').val('');
                    $('#<%=txtAdvCurCodeValue.ClientID%>').val('');

                    loadCurrencyType();

                },
                    failure: function () {
                        alert("Failed!");
                    }
                });
        }
        else {
            $('#<%=lblAdvCurrencyStatus.ClientID%>').html('Vennligst først velg valuta i listen til venstre før du klikker slett.');
                }


            });

            /*------------END OF CURRENCY CODE-------------------------------------------------------------------------------------------*/


            // BRREG API
            function LoadBrreg(ssn) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/getBrregData",
                    data: "{Search: '" + ssn + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d.length != 0) {
                            console.log(data.d);
                            if (data.d[0].konkurs == 'J') {
                                var konkURL = 'https://w2.brreg.no/kunngjoring/hent_nr.jsp?orgnr=' + data.d[0].organisasjonsnummer;
                                $('#konkurs')
                                    .modal('show')
                                ;
                                $('#konkFirma').html(data.d[0].navn);
                                $('#konkLink').prop('href', konkURL);
                            }
                            $('#<%=txtAdvEmployees.ClientID%>').val(data.d[0].antallAnsatte);
                        }
                        else {
                            console.log('No company was found. Please search with something else as your data.')
                        }
                    },
                    failure: function () {
                        console.log("Failed!");
                    }
                });
            }

            //ENIRO FUNCTIONS
            $('#<%=CustSelect.ClientID%>').change(function () {
                var eniroId = this.value;
                LoadEniroDet(eniroId);
            });

            //New customer popup
            $('.modCloseCust').on('click', function () {
                $('#modNewCust').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });

            $('#<%=btnSearchCustomer.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modNewCust').removeClass('hidden');
                FetchEniro($('#<%=txtCustId.ClientID()%>').val());
            });
            $('#<%=btnWashCustomer.ClientID%>').on('click', function () {
                $('#<%=txtWashLocalLastName.ClientID()%>').val($('#<%=txtLastname.ClientID()%>').val());
                $('#<%=txtWashLocalFirstName.ClientID()%>').val($('#<%=txtFirstname.ClientID()%>').val());
                $('#<%=txtWashLocalMiddleName.ClientID()%>').val($('#<%=txtMiddlename.ClientID()%>').val());
                $('#<%=txtWashLocalVisitAddress.ClientID()%>').val($('#<%=txtPermAdd1.ClientID()%>').val());
                $('#<%=txtWashLocalZipCode.ClientID()%>').val($('#<%=txtPermZip.ClientID()%>').val());
                $('#<%=txtWashLocalZipPlace.ClientID()%>').val($('#<%=txtPermCity.ClientID()%>').val());
                $('#<%=txtWashLocalMobile.ClientID()%>').val($('[data-contact-type=1]').val());
                $('#<%=txtWashLocalPhone.ClientID()%>').val($('[data-contact-type=2]').val());
                $('#<%=txtWashLocalBorn.ClientID()%>').val($('#<%=txtBirthDate.ClientID()%>').val());
                $('#<%=txtWashLocalSsnNo.ClientID()%>').val($('#<%=txtAdvSsnNo.ClientID()%>').val());
                WashEniroData();
                if ($('#<%=txtWashLocalLastName.ClientID()%>').val() != $('#<%=txtWashEniroLastName.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroLastName.ClientID()%>').val() != "") {
                        $('#<%=chkWashLastName.ClientID()%>').prop('checked', true);
                    }  
                }
                else {
                    $('#<%=chkWashLastName.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalFirstName.ClientID()%>').val() != $('#<%=txtWashEniroFirstName.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroFirstName.ClientID()%>').val() != "") {
                        $('#<%=chkWashFirstName.ClientID()%>').prop('checked', true);
                    } 
                }
                else {
                    $('#<%=chkWashFirstName.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalMiddleName.ClientID()%>').val() != $('#<%=txtWashEniroMiddleName.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroMiddleName.ClientID()%>').val() != "") {
                       $('#<%=chkWashMiddleName.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashMiddleName.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalVisitAddress.ClientID()%>').val() != $('#<%=txtWashEniroVisitAddress.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroVisitAddress.ClientID()%>').val() != "") {
                       $('#<%=chkWashVisitAddress.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashVisitAddress.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalBillAddress.ClientID()%>').val() != $('#<%=txtWashEniroBillAddress.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroBillAddress.ClientID()%>').val() != "") {
                        $('#<%=chkWashBillAddress.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashBillAddress.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalZipCode.ClientID()%>').val() != $('#<%=txtWashEniroZipCode.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroZipCode.ClientID()%>').val() != "") {
                       $('#<%=chkWashZipCode.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashZipCode.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalZipPlace.ClientID()%>').val() != $('#<%=txtWashEniroZipPlace.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroZipPlace.ClientID()%>').val() != "") {
                       $('#<%=chkWashZipPlace.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashZipPlace.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalPhone.ClientID()%>').val() != $('#<%=txtWashEniroPhone.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroPhone.ClientID()%>').val() != "") {
                        $('#<%=chkWashPhone.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashPhone.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalMobile.ClientID()%>').val() != $('#<%=txtWashEniroMobile.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroMobile.ClientID()%>').val() != "") {
                        $('#<%=chkWashMobile.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashMobile.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalBorn.ClientID()%>').val() != $('#<%=txtWashEniroBorn.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroBorn.ClientID()%>').val() != "") {
                       $('#<%=chkWashBorn.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashBorn.ClientID()%>').prop('checked', false);
                }
                if ($('#<%=txtWashLocalSsnNo.ClientID()%>').val() != $('#<%=txtWashEniroSsnNo.ClientID()%>').val()) {
                    if ($('#<%=txtWashEniroSsnNo.ClientID()%>').val() != "") {
                       $('#<%=chkWashSsnNo.ClientID()%>').prop('checked', true);
                    }
                }
                else {
                    $('#<%=chkWashSsnNo.ClientID()%>').prop('checked', false);
                }
                $('#modWashCustomer').modal({
                    onDeny: function () {

                    },
                    onApprove: function () {
                        if ($('#<%=chkWashLastName.ClientID%>').is(':checked')){
                            $('#<%=txtLastname.ClientID%>').val($('#<%=txtWashEniroLastName.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashFirstName.ClientID%>').is(':checked')) {
                            $('#<%=txtFirstname.ClientID%>').val($('#<%=txtWashEniroFirstName.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashMiddleName.ClientID%>').is(':checked')) {
                            $('#<%=txtMiddlename.ClientID%>').val($('#<%=txtWashEniroMiddleName.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashVisitAddress.ClientID%>').is(':checked')) {
                            $('#<%=txtPermAdd1.ClientID%>').val($('#<%=txtWashEniroVisitAddress.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashBillAddress.ClientID%>').is(':checked')) {
                            $('#<%=txtBillAdd1.ClientID%>').val($('#<%=txtWashEniroBillAddress.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashZipCode.ClientID%>').is(':checked')) {
                            $('#<%=txtPermZip.ClientID%>').val($('#<%=txtWashEniroZipCode.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashZipPlace.ClientID%>').is(':checked')) {
                            $('#<%=txtPermCity.ClientID%>').val($('#<%=txtWashEniroZipPlace.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashPhone.ClientID%>').is(':checked')) {
                            $('[data-contact-type=2]').val($('#<%=txtWashEniroLastName.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashMobile.ClientID%>').is(':checked')) {
                            $('[data-contact-type=1]').val($('#<%=txtWashEniroMobile.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashBorn.ClientID%>').is(':checked')) {
                            $('#<%=txtBirthDate.ClientID%>').val($('#<%=txtWashEniroBorn.ClientID%>').val());    
                        }
                        if ($('#<%=chkWashSsnNo.ClientID%>').is(':checked')) {
                            $('#<%=txtAdvSsnNo.ClientID%>').val($('#<%=txtWashEniroSsnNo.ClientID%>').val());    
                        }
                        $('#<%=txtWashDate.ClientID%>').val($.datepicker.formatDate("dd.mm.yy", new Date()));

                    
                    }
                }).modal('show');
            });

            $('#<%=btnEniroFetch.ClientID%>').on('click', function () {
                FetchEniro($('#<%=txtEniro.ClientID()%>').val());
            });

            function FetchEniro(eniroId) {
                $('#<%=txtCustId.ClientID%>').val(eniroId);
                $('#<%=txtEniro.ClientID%>').val(eniroId);

                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/FetchEniro",
                    data: "{search: '" + eniroId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d.length != 0) {
                            $('#<%=CustSelect.ClientID%>').empty();
                            var res = data.d;
                            $.each(res, function (key, value) {
                                if ((value.CUST_FIRST_NAME != "" && value.CUST_FIRST_NAME != undefined && value.CUST_FIRST_NAME != null) || (value.CUST_LAST_NAME != "" && value.CUST_LAST_NAME != undefined && value.CUST_LAST_NAME != null) || (value.CUST_MIDDLE_NAME != "" && value.CUST_MIDDLE_NAME != undefined && value.CUST_MIDDLE_NAME != null)) {
                                    var name = value.CUST_FIRST_NAME + " " + value.CUST_MIDDLE_NAME + " " + value.CUST_LAST_NAME + " - " + value.CUST_PERM_ADD1 + " - " + value.ID_CUST_PERM_ZIPCODE + " " + value.CUST_PERM_ADD2 + " - " + value.CUST_PHONE_MOBILE;
                                    $('#<%=CustSelect.ClientID%>').append($("<option></option>").val(value.ENIRO_ID).html(name));
                                }
                                
                            });
                        }
                             else {
                                 alert('No customer was found. Please search with something else as your data.')
                             }
                    },
                    failure: function () {
                        alert("Failed!");
                    },
                    select: function (e, i) {
                        alert('hi');

                    },
                });
                 }

            function LoadEniroDet(eniroId) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadEniroDet",
                    data: "{EniroId: '" + eniroId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d.length != 0) {
                            $('#aspnetForm')[0].reset();
                            $('#customerContactPH').html('');
                            FetchCustomerTemplate($('#<%=ddlCustomerTemplate.ClientID%>').val());
                            $('#customerContactPH').html('');
                            $('#<%=txtEniroId.ClientID%>').val(data.d[0].ENIRO_ID);
                            $('#<%=txtFirstname.ClientID%>').val(data.d[0].CUST_FIRST_NAME);
                            $('#<%=txtMiddlename.ClientID%>').val(data.d[0].CUST_MIDDLE_NAME);
                            $('#<%=txtLastname.ClientID%>').val(data.d[0].CUST_LAST_NAME);
                            $('#<%=txtPermAdd1.ClientID%>').val(data.d[0].CUST_PERM_ADD1);
                            $('#<%=txtPermZip.ClientID%>').val(data.d[0].ID_CUST_PERM_ZIPCODE);
                            $('#<%=txtPermCity.ClientID%>').val(data.d[0].CUST_PERM_ADD2);
                            $('#<%=txtPermCounty.ClientID%>').val(data.d[0].CUST_COUNTY);
                            //if (data.d[0].PHONE_TYPE == 'M') {
                            //    insertContactField('1', 'Mobil', data.d[0].CUST_PHONE_MOBILE, 'TRUE', '1');
                            //}
                            //if (data.d[0].PHONE_TYPE == 'T') {
                            //    insertContactField('1', 'Direkte', data.d[0].CUST_PHONE_MOBILE, 'TRUE', '1');
                            //}
                            $('#<%=txtAdvSsnNo.ClientID%>').val(data.d[0].CUST_SSN_NO);
                            if (data.d[0].CUST_SSN_NO.length > 0) {
                                LoadBrreg(data.d[0].CUST_SSN_NO);
                            }
                            $('#<%=txtBirthDate.ClientID%>').val(data.d[0].CUST_BORN);

                            if (data.d[0].CUST_FIRST_NAME == '') {
                                $("#<%=chkPrivOrSub.ClientID%>").prop('checked', true);
                                setCustomerType();
                            }
                            else {
                                $("#<%=chkPrivOrSub.ClientID%>").prop('checked', false);
                                setCustomerType();
                            }
                            $('#<%=txtWashDate.ClientID%>').val($.datepicker.formatDate("dd.mm.yy", new Date()));
                            BindContact(data.d[0].ID_CUST);
                            $('#modNewCust').addClass('hidden');
                            $('.overlayHide').removeClass('ohActive');
                            $('#<%=txtCustId.ClientID%>').val('');
                            setBillAdd();
                        }
                        else {
                            alert('No customer was found. Please search with something else as your data.')
                        }
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            function BindContact(Id)
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/BindContact",
                    data: "{Id: '" + Id + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (Result) {
                        for (var i = 0; i < Result.d.length; i++) {
                            var label = Result.d[i].split('-')[0];
                            if (label == 'M') {
                                insertContactField('1', 'Mobil', Result.d[i].split('-')[1], 'TRUE', '1');
                            }
                            else if (label == 'T') {
                                insertContactField('1', 'Direkte', Result.d[i].split('-')[2], 'TRUE', '1');
                            }
                            else
                            {
                                insertContactField('1', 'Direkte', Result.d[i].split('-')[2], 'TRUE', '1');
                            }
                        }
                    } 
                });
            }

            function WashEniroData() {

                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/FetchEniro",
                    data: "{search: '" + $('#<%=txtFirstname.ClientID()%>').val() + " " + $('#<%=txtMiddlename.ClientID()%>').val() + " " + $('#<%=txtLastname.ClientID()%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d.length != 0) {
                            var res = data.d;
                            $.each(res, function (key, value) {
                                console.log(value.ENIRO_ID);
                                if (value.ENIRO_ID == $('#<%=txtEniroId.ClientID()%>').val()) {
                                    $('#<%=txtWashEniroLastName.ClientID()%>').val(value.CUST_LAST_NAME);
                                    $('#<%=txtWashEniroFirstName.ClientID()%>').val(value.CUST_FIRST_NAME);
                                    $('#<%=txtWashEniroMiddleName.ClientID()%>').val(value.CUST_MIDDLE_NAME);
                                    $('#<%=txtWashEniroVisitAddress.ClientID()%>').val(value.CUST_PERM_ADD1);
                                    $('#<%=txtWashEniroZipCode.ClientID()%>').val(value.ID_CUST_PERM_ZIPCODE);
                                    $('#<%=txtWashEniroZipPlace.ClientID()%>').val(value.CUST_PERM_ADD2);
                                    if (value.PHONE_TYPE == 'M') {
                                        $('#<%=txtWashEniroMobile.ClientID()%>').val(value.CUST_PHONE_MOBILE);
                                    }
                                    if (value.PHONE_TYPE == 'T') {
                                       $('#<%=txtWashEniroPhone.ClientID()%>').val(value.CUST_PHONE_MOBILE);
                                    }
                                    $('#<%=txtWashEniroBorn.ClientID()%>').val(value.CUST_BORN);
                                    $('#<%=txtWashEniroSsnNo.ClientID()%>').val(value.CUST_SSN_NO);
                                }
                                 });
                             }
                             else {
                                 alert('No customer was found. Please search with something else as your data.')
                             }
                    },
                    failure: function () {
                        alert("Failed!");
                    },
                    select: function (e, i) {
                        alert('hi');

                    },
                });
                 }

            function checkFormType(e) {

                return elemType;
            }
            $("#btnCustEmptyScreen").on('click', function (e) {
                fetchFLG = false;
                $(this).addClass('loading');
                $('#aspnetForm')[0].reset();
                $('#customerContactPH').html('');
                $('#<%=btnCustNotes.ClientID()%>').removeClass('warningAN');
                console.log($(this).prop('id'));
                if ($(this).prop('id') == 'btnCustNewCust') {
                    $('#<%=txtCustId.ClientID()%>').focus();
                }
                $('.loading').removeClass('loading');
            });


            $("#btnCustNewCust").on('click', function (e) {
                fetchFLG = false;
                $(this).addClass('loading');
                $('#aspnetForm')[0].reset();
                $('#customerContactPH').html('');
                $('#ctl00_cntMainPanel_ddlCustomerTemplate option[value="01"]').prop('selected', true);
                var tempId = $('#<%=ddlCustomerTemplate.ClientID%>').val();
                FetchCustomerTemplate(tempId);
                $('#<%=btnCustNotes.ClientID()%>').removeClass('warningAN');
                console.log($(this).prop('id'));
                if ($(this).prop('id') == 'btnCustNewCust') {
                    $('#<%=txtCustId.ClientID()%>').focus();
                }
                $('.loading').removeClass('loading');
            });
            //CUSTOMER CONTACT SAVE FUNCTION
            function AddCustomerContact() {
                if ($('#<%=txtCustomerId.ClientID%>').val().length <= 0 || !fetchFLG) {
                    var id = 0;
                    var name = $('#<%=drpContactType.ClientID%> option:selected').text();
                    var value = $('#<%=txtContactType.ClientID%>').val();
                    var type = $('#<%=drpContactType.ClientID%> option:selected').val();
                    var standard = $('#<%=chkContactType.ClientID%>').is(":checked");
                    insertContactField(id, name, value, standard, type);
                } else {
                    var seq = '';
                    var customerID = $('#<%=txtCustomerId.ClientID%>').val();
                    var contactValue = $('#<%=txtContactType.ClientID%>').val();
                    var contactType = $('#<%=drpContactType.ClientID%> option:selected').val();
                    var contactStandard = $('#<%=chkContactType.ClientID%>')[0].checked;
                    SaveCustomerContact(seq, contactType, customerID, contactValue, contactStandard);
                }
            }
            function SaveCustomerContact(seq, contactType, customerID, contactValue, contactStandard) {
                var postData = '{seq: "' + seq + '", contactType: "' + contactType + '", customerId: "' + customerID + '", contactValue: "' + contactValue + '", contactStandard: "' + contactStandard + '" }';
                if (debug) { console.log(postData); }
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/AddCustomerContact",
                    data: postData,
                    dataType: "json",
                    success: function (data) {
                        if (data.d == "INSFLG") {
                            if (debug) { console.log('New contact added for customer: ' + customerID); }
                            loadContact(customerID);
                        }
                    },
                    error: function (jqXHR, error, errorThrown) {
                        if (jqXHR.status && jqXHR.status == 400) {
                            alert(jqXHR.responseText);
                        } else {
                            console.log("Unable to process AddCustomerContact");

                        }
                    }
                });
            }

            function saveCustomer()
            {
                var customer = collectGroupData('submit');
                var fromPage = getUrlParameter('pageName');
                console.log(fromPage);

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "frmCustomerDetail.aspx/InsertCustomerDetails",
                    data: "{'Customer': '" + JSON.stringify(customer) + "'}",
                    dataType: "json",
                    //async: false,//Very important
                    success: function (data)
                    {
                        $('.loading').removeClass('loading');
                        if (data.d[0] == "INSFLG")
                        {
                            
                            $('#<%=ddlContactPerson.ClientID%>').empty().prop('disabled', false);
                            $('#<%=txtCustomerId.ClientID%>').val(data.d[1]);
                            
                            setSaveVar();
                            
                            if (window.parent != undefined && window.parent != null && window.parent.length > 0)
                            {                               
                                if (fromPage == "OrderHead")
                                { window.parent.document.getElementById('ctl00_cntMainPanel_txtSrchCust').value = data.d[1]; }

                                else if(fromPage == "Vehicle")
                                { window.parent.document.getElementById('ctl00_cntMainPanel_txtCustNo').value = data.d[1]; }

                                saveInputBackToParentWindow(fromPage);
                                window.parent.$('.ui-dialog-content:visible').dialog('close');
                                systemMSG('success', 'The customer has been saved!', 4000);
                            }
                        }
                        else if (data.d[0] == "UPDFLG")
                        {
                            setSaveVar();
                            
                            if (window.parent != undefined && window.parent != null && window.parent.length > 0)
                            {
                             
                                saveInputBackToParentWindow(fromPage);

                                if(fromPage == "OrderHead") 
                                {
                                    //if the textfield in parent is different from the one in the popup window(when new search in popup has been perfomed)
                                    if (window.parent.document.getElementById('ctl00_cntMainPanel_txtSrchCust').value != data.d[1])
                                    {                                  
                                        window.parent.document.getElementById('ctl00_cntMainPanel_txtSrchCust').value = data.d[1]; 
                                        window.parent.FillCustDet(data.d[1]);
                                        window.parent.FillVehDrpDwn(data.d[1]);
                                        window.parent.LoadNonInvoiceOrderDet(data.d[1]);
                                    }
                                }
                                else if(fromPage == "Vehicle")
                                {

                                    if (window.parent.document.getElementById('ctl00_cntMainPanel_txtCustNo').value != data.d[1])
                                    {
                                        window.parent.document.getElementById('ctl00_cntMainPanel_txtCustNo').value = data.d[1];
                                        window.parent.document.getElementById('ctl00_cntMainPanel_txtCustSearchEniro').value = "";
                                    }
                                    
                                }
                                

                                window.parent.$('.ui-dialog-content:visible').dialog('close');
                                systemMSG('success', 'Customer post has been updated!', 4000);
                            }
                        }
                        else if (data.d[0] == "ERRFLG")
                        { systemMSG('error', 'An error occured while trying to save the customer, please check input data.', 4000); }

                        if (data.d[1].length > 0)
                        { buildContactInfo(data.d[1]); }
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }
            /*
                saveInputBackToParentWindow(fromPage) is a helper funtion to the above function
                simply saves stuff back to the parent window's inputfields when clicking "save" 
            */
            function saveInputBackToParentWindow(fromPage)
            {
                if (fromPage == "OrderHead")
                {                                      
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtName').value = $('#<%=txtFirstname.ClientID%>').val() + " " + $('#<%=txtMiddlename.ClientID%>').val() + " " + $('#<%=txtLastname.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_ddlPayType').value = $('#<%=ddlPayType.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_ddlPayTerms').value = $('#<%=ddlPayTerms.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_ddlCusGroup').value = $('#<%=ddlCustGroup.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtAddress1').value = $('#<%=txtPermAdd1.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtZipCode').value = $('#<%=txtPermZip.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtState').value = $('#<%=txtPermCity.ClientID%>').val();
                }
                else if(fromPage == "Vehicle")
                {
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustFirstName').value = $('#<%=txtFirstname.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustMiddleName').value = $('#<%=txtMiddlename.ClientID%>').val()
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustLastName').value = $('#<%=txtLastname.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustAdd1').value = $('#<%=txtPermAdd1.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustVisitZip').value = $('#<%=txtPermZip.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustVisitPlace').value = $('#<%=txtPermCity.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustBillAdd').value = $('#<%=txtBillAdd1.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustBillZip').value = $('#<%=txtBillZip.ClientID%>').val();
                    window.parent.document.getElementById('ctl00_cntMainPanel_txtCustBillPlace').value = $('#<%=txtBillCity.ClientID%>').val();
                   
                }
               
            }

            $('#btnCustSave').on('click', function (e)
            {
                if (requiredFields(true, 'data-submit') === true)
                {
                    $(this).addClass('loading');
                    saveCustomer();
                    loadCompanyList($('#<%=txtCompanyPerson.ClientID%>').val());
                }
            });

            function clearContacts() {
                $('#customerContactPH').html('');
            }

            function loadContact(custId) {
                console.log('Running loadContact with id ' + custId);
                clearContacts();
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/LoadContact",
                    data: "{'custId': '" + custId + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        Result = Result.d;
                        $.each(Result, function (key, value) {
                            insertContactField(value.id, value.description, value.value, value.standard, value.type);
                        });
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
                }
            var countCont = 1;
            var contactOptions = {};
            function insertContactField(id, name, value, standard, type) {
                var elem = "<div class=\"inline fields contactWrapper\"><div class=\"five wide field\"><label for=\"txtContact" + countCont + "\">" + name + "</label></div><div class=\"eleven wide field\"><input type=\"text\" id=\"txtContact" + countCont + "\" data-contact=\"contact\" class=\"twelve char field\" value=\"" + value + "\" data-contact-type=\"" + type + "\" data-contact-id=\"" + id + "\" data-contact-standard=\"" + standard + "\"/><i class='checkmark icon'></i></div></div>";
                $('#customerContactPH').append(elem);
                if (standard == true) {
                    $('#txtContact' + countCont).closest('.contactWrapper').addClass('isStandard');
                }
                countCont = countCont + 1;
            }
            function standardContact(obj) {
                if ($('#<%=txtCustomerId.ClientID%>').val().length > 0 || !fetchFLG) {
                    var id = $(obj).data('contact-id');
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/StandardContact",
                        data: "{'CustomerSeq': '" + id + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (Result) {
                            systemMSG('success', 'Kontaktinformasjonen ble oppdatert på kunden', 4000);
                            loadContact($('#<%=txtCustomerId.ClientID%>').val());
                        },
                        failure: function () {
                            systemMSG('error', 'Kontaktinformasjonen ble ikke slettet, prøv å åpne kunden på nytt.', 4000);
                        }
                    });
                } else {
                    var type = $(obj).data('contact-type');
                    $("input[data-contact-type='" + type + "']").each(function (index, elem) {
                        $(elem).data('contact-standard', 'false');
                        $(elem).parents('.isStandard').removeClass('isStandard');
                    })
                    $(obj).data('contact-standard', 'true');
                    $(obj).parents('.inline.fields').addClass('isStandard');
                }
            }
            function deleteContactField(elem) {
                if ($('#<%=txtCustomerId.ClientID%>').val().length > 0 || !fetchFLG) {
                    console.log(elem);
                    var id = $('#' + elem).data('contact-id');
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/DeleteContact",
                        data: "{'CustomerSeq': '" + id + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (Result) {
                            systemMSG('success', '"Kontaktinformasjonen ble fjernet fra kunden!', 4000);
                            loadContact($('#<%=txtCustomerId.ClientID%>').val());
                        },
                        failure: function () {
                            systemMSG('error', 'Kontaktinformasjonen ble ikke slettet, prøv å åpne kunden på nytt.', 4000);
                        }
                    });
                } else {
                    $('#' + elem).parents('.inline.fields').remove();
                }
            }
            var contactInformation = {};
            function buildContactInfo(customer) {
                contactInformation = {};
                if (debug) { console.log("Running buildContactInfo()"); }
                $('[data-contact]').each(function (index, elem) {
                    var contactCard = [];
                    
                    var seq = $(elem).data('contact-id');
                    if (seq == 0) {
                        seq = '';
                    }
                    var type        =   $(elem).data('contact-type');
                    var value       =   $(elem).val();
                    var standard = $(elem).data('contact-standard');
                    contactCard = {
                        customer: customer,
                        seq: seq,
                        type: type,
                        value: value,
                        standard: standard
                    }
                    contactInformation['contactCard' + index] = contactCard;
                    if (debug) { console.log("Testing values Seq: " + seq + " Type: " + type + " Value: " + value + " Standard: " + standard); }
                });
                if (debug) { console.log(contactInformation); }
                $.each(contactInformation, function (index, value) {
                    console.log(index + ' ' + value['customer'] + ' ' + value['seq'] + ' ' + value['type'] + ' ' + value['value'] + ' ' + value['standard']);
                    SaveCustomerContact(value['seq'], value['type'], value['customer'], value['value'], value['standard']);
                });
                
            }
            function setCustomerType() {
                (companyIsChecked()) ? customerType('c') : customerType();
            }
            $("#panelPermAdd input").bind("change keyup blur", function () {
                setBillAdd();
            });
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
            function companyIsChecked() {
                if ($('#<%=chkPrivOrSub.ClientID%>').is(':checked'))
                    return true;
                else
                    return false;
            }
            function sameAdressIsChecked() {
                if ($('#<%=chkSameAdd.ClientID%>').is(':checked'))
                    return true;
                else
                    return false;
            }
            function customerType(d) {
                (d == 'c') ? isCompany() : isPrivate();
                function isCompany() { $('#priv').addClass('company'); $('#<%=txtFirstname.ClientID%>').attr('data-required', 'FALSE'); }
                function isPrivate() { $('#priv').removeClass('company'); $('#<%=txtFirstname.ClientID%>').attr('data-required', 'REQUIRED'); }
            }



            // Binds to elements
            $('#<%=chkPrivOrSub.ClientID%>').on('click', function (e) {
                setCustomerType();
            });
            $('#<%=chkSameAdd.ClientID%>').on('click', function (e) {
                setBillAdd();
            });


            $('#btnNewContact').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $("#modContact").modal('setting', {
                    autofocus: false,
                    onShow: function () {
                        $('#<%=txtContactType.ClientID%>').focus();
                    },
                    onDeny: function () {
                        if (debug) { console.log('modContact abort mod executed'); }
                        $('#<%=txtContactType.ClientID%>').val('');
                        $('#<%=drpContactType.ClientID%>').val($('#<%=drpContactType.ClientID%> option:first').val());
                        $('#<%=chkContactType.ClientID%>').prop('checked', false);
                    },
                    onApprove: function () {
                        if (debug) { console.log('modContact ok mod executed'); }
                        AddCustomerContact();
                        $('#<%=txtContactType.ClientID%>').val('');
                        $('#<%=drpContactType.ClientID%>').val($('#<%=drpContactType.ClientID%> option:first').val());
                        $('#<%=chkContactType.ClientID%>').prop('checked', false);
                    }
                })
                .modal('show')
            });

            $('#btnViewCustGroup').on('click', function () {

                $('#hideCustGroup').toggleClass('hidden');

            });

            $('#btnViewDetails').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $('#hideDetails').toggleClass('hidden');
                $('#hideDetails').hasClass('hidden') ? $(this).find('i.icon').removeClass('up').addClass('down') : $(this).find('i.icon').removeClass('down').addClass('up');
            });

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

            $('#btnCustHomepage').on('click', function () {
                var url = $('#txtCustHomepage:text').val();
                if (url.length == 0) return true;
                if (url.toLowerCase().indexOf("http:") < 0)
                    var nurl = "http://" + url;
                window.open(nurl);
            });

            function FetchCustomerDetails(custId) {
                if (custId === undefined) {
                    if (debug) {
                        console.log('No customerID defined, fetch cancelled');
                        $('#<%=ddlContactPerson.ClientID%>').empty().prop('disabled', true);
                    }
                }
                else {
                    loadContact(custId);
                    cpChange = '';
                    $.ajax({
                        type: "POST",
                        url: "frmCustomerDetail.aspx/FetchCustomerDetails",
                        data: "{custId: '" + custId + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (data) {

                            $('#<%=txtCustomerId.ClientID%>').val(data.d[0].ID_CUSTOMER);
                            if (data.d[0].ID_CUSTOMER.length > 0) {
                                $('#<%=txtCustomerId.ClientID%>').prop('disabled', true);
                            }
                            $('#<%=txtBillAdd1.ClientID%>').val(data.d[0].CUST_BILL_ADD1);
                            $('#<%=txtBillAdd2.ClientID%>').val(data.d[0].CUST_BILL_ADD2);
                            $('#<%=txtBillZip.ClientID%>').val(data.d[0].ID_CUST_BILL_ZIPCODE);
                            $('#<%=txtBillCity.ClientID%>').val(data.d[0].CUST_BILL_CITY);
                            $('#<%=txtPermAdd1.ClientID%>').val(data.d[0].CUST_PERM_ADD1);
                            $('#<%=txtPermAdd2.ClientID%>').val(data.d[0].CUST_PERM_ADD2);
                            $('#<%=txtPermZip.ClientID%>').val(data.d[0].ID_CUST_PERM_ZIPCODE);
                            $('#<%=txtPermCity.ClientID%>').val(data.d[0].CUST_PERM_CITY);
                            $('#<%=txtFirstname.ClientID%>').val(data.d[0].CUST_FIRST_NAME);
                            $('#<%=txtMiddlename.ClientID%>').val(data.d[0].CUST_MIDDLE_NAME);
                            $('#<%=txtLastname.ClientID%>').val(data.d[0].CUST_LAST_NAME);
                            $('#<%=txtNotes.ClientID%>').val(data.d[0].CUST_NOTES);
                            if ($('#<%=txtNotes.ClientID%>').val() != '') {
                                $('#<%=btnCustNotes.ClientID%>').addClass('warningAN');
                            }
                            else {
                                $('#<%=btnCustNotes.ClientID%>').removeClass('warningAN');
                            }
                            $('#<%=txtCompanyPerson.ClientID%>').val(data.d[0].CUST_COMPANY_NO);
                            $('#lblCompanyPersonName').html(data.d[0].CUST_COMPANY_DESCRIPTION);
                            if (data.d[0].CUST_COMPANY_NO.length > 0) {
                                loadCompanyList(data.d[0].CUST_COMPANY_NO);
                            }
                            else {
                                loadCompanyList(data.d[0].ID_CUSTOMER);
                            }
                            $('#<%=ddlCustGroup.ClientID()%>').val(data.d[0].ID_CUST_GROUP);
                            $('#<%=ddlPayTerms.ClientID()%>').val(data.d[0].ID_CUST_PAY_TERM);
                            $('#<%=ddlPayType.ClientID()%>').val(data.d[0].ID_CUST_PAY_TYPE);
                            $('#<%=txtAdvSparesDiscount.ClientID()%>').val(data.d[0].CUST_DISC_SPARES);
                            $('#<%=txtAdvLabourDiscount.ClientID()%>').val(data.d[0].CUST_DISC_LABOUR);
                            $('#<%=txtAdvGeneralDiscount.ClientID()%>').val(data.d[0].CUST_DISC_GENERAL);
                            $('#<%=txtBirthDate.ClientID()%>').val(data.d[0].CUST_BORN);
                            $('#<%=txtEniroId.ClientID()%>').val(data.d[0].ENIRO_ID);

                            if (data.d[0].FLG_PRIVATE_COMP == 'True') {
                                $("#<%=chkPrivOrSub.ClientID%>").prop('checked', true);
                                $('#<%=txtCompanyPersonFind.ClientID()%>').attr("disabled", "disabled");
                                $('#<%=txtCompanyPerson.ClientID()%>').attr("disabled", "disabled");
                            } else {
                                $("#<%=chkPrivOrSub.ClientID%>").prop('checked', false);
                                $('#<%=txtCompanyPersonFind.ClientID()%>').removeAttr("disabled", "disabled");
                                $('#<%=txtCompanyPerson.ClientID()%>').removeAttr("disabled", "disabled");
                            }
                            if (data.d[0].ISSAMEADDRESS == 'True') {
                                $("#<%=chkSameAdd.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkSameAdd.ClientID%>").prop('checked', false);
                            }
                            // GEN > DETAILS
                            if (data.d[0].FLG_EINVOICE == 'True') {
                                $("#<%=chkEinvoice.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkEinvoice.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_INV_EMAIL == 'True') {
                                $("#<%=chkInvEmail.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkInvEmail.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_ORDCONF_EMAIL == 'True') {
                                $("#<%=chkOrdconfEmail.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkOrdconfEmail.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_SMS == 'True') {
                                $("#<%=chkNoSms.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoSms.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_EMAIL == 'True') {
                                $("#<%=chkNoEmail.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoEmail.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_MARKETING == 'True') {
                                $("#<%=chkNoMarketing.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoMarketing.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_HUMANEORG == 'True') {
                                $("#<%=chkNoHumaneorg.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoHumaneorg.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_PHONESALE == 'True') {
                                $("#<%=chkNoPhonesale.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkNoPhonesale.ClientID%>").prop('checked', false);
                            }
                            // ADVANCED TAB
                            if (data.d[0].FLG_CUST_IGNOREINV == 'False') {
                                $("<%=chkAdvCustIgnoreInv.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustIgnoreInv.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_CUST_FACTORING == 'True') {
                                $("#<%=chkAdvCustFactoring.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustFactoring.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_CUST_BATCHINV == 'True') {
                                $("#<%=chkAdvCustBatchInv.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustBatchInv.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_GM == 'True') {
                                $("#<%=chkAdvNoGm.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvNoGm.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_CUST_INACTIVE == 'True') {
                                $("#<%=chkAdvCustInactive.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvCustInactive.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_NO_ENV_FEE == 'True') {
                                $("#<%=chkAdvNoEnv.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkAdvNoEnv.ClientID%>").prop('checked', false);
                            }
                            if (data.d[0].FLG_PROSPECT == 'True') {
                                $("#<%=chkProspect.ClientID%>").prop('checked', true);
                            } else {
                                $("#<%=chkProspect.ClientID%>").prop('checked', false);
                            }
                            loadBranch();
                            setCustomerType();
                            fetchFLG = true;
                            if (debug) { console.log('Customer fetch flag: ' + fetchFLG) }
                            loadCustomerContactPerson('', data.d[0].ID_CUSTOMER)
                            $('#<%=ddlContactPerson.ClientID%>').val(data.d[0].ID_CP);
                            console.log('ID CP: ' + data.d[0].ID_CP);
                            clearSaveVar();
                            setSaveVar();
                        },
                        failure: function () {
                            alert("Failed!");
                        }
                    });
                }
            };

            $.datepicker.setDefaults($.datepicker.regional["no"]);
            $('#<%=txtNextContact1.ClientID%>,#<%=txtDeathDate.ClientID%>').datepicker({
                showWeek: true,
                //showOn: "button",
                //buttonImage: "../images/calendar_icon.gif",
                //buttonImageOnly: true,
                //buttonText: "Select date",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+1"
            });

            //autocomplete for cusatomer search in local DB
            $('#<%=txtCustId.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "../Transactions/frmWoSearch.aspx/Customer_Search",
                        data: "{q:'" + $('#<%=txtCustId.ClientID%>').val() + "', 'isPrivate': '" + true + "', 'isCompany': '" + true + "'}",
                        dataType: "json",
                        success: function (data) {

                            console.log($('#<%=txtCustId.ClientID%>').val());
                             if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                 response([{ label: 'Ingen treff i lokalt kunderegister. Hente fra eniro?', value: $('#<%=txtCustId.ClientID%>').val(), val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME + " - " + item.CUST_PERM_ADD1 + " - " + item.ID_CUST_PERM_ZIPCODE + " " + item.CUST_PERM_CITY,
                                        val: item.ID_CUSTOMER,
                                        value: item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME
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
                    //alert(i.item.val);
                    cpChange = '';
                    if (i.item.val != 'new') {
                        $('#aspnetForm')[0].reset();
                        $('#customerContactPH').html('');
                        FetchCustomerDetails(i.item.val);
                        $(this).val('');
                        return false;
                    }
                    else {
                        $('.overlayHide').addClass('ohActive');
                        $('#modNewCust').removeClass('hidden');
                        FetchEniro($('#<%=txtCustId.ClientID()%>').val());
                    }
                }
            });

            //Autocomplete for zip code field
            $('#<%=txtPermZip.ClientID%>').autocomplete({
                autoFocus: true,
                selectFirst: true,
                source: function (request, callback) {
                    el = this.element;
                    zipSearch($(el).val(), callback)
                },
                    select: function (e, i) {
                        $("#<%=txtPermZip.ClientID%>").val(i.item.val);
                        $("#<%=txtPermCity.ClientID%>").val(i.item.city);
                        $("#<%=txtPermCountry.ClientID%>").val(i.item.country);
                        $("#<%=txtPermCounty.ClientID%>").val(i.item.state);
                    },
                });
            $('#<%=txtBillZip.ClientID%>').autocomplete({
                autoFocus: true,
                selectFirst: true,
                source: function (request, callback) {
                    el = this.element;
                    zipSearch($(el).val(), callback)
                },
                select: function (e, i) {
                    $("#<%=txtBillZip.ClientID%>").val(i.item.val);
                        $("#<%=txtBillCity.ClientID%>").val(i.item.city);
                        $("#<%=txtBillCountry.ClientID%>").val(i.item.country);
                        $("#<%=txtBillCounty.ClientID%>").val(i.item.state);
                    },
            });

            //autocomplete for company person to add a company for the chosen customer
            $('#<%=txtCompanyPersonFind.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "../Transactions/frmWoSearch.aspx/Customer_Search",
                        data: "{q:'" + $('#<%=txtCompanyPersonFind.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {

                            console.log($('#<%=txtCompanyPersonFind.ClientID%>').val());
                             if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                 response([{ label: 'Kan ikke finne kunde med det oppgitte søkekriteriet'}]);
                            } else
                                response($.map(data.d, function (item) {
                                    return {
                                        label: item.ID_CUSTOMER + " - " + item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME + " - " + item.CUST_PHONE_MOBILE,
                                        val: item.ID_CUSTOMER,
                                        value: item.CUST_FIRST_NAME + " " + item.CUST_MIDDLE_NAME + " " + item.CUST_LAST_NAME
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
                    //alert(i.item.val);
                    $('#<%=txtCompanyPerson.ClientID%>').val(i.item.val)
                    $('#lblCompanyPersonName').html(i.item.value)
                    loadCompanyList($('#<%=txtCompanyPerson.ClientID%>').val());
                }
            });

            $('#<%=txtCompanyPerson.ClientID%>').on('blur', function () {
                if($('#<%=txtCompanyPerson.ClientID%>').val() == ''){
                    $('#lblCompanyPersonName').html('Ingen tilknytning.');
                    loadCompanyList($('#<%=txtCompanyPerson.ClientID%>').val());
                }
                else {
                    loadCompanyList($('#<%=txtCompanyPerson.ClientID%>').val());
                }
                
            });

            //Fetch company list function for drop down list
            function loadCompanyList(q) {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/Company_List",
                    data: "{q:'" + q + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=ddlCompanyList.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                           $('#<%=ddlCompanyList.ClientID%>').append($("<option></option>").val(value.ID_CUSTOMER).html(value.ID_CUSTOMER + " - " + value.CUST_FIRST_NAME + " " + value.CUST_MIDDLE_NAME + " " + value.CUST_LAST_NAME));
                                                       
                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            $(function () {
                $('#<%=txtAdvSalesman.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "frmCustomerDetail.aspx/LoadSalesman",
                            data: '{}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d.length === 0) { // If no hits
                                    response([{ label: 'Ingen treff i. Trykk enter for å opprette ny selger.', value: '0', val: 'new' }]);
                                } else
                                    response($.map(data.d, function (item) {
                                        return {
                                            label: item.USER_LOGIN + " - " + item.USER_FIRST_NAME + " " + item.USER_LAST_NAME,
                                            val: item.USER_LOGIN,
                                            value: item.USER_LOGIN
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
                    minLength: 0
                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                });
            });

            $(function () {
                $('#<%=txtAdvBranch.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "frmCustomerDetail.aspx/LoadBranch",
                            data: '{}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d.length === 0) { // If no hits
                                    response([{ label: 'Ingen treff i. Trykk enter for å opprette ny selger.', value: '0', val: 'new' }]);
                                } else
                                    response($.map(data.d, function (item) {
                                        return {
                                            label: item.BRANCH_CODE + " - " + item.BRANCH_TEXT,
                                            val: item.BRANCH_CODE,
                                            value: item.BRANCH_CODE
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
                    minLength: 0
                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                });
            });

            $(function () {
                $('#<%=txtAdvCategory.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "frmCustomerDetail.aspx/LoadCategory",
                            data: '{}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d.length === 0) { // If no hits
                                    response([{ label: 'Ingen treff i. Trykk enter for å opprette ny selger.', value: '0', val: 'new' }]);
                                } else
                                    response($.map(data.d, function (item) {
                                        return {
                                            label: item.CATEGORY_CODE + " - " + item.CATEGORY_TEXT,
                                            val: item.CATEGORY_CODE,
                                            value: item.CATEGORY_CODE + " - " + item.CATEGORY_TEXT
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
                    minLength: 0
                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                });
            });

            $(function () {
                $('#<%=txtAdvSalesgroup.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "frmCustomerDetail.aspx/LoadSalesGroup",
                            data: '{}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d.length === 0) { // If no hits
                                    response([{ label: 'Ingen treff i. Trykk enter for å opprette ny selger.', value: '0', val: 'new' }]);
                                } else
                                    response($.map(data.d, function (item) {
                                        return {
                                            label: item.SALESGROUP_CODE + " - " + item.SALESGROUP_TEXT,
                                            val: item.SALESGROUP_CODE,
                                            value: item.SALESGROUP_CODE
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
                    minLength: 0
                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                });
            });

            $(function () {
                $('#<%=txtAdvPayterms.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "frmCustomerDetail.aspx/LoadPaymentTerms",
                            data: '{}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d.length === 0) { // If no hits
                                    response([{ label: 'Ingen treff i. Trykk enter for å opprette ny selger.', value: '0', val: 'new' }]);
                                } else
                                    response($.map(data.d, function (item) {
                                        return {
                                            label: item.PAYMENT_TERMS_CODE + " - " + item.PAYMENT_TERMS_TEXT,
                                            val: item.PAYMENT_TERMS_CODE,
                                            value: item.PAYMENT_TERMS_CODE + " - " + item.PAYMENT_TERMS_TEXT
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
                    minLength: 0
                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                });
            });

            $(function () {
                $('#<%=txtAdvCardtype.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "frmCustomerDetail.aspx/LoadCardType",
                            data: '{}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d.length === 0) { // If no hits
                                    response([{ label: 'Ingen treff i. Trykk enter for å opprette ny selger.', value: '0', val: 'new' }]);
                                } else
                                    response($.map(data.d, function (item) {
                                        return {
                                            label: item.CARD_TYPE_CODE + " - " + item.CARD_TYPE_TEXT,
                                            val: item.CARD_TYPE_CODE,
                                            value: item.CARD_TYPE_CODE
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
                    minLength: 0
                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                });
            });

            $(function () {
                $('#<%=txtAdvCurrcode.ClientID%>').autocomplete({
                    selectFirst: true,
                    autoFocus: true,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "frmCustomerDetail.aspx/LoadCurrencyType",
                            data: '{}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: function (data) {
                                if (data.d.length === 0) { // If no hits
                                    response([{ label: 'Ingen treff i. Trykk enter for å opprette ny selger.', value: '0', val: 'new' }]);
                                } else
                                    response($.map(data.d, function (item) {
                                        return {
                                            label: item.CURRENCY_TYPE_CODE + " - " + item.CURRENCY_TYPE_TEXT,
                                            val: item.CURRENCY_TYPE_CODE,
                                            value: item.CURRENCY_TYPE_CODE
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
                    minLength: 0
                }).focus(function () {
                    //Use the below line instead of triggering keydown
                    $(this).autocomplete("search", "").select();
                });
            });

            $('#<%=ddlVehicleList.ClientID%>').change(function () {
                loadCustVehicleDet();
            });
            $('#<%=ddlSortVehicleList.ClientID%>').change(function () {
                loadCustVehicle();
            });

            $('#btnVehicle').on('click', function () {
                loadCustVehicle();
            });

            //Fetch vehicle list function for drop down list
            function loadCustVehicle() {
                $.ajax({
                    type: "POST",
                    url: "../Transactions/frmWOSearch.aspx/Vehicle_Search",
                    data: "{q:'" + $('#<%=txtCustomerId.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=ddlVehicleList.ClientID%>').empty();
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            if ($('#<%=ddlSortVehicleList.ClientID%>').val() == '-1') {
                                $('#<%=ddlVehicleList.ClientID%>').append($("<option data-refno='"+value.IntNo+"'></option>").val(value.Id_Veh_Seq).html(value.IntNo + " - " + value.VehRegNo + " - " + value.Make + " - " + value.VehVin));
                            }
                            if ($('#<%=ddlSortVehicleList.ClientID%>').val() == value.New_Used) {
                                $('#<%=ddlVehicleList.ClientID%>').append($("<option></option>").val(value.Id_Veh_Seq).html(value.IntNo + " - " + value.VehRegNo + " - " + value.Make + " - " + value.VehVin));
                            }
                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            //fills the ddl list to sort the vehicle list
            function loadNewUsedCode() {
                $.ajax({
                    type: "POST",
                    url: "frmVehicleDetail.aspx/LoadNewUsedCode",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=ddlSortVehicleList.ClientID%>').empty();
                        $('#<%=ddlSortVehicleList.ClientID%>').prepend("<option value='-1'>" + "Alle" + "</option>");
                        Result = Result.d;

                        $.each(Result, function (key, value) {
                            $('#<%=ddlSortVehicleList.ClientID%>').append($("<option></option>").val(value.RefnoCode).html(value.RefnoDescription));

                        });

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            //Fetch vehicle list function for drop down list
            function loadCustVehicleDet() {
                $.ajax({
                    type: "POST",
                    url: "../Transactions/frmWOSearch.aspx/Vehicle_Search",
                    data: "{q:'" + $('#<%=ddlVehicleList.ClientID%>').find(':selected').data('refno') + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (Result) {
                        $('#<%=txtVehRefNo.ClientID%>').val('');
                        $('#<%=txtVehRegNo.ClientID%>').val('');
                        $('#<%=txtVehVin.ClientID%>').val('');
                        $('#<%=txtVehMileage.ClientID%>').val('');
                        $('#<%=txtVehMake.ClientID%>').val('');
                        $('#<%=txtVehModel.ClientID%>').val('');
                        $('#<%=txtVehRegYear.ClientID%>').val('');
                        $('#<%=txtVehRegDate.ClientID%>').val('');
                        $('#<%=txtVehRefNo.ClientID%>').val(Result.d[0].IntNo);
                        $('#<%=txtVehRegNo.ClientID%>').val(Result.d[0].VehRegNo);
                        $('#<%=txtVehVin.ClientID%>').val(Result.d[0].VehVin);
                        $('#<%=txtVehMileage.ClientID%>').val(Result.d[0].Mileage);
                        $('#<%=txtVehMake.ClientID%>').val(Result.d[0].Make);
                        $('#<%=txtVehModel.ClientID%>').val(Result.d[0].VehType);
                        $('#<%=txtVehRegYear.ClientID%>').val(Result.d[0].RegYear);
                        $('#<%=txtVehRegDate.ClientID%>').val(Result.d[0].RegDate);

                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            }

            

            $('#ID_CUSTOMER_WRAPPER').on('click', function () {
                if ($('#<%=txtCustomerId.ClientID%>').prop('disabled') && $('#<%=txtCustomerId.ClientID%>').val().length == 0) {
                    console.log('read only true');
                    $('#modCustomerLock').modal('setting', {
                        onDeny: function () {
                        },
                        onApprove: function () {
                            $('#<%=txtCustomerId.ClientID%>').removeAttr('disabled').removeAttr('readonly').focus();
                            console.log('Enabled the #ID_CUSTOMER field');
                        },
                        onShow: function () {
                            $(this).children('ui.button.ok.positive').focus();
                        }
                    }).modal('show');
                }
            });

            $('#<%=txtCustomerId.ClientID%>').on('blur', function () {
                $.ajax({
                    type: "POST",
                    url: "frmCustomerDetail.aspx/FetchCustomerDetails",
                    data: "{custId: '" + $('#<%=txtCustomerId.ClientID%>').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d[0] == null) {
                            console.log('OK');
                        } else {
                            console.log('Error');
                            $('#mceMSG').html('Kundenummer er allerede i bruk på kunde ' + data.d[0].CUST_FIRST_NAME + ' ' + data.d[0].CUST_MIDDLE_NAME + ' ' + data.d[0].CUST_LAST_NAME + ', vil du åpne kunden for redigering eller vil du prøve et annet nummer?')
                            $('#modCustomerExists').modal({
                                onDeny: function () {
                                    $('#<%=txtCustomerId.ClientID%>').val('');
                                    $('#<%=txtCustomerId.ClientID%>').focus();
                                },
                                onApprove: function () {
                                    FetchCustomerDetails($('#<%=txtCustomerId.ClientID%>').val());
                                }
                            }).modal('show');
                        }
                    }
                });
            });



        window.onbeforeunload = confirmExit;
        function confirmExit() {
            if (checkSaveVar()) {

            } else {
                return "Det kan være ulagrede endringer på siden, er du sikker på at du vil lukke siden?";
            }
        }
        function setSaveVar() {
            custvar = collectGroupData('submit');
        }
        function checkSaveVar() {
            contvar = collectGroupData('submit');
            //if (JSON.stringify(custvar) === JSON.stringify(contvar)) {
            if(objectEquals(custvar, contvar)){
                return true;
            }
            else {
                return false;
            }
        }
        function clearSaveVar() {
            custvar = {};
        }
        });

    </script>
    <asp:HiddenField ID="hdnSelect" runat="server" />
    <div class="overlayHide"></div>
    <div id="konkurs" class="ui modal">
        <div class="header">
            Advarsel!
        </div>
        <div class="image content">
            <div class="image">
                <i class="warning icon"></i>
            </div>
            <div class="description">
                <p>Firmaet <span id="konkFirma"></span>er ærklert konkurs eller under tvangsavvikling. Se mer informasjon i <a href="https://www.brreg.no/" id="konkLink" title="Brønnøysundregistrene" target="_blank">Brønnøysundregistrene</a>.</p>
            </div>
        </div>
        <div class="actions">
            <div class="ui button ok">Ok</div>
        </div>
    </div>
    <%-- Modal for Eniro search pop up --%>
    <div id="modCustomerLock" class="ui modal">
        <div class="header">
            <asp:Literal runat="server" ID="CustomerLockHead" meta:resourcekey="CustomerLockHeadResource1" Text="Advarsel!"></asp:Literal>
        </div>
        <div class="image content">
            <div class="image">
                <i class="warning icon"></i>
            </div>
            <div class="description">
                <p><asp:Label runat="server" ID="CustomerLock1" meta:resourcekey="CustomerLock1Resource1" Text="Kundefeltet er låst for manuell inntasting. Kundenummer blir automatisk tildelt ved lagring av kunde."></asp:Label></p>
                <p><asp:Literal runat="server" ID="CustomerLock2" meta:resourcekey="CustomerLock2Resource1" Text="Ønsker du å søke opp kunde, trykk avbryt og bruk søkefeltet til høyre."></asp:Literal></p>
                <p><asp:Literal runat="server" ID="CustomerLock3" meta:resourcekey="CustomerLock3Resource1" Text="For å tildele manuelt kundenummer, velg &quot;lås opp&quot; for å låse opp feltet for inntasting."></asp:Literal></p>
            </div>
        </div>
        <div class="actions">
            <div class="ui button ok positive"><asp:Literal runat="server" ID="CustomerLockOK" meta:resourcekey="CustomerLockOKResource1" Text="Lås opp"></asp:Literal></div>
            <div class="ui button cancel negative"><asp:Literal runat="server" ID="CustomerLockCancel" meta:resourcekey="CustomerLockCancelResource1" Text="Avbryt"></asp:Literal></div>
        </div>
    </div>
    <%-- Modal for adding customer contact person --%>
    <div id="modContactPerson" class="ui modal coupled">
        <i class="close icon"></i>
        <div class="header">
            <asp:Literal runat="server" ID="litCustCPHeader" Text="Contact Person"></asp:Literal>
        </div>
        <div class="content">
            <div class="ui grid form">
                <div class="six wide column">
                    <asp:TextBox ID="txtCPID" runat="server" data-cp-submit="ID_CP" CssClass="sr-only"></asp:TextBox>
                    <label for="txtCPFirstName" id="lblCPFirstName"><asp:Literal ID="litCPFirstName" runat="server" Text="First name"></asp:Literal></label>
                    <asp:TextBox ID="txtCPFirstName" runat="server" data-cp-submit="CP_FIRST_NAME" data-required="REQUIRED" Text="CPFN"></asp:TextBox>
                </div>
                <div class="four wide column">
                    <label for="txtCPMiddleName" id="lblCPMiddleName"><asp:Literal ID="litCPMiddleName" runat="server" Text="Middle name"></asp:Literal></label>
                    <asp:TextBox ID="txtCPMiddleName" runat="server" data-cp-submit="CP_MIDDLE_NAME"></asp:TextBox>
                </div>
                <div class="six wide column">
                    <label for="txtCPLastName" id="lblCPLastName"><asp:Literal ID="litCPLastName" runat="server" Text="Last name"></asp:Literal></label>
                    <asp:TextBox ID="txtCPLastname" runat="server" data-cp-submit="CP_LAST_NAME" data-required="REQUIRED" Text="CPLN"></asp:TextBox>
                </div>
                <div class="ten wide column">
                    <label for="txtCPPostalAddress" id="lblCPPostalAddress"><asp:Literal ID="litCPPostalAddress" runat="server" Text="Postal address"></asp:Literal></label>
                    <asp:TextBox ID="txtCPPostalAddress" runat="server" data-cp-submit="CP_PERM_ADD"></asp:TextBox>
                    <label for="txtCPVisitAddress" id="lblCPVisitAddress"><asp:Literal ID="litCPVisitAddress" runat="server" Text="Visit address"></asp:Literal></label>
                    <asp:TextBox ID="txtCPVisitAddress" runat="server" data-cp-submit="CP_VISIT_ADD"></asp:TextBox>
                    <div class="fields">
                        <div class="four wide field">
                            <label for="txtCPZip" id="lblCPZip"><asp:Literal ID="litCPZip" runat="server" Text="Zip code"></asp:Literal></label>
                            <asp:TextBox ID="txtCPZip" CssClass="CPZip" runat="server" data-cp-submit="CP_ZIP_CODE"></asp:TextBox>
                        </div>
                        <div class="twelve wide field">
                            <label for="txtCPZipCity" id="lblCPZipCity"><asp:Literal ID="litCPZipCity" runat="server" Text="Zip city"></asp:Literal></label>
                            <asp:TextBox ID="txtCPZipCity" runat="server" data-cp-submit="CP_ZIP_CITY"></asp:TextBox>
                        </div>
                    </div>
                    <label for="txtCPEmail" id="lblCPEmail"><asp:Literal ID="litCPEmail" runat="server" Text="E-mail"></asp:Literal></label>
                    <asp:TextBox ID="txtCPEmail" runat="server" data-cp-submit="CP_EMAIL"></asp:TextBox>
                    <div class="fields">
                        <div class="four wide field">
                            <label for="txtCPTitleCode" id="lblCPTitleCode"><asp:Literal ID="litCPTitleCOde" runat="server" Text="Title"></asp:Literal></label>
                            <asp:TextBox ID="txtCPTitleCode" runat="server" data-cp-submit="CP_TITLE_CODE"></asp:TextBox>
                        </div>
                        <div class="twelve wide field">
                            <label>&nbsp;</label>
                            <asp:TextBox ID="txtCPTitle" runat="server" ReadOnly="true" Enabled="false" data-ccp-type="t" CssClass="disable-tab"></asp:TextBox>
                        </div>
                    </div>
                    <div class="fields">
                        <div class="four wide field">
                            <label for="txtCPFunctionCode" id="lblCPFunctionCode"><asp:Literal ID="litCPFunctionCode" runat="server" Text="Function"></asp:Literal></label>
                            <asp:TextBox ID="txtCPFunctionCode" runat="server" data-cp-submit="CP_FUNCTION_CODE"></asp:TextBox>
                        </div>
                        <div class="twelve wide field">
                            <label>&nbsp;</label>
                            <asp:TextBox ID="txtCPFunction" runat="server" ReadOnly="true" Enabled="false" data-ccp-type="f" CssClass="disable-tab"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="six wide column">
                    <h4 class="ui dividing header">Phone</h4>
                    <div class="inline field">
                        <label for="txtCPPhonePrivate" id="lblCPPhonePrivate"><asp:Literal ID="litCPPhonePrivate" runat="server" Text="Private"></asp:Literal></label>
                        <asp:TextBox ID="txtCPPhonePrivate" runat="server" data-cp-submit="CP_PHONE_PRIVATE"></asp:TextBox>
                    </div>
                    <div class="inline field">
                        <label for="txtCPPhoneMobile" id="lblCPPhoneMobile"><asp:Literal ID="litCPPhoneMobile" runat="server" Text="Mobile"></asp:Literal></label>
                        <asp:TextBox ID="txtCPPhoneMobile" runat="server" data-cp-submit="CP_PHONE_MOBILE"></asp:TextBox>
                    </div>
                    <div class="inline field">
                        <label for="txtCPPhoneFax" id="lblCPPhoneFax"><asp:Literal ID="litCPPhoneFax" runat="server" Text="Fax"></asp:Literal></label>
                        <asp:TextBox ID="txtCPPhoneFax" runat="server" data-cp-submit="CP_PHONE_FAX"></asp:TextBox>
                    </div>
                    <div class="inline field">
                        <label for="txtCPPhoneWork" id="lblCPPhoneWork"><asp:Literal ID="litCPPhoneWork" runat="server" Text="Work"></asp:Literal></label>
                        <asp:TextBox ID="txtCPPhoneWork" runat="server" data-cp-submit="CP_PHONE_WORK"></asp:TextBox>
                    </div>
                    <div class="ui fitted divider"></div>
                    <div class="inline field">
                        <label for="txtCPBirthday" id="lblCPBirthday"><asp:Literal ID="litCPBirthday" runat="server" Text="Birthday"></asp:Literal></label>
                        <asp:TextBox ID="txtCPBirthday" CssClass="CPDate" runat="server" data-cp-submit="CP_BIRTH_DATE"></asp:TextBox>
                        <i class="calendar icon"></i>
                    </div>
                </div>
                <div class="ten wide field">
                    <label for="txtCPNotes" id="lblCPNotes"><asp:Literal ID="litCPNotes" runat="server" Text="Notes"></asp:Literal></label>
                    <asp:TextBox ID="txtCPNotes" TextMode="multiline" runat="server" data-cp-submit="CP_NOTES"></asp:TextBox>
                </div>
                <div class="six wide field">
                    <div class="ui fitted divider"></div>
                    <div class="ui checkbox">
                        <asp:CheckBox ID="chkContactPerson" runat="server" Text="Contact person" data-cp-submit="CP_CONTACT" />
                    </div>
                    <div class="ui checkbox">
                        <asp:CheckBox ID="chkCarUser" runat="server" Text="Car user" data-cp-submit="CP_CAR_USER" />
                    </div>
                    <div class="ui checkbox">
                        <asp:CheckBox ID="chkEmailReferance" runat="server" Text="E-mail as reference" data-cp-submit="CP_EMAIL_REF" />
                    </div>
                </div>
            </div>
        </div>
        <div class="actions">
            <div id="btnCPDelete" class="ui button"><asp:Literal runat="server" ID="litCustCPDelete" Text="Delete"></asp:Literal></div>
            <div class="ui button ok positive"><asp:Literal runat="server" ID="litCustCPSave"  Text="Save"></asp:Literal></div>
            <div class="ui button cancel negative"><asp:Literal runat="server" ID="litCustCPCancel" Text="Cancel"></asp:Literal></div>
        </div>
    </div>
    <%-- Modal for sjekking av eksisterende kundenummer --%>
    <div id="modContactPersonConfirm" class="ui modal coupled small">
        <div class="header">Please confirm</div>
        <div class="content">
            You are adding a new <span id="custCPAddType">PH</span>: <br />
            Code: <strong><span id="custCPAddCode">PH</span></strong> Description: <strong><span id="custCPAddDescription">PH</span></strong>.
        </div>
        <div class="actions">
            <div class="ui button ok positive"><asp:Literal runat="server" ID="litCustCPAddSave"  Text="Continue"></asp:Literal></div>
            <div class="ui button cancel negative"><asp:Literal runat="server" ID="litCustCPAddCancel" Text="Cancel"></asp:Literal></div>
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
            <div class="ui button ok">Se på kunde</div>
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
                                <asp:Label ID="Label1" Text="Søk etter kunde (Tlf, navn, sted, etc.)" runat="server" meta:resourcekey="Label1Resource1"></asp:Label>
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
            <input type="button" value="Kunde" id="btnCustomer" class="ui btn cTab" data-tab="Customer" />
            <input type="button" value="Avansert" id="btnAdvanced" class="ui btn cTab" data-tab="Advanced" />
            <input type="button" value="Aktiviteter" id="btnActivities" class="ui btn cTab" data-tab="Activities" />
            <input type="button" value="Bil" id="btnVehicle" class="ui btn cTab" data-tab="Vehicle" />
            <input type="button" value="Bilønske" id="btnWanted" class="ui btn cTab" data-tab="Wanted" />
        </div>
    </div>
    <h2 class="ui top attached small header">Customer Details</h2>
    <div class="ui form attached segment">
        <div class="ui stackable grid">
            <div id="ID_CUSTOMER_WRAPPER" class="four wide computer four wide tablet column">
                <div class="inline fields">
                    <label for="txtCustomerId" id="lblCustomerId" runat="server"><asp:Label ID="lblcustId" runat="server" Text="Kundenummer" meta:resourcekey="lHeadResource1"></asp:Label></label>
                    <asp:TextBox ID="txtCustomerId" runat="server" data-submit="ID_CUSTOMER" data-cp-submit="CP_CUSTOMER_ID" Enabled="False" CssClass="eight char field" meta:resourcekey="txtCustomerIdResource1"></asp:TextBox>
                </div>
            </div> <!-- /# id_customer_wrapper column -->
            <div class="six wide computer eight wide tablet column ">
               <div class="inline fields">
                    <label for="txtCustId"><asp:Label ID="lblHead" runat="server" Text="Kundesøk" meta:resourcekey="lHeadResource1"></asp:Label></label>
                    <asp:TextBox ID="txtCustId" runat="server" meta:resourcekey="txtCustIdResource1" placeholder="søk etter tlf, navn, addresse..."></asp:TextBox>
                    <input type="button" id="btnSearchCustomer" runat="server" value="Hent" class="ui btn mini" />
                    <input type="button" id="btnWashCustomer" runat="server" value="Vask" class="ui btn mini" />
                </div>
            </div> <!-- /column -->
            <div class="six  wide tablet four wide tablet column">
                <div class="inline fields">
                    <asp:Label ID="lblCustomerTemplate" runat="server" Text="Velg mal" meta:resourcekey="lblCustomerTemplateResource1"></asp:Label>
                    <div id="updCustomerTemplate">
                        <asp:DropDownList ID="ddlCustomerTemplate" CssClass="dropdowns" runat="server" meta:resourcekey="ddlCustomerTemplateResource1"></asp:DropDownList>
                    </div><!-- /#updCustomerTemplate -->
                    
                </div>
            </div> <!-- /column -->
        </div>
    </div>
 

        <%--########################################## CUSTOMER ##########################################--%>
    <div id="tabCustomer" class="tTab">
        <div class="ui grid">
            <div class="eleven wide column">
                <div class="ui form">
                    <h3 id="lblCustomerPanel" class="ui top attached tiny header">Customer Details</h3>
                    <div class="ui attached segment">
                        <%--Customer info panel--%>
                        <label>
                            <asp:CheckBox ID="chkPrivOrSub" runat="server" Text="Company" CssClass="inHeaderCheckbox" data-submit="FLG_PRIVATE_COMP" meta:resourcekey="chkPrivOrSubResource1" />
                            <asp:CheckBox ID="chkProspect" runat="server" Text="Prospect" CssClass="inHeaderCheckbox2" data-submit="FLG_PROSPECT" meta:resourcekey="chkProspectResource1" />
                        </label>
                        <label>
                        </label>
                      
                        <div class="ui stackable grid" id="priv">
                            <div class="hidden">
                                <asp:TextBox ID="txtEniroId" runat="server" data-submit="ENIRO_ID" meta:resourcekey="txtEniroIdResource1"></asp:TextBox>
                            </div>
                            <div class="six wide column" data-type="po">
                                <asp:Label ID="lblFirstname" Text="First name" runat="server" meta:resourcekey="lblFirstnameResource1"></asp:Label>
                                <asp:TextBox ID="txtFirstname" runat="server" data-submit="CUST_FIRST_NAME" data-required="REQUIRED" meta:resourcekey="txtFirstnameResource1"></asp:TextBox>
                            </div>
                            <div class="four wide column" data-type="po">
                                <asp:Label ID="lblMiddlename" Text="Middle name" runat="server" meta:resourcekey="lblMiddlenameResource1"></asp:Label>
                                <asp:TextBox ID="txtMiddlename" runat="server" data-submit="CUST_MIDDLE_NAME" meta:resourcekey="txtMiddlenameResource1"></asp:TextBox>
                            </div>
                            <div class="six wide column">
                                <asp:Label ID="lblLastname" Text="Last name" runat="server" data-type="po" meta:resourcekey="lblLastnameResource1"></asp:Label>
                                <asp:Label ID="lblCompany" Text="Company" runat="server" data-type="co" meta:resourcekey="lblCompanyResource1"></asp:Label>
                                <asp:TextBox ID="txtLastname" runat="server" data-submit="CUST_LAST_NAME" data-required="REQUIRED" meta:resourcekey="txtLastnameResource1"></asp:TextBox>
                            </div>
                            <div id="ddlContactPersonContainer" class="six wide column" data-type="co">
                                <asp:Label ID="lblContactPerson" Text="Contact person" runat="server"></asp:Label>
                                <asp:DropDownList ID="ddlContactPerson" class="dropdowns" runat="server" data-submit="ID_CP"></asp:DropDownList>
                            </div>
                            <div class="four wide column" data-type="co">
                                <asp:Label ID="lblContactPersonTitle" Text="Contact title" runat="server"></asp:Label>
                                <asp:TextBox ID="txtContactPersonTitle" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="ui grid">
                                <div id="panelPermAdd" class="sixteen wide computer sixteen wide tablet sixteen wide mobile column">
                                    <div class="column">
                                        <asp:Label ID="lblPermAdd" Text="Visit address" runat="server" meta:resourcekey="lblPermAddResource1"></asp:Label>
                                        <asp:TextBox ID="txtPermAdd1" runat="server" data-submit="CUST_PERM_ADD1" data-required="REQUIRED" meta:resourcekey="txtPermAdd1Resource1"></asp:TextBox>
                                        <asp:TextBox ID="txtPermAdd2" runat="server" Visible="False" data-submit="CUST_PERM_ADD2" CssClass="mt3" meta:resourcekey="txtPermAdd2Resource1"></asp:TextBox>
                                    </div>
                                    <div class="column">
                                        <div class="ui two column stackable grid">
                                            <div class="column">
                                                <div class="ui grid">
                                                    <div class="five wide column">
                                                        <asp:Label ID="lblPermZip" Text="Zipcode" runat="server" meta:resourcekey="lblPermZipResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermZip" runat="server" data-submit="ID_CUST_PERM_ZIPCODE" meta:resourcekey="txtPermZipResource1"></asp:TextBox>
                                                    </div>
                                                    <div class="eleven wide column">
                                                        <asp:Label ID="lblPermCity" Text="City" runat="server" meta:resourcekey="lblPermCityResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermCity" runat="server" meta:resourcekey="txtPermCityResource1"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="column">
                                                <div class="ui two column grid">
                                                    <div class="column">
                                                        <asp:Label ID="lblPermCounty" Text="County(fyl)" runat="server" meta:resourcekey="lblPermCountyResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermCounty" runat="server" meta:resourcekey="txtPermCountyResource1"></asp:TextBox>
                                                    </div>
                                                    <div class="column">
                                                        <asp:Label ID="lblPermCountry" Text="Country" runat="server" meta:resourcekey="lblPermCountryResource1"></asp:Label>
                                                        <asp:TextBox ID="txtPermCountry" runat="server" meta:resourcekey="txtPermCountryResource1"></asp:TextBox>
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
                                            <asp:CheckBox ID="chkSameAdd" runat="server" Text="Same as visit address" CssClass="inLblCheckbox" data-submit="ISSAMEADDRESS" meta:resourcekey="chkSameAddResource1" />
                                        </label>
                                        <asp:TextBox ID="txtBillAdd1" runat="server" data-submit="CUST_BILL_ADD1" meta:resourcekey="txtBillAdd1Resource1"></asp:TextBox>
                                        <asp:TextBox ID="txtBillAdd2" runat="server" Visible="False" data-submit="CUST_BILL_ADD2" CssClass="mt3" meta:resourcekey="txtBillAdd2Resource1"></asp:TextBox>
                                    </div>
                                    <div class="column">
                                        <div class="ui two column stackable grid">
                                            <div class="column">
                                                <div class="ui grid">
                                                    <div class="five wide column">
                                                        <asp:Label ID="lblBillZip" Text="Zipcode" runat="server" meta:resourcekey="lblBillZipResource1"></asp:Label>
                                                        <asp:TextBox ID="txtBillZip" runat="server" data-submit="ID_CUST_BILL_ZIPCODE" meta:resourcekey="txtBillZipResource1"></asp:TextBox>
                                                    </div>
                                                    <div class="eleven wide column">
                                                        <asp:Label ID="lblBillCity" Text="City" runat="server" meta:resourcekey="lblBillCityResource1"></asp:Label>
                                                        <asp:TextBox ID="txtBillCity" runat="server" meta:resourcekey="txtBillCityResource1"></asp:TextBox>
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
                                                        <asp:TextBox ID="txtBillCountry" runat="server" meta:resourcekey="txtBillCountryResource1"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Annet</h3>
                    <div class="ui attached segment">
                        <div class="ui stackable grid">
                            <div class="four wide column">
                                <br />
                                <input type="button" id="btnCustNotes" runat="server" class="ui btn wide" value="Notes" meta:resourcekey="btnCompanyPersonResource1" />
                            </div>
                            <div class="eight wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="four wide field">
                                        </div>
                                        <div class="twelve wide field">
                                            <asp:Label ID="lblCompanyPersonFind" Text="Search below to add a company..." runat="server" CssClass="centerlabel" meta:resourcekey="lblCompanyPersonFindResource1"></asp:Label>
                                            <asp:TextBox ID="txtCompanyPersonFind" runat="server" CssClass="texttest" meta:resourcekey="txtCompanyPerson2Resource1"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="four wide field">
                                        
                                        </div>
                                        <div class="four wide field">
                                            <asp:Label ID="lblCompanyPersonNo" Text="Company&nbspassociation" runat="server" meta:resourcekey="lblCompanyPersonResource1"></asp:Label>
                                            <asp:TextBox ID="txtCompanyPerson" runat="server" CssClass="texttest" data-submit="CUST_COMPANY_NO" meta:resourcekey="txtCompanyPersonResource1"></asp:TextBox>
                                        </div>
                                        <div class="eight wide field">
                                            <asp:Label ID="lblCompanyNameHead" Text="Company name" runat="server" meta:resourcekey="lblCompanyNameHeadResource1"></asp:Label><br />
                                            <b><label id="lblCompanyPersonName" data-submit="CUST_COMPANY_DESCRIPTION">Ingen tilknytning.</label></b>
                                            
                                        </div>
                                    </div>

                                </div>
                            </div>
                            <div class="four wide column">
                                <asp:Label ID="lblEmployees" Text="Employees" runat="server" CssClass="centerlabel" meta:resourcekey="lblEmployeesResource1"></asp:Label>
                                <select id="ddlCompanyList" runat="server" size="10" class="wide dropdownList"></select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%-- End Left Column --%>

            <div class="five wide column">
                <%-- Start Right Column --%>
                <div class="ui form">
                    <h3 id="lblContactPanel" class="ui top attached tiny header">Contact information</h3>
                    <div id="customerContact" class="ui attached segment">
                        <label class="inHeaderCheckbox">
                            Contact
                            <button id="btnNewContact"  class="ui btn mini">
                                <i class="plus icon"></i>
                            </button>
                        </label>
                        <div id="customerContactPH">
                        </div>


                    </div>

                    <h3 class="ui top attached tiny header">Details</h3>
                    <div class="ui attached segment">
                        <label class="inHeaderCheckbox">
                            View/Hide
                            <button id="btnViewDetails"  class="ui btn mini">
                                <i class="caret down icon"></i>
                            </button>
                        </label>
                        <%-- Details Panel --%>
                        <div id="hideDetails" class="hidden">
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkEinvoice" runat="server" Text="EHF-Faktura" data-submit="FLG_EINVOICE" meta:resourcekey="chkEinvoiceResource1" />
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkInvEmail" runat="server" Text="Invoice by email" data-submit="FLG_INV_EMAIL" meta:resourcekey="chkInvEmailResource1" />
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkOrdconfEmail" runat="server" Text="Orderconfirmation by email" data-submit="FLG_ORDCONF_EMAIL" meta:resourcekey="chkOrdconfEmailResource1" />
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkNoSms" runat="server" Text="No SMS" data-submit="FLG_NO_SMS" meta:resourcekey="chkNoSmsResource1" />
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkNoEmail" runat="server" Text="No Email" data-submit="FLG_NO_EMAIL" meta:resourcekey="chkNoEmailResource1" />
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkNoMarketing" runat="server" Text="No direct marketing" data-submit="FLG_NO_MARKETING" meta:resourcekey="chkNoMarketingResource1" />
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkNoHumaneorg" runat="server" Text="No humane org." data-submit="FLG_NO_HUMANEORG" meta:resourcekey="chkNoHumaneorgResource1" />
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui checkbox">
                                <asp:CheckBox ID="chkNoPhonesale" runat="server" Text="No telemarketing" data-submit="FLG_NO_PHONESALE" meta:resourcekey="chkNoPhonesaleResource1" />
                            </div>
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
            <div class="five wide column">
                <%--START Left Column--%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Advanced Customer Settings</h3>
                    <div class="ui mini attached segment">
                        <div class="inline fields">
                            <%--Salesman/ Selger--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblSalesman" runat="server" Text="Salesman" meta:resourcekey="lblSalesmanResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="eight wide field">
                                <asp:TextBox ID="txtAdvSalesman" runat="server" meta:resourcekey="txtAdvSalesmanResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                                <input type="button" id="btnAdvSalesman" runat="server" class="ui btn mini" value="+" />
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Branch/ Bransje--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvBranch" runat="server" Text="Branch" meta:resourcekey="lblAdvBranchResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="eight wide field">
                                <asp:TextBox ID="txtAdvBranch" runat="server" meta:resourcekey="txtAdvBranchResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                                <input type="button" id="btnAdvBranch" runat="server" class="ui btn mini" value="+" />
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Category/ Kategori--%>

                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvCategory" runat="server" Text="Category" meta:resourcekey="lblAdvCategoryResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="eight wide field">
                                
                                <asp:DropDownList ID="ddlCustGroup" runat="server" class="dropdowns" data-submit="ID_CUST_GROUP" meta:resourcekey="ddlCustGroupResource1"></asp:DropDownList>
                                <div class="hidden">
                                    <asp:Label ID="lblPayType" Text="Payment type" runat="server" meta:resourcekey="lblPayTypeResource1" ></asp:Label>
                                    <asp:DropDownList ID="ddlPayType" runat="server" class="dropdowns" data-submit="ID_CUST_PAY_TYPE" meta:resourcekey="ddlPayTypeResource1"></asp:DropDownList>
                                    <asp:TextBox ID="txtAdvCategory" runat="server" meta:resourcekey="txtAdvCategoryResource1"></asp:TextBox>
                                </div>
                            </div>
                            <div class="one wide field">
                                <input type="button" id="btnAdvCategory" runat="server" class="ui btn mini" value="+" />
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Sales group/ Salgsgruppe--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvSalesgroup" runat="server" Text="Sales group" meta:resourcekey="lblAdvSalesgroupResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="eight wide field">
                                <asp:TextBox ID="txtAdvSalesgroup" runat="server" meta:resourcekey="txtAdvSalesgroupResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                                <input type="button" id="btnAdvSalesgroup" runat="server" class="ui btn mini" value="+" />
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Payment terms/ Bet. betingelser--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvPayterms" runat="server" Text="Payment terms" meta:resourcekey="lblAdvPaytermsResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="eight wide field">
                                <asp:DropDownList ID="ddlPayTerms" runat="server" class="dropdowns" data-submit="ID_CUST_PAY_TERM" meta:resourcekey="ddlPayTermsResource1"></asp:DropDownList>
                                <div class="hidden">
                                    <asp:TextBox ID="txtAdvPayterms" runat="server" meta:resourcekey="txtAdvPaytermsResource1"></asp:TextBox>
                                </div>
                            </div>
                            <div class="one wide field">
                                <input type="button" id="btnAdvPayterms" runat="server" class="ui btn mini" value="+" />
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Card type/ Kredittkorttype--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvCardtype" runat="server" Text="Card type" meta:resourcekey="lblAdvCardtypeResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="eight wide field">
                                <asp:TextBox ID="txtAdvCardtype" runat="server" meta:resourcekey="txtAdvCardtypeResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                                <input type="button" id="btnAdvCardtype" runat="server" class="ui btn mini" value="+" />
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Currency code/ Valutakode--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvCurrcode" runat="server" Text="Currency code" meta:resourcekey="lblAdvCurrcodeResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="eight wide field">
                                <asp:TextBox ID="txtAdvCurrcode" runat="server" meta:resourcekey="txtAdvCurrcodeResource1"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                                <input type="button" id="btnAdvCurrcode" runat="server" class="ui btn mini" value="+" />
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Debitor group/ Debtorgruppe--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvDebitorgroup" runat="server" Text="Debitor group" meta:resourcekey="lblAdvDebitorgroupResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="three wide field">
                                <asp:TextBox ID="txtAdvDebitorgroup" runat="server" meta:resourcekey="txtAdvDebitorgroupResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="inline fields">
                            <%--Invoice level/ Fakturanivå--%>
                            <div class="three wide field">
                                <label>
                                    <asp:Label ID="lblAdvInvoicelevel" runat="server" Text="Invoice level" meta:resourcekey="lblAdvInvoicelevelResource1"></asp:Label>
                                </label>
                            </div>
                            <div class="three wide field">
                                <asp:TextBox ID="txtAdvInvoicelevel" runat="server" meta:resourcekey="txtAdvInvoicelevelResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Miscellaneous</h3>
                    <div class="ui attached segment">
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvCustIgnoreInv" runat="server" Text="No Invoice Fee" data-submit="FLG_CUST_IGNOREINV" meta:resourcekey="chkAdvCustIgnoreInvResource1" />
                        </div>
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvBankgiro" runat="server" Text="Bankgiro" meta:resourcekey="chkAdvBankgiroResource1" />
                        </div>
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvCustFactoring" runat="server" Text="Factoring" data-submit="FLG_CUST_FACTORING" meta:resourcekey="chkAdvCustFactoringResource1" />
                        </div>
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvCustBatchInv" runat="server" Text="Batch Invoicing" data-submit="FLG_CUST_BATCHINV" meta:resourcekey="chkAdvCustBatchInvResource1" />
                        </div>
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvHourlyMarkup" runat="server" Text="Hourly Markup" data-submit="FLG_HOURLY_MARKUP" meta:resourcekey="chkAdvHourlyMarkupResource1" />
                        </div>
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvNoGm" runat="server" Text="No Garage Material" data-submit="FLG_NO_GM" meta:resourcekey="chkAdvNoGmResource1" />
                        </div>
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvCustInactive" runat="server" Text="Inactive" data-submit="FLG_CUST_INACTIVE" meta:resourcekey="chkAdvCustInactiveResource1" />
                        </div>
                        <div class="ui checkbox">
                            <asp:CheckBox ID="chkAdvNoEnv" runat="server" Text="No Env. Fee" data-submit="FLG_NO_ENV_FEE" meta:resourcekey="chkAdvNoEnvResource1" />
                        </div>
                    </div>
                </div>
            </div>
            <%--END Left Column --%>

            <div class="four wide column">
                <%-- START Middle Column --%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Discount</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="five wide field">
                                <asp:Label ID="lblAdvGeneralDiscount" runat="server" Text="General %" meta:resourcekey="lblAdvGeneralDiscountResource1"></asp:Label>
                                <asp:TextBox ID="txtAdvGeneralDiscount" runat="server" data-submit="CUST_DISC_GENERAL" meta:resourcekey="txtAdvGeneralDiscountResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <asp:Label ID="lblAdvSparesDiscount" runat="server" Text="Parts %" meta:resourcekey="lblAdvSparesDiscountResource1"></asp:Label>
                                <asp:TextBox ID="txtAdvSparesDiscount" runat="server" data-submit="CUST_DISC_SPARES" meta:resourcekey="txtAdvSparesDiscountResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <asp:Label ID="lblAdvLabourDiscount" runat="server" Text="Labour %" meta:resourcekey="lblAdvLabourDiscountResource1"></asp:Label>
                                <asp:TextBox ID="txtAdvLabourDiscount" runat="server" data-submit="CUST_DISC_LABOUR" meta:resourcekey="txtAdvLabourDiscountResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Misc</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvHourlyrate" runat="server" Text="Hourly rate no." meta:resourcekey="lblAdvHourlyrateResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvHourlyrate" runat="server" meta:resourcekey="txtAdvHourlyrateResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvPriceType" runat="server" Text="Price type" meta:resourcekey="lblAdvPriceTypeResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <select id="cmbAdvPriceType" class="dropdowns">
                                    <option value="0">Cost price</option>
                                    <option value="1">Net price</option>
                                    <%--<option value="2" ="Standard"></option>--%>
                                    <option value="3">Retail price</option>
                                </select>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvEmployees" Text="No of employees" runat="server" meta:resourcekey="lblAdvEmployeesResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvEmployees" runat="server" meta:resourcekey="txtAdvEmployeesResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvSsnNo" Text="Org.no." runat="server" meta:resourcekey="lblAdvSsnNoResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvSsnNo" runat="server" data-submit="CUST_SSN_NO" meta:resourcekey="txtAdvSsnNoResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Economy</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvCreditLimit" Text="Credit limit" runat="server" meta:resourcekey="lblAdvCreditLimitResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvCredlimit" runat="server" meta:resourcekey="txtAdvCredlimitResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvSumOrder" Text="Sum on orders" runat="server" meta:resourcekey="lblAdvSumOrderResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvSumOrder" runat="server" meta:resourcekey="txtAdvSumOrderResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvSumInvoice" Text="Sum invoiced" runat="server" meta:resourcekey="lblAdvSumInvoiceResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvSumInvoice" runat="server" meta:resourcekey="txtAdvSumInvoiceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvBalance" Text="Balance" runat="server" meta:resourcekey="lblAdvBalanceResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvBalance" runat="server" meta:resourcekey="txtAdvBalanceResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="seven wide field">
                                <asp:Label ID="lblAdvRemainingCredit" Text="Remaining credit" runat="server" meta:resourcekey="lblAdvRemainingCreditResource1"></asp:Label>
                            </div>
                            <div class="nine wide field">
                                <asp:TextBox ID="txtAdvRemainingCredit" runat="server" meta:resourcekey="txtAdvRemainingCreditResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%-- END Middle Column --%>

            <div class="six wide column">
                <%-- START Right Column --%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">???</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="lblAdvNewCustomer" Text="New customer" runat="server" meta:resourcekey="lblAdvNewCustomerResource1"></asp:Label>
                            </div>
                            <div class="field">
                                <asp:TextBox ID="txtAdvNewCustomer" runat="server" meta:resourcekey="txtAdvNewCustomerResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="lblAdvVendor" Text="Dealer" runat="server" meta:resourcekey="lblAdvVendorResource1"></asp:Label>
                            </div>
                            <div class="field">
                                <asp:TextBox ID="txtAdvVendor" runat="server" meta:resourcekey="txtAdvVendorResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="lblAdvFree" Text="Free" runat="server" meta:resourcekey="lblAdvFreeResource1"></asp:Label>
                            </div>
                            <div class="field">
                                <asp:TextBox ID="txtAdvFree" runat="server" meta:resourcekey="txtAdvFreeResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="lblAdvTruck" Text="Truck/Bus" runat="server" meta:resourcekey="lblAdvTruckResource1"></asp:Label>
                            </div>
                            <div class="field">
                                <asp:TextBox ID="txtAdvTruck" runat="server" meta:resourcekey="txtAdvTruckResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="lblAdvBonusmember" Text="Bonus member" runat="server" meta:resourcekey="lblAdvBonusmemberResource1"></asp:Label>
                            </div>
                            <div class="field">
                                <asp:TextBox ID="txtAdvBonusmember" runat="server" meta:resourcekey="txtAdvBonusmemberResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="wide field">
                                <asp:Label ID="lblAdvSumBonus" Text="Sum bonus" runat="server" meta:resourcekey="lblAdvSumBonusResource1"></asp:Label>
                            </div>
                            <div class="field">
                                <asp:TextBox ID="txtAdvSumBonus" runat="server" meta:resourcekey="txtAdvSumBonusResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">NBF membership</h3>
                    <div class="ui attached segment">
                        <label>
                            <asp:CheckBox ID="chkNBFmember" CssClass="inHeaderCheckbox" runat="server" Text="NBF member" meta:resourcekey="chkNBFmemberResource1" />
                        </label>
                        <div class="inline fields">
                            <div class="six wide field">
                                <asp:Label ID="lblCustomer" Text="Customer Id" runat="server" meta:resourcekey="lblCustomerResource1"></asp:Label>
                                <asp:TextBox ID="txtCustomer" runat="server" meta:resourcekey="txtCustomerResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <input type="button" id="btnNBFCustomer" class="ui btn mini" value="Hent" />
                            </div>
                            <div class="six wide field">
                                <asp:Label ID="lblNBFmember" Text="Member no." runat="server" meta:resourcekey="lblNBFmemberResource1"></asp:Label>
                                <asp:TextBox ID="txtNBFmember" runat="server" meta:resourcekey="txtNBFmemberResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">BilXtra coordinating</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <asp:Label ID="lblAdvVendorNo" Text="Wholesaler no." runat="server" meta:resourcekey="lblAdvVendorNoResource1"></asp:Label>
                                <asp:TextBox ID="txtAdvVendorNo" runat="server" meta:resourcekey="txtAdvVendorNoResource1"></asp:TextBox>
                            </div>

                            <div class="four wide field">
                                <asp:Label ID="lblAdvWorkshopNo" Text="Workshop no." runat="server" meta:resourcekey="lblAdvWorkshopNoResource1"></asp:Label>
                                <asp:TextBox ID="txtAdvWorkshopNo" runat="server" meta:resourcekey="txtAdvWorkshopNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <asp:Label ID="lblAdvExtCustNo" Text="External cust.no." runat="server" meta:resourcekey="lblAdvExtCustNoResource1"></asp:Label>
                                <asp:TextBox ID="txtAdvExtCustNo" runat="server" meta:resourcekey="txtAdvExtCustNoResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <h3 class="ui top attached tiny header">Warranty</h3>
                    <div class="ui attached segment">
                        <label>
                            <asp:CheckBox ID="chkWarrantyClaim" CssClass="inHeaderCheckbox" runat="server" Text="Garantibehandling" meta:resourcekey="chkWarrantyClaimResource1" />
                        </label>
                        <div class="inline fields">
                            <div class="field">
                                <asp:Label ID="lblAdvWarranty" Text="Leverandørnr." runat="server" meta:resourcekey="lblAdvWarrantyResource1"></asp:Label>
                                <asp:TextBox ID="txtAdvWarranty" runat="server" meta:resourcekey="txtAdvWarrantyResource1"></asp:TextBox>
                                <input type="button" id="btnAdvWarranty" class="ui btn mini" value="Hent" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--                    ############################### ACTIVITIES ##########################################--%>
    <div id="tabActivities" class="tTab">
        <div class="ui grid">
            <div class="two wide column">
                <%--START Left Column--%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Varmhetsgrad</h3>
                    <div class="ui mini attached segment">
                        <div class="fields">
                            <div class="sixteen wide field">
                                <label>
                                    <asp:RadioButton ID="rbTemp1" runat="server" Text="Grad 1" GroupName="ActTemp" meta:resourcekey="rbTemp1Resource1" />
                                </label>
                                <label>
                                    <asp:RadioButton ID="rbTemp2" runat="server" Text="Grad 2" GroupName="ActTemp" meta:resourcekey="rbTemp2Resource1" />
                                </label>
                                <label>
                                    <asp:RadioButton ID="rbTemp3" runat="server" Text="Grad 3" GroupName="ActTemp" meta:resourcekey="rbTemp3Resource1" />
                                </label>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
            <%--END Left Column --%>

            <div class="five wide column">
                <%-- START 1st Middle Column --%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Datoer</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <asp:Label ID="lblBirthDate" runat="server" Text="Birth date" CssClass="centerlabel" meta:resourcekey="lblBirthDateResource1"></asp:Label>
                                <asp:TextBox ID="txtBirthDate" runat="server" CssClass="texttest" data-submit="CUST_BORN" meta:resourcekey="txtBirthDateResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <asp:Label ID="lblWashDate" runat="server" Text="Wash date" CssClass="centerlabel" meta:resourcekey="lblWashDateResource1"></asp:Label>
                                <asp:TextBox ID="txtWashDate" runat="server" CssClass="texttest" meta:resourcekey="txtWashDateResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <asp:Label ID="lblDeathDate" runat="server" Text="Death date" CssClass="centerlabel" meta:resourcekey="lblDeathDateResource1"></asp:Label>
                                <asp:TextBox ID="txtDeathDate" runat="server" CssClass="texttest" meta:resourcekey="txtDeathDateResource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%-- END 1st Middle Column --%>

            <div class="five wide column">
                <%-- START 2nd Middle Column --%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Kontakt</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="five wide field">
                                <asp:Label ID="lblLastContact" runat="server" Text="Last contact" CssClass="centerlabel" meta:resourcekey="lblLastContactResource1"></asp:Label>
                                <asp:TextBox ID="txtLastContact" runat="server" CssClass="texttest" meta:resourcekey="txtLastContactResource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <asp:Label ID="lblContactType1" runat="server" Text="Contact type" CssClass="centerlabel" meta:resourcekey="lblContactType1Resource1"></asp:Label>
                                <asp:TextBox ID="txtContactType1" runat="server" CssClass="texttest" meta:resourcekey="txtContactType1Resource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <asp:Label ID="lblContactSign1" runat="server" Text="Contact sign." CssClass="centerlabel" meta:resourcekey="lblContactSign1Resource1"></asp:Label>
                                <asp:TextBox ID="txtContactSign1" runat="server" CssClass="texttest" meta:resourcekey="txtContactSign1Resource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="five wide field">
                                <asp:Label ID="lblNextContact1" runat="server" Text="Next contact" CssClass="centerlabel" meta:resourcekey="lblNextContact1Resource1"></asp:Label>
                                <asp:TextBox ID="txtNextContact1" runat="server" CssClass="texttest" meta:resourcekey="txtNextContact1Resource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <asp:Label ID="lblContactType2" runat="server" Text="Contact type" CssClass="centerlabel" meta:resourcekey="lblContactType2Resource1"></asp:Label>
                                <asp:TextBox ID="txtContactType2" runat="server" CssClass="texttest" meta:resourcekey="txtContactType2Resource1"></asp:TextBox>
                            </div>
                            <div class="five wide field">
                                <asp:Label ID="lblContactSign2" runat="server" Text="Contact sign." CssClass="centerlabel" meta:resourcekey="lblContactSign2Resource1"></asp:Label>
                                <asp:TextBox ID="txtContactSign2" runat="server" CssClass="texttest" meta:resourcekey="txtContactSign2Resource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%-- END 2nd Middle Column --%>

            
        </div>

        <div class="ui grid">
            <div class="ten wide column">
                <%--START Left Column--%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">Aktiviteter</h3>
                    <div class="ui mini attached segment">
                        <div class="fields">
                            <div class="six wide field">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <asp:TextBox ID="TextBox1" TextMode="MultiLine" Height="100px" runat="server" meta:resourcekey="TextBox9Resource1"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="two wide field">
                                <input type="button" id="btnQuotation" class="btnconst" value="Quotation" />
                            </div>
                            <div class="two wide field">
                                <input type="button" id="btnWord" class="btnconst" value="Word" />
                            </div>
                            <div class="two wide field">
                                <input type="button" id="btnExcel" class="btnconst" value="Excel" />
                            </div>
                            <div class="two wide field">
                                <input type="button" id="btnMail" class="btnconst" value="Mail" />
                            </div>
                            <div class="two wide field">
                                <input type="button" id="btnPhone" class="btnconst" value="Phone" />
                            </div>
                            <div class="two wide field">
                                <input type="button" id="btnAttachment" class="btnconst" value="Attachment" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%--END Left Column --%>
            <div class="six wide column">
                <%-- START Right Column --%>
                <div class="ui form">
                    <h3 class="ui top attached tiny header">???</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <div class="four wide field">
                                <asp:Label ID="Label22" Text="Wholesaler no." runat="server" meta:resourcekey="Label22Resource1"></asp:Label>
                                <asp:TextBox ID="TextBox7" runat="server" meta:resourcekey="TextBox7Resource1"></asp:TextBox>
                            </div>

                            <div class="four wide field">
                                <asp:Label ID="Label23" Text="Workshop no." runat="server" meta:resourcekey="Label23Resource1"></asp:Label>
                                <asp:TextBox ID="TextBox8" runat="server" meta:resourcekey="TextBox8Resource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <asp:Label ID="Label24" Text="External cust.no." runat="server" meta:resourcekey="Label24Resource1"></asp:Label>
                                <asp:TextBox ID="TextBox10" runat="server" meta:resourcekey="TextBox10Resource1"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>

    <%--                    ############################### VEHICLE ##########################################--%>
    <div id="tabVehicle" class="tTab">
        <div class="ui grid">
            <div class="four wide column">
                <div class="ui form">
                    <h3 id="lblVehiclePanel" class="ui top attached tiny header">Current vehicle list</h3>
                    <div class="ui attached segment">

                        <div class="fields">

                            <div class="four wide column">
                                <asp:Label ID="lblVehicleList" Text="Liste over kjøretøy" runat="server" meta:resourcekey="lblVehicleListResource1"></asp:Label>
                                <select id="ddlVehicleList" runat="server" size="10" class="wide dropdownList"></select>
                            </div>

                        </div>
                        <div class="fields">

                            <div class="four wide column">
                                <select id="ddlSortVehicleList" runat="server" class="wide dropdownList"></select>
                            </div>

                        </div>

                    </div>
                </div>
            </div>

            <div class="eight wide column">
                <div class="ui form">
                    <h3 id="lblVehicleDetail" class="ui top attached tiny header">Current vehicle details</h3>
                    <div class="ui attached segment">

                        <div class="fields">


                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehRefNo" Text="RefNr" runat="server" meta:resourcekey="lblVehRefNoResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehRefNo" runat="server" meta:resourcekey="txtVehRefNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehRegNo" Text="RegNo" runat="server" meta:resourcekey="lblVehRegNoResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehRegNo" runat="server" meta:resourcekey="txtVehRegNoResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehVin" Text="Chassinr" runat="server" meta:resourcekey="lblVehVinResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehVin" runat="server" meta:resourcekey="txtVehVinResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehMileage" Text="Km.stand" runat="server" meta:resourcekey="lblVehMileageResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehMileage" runat="server" meta:resourcekey="txtVehMileageResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">

                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehMake" Text="Fabrikat" runat="server" meta:resourcekey="lblVehMakeResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehMake" runat="server" meta:resourcekey="txtVehMakeResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehModel" Text="Modell" runat="server" meta:resourcekey="lblVehModelResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehModel" runat="server" meta:resourcekey="txtVehModelResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehRegYear" Text="Årsmodell" runat="server" meta:resourcekey="lblVehRegYearResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehRegYear" runat="server" meta:resourcekey="txtVehRegYearResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblVehRegDate" Text="Reg.dato" runat="server" meta:resourcekey="lblVehRegDateResource1"></asp:Label></label>
                                <asp:TextBox ID="txtVehRegDate" runat="server" meta:resourcekey="txtVehRegDateResource1"></asp:TextBox>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
            <div class="four wide column">
                <div class="ui form">
                    <h3 id="lblVehicleNotes" class="ui top attached tiny header">Current vehicle Notes</h3>
                    <div class="ui attached segment">

                        <div class="fields">
                            <div class="three wide column">
                                <asp:Label ID="lblNewBought" runat="server" Text="New vehicles bought" meta:resourcekey="lblNewBoughtResource1"></asp:Label>
                            </div>
                            <div class="two wide column">
                                <asp:TextBox ID="txtNewBought" runat="server" CssClass="texttest" meta:resourcekey="txtNewBoughtResource1"></asp:TextBox>
                            </div>
                            <div class="two wide column">
                                <input type="button" id="btnGetNewBought" value="Get" />
                            </div>
                        </div>
                        <div class="fields">
                            <div class="three wide column">
                                <asp:Label ID="lblUsedBought" runat="server" Text="Used vehicles bought" meta:resourcekey="lblUsedBoughtResource1"></asp:Label>
                            </div>
                            <div class="two wide column">
                                <asp:TextBox ID="txtUsedBought" runat="server" CssClass="texttest" meta:resourcekey="txtUsedBoughtResource1"></asp:TextBox>
                            </div>
                            <div class="two wide column">
                                <input type="button" id="btnGetUsedBought" value="Get" />
                            </div>
                        </div>
                        <div class="fields">
                            <asp:TextBox ID="txtNotes2" runat="server" CssClass="texttest" meta:resourcekey="txtNotes2Resource1"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>


    <%--                    ############################### WANTED ##########################################--%>
    <div id="tabWanted" class="tTab">
        <div class="ui grid">
            <div class="eight wide column">
                <div class="ui form">
                    <h3 id="lblWantedVehicle" class="ui top attached tiny header">Wanted car by customer</h3>
                    <div class="ui attached segment">

                        <div class="fields">
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblWantedMake" Text="Make" runat="server" CssClass="centerlabel" meta:resourcekey="lblMakeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtWantedMake" runat="server" CssClass="texttest" meta:resourcekey="txtWantedMakeResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblWantedModel" Text="Model" runat="server" CssClass="centerlabel" meta:resourcekey="lblWantedModelResource1"></asp:Label></label>
                            <asp:TextBox ID="txtWantedModel" runat="server" CssClass="texttest" meta:resourcekey="txtWantedModelResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                   <asp:Label ID="lblWantedYearFrom" Text="Year model from" runat="server" CssClass="centerlabel" Width="200%" meta:resourcekey="lblWantedYearFromResource1"></asp:Label></label>
                                   <asp:TextBox ID="txtWantedYearFrom" runat="server" CssClass="texttest" meta:resourcekey="txtWantedYearFromResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                     <asp:Label ID="lblWantedYearTo" Text="Year model to" runat="server" CssClass="centerlabel" Width="200%" meta:resourcekey="lblWantedYearToResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtWantedYearTo" runat="server" CssClass="texttest" meta:resourcekey="txtWantedYearToResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblWantedPriceFrom" Text="Priceclass from" runat="server" CssClass="centerlabel" Width="200%" meta:resourcekey="lblWantedPriceFromResource1"></asp:Label></label>
                            <asp:TextBox ID="txtWantedPriceFrom" runat="server" CssClass="texttest" meta:resourcekey="txtWantedPriceFromResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                   <asp:Label ID="lblWantedPriceTo" Text="Priceclass to" runat="server" CssClass="centerlabel" Width="200%" meta:resourcekey="lblWantedPriceToResource1" ></asp:Label></label>
                           <asp:TextBox ID="txtWantedPriceTo" runat="server" CssClass="texttest" meta:resourcekey="txtWantedPriceToResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblWantedMileageFrom" Text="Mileage from" runat="server" CssClass="centerlabel" Width="200%" meta:resourcekey="lblWantedMileageFromResource1" ></asp:Label></label>
                            <asp:TextBox ID="txtWantedMileageFrom" runat="server" CssClass="texttest" meta:resourcekey="txtWantedMileageFromResource1"></asp:TextBox>
                            </div>
                            <div class="four wide field">
                                <label>
                                     <asp:Label ID="lblWantedMileageTo" Text="Mileage to" runat="server" CssClass="centerlabel" Width="200%" meta:resourcekey="lblWantedMileageToResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtWantedMileageTo" runat="server" CssClass="texttest" meta:resourcekey="txtWantedMileageToResource1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="fields">
                            <div class="four wide field">
                                <label>
                                     <asp:Label ID="lblColor" Text="Color" runat="server" CssClass="centerlabel" meta:resourcekey="lblColorResource1"></asp:Label></label>
                            <asp:TextBox ID="txtColor" runat="server" CssClass="texttest" meta:resourcekey="txtColorResource1"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                <label>
                               <asp:CheckBox ID="cbGasoline" runat="server" Text="Gasoline" meta:resourcekey="cbGasolineResource1" />
                            </label>
                            </div>
                            <div class="two wide field">
                                <label>
                                <asp:CheckBox ID="cbDiesel" runat="server" Text="Diesel" meta:resourcekey="cbDieselResource1" />
                            </label>
                            </div>
                            <div class="two wide field">
                                <label>
                                <asp:CheckBox ID="cbElectric" runat="server" Text="El." meta:resourcekey="cbElectricResource1" />
                            </label>
                            </div>
                            <div class="two wide field">
                                <label>
                                <asp:CheckBox ID="cbGas" runat="server" Text="Gas" meta:resourcekey="cbGasResource1" />
                            </label>
                            </div>
                            <div class="four wide field">
                                <label>
                                    <asp:Label ID="lblOtherFuel" Text="Other fuel" runat="server" CssClass="centerlabel" meta:resourcekey="lblOtherFuelResource1"></asp:Label></label>
                            <asp:TextBox ID="txtOtherFuel" runat="server" CssClass="texttest" meta:resourcekey="txtOtherFuelResource1"></asp:TextBox>
                            </div>      
                        </div>
                    </div>
                </div>
            </div>
            <div class="four wide column">
                <div class="ui form">
                    <h3 id="lblVehic" class="ui top attached tiny header">Annotation</h3>
                    <div class="ui attached segment">
                        <div class="fields">
                            <asp:TextBox ID="txtWantedAnnot" runat="server" TextMode="MultiLine" Height="175px" meta:resourcekey="txtOtherFuelResource1"></asp:TextBox>
                        </div>
                        
                    </div>
                </div>
            </div>
            <div class="four wide column">
                
            </div>

        </div>
        <div class="ui grid">
            <div class="sixteen wide column">
                <div class="ui form">
                    <h3 id="lblWantedVehicleEq" class="ui top attached tiny header">Wanted car equipment</h3>
                    <div class="ui attached segment">
                <div class="fields">
                        <div class="two wide column">
                            <label>
                                <asp:CheckBox ID="cbSummerwheels" runat="server" Width="200%" Text="Summer wheels" meta:resourcekey="cbSummerwheelsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbWinterwheels" runat="server" Width="200%" Text="Winter wheels" meta:resourcekey="cbWinterwheelsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbXenon" runat="server" Width="200%" Text="Xenon lights" meta:resourcekey="cbXenonResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbCentrallock" runat="server" Width="200%" Text="Central lock" meta:resourcekey="cbCentrallockResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbElWindows" runat="server" Width="200%" Text="El.windows" meta:resourcekey="cbElWindowsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbElMirrors" runat="server" Width="200%" Text="El.mirrors" meta:resourcekey="cbElMirrorsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbColoredglass" runat="server" Width="200%" Text="Colored glass" meta:resourcekey="cbColoredglassResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbHeatedseats" runat="server" Width="200%" Text="Heated seats" meta:resourcekey="cbHeatedseatsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAlloyrimswinter" runat="server" Width="200%" Text="Alloy rims winter" meta:resourcekey="cbAlloyrimswinterResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAlloywheelssummer" runat="server" Width="200%" Text="Alloy rims summer" meta:resourcekey="cbAlloywheelssummerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAllyeartires" runat="server" Width="200%" Text="All year tires" meta:resourcekey="cbAllyeartiresResource1" />
                            </label>
                        </div>

                    <div class="two wide column">
                            <label>
                                <asp:CheckBox ID="cbServo" runat="server" Width="200%" Text="Servo steering" meta:resourcekey="cbServoResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAirbagfront" runat="server" Width="200%" Text="Airbag front" meta:resourcekey="cbAirbagfrontResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAirbagside" runat="server" Width="200%" Text="Airbag sides" meta:resourcekey="cbAirbagsideResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbSkylight" runat="server" Width="200%" Text="Skylight" meta:resourcekey="cbSkylightResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbClimate" runat="server" Width="200%" Text="Climate control" meta:resourcekey="cbClimateResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAircondition" runat="server" Width="200%" Text="Aircondition" meta:resourcekey="cbAirconditionResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbMetallic" runat="server" Width="200%" Text="Metallic" meta:resourcekey="cbMetallicResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbRadioCD" runat="server" Width="200%" Text="Radio/CD" meta:resourcekey="cbRadioCDResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbCDchanger" runat="server" Width="200%" Text="CD-changer" meta:resourcekey="cbCDchangerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbDVD" runat="server" Width="200%" Text="DVD" meta:resourcekey="cbDVDResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbTowinghitch" runat="server" Width="200%" Text="Towing hitch" meta:resourcekey="cbTowinghitchResource1" />
                            </label>
                        </div>
                    <div class="two wide column">
                            <label>
                                <asp:CheckBox ID="CheckBox1" runat="server" Width="200%" Text="ABS brakes" meta:resourcekey="cbABSbrakesResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox2" runat="server" Width="200%" Text="Traction control" meta:resourcekey="cbTractionResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox3" runat="server" Width="200%" Text="Anti-skid" meta:resourcekey="cbAntiskidResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox4" runat="server" Width="200%" Text="Engine immobilizer" meta:resourcekey="cbImmobilizerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox5" runat="server" Width="200%" Text="Differential lock" meta:resourcekey="cbDifflockResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox6" runat="server" Width="200%" Text="Steel beams" meta:resourcekey="cbSteelbeamsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox7" runat="server" Width="200%" Text="Cruise control" meta:resourcekey="cbCruisecontrolResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox8" runat="server" Width="200%" Text="Alarm" meta:resourcekey="cbAlarmResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox9" runat="server" Width="200%" Text="Engine heater" meta:resourcekey="cbEngineheaterResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox10" runat="server" Width="200%" Text="Leather interior" meta:resourcekey="CheckBox33Resource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox11" runat="server" Width="200%" Text="Partial leather" meta:resourcekey="CheckBox34Resource1" />
                            </label>
                    </div>
                    <div class="two wide column">
                            <label>
                                <asp:CheckBox ID="cbABSbrakes" runat="server" Width="200%" Text="ABS brakes" meta:resourcekey="cbABSbrakesResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbTraction" runat="server" Width="200%" Text="Traction control" meta:resourcekey="cbTractionResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAntiskid" runat="server" Width="200%" Text="Anti-skid" meta:resourcekey="cbAntiskidResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbImmobilizer" runat="server" Width="200%" Text="Engine immobilizer" meta:resourcekey="cbImmobilizerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbDifflock" runat="server" Width="200%" Text="Differential lock" meta:resourcekey="cbDifflockResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbSteelbeams" runat="server" Width="200%" Text="Steel beams" meta:resourcekey="cbSteelbeamsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbCruisecontrol" runat="server" Width="200%" Text="Cruise control" meta:resourcekey="cbCruisecontrolResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAlarm" runat="server" Width="200%" Text="Alarm" meta:resourcekey="cbAlarmResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbEngineheater" runat="server" Width="200%" Text="Engine heater" meta:resourcekey="cbEngineheaterResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox33" runat="server" Width="200%" Text="Leather interior" meta:resourcekey="CheckBox33Resource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="CheckBox34" runat="server" Width="200%" Text="Partial leather" meta:resourcekey="CheckBox34Resource1" />
                            </label>
                    </div>
                    <div class="two wide column">
                            <label>
                                <asp:CheckBox ID="cbTV" runat="server" Width="200%" Text="TV" meta:resourcekey="cbTVResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbSportingseats" runat="server" Width="200%" Text="Sporting seats" meta:resourcekey="cbSportingseatsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbCargorails" runat="server" Width="200%" Text="Cargo rails" meta:resourcekey="cbCargorailsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAirsuspension" runat="server" Width="200%" Text="Air suspension" meta:resourcekey="cbAirsuspensionResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbLevelling" runat="server" Width="200%" Text="Levelling" meta:resourcekey="cbLevellingResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbComputer" runat="server" Width="200%" Text="Computer" meta:resourcekey="cbComputerResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbRainsensor" runat="server" Width="200%" Text="Rain sensor" meta:resourcekey="cbRainsensorResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbLuggagecompcover" runat="server" Width="200%" Text="Luggage comp. cover" meta:resourcekey="cbLuggagecompcoverResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbKeyless" runat="server" Width="200%" Text="Keyless go" meta:resourcekey="cbKeylessResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbRemtowinghitch" runat="server" Width="200%" Text="Removable towing hitch" meta:resourcekey="cbRemtowinghitchResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbDieselfilter" runat="server" Width="200%" Text="Diesel particle filter" meta:resourcekey="cbDieselfilterResource1" />
                            </label>
                    </div>
                    <div class="two wide column">
                            <label>
                                <asp:CheckBox ID="cbRoofSkirails" runat="server" Width="200%" Text="Roof-/ski rails" meta:resourcekey="cbRoofSkirailsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbNavigation" runat="server" Width="200%" Text="Navigation system" meta:resourcekey="cbNavigationResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbParksensorfront" runat="server" Width="200%" Text="Parking sensor front" meta:resourcekey="cbParksensorfrontResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbParksensorrear" runat="server" Width="200%" Text="Parking sensor rear" meta:resourcekey="cbParksensorrearResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbMultifuncsteering" runat="server" Width="200%" Text="Multifunc. steering wheel" meta:resourcekey="cbMultifuncsteeringResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbElseatmemory" runat="server" Width="200%" Text="El. seat w/memory" meta:resourcekey="cbElseatmemoryResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbElseat" runat="server" Width="200%" Text="El. seat" meta:resourcekey="cbElseatResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbHandsfree" runat="server" Width="200%" Text="Handsfree" meta:resourcekey="cbHandsfreeResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbArmrests" runat="server" Width="200%" Text="Armrests" meta:resourcekey="cbArmrestsResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbOriginalphone" runat="server" Width="200%" Text="Original telephone" meta:resourcekey="cbOriginalphoneResource1" />
                            </label>
                            <label>
                                <asp:CheckBox ID="cbAnnualfeepaid" runat="server" Width="200%" Text="Annual fee paid" meta:resourcekey="cbAnnualfeepaidResource1" />
                            </label>
                    </div>
                    <div class="two wide column">
                            <label>
                                <asp:CheckBox ID="cbFullservicehistory" runat="server" Width="200%" Text="Full service history" meta:resourcekey="cbFullservicehistoryResource1" />
                            </label>
                            <%--<label>
                                        <asp:CheckBox ID="CheckBox58" runat="server" Width="200%" Text="Bankgiro" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox59" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox60" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox61" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox62" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox63" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox64" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox65" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox66" runat="server" Width="200%" Text="factoring" />
                                    </label>
                                    <label>
                                        <asp:CheckBox ID="CheckBox67" runat="server" Width="200%" Text="factoring" />
                                    </label>--%>
    
                    </div>
                </div>
            </div>
        </div> 
        </div>
    </div>
</div>



    <%--                    ############################### BOTTOM ##########################################--%>
    <div id="tabBottom">
        <div class="tbActions">
            <div id="btnCustEmptyScreen" class="ui button negative">Tøm</div>
            <div id="btnCustLog" class="ui button">Log</div>
            <div id="btnCustNewCust" class="ui button blue">Ny kunde</div>
            <div id="btnCustSave" class="ui button positive">Lagre</div>
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
                        <p id="P1" runat="server">Legg inn notater på kunden.</p>
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
 