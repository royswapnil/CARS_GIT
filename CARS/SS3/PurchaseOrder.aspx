<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.Master" CodeBehind="PurchaseOrder.aspx.vb" Inherits="CARS.PurchaseOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="server">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/tabulator/3.3.1/css/tabulator.min.css" rel="stylesheet" />
    <link href="https://use.fontawesome.com/releases/v5.0.2/css/all.css" rel="stylesheet" />


    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/tabulator/3.3.1/js/tabulator.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.1/moment.js"></script>

    
    
    <style type="text/css">
        .mytabulatorclass {
            background-color: #4a4a4a;           
            border-radius: 10px;
            font-size: 16px;
        }

             .mytabulatorclass .tabulator-selected{
                 background-color: #0053d7 !important;
             }

             

             

            /*Theme the header*/
            .mytabulatorclass .tabulator-header .tabulator-col {
                background: #cce2ff !important;
                background-color: #cce2ff !important;
                color: black;
                border-bottom: 1px solid grey;
                text-align: center;
            }

                /*Allow column header names to wrap lines*/
                .mytabulatorclass .tabulator-header .tabulator-col,
                .mytabulatorclass .tabulator-header .tabulator-col-row-handle {
                    white-space: normal;
                }

            /*Color the table rows*/
            .mytabulatorclass .tabulator-tableHolder .tabulator-table .tabulator-row {
                color: black;
                background: #fff;
            }

                /*Color even rows*/
                .mytabulatorclass .tabulator-tableHolder .tabulator-table .tabulator-row:nth-child(even) {
                    background-color: #efefef;
                }

                /*color arrows green*/
        .tabulator .tabulator-row.tabulator-group.tabulator-group-visible .tabulator-arrow {
            
            border-top: 6px solid #666;
            
        }

        .tabulator .tabulator-row.tabulator-group .tabulator-arrow {
            
            border-left: 6px solid #37901b;
            
        }

        #btnSavePurchaseOrderSuggestion{
            margin-top: 3%;
        }

      /*  .NEWpodatepicker .ui-datepicker-trigger {
             position:absolute;
             margin-left: 2px;
             height: 20px;

        }
          */

      .justForLabelSize label 
      {
          font-size: 1.2em;
          padding-right:1.0em;
          
      }

      #lbl_del {
          opacity: 0.25;
          
      }

      #item-table-modal {
          margin-top: 2em;
      }

     
      
      
    
        
    </style>

    <script type="text/javascript">

        $(document).ready(function () {
            /*
                This method is called when the page is loaded to initialise different things
            */
            var departmentID = '';    //global variable in this file
            var warehouseID = '';     //global variable in this file
            var tabcounter = 0;
            
            var items = [];
            loadInit();
            function loadInit() {
                setTab('PurchaseOrders');
                getDepartmentID();
                getWarehouseID();
                getPOnumber();
                var today = $.datepicker.formatDate('dd-mm-yy', new Date());
                $('#<%=lblOrderDate.ClientID%>').text(today)
               
            }

            /* HOW TO AVOID GLOBALS:
            https://www.w3.org/wiki/JavaScript_best_practices#Avoid_globals
            globals are bad. So all our global variables should be encapsulated in this "namespace". Here we can change and retrieve values with getters and setters

            */
            myNameSpace = function () {

                var objectOfVariables = {
                    po_modal_state: 1,            //1:means that we are at the state where you still can add more spareparts to order 2:after pressing next and on "send order". 3: is final state
                    po_modal_state_canclose: 0,
                    po_modal_ddlnonstock: false,
                    item_catg_desc: 0
                };
                
                var item_arr = [];


                function set(variableToChange ,newvalue)
                {
                    var count = 0;
                    while(Object.keys(objectOfVariables)[count] != undefined)     //while we still have properties to loop over
                    {
                        if (Object.keys(objectOfVariables)[count] === variableToChange)
                        {
                            
                            objectOfVariables[variableToChange] = newvalue;
                            console.log("Set variable!");
                        }
                        count++;
                    }
                }
                function get(variableToRetrieve)
                {
                    var count = 0;
                    while (Object.keys(objectOfVariables)[count] != undefined)     //while we still have properties to loop over
                    {
   
                        if (Object.keys(objectOfVariables)[count] === variableToRetrieve) {
                                                  
                            return objectOfVariables[variableToRetrieve];
                        }
                        count++;
                    }
                    
                }


                
                return {
                    /* public_call : internal call.  Can be the same such as init:init, or different such as set:change */
                    
                    set: set,
                    get: get
                    
                }
            }();



            /*
                This method is called when a tab is clicked, and loads the correct "page" with css etc
            */
            function setTab(currTab) {
                //currtab means currentTab             
                var tabID = "";
              
                tabID = $(currTab).data('tab') || currTab; // Checks if click or function call. If ctab is undefined, it is not a string, but instead an element with data
                var tab;
                (tabID == "") ? tab = currTab : tab = tabID;

                $('.tTab').addClass('hidden'); // Hides all tabs
                $('#tab' + tabID).removeClass('hidden'); // Shows target tab and sets active class
                $('.cTab').removeClass('tabActive'); // Removes the tabActive class for all 
                $("#btn" + tabID).addClass('tabActive'); // Sets tabActive to clicked or active tab
                if (tabcounter > 0)
                {
                    //tabcounter will be 0 first time this method is called. Then we should not redraw the tabulator tables.
                    //however, whenever we switch tab, the tables should be redrawn. If not, often you will see a weird looking tabulator table
                    console.log("cha");
                    $("#example-table").tabulator("redraw", true);
                    $("#item-table").tabulator("redraw");
                    $("#restorder-table").tabulator("redraw");
                }
                tabcounter++;

            }
            //tabs with class .ctab have this onclick func that calls setTab for switching tabs
            $('.cTab').on('click', function (e) {                               
                setTab($(this));               
            });



           
          


            function getPOnumber() {
                console.log("inside getponumber");
                console.log(departmentID + " " + warehouseID);

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/GeneratePOnumber",
                    data: "{deptID:'" + departmentID + "',warehouseID:'" + warehouseID + "'}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        {
                            if (data.d.length != 0) {
                                $('#<%=lblSerNum.ClientID%>').text(data.d[1]);
                                
                            }
                        }
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }

            

            function getWarehouseID() {
                console.log("inside getware");
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/LoadWarehouseDetails",
                    data: '{}',
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        {
                            if (data.d.length != 0) {

                                warehouseID = data.d[0].WarehouseID;
                            }
                            else {
                                console.log("no len");
                            }
                        }
                    }
                });
            }

            function getDepartmentID() {
                console.log("getdepid inside");
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/FetchCurrentDepartment",
                    data: "{}",
                    dataType: "json",
                    async: false,//Very important
                    success: function (data) {
                        if (data.d.length != 0) {
                            departmentID = data.d[0].DeptId;

                        }
                        else {
                            console.log("a problem occured");
                        }
                    }
                });
            }

            function poExists(ponum)
            {
                var ret = 0;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/poExists",
                    data: "{ponum:'" + ponum + "'}",
                    dataType: "json",
                    async: false,//Very important. If not, then succeeded will not be set, because it will make an asynchronous call
                    success: function (data) {
                        console.log("success");
                        ret = 1;
                        console.log("data is "+data.d);

                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
                return ret;
            }
            

            $('#btnSavePurchaseOrderSuggestion').on('click', function (e) {
                
                var rows = $("#item-table").tabulator("getRows");
                if (rows.length > 0) {
                    if (confirm('Lagre bestillingsforslag?')) {

                        saveNewPurchaseOrder();
                        console.log("xxx");
                        //emptyAllFields();

                        $('#<%=lblSerNum.ClientID%>').text(getPOnumber());
                        var today = $.datepicker.formatDate('dd-mm-yy', new Date());
                        $('#<%=lblOrderDate.ClientID%>').text(today);

                        } else {
                        // Do nothing!
                        }
                    }
                    else {
                        alert("No items on purchaseorder. Not saved");
                    }

            });

            /* only called from the new po tab*/

            function saveNewPurchaseOrder()
            {
                $('#<%=lblSerNum.ClientID%>').text(getPOnumber());
                var ponumber = $('#<%=lblSerNum.ClientID%>').text(); //gets updated PO                   
                var expdlvdate = convertDate($('#<%=txtbxExpDelivery.ClientID%>').val());   //expected delivery date, can be null
                var suppcurrentno = $('#<%=txtbxSupplierNameNEWPO.ClientID%>').val();
                var ordertype = $('#<%=ddlOrderType.ClientID%>').val();               
                var rows = $("#item-table").tabulator("getRows");


                var purchaseOrderHead = createPOHeaderJSONstring(expdlvdate, ponumber, suppcurrentno);
                console.log("num rows " + rows.length);
                
                
                var succeeded = false;

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/SavePurchaseOrderHead",
                    data: "{PurchaseOrderHead:'" + purchaseOrderHead + "'}",
                    dataType: "json",
                    async: false,//Very important. If not, then succeeded will not be set, because it will make an asynchronous call
                    success: function (data) {
                        console.log("success");
                        succeeded = true;
                        console.log("res:")
                        console.log(data);

                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            


                console.log("num rows "+rows.length);
                for (i = 0; i < rows.length; i++)
                {
                 
                    var success = addItemToPO(rows[i]);
                    if (!success) {
                        alert("Noe gikk galt med lagring av varer på bestilling");
                    }

                }
                

                if (succeeded) {
                    systemMSG('success', 'Bestillingsforslag lagret', 5000);
                }

                else {
                    alert("Fikk ikke lagret ordre");
                }


            }


            function addItemToPO(row)
            {

                var itemobj = createPOItemJSONstring(row);
                console.log("next")
                console.log(itemobj);


                var succeeded = false;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/Add_PO_Item",
                    data: "{item:'" + itemobj + "'}",
                    dataType: "json",
                    async: false,//Very important. If not, then succeeded will not be set, because it will make an asynchronous call
                    success: function (data) {
                        console.log("success");
                        succeeded = true;

                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });

                return succeeded;
            }
            

            /*  Add fields to header-object, Then we store it back in a json string and return it to the calling method.
            */
            function createPOHeaderJSONstring( expdlvdate, ponum, suppcurrentno)
            {
                var purchaseOrderHeader = {};

                purchaseOrderHeader["NUMBER"] = ponum;
                purchaseOrderHeader["PREFIX"] = $('#<%=lblSerNum.ClientID%>').text().substring(0, 3);
                purchaseOrderHeader["SUPP_CURRENTNO"] = suppcurrentno;
                purchaseOrderHeader["DT_EXPECTED_DELIVERY"] = expdlvdate;
                purchaseOrderHeader["ID_ORDERTYPE"]     =   $('#<%=ddlOrderType.ClientID%>').val();
                purchaseOrderHeader["ID_DEPT"] = departmentID;
                purchaseOrderHeader["ID_WAREHOUSE"] = warehouseID;              
                purchaseOrderHeader["DT_CREATED_SIMPLE"] = convertDate($('#<%=lblOrderDate.ClientID%>').text());
                purchaseOrderHeader["STATUS"] = false;
                purchaseOrderHeader["FINISHED"] = false;
                purchaseOrderHeader["CREATED_BY"] = ""
                purchaseOrderHeader["DELIVERY_METHOD"] = $('#<%=ddlDeliveryMethod.ClientID%>').val();
                purchaseOrderHeader["ANNOTATION"] = "COMMENT";

                
                var jsonPO = JSON.stringify(purchaseOrderHeader);
                console.log(jsonPO);
                                         
                
               return jsonPO;
            }

            function createPOItemJSONstring(row)
            {

                var ponumber = $('#<%=lblSerNum.ClientID%>').text();
                var poid = fetch_PO_id(ponumber);
                
                var purchaseOrderItem = {};             

                purchaseOrderItem["ID_PO"] = poid;
                purchaseOrderItem["PONUMBER"] = ponumber;
                purchaseOrderItem["POPREFIX"] = $('#<%=lblSerNum.ClientID%>').text().substring(0, 3);
                purchaseOrderItem["ID_ITEM"] = row.getCell("ID_ITEM").getValue();
                purchaseOrderItem["ITEM_CATG_DESC"] = row.getCell("ITEM_CATG_DESC").getValue();
                purchaseOrderItem["ORDERQTY"] = row.getCell("ORDERQTY").getValue();
                purchaseOrderItem["DELIVERED_QTY"] = 0;
                purchaseOrderItem["REMAINING_QTY"] = row.getCell("ORDERQTY").getValue();
                purchaseOrderItem["BUYCOST"] = row.getCell("BUYCOST").getValue();
                purchaseOrderItem["TOTALCOST"] = row.getCell("TOTALCOST").getValue();
                purchaseOrderItem["BACKORDERQTY"] = 0;
                purchaseOrderItem["CONFIRMQTY"] = 0;
                purchaseOrderItem["DELIVERED"] = false;
                purchaseOrderItem["ANNOTATION"] = "COMMENT";
                
                var jsonPO = JSON.stringify(purchaseOrderItem);
                console.log(jsonPO);
                                         
                
               return jsonPO;
            }

            function fetch_PO_id(ponumber)
            {
                var id;

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/Fetch_PO_id",
                    data: "{ponum:'" + ponumber + "'}",
                    dataType: "json",
                    async: false,//Very important. If not, then succeeded will not be set, because it will make an asynchronous call
                    success: function (data) {
                        console.log("success");
                        id = data.d;

                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });

                return id;
            }
            


            function emptyAllFields(deleteItems)
            {
                $('#<%=txtbxSupplier.ClientID%>').val('');
                $('#<%=txtbxSupplierNameNEWPO.ClientID%>').val('');
                $('#<%=txtbxExpDelivery.ClientID%>').val('');
                $('#<%=TextBox1.ClientID%>').val('');
                $('#<%=txtbxSpareNum.ClientID%>').val('');
                items.length = 0; //clearing the items array is crucial

                if (deleteItems) {
                    var rows = $("#item-table").tabulator("getRows");

                    if (rows.length > 0) {

                        for (i = 0; i < rows.length; i++) {
                            rows[i].delete();

                        }
                    }
                }


            }

            function addItemToTable(tablename, item_num)
            {
                var rows = $(tablename).tabulator("getRows");
                console.log(rows.length !== 0);
                if (rows.length !== 0) {
                    for (i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        data = row.getData();
                        
                        if(data.ID_ITEM === item_num)
                        {                      
                            console.log(row);
                            $(tablename).tabulator("deselectRow"); //deselect all
                            $(tablename).tabulator("selectRow", row);        //select the existing item, easier to see for user
                            setTimeout(function () { $(tablename).tabulator("deselectRow", row); }, 3000);
                            
                            return 0;
                        }
                    }

                }
                return 1;
            }

            
                       
          
            /****              DATEPICKERS START                */


            //datepickers should now be bulletproof!! Some magic in onselect!

            $("#<%=txtbxDateFrom.ClientID%>").datepicker({
                showWeek: true,
                showOn: "button",
                buttonImage: "../images/calendar_icon.gif",
                buttonImageOnly: true,
                buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+10",
                dateFormat: "dd-mm-yy",
                onSelect: function (date) {
                    var dt2 = $('#<%=txtbxDateTo.ClientID%>');
                    var startDate = $(this).datepicker('getDate');
                    var minDate = $(this).datepicker('getDate');
                    dt2.datepicker('setDate', minDate);              
                    dt2.datepicker('option', 'minDate', minDate);
                  
                }
                
                
            });

            $('#<%=txtbxDateTo.ClientID%>').datepicker({
                showWeek: true,
                showOn: "button",
                buttonImage: "../images/calendar_icon.gif",
                buttonImageOnly: true,
                buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+10",
                dateFormat: "dd-mm-yy",
                onSelect: function (date) {
                    var dt1 = $('#<%=txtbxDateFrom.ClientID%>');
                    var dt1value = $('#<%=txtbxDateFrom.ClientID%>').val();
                    console.log(dt1value);
                    if(dt1value === undefined || dt1value === "" )
                    {
                         var thisdate = $(this).datepicker('getDate')
                         dt1.datepicker('setDate', thisdate);
                         $(this).datepicker('option', 'minDate', thisdate);
                    }
                }
            });
        

             $("#<%=txtbxExpDelivery.ClientID%>").datepicker({
                showWeek: true,
                showOn: "button",
                buttonImage: "../images/calendar_icon.gif",
                buttonImageOnly: true,
                buttonText: "Velg dato",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                yearRange: "-50:+10",
                dateFormat: "dd-mm-yy",
                minDate: 0,
                onSelect: function(date)
                {
                    if ($('#<%=txtbxSupplierNameNEWPO.ClientID%>').val().length && $('#<%=ddlOrderType.ClientID%>').val().length && $('#<%=ddlDeliveryMethod.ClientID%>').val().length)
                    {
                        
                        //setTimeout(function () { openOrCloseFieldArea("#btnViewDetailsNEWPO") }, 1200);
                    }
                }
                 
                
                
            });

            /****        DATEPICKERS END    */

            function convertDate(date)
            {
                var newDateFormat = date.split("-");
                var tmp = newDateFormat[0];
                newDateFormat[0] = newDateFormat[2];
                newDateFormat[2] = tmp;
                newDateFormat = newDateFormat.join("");
                return newDateFormat;
            }

            /* if two of these are active, disable the third. We dont want people to use all three input fields: that is useless*/

            $('#<%=txtbxPOnumbersearch.ClientID%>').on('input', function () {

                if ($(this).val().length && $('#<%=txtbxInfoSupplier.ClientID%>').val().length)
                    $('#<%=txtbxSparepartNumber.ClientID%>').prop('disabled', true);
                else
                     $('#<%=txtbxSparepartNumber.ClientID%>').prop('disabled', false);
            });

            $('#<%=txtbxInfoSupplier.ClientID%>').on('input', function () {

                if ($(this).val().length && $('#<%=txtbxPOnumbersearch.ClientID%>').val().length)
                    $('#<%=txtbxSparepartNumber.ClientID%>').prop('disabled', true);
                
                else if($(this).val().length && $('#<%=txtbxSparepartNumber.ClientID%>').val().length)
                    $('#<%=txtbxPOnumbersearch.ClientID%>').prop('disabled', true);
                else
                {
                    $('#<%=txtbxPOnumbersearch.ClientID%>').prop('disabled', false);
                    $('#<%=txtbxSparepartNumber.ClientID%>').prop('disabled', false);
                }
                    

            });

            $('#<%=txtbxSparepartNumber.ClientID%>').on('input', function () {

                if ($(this).val().length && $('#<%=txtbxInfoSupplier.ClientID%>').val().length)
                    $('#<%=txtbxPOnumbersearch.ClientID%>').prop('disabled', true);
                else
                     $('#<%=txtbxPOnumbersearch.ClientID%>').prop('disabled', false);
            });




            function isValidNumber(evt, element) {

                var charCode = (evt.which) ? evt.which : event.keyCode

                if (
                 
                  (charCode != 44 || $(element).val().indexOf(',') != -1) && // “,” CHECK comma, AND ONLY ONE.
                  (charCode < 48 || charCode > 57) 
                    )
                    return false;

                return true;
            }


            //prevent from being able to copy/paste/cut. That would break the input restriction logic.
            $('.inputNumberDot').bind("cut copy paste", function (e) { 
                e.preventDefault();
            });

            $('.inputNumberDot').keypress(function (event) {
                
                return (isValidNumber(event, this) && ($(this).val().length < 8));
        });

            $('#txtbxQuantityModal').on('keyup', function ()
            {
                
                if($("#txtbxQuantityModal").val() === "")
                {
                    $("#txtbxQuantityModalparent").removeClass("success");
                    $("#txtbxQuantityModalparent").addClass("error");
                    $("#btnAddItemToTableModal").addClass("disabled");
                }
                else
                {
                    if(($("#txtbxQuantityModalparent").hasClass("success") === false))
                    {
                        $("#txtbxQuantityModalparent").removeClass("error");
                        $("#txtbxQuantityModalparent").addClass("success");
                    }

                    if ($("#txtbxSparepartModalparent").hasClass("success") && $("#txtbxCostModalparent").hasClass("success")) {
                        $("#btnAddItemToTableModal").removeClass("disabled");
                    }

                
                   
                }
                
            });

            $('#txtbxCostModal').on('keyup', function () {
                
                console.log($('#txtbxCostModal').val());
                if ($("#txtbxCostModal").val() === "" || parseInt($("#txtbxCostModal").val(), 10) === 0) {
                    
                    $("#txtbxCostModalparent").removeClass("success");
                    $("#txtbxCostModalparent").addClass("error");
                    $("#btnAddItemToTableModal").addClass("disabled");
                }
                else
                {
                    if ($("#txtbxCostModalparent").hasClass("success") === false) {
                        $("#txtbxCostModalparent").removeClass("error");
                        $("#txtbxCostModalparent").addClass("success");
                        
                    }
                    if ($("#txtbxSparepartModalparent").hasClass("success") && $("#txtbxQuantityModalparent").hasClass("success")) {
                        $("#btnAddItemToTableModal").removeClass("disabled");
                    }
                }
                    

            });



            $('#txtbxSparepartModal').on('keyup', function () {
                console.log($('#txtbxSparepartModal').val());
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/SparePart_Search",
                    data: "{'q': '" + $('#txtbxSparepartModal').val() + "', 'mustHaveQuantity': '" + false + "', 'isStockItem': '" + false + "', 'isNotStockItem': '" + false + "', 'loc': '" + "%" + "', 'supp': '" + $("#pomodal_details_supplier").text() + "', 'nonStock': '" + myNameSpace.get("po_modal_ddlnonstock") + "', 'accurateSearch': '" + true + "'}",
                    dataType: "json",
                    success: function (data) {

                        if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                            console.log("no hits");
                            if ($("#txtbxSparepartModalparent").hasClass("error") === false)
                            {
                                $("#txtbxSparepartModalparent").removeClass("success");
                                $("#txtbxSparepartModalparent").addClass("error");
                                $("#modalPointingLabel").css('visibility', 'visible');
                                $("#btnAddItemToTableModal").addClass("disabled");
                                
                            }
                            
                        }
                        else
                        {
                            console.log("hit");
                            if ($("#txtbxSparepartModalparent").hasClass("error") === true)
                            {
                                $("#txtbxSparepartModalparent").addClass("success");
                                $("#txtbxSparepartModalparent").removeClass("error");
                                //$("#modalPointingLabel").addClass("hidden");
                                $("#modalPointingLabel").css('visibility', 'hidden'); // we want this div to STILL TAKE UP SPACE after it is hidden(so that other labels are still aligned correctly).
                                if ($("#txtbxCostModalparent").hasClass("success") && $("#txtbxQuantityModalparent").hasClass("success"))
                                {
                                    $("#btnAddItemToTableModal").removeClass("disabled");
                                }
                                
                            }
                            
                        }
                    },
                    error: function (xhr, status, error) {
                        alert("Error" + error);
                        var err = eval("(" + xhr.responseText + ")");
                        alert('Error: ' + err.Message);
                    }
                });



            });

            //when pushing tab in last checkbox in modal, add new item
            $("#txtbxQuantityModalparent").on('keydown', '#txtbxQuantityModal', function (e) {
                var keyCode = e.keyCode || e.which;

                if (keyCode == 9) { //tab
                    e.preventDefault();
                    if (!$("#btnAddItemToTableModal").hasClass("disabled")) {
                        var vgruppe = myNameSpace.get("item_catg_desc");
                        var nr = $("#txtbxSparepartModal").val();
                        var ant = $("#txtbxQuantityModal").val();
                        var kost = $("#txtbxCostModal").val();
                        var total = kost * ant;

                        if (addItemToTable("#item-table-modal", nr))
                        {
                            $("#item-table-modal").tabulator("addData", [{ ITEM_CATG_DESC: vgruppe, ID_ITEM: nr, ORDERQTY: ant, BUYCOST: kost, TOTALCOST: total }], false);
                            $("#item-table-modal").tabulator("redraw", true);
                            $('#txtbxSparepartModal').focus();
                            $('#txtbxSparepartModal').val("");
                            $('#txtbxCostModal').val("");
                            $('#txtbxQuantityModal').val("");
                        }
                        else {
                            alert("Denne varen finnes allerede på ordren. Du kan endre antallet manuelt i tabellen");
                        }
                        
                        
                    }
                    
                }
            });
            
            
            function getCostPrice(itemID, suppcurrentno, orderType)
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/getCostPrice",
                    data: "{itemID:'" + itemID + "',suppcurrentno:'" + suppcurrentno + "',orderType:'" + orderType + "'}",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        {
                            if (data.d.length != 0) {
                                console.log(data.d);
                                $("#txtbxCostModal").val(data.d);
                                if (data.d === 0)
                                {
                                   
                                    $("#txtbxCostModalparent").removeClass("success");
                                    $("#txtbxCostModalparent").addClass("error");
                                }
                                else 
                                {
                                    $("#txtbxCostModalparent").removeClass("error");
                                    $("#txtbxCostModalparent").addClass("success");
                                }
                                
                            }
                        }
                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }

                });
            }
            


            //dont use clientid here because this textbox is semantics and not asp
            $('#txtbxSparepartModal').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "PurchaseOrder.aspx/SparePart_Search",
                        data: "{'q': '" + $('#txtbxSparepartModal').val() + "', 'mustHaveQuantity': '" + false + "', 'isStockItem': '" + false + "', 'isNotStockItem': '" + false + "', 'loc': '" + "%" + "', 'supp': '" + $("#pomodal_details_supplier").text() + "', 'nonStock': '" + myNameSpace.get("po_modal_ddlnonstock") + "', 'accurateSearch': '" + false + "'}",
                        dataType: "json",
                        success: function (data) {
                          
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager', value: $('#txtbxSparepartModal').val(), val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {

                                    return {
                                        label: item.ID_MAKE + " - " + item.ID_ITEM + " - " + item.ITEM_DESC + " - " + item.LOCATION + " - " + item.ID_WH_ITEM,
                                        val: item.ID_ITEM,
                                        value: item.ID_ITEM,
                                        make: item.ID_MAKE,
                                        warehouse: item.ID_WH_ITEM,
                                        desc: item.ITEM_DESC,
                                        catg_desc: item.ITEM_CATG_DESC
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

                    if (i.item.val != "new") {
                        e.preventDefault();
                        if ($("#txtbxSparepartModalparent").hasClass("error") === true) {
                            $("#txtbxSparepartModalparent").removeClass("error");
                            $("#modalPointingLabel").addClass("hidden");
                            $("#txtbxSparepartModalparent").addClass("success");
                            if ($("#txtbxCostModalparent").hasClass("success") && $("#txtbxQuantityModalparent").hasClass("success")) {
                                $("#btnAddItemToTableModal").removeClass("disabled");
                            }                        
                        }
                        $('#txtbxSparepartModal').val(i.item.value);
                        $('#txtbxQuantityModal').focus();
                        getCostPrice(i.item.value, $("#pomodal_details_supplier").text(), $('#pomodal_details_ordertype').text());
                        myNameSpace.set("item_catg_desc", i.item.catg_desc);
                    }
                    else {


                    }

                }
            });
       
            
            $('#<%=txtbxPOnumbersearch.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "PurchaseOrder.aspx/Fetch_PurchaseOrders",
                        data: "{'POnum': '" + $('#<%=txtbxPOnumbersearch.ClientID%>').val() + "', 'supplier': '" + "%" + "', 'fromDate': '" + 0 + "', 'toDate': '" + 0 + "', 'spareNumber': '" + "%" + "', 'isDelivered': '" + "%" + "', 'isConfirmedOrder': '" + true + "', 'isUnconfirmedOrder': '" + true + "', 'isExactPOnum': '" + false + "', 'isExactSupp': '" + false + "'}",
                        dataType: "json",
                        success: function (data) {                         

                            if (data.d.length === 0) // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                            {
                                response([{ label: 'Ingen treff på bestillingsnummer', value: '0', val: 'new' }]);
                            }
                            else
                                response($.map(data.d, function (item) {

                                    return {
                                        label: item.PONUMBER,
                                        val: item.PONUMBER,
                                        value: item.PONUMBER
                                        
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            console.log("err");
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }

                    });

                },

            // select invoken when: autocomplete prompt clicked/enter pressed/tab pressed
            select: function (e, i) {

                if (i.item.val != 'new') {
                    e.preventDefault();
                    $('#<%=txtbxPOnumbersearch.ClientID%>').val(i.item.val); //crucial so that txtinfosupplier can send correct info to stored procedure in loadcategory
                     
                        //loadCategory();
                    }
                    else {

                        
                    }

                }

        });
            //autocomplete for listing of the supplier

            $('#<%=txtbxInfoSupplier.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LocalSPDetail.aspx/Supplier_Search",
                        data: "{q:'" + $('#<%=txtbxInfoSupplier.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtbxInfoSupplier.ClientID%>').val());

                            if (data.d.length === 0) // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                            {
                                response([{ label: 'Ingen treff i leverandørregister', value: '0', val: 'new' }]);
                            }
                            else
                                response($.map(data.d, function (item) {

                                    return {
                                        label: item.ID_SUPPLIER_ITEM + " - " + item.SUP_Name + " - " + item.SUPP_CURRENTNO,
                                        val: item.SUPP_CURRENTNO,
                                        value: item.SUPP_CURRENTNO,
                                        supName: item.SUP_Name
                                    }
                                }))
                        },
                        error: function (xhr, status, error) {
                            console.log("err");
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }

                    });

                },

            // select invoken when: autocomplete prompt clicked/enter pressed/tab pressed
            select: function (e, i) {

                if (i.item.val != 'new') {
                    e.preventDefault();
                    $('#<%=txtbxInfoSupplier.ClientID%>').val(i.item.val); //crucial so that txtinfosupplier can send correct info to stored procedure in loadcategory
                     
                        //loadCategory();
                    }
                    else {

                        //moreInfo("SupplierDetail.aspx?" + "&pageName=SpareInfo");
                    }

                }

        });



            //autocomplete for listing of the supplier


            $('#<%=txtbxSupplier.ClientID%>').autocomplete({
                
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LocalSPDetail.aspx/Supplier_Search",
                        data: "{q:'" + $('#<%=txtbxSupplier.ClientID%>').val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtbxSupplier.ClientID%>').val());

                            if (data.d.length === 0) // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                            {
                               
                                response([{ label: 'Fant ingen treff på leverandør', value: '', val: 'new' }]);

                            }
                            else

                                response($.map(data.d, function (item) {

                                    return {
                                        label: item.ID_SUPPLIER_ITEM + " - " + item.SUP_Name + " - " + item.SUPP_CURRENTNO,
                                        val: item.SUPP_CURRENTNO,
                                        value: item.SUPP_CURRENTNO,
                                        supName: item.SUP_Name,
                                        itemname: item.ID_SUPPLIER_ITEM

                                    }
                                }))

                        },
                        error: function (xhr, status, error) {
                            console.log("err");
                            alert("Error" + error);
                            var err = eval("(" + xhr.responseText + ")");
                            alert('Error: ' + err.Message);
                        }

                    });

                },

            // select invoken when: autocomplete prompt clicked/enter pressed/tab pressed
            select: function (e, i) {

                if (i.item.val != 'new') {
                    e.preventDefault()
                    $('#<%=txtbxSupplier.ClientID%>').val(i.item.supName);                  
                    $('#<%=txtbxSupplierNameNEWPO.ClientID%>').val(i.item.val);
                    $('#<%=txtbxSpareNum.ClientID%>').prop("disabled", false);
                        //crucial so that txtinfosupplier can send correct info to stored procedure in loadcategory
                        //loadCategory();
                    }
                    else {
                    e.preventDefault(); //prevents default behaviour which is setting input to something else
                     $('#<%=txtbxSupplier.ClientID%>').val('');
                        //moreInfo("SupplierDetail.aspx?" + "&pageName=SpareInfo");
                    }

            },
               

            });

                    

            $('#<%=txtbxSupplier.ClientID%>').on('keyup', function () {

                var rows = $("#item-table").tabulator("getRows");
                $('#<%=TextBox1.ClientID%>').val("");
                $('#<%=txtbxSpareNum.ClientID%>').val("");
                if (rows.length > 0)
                {
                    if (confirm('Endre leverandør? Dette vil medføre at alle varer som er lagt til på ordren fjernes'))
                    {
                        
                        for(i=0; i < rows.length; i++)
                        {
                            rows[i].delete();
                            
                        }
                        items.length = 0; //clearing the items array is crucial
                    }
                }
                
               
                if($('#<%=txtbxSupplier.ClientID%>').val() == "")
                {
                    $('#<%=txtbxSupplierNameNEWPO.ClientID%>').val("");
                }
            });

            $('#<%=txtbxSpareNum.ClientID%>').on('keyup', function () {
               
                if($('#<%=txtbxSpareNum.ClientID%>').val() == "")
                {
                    $('#<%=TextBox1.ClientID%>').val("");
                }
            });


        
            
            $('#<%=txtbxPOnumbersearch.ClientID%>').on('keyup', function () {

            });

            $('#<%=txtbxPOnumbersearch.ClientID%>').on('keyup', function () {

            });

           


          

            $('#<%=txtbxSparepartNumber.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LocalSPDetail.aspx/SparePart_Search_Short",
                        data: "{q:'" + $('#<%=txtbxSparepartNumber.ClientID%>').val() + "', 'supp': '" + $('#<%=txtbxInfoSupplier.ClientID%>').val()  + "'}",
                        dataType: "json",
                        success: function (data) {
                            console.log($('#<%=txtbxSparepartNumber.ClientID%>').val());
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager', value: $('#<%=txtbxSparepartNumber.ClientID%>').val(), val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {

                                    return {
                                        label: item.ID_MAKE + " - " + item.ID_ITEM + " - " + item.ITEM_DESC + " - " + item.LOCATION + " - " + item.ID_WH_ITEM,
                                        val: item.ID_ITEM,
                                        value: item.ID_ITEM,
                                        make: item.ID_MAKE,
                                        warehouse: item.ID_WH_ITEM,
                                        desc: item.ITEM_DESC
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

                    if (i.item.val != "new") {
                        e.preventDefault();
                        
                        $('#<%=txtbxSparepartNumber.ClientID%>').val(i.item.value);

                    }
                    else {


                    }

                }
            });

            $('#<%=txtbxSpareNum.ClientID%>').autocomplete({
                selectFirst: true,
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LocalSPDetail.aspx/SparePart_Search_Short",
                        data: "{q:'" + $('#<%=txtbxSpareNum.ClientID%>').val() + "', 'supp': '" + $('#<%=txtbxSupplierNameNEWPO.ClientID%>').val()  + "'}",
                        dataType: "json",
                        success: function (data) {
                            if (data.d.length === 0) { // If no hits in local search, prompt create new, sends user to new vehicle if enter is pressed.
                                response([{ label: 'Ingen treff i lokalt lager', value: $('#<%=txtbxSpareNum.ClientID%>').val(), val: 'new' }]);
                            } else
                                response($.map(data.d, function (item) {

                                    return {
                                        label: item.ID_MAKE + " - " + item.ID_ITEM + " - " + item.ITEM_DESC + " - " + item.LOCATION + " - " + item.ID_WH_ITEM + " - " + item.ITEM_CATG_DESC,
                                        val: item.ID_ITEM,
                                        value: item.ID_ITEM,
                                        make: item.ID_MAKE,
                                        warehouse: item.ID_WH_ITEM,
                                        desc: item.ITEM_DESC,
                                        catg_desc: item.ITEM_CATG_DESC
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

                    if (i.item.val != "new") {
                        e.preventDefault();
                        $('#<%=txtbxSpareNum.ClientID%>').val(i.item.desc);
                        $('#<%=TextBox1.ClientID%>').val(i.item.val);
                        console.log("catg is " + i.item.catg_desc);
                        
                        myNameSpace.set("item_catg_desc", i.item.catg_desc);
                   
                    }
                    else {


                    }

                }
            });

              $('#<%=btnAdvSalesman.ClientID%>').on('click', function () {
                overlay('on', 'modAdvSalesman');
              });

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
            
            $(".modClose").on('click', function (e) {
                overlay('off', '');
            });





           /* Close actions are applied by default to all button actions, in addition an onApprove or onDeny callback will fire if the elements match either selector.

                approve  : '.positive, .approve, .ok',
                deny     : '.negative, .deny, .cancel' */

            //need this in order for dropdown to work!!

            $('#ddlLocalNonstock').dropdown({
                onChange: function () {
                    console.log("val is " + $(this).dropdown('get value'));
                    var currentSelection = $(this).dropdown('get value');
                   
                    if(currentSelection === "non-stock")
                    {
                        myNameSpace.set("po_modal_ddlnonstock", true);
                    }
                    else
                    {
                        myNameSpace.set("po_modal_ddlnonstock", false);
                    }
                    
                }


            }); 

          


            $('#modal_po_steps').modal({
                allowMultiple: true,
                closable: false, //so that you cant close by just clicking outside modal
                selector: {
                    
                    deny: '.actions .negative, .actions .deny, .actions .cancel, .close'
                },
                onDeny: function () {
                    if (myNameSpace.get("po_modal_state") !== 3)
                    {

                    }
                    return false;
                },
                
                onApprove : function() {
                    returnValue = false;
                    if (myNameSpace.get("po_modal_state") === 3) //if we are at the final step in modal allow to close 
                    {
                        if (myNameSpace.get("po_modal_state_canclose") === 0)
                        {
                            returnValue = false;
                            myNameSpace.set("po_modal_state_canclose", 1);
                        }
                        else
                        {
                            returnValue = true;
                        }
                        
                    }
                    return returnValue; //Return false as to not close modal dialog
                }
            });

            $(".ui modal close icon").on("click", function (e) {
                alert("yeye");


            });


            $('#po_modal_next').on('click', function (e)
            {
                if (myNameSpace.get("po_modal_state") == 1)     //first step in modal
                {
                    //content divs

                    $('.modal_po_divstep1').addClass('hidden');
                    $('.modal_po_divstep2').removeClass('hidden');
                    
                    //header steps
                    $("#step_po_first").removeClass("active step");             
                    $("#step_po_first").addClass("completed step");
                    $("#step_po_first").addClass("disabled step");                 
                    $("#step_po_second").removeClass("disabled step");
                    $("#step_po_second").addClass("active step");

                    //buttons
                    $("#po_modal_previous").removeClass("disabled");
                    $("#po_modal_previous").addClass("orange");
                    $("#po_modal_next").text("Send bestilling");
                    $("#po_modal_next").append('<i class="checkmark icon"></i>');

                    //update state
                    myNameSpace.set("po_modal_state", 2);
                    console.log("new state: " + myNameSpace.get("po_modal_state"));
                }
                else if (myNameSpace.get("po_modal_state") == 2)   //second step in modal
                {
                    
                    //if ($('#modal_po_confirmorder').modal('show'))      fix this!
                    if (confirm("Sende bestilling?"))
                    {
                        //content divs
                        $('.modal_po_divstep2').addClass('hidden');
                        $('.modal_po_divstep3').removeClass('hidden');

                        //header steps
                        $("#step_po_second").removeClass("active step");
                        $("#step_po_second").addClass("completed step");
                        $("#step_po_second").addClass("disabled step")
                        $("#step_po_third").removeClass("disabled step");
                        $("#step_po_third").addClass("active step");

                        //buttons
                        $("#po_modal_next").text("Lukk");
                        $("#po_modal_next").append('<i class="checkmark icon"></i>');
                        $("#po_modal_previous").remove();
                        $("#po_modal_cancel").remove();

                        setPOtoSent($("#pomodal_details_ponumber").text());
                        //update state
                        myNameSpace.set("po_modal_state", 3);
                        console.log("new state: " + myNameSpace.get("po_modal_state"));
                    }

                  
                }

                else if (myNameSpace.get("po_modal_state") == 3)   //third and final step in modal
                {
                    
                }
                else   //should never enter here. added this in case someone added the wrong value for the modal state.
                {
                    alert("her skulle vi definitivt ikke havne!");
                }



            });

            $('#po_modal_previous').on('click', function (e)
            {
                if (myNameSpace.get("po_modal_state") == 2)     //second step in modal
                {
                    //content divs
                    $('.modal_po_divstep2').addClass('hidden');
                    $('.modal_po_divstep1').removeClass('hidden');

                    //header steps
                    $("#step_po_second").removeClass("active step");
                    $("#step_po_second").addClass("disabled step");
                    
                    $("#step_po_first").removeClass("completed step");
                    $("#step_po_first").removeClass("disabled step");
                    $("#step_po_first").addClass("active step");

                    //buttons
                    $("#po_modal_previous").addClass("disabled");
                    $("#po_modal_next").text("Neste");
                    $("#po_modal_next").append('<i class="chevron right icon"</i>');

                    myNameSpace.set("po_modal_state", 1);
                    console.log("new state: " + myNameSpace.get("po_modal_state"));;
                }
            });

           

            $.contextMenu({
                selector: '#example-table .tabulator-selected',   //only trigger contextmenu on selected rows in table
                items: {
                    open: {
                        name: "Åpne ordre",
                        icon: "paste",
                        callback: function (key, opt) {
                            openModalItemInformation(); //opens modal and shows information about the items on this order
 
                            
                        }
                    },
                    brreg: {
                        name: "Send bestilling",
                        icon: "attach",
                        callback: function (key, opt) {
                            if(confirm("Sende bestilling?"))
                            {

                            }

                        }
                    },
                    
                    sub: {
                        "name": "Sub group",
                        "items": {
                        copy: {
                            name: "Kopier",
                            callback: function (key, opt) {
                                
                            }
                        },
                        
                        proff: {
                            name: "Åpne i Proff",
                            callback: function (key, opt) {
                                
                            }
                        }
                        }
                    }
                }
            });

            function getPurchaseOrderItems(ponumber)
            {
                var dataret = {};

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/Fetch_PO_Item",
                    data: "{ponum:'" + ponumber + "'}",
                    dataType: "json",
                    async: false,//Very important. If not, then succeeded will not be set, because it will make an asynchronous call
                    success: function (data) {
                        console.log("success");
                      
                        console.log(data.d);
                        dataret = data.d[0];



                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
                return dataret;
                
            }


            function setPOtoSent(ponumber) 
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/setPOtoSent",
                    data: "{ponumber:'" + ponumber + "'}",
                    dataType: "json",
                    async: false,//Very important. If not, then succeeded will not be set, because it will make an asynchronous call
                    success: function (data) {
                        console.log("success");
                        console.log(data.d);
                        dataret = data.d[0];

                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }

            function updatePOitem(ponumber, polineno, orderqty, buycost, totalcost) 
            {


                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PurchaseOrder.aspx/updatePOitem",
                    data: "{ponumber:'" + ponumber + "', 'polineno': '" + polineno + "', 'orderqty': '" + orderqty + "', 'buycost': '" + buycost + "', 'totalcost': '" + totalcost + "'}",
                    dataType: "json",
                    async: false,//Very important. If not, then succeeded will not be set, because it will make an asynchronous call
                    success: function (data) {
                        console.log("success");
                        console.log(data.d);
                        dataret = data.d[0];

                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        console.log(xhr.status);
                        console.log(xhr.responseText);
                        console.log(thrownError);
                    }
                });
            }

            function getPOlineno(tablename, id_item)
            {
                var polineno = -1;
                console.log(id_item);
                
                therows = $(tablename).tabulator("getRows");
                for(i = 0; i < therows.length; i++)
                {
                   
                    if (therows[i].getData().ID_ITEM === id_item)
                    {
                        polineno = i+1;
                        
                    }
                }
                return polineno;

            }
           
            
            function openModalItemInformation()
            {
                var ajaxConfig = {
                    type: "POST", //set request type to Position
                    contentType: 'application/json; charset=utf-8', //set specific content type
                };

                var selectedRows = $("#example-table").tabulator("getSelectedRows");
                row = selectedRows[0];
                

                var ponumber = row.getCell("NUMBER").getValue();
                var supp_currentno = row.getCell("SUPP_CURRENTNO").getValue();
                var ordertype = row.getCell("ID_ORDERTYPE").getValue();

                //gets items 
                //var ret_data = getPurchaseOrderItems(ponumber);
                

                var deliverymethod = "Tog";
               
                
                $('#pomodal_details_ponumber').text(ponumber);
                $('#pomodal_details_supplier').text(supp_currentno); 
                $('#pomodal_details_ordertype').text(ordertype);
                
                $('#pomodal_details_delmethod').text(deliverymethod);
                //$('#pomodal_details_expdel').text(expected_del);
                $('.modal_po_divstep2').addClass('hidden');
                $('.modal_po_divstep3').addClass('hidden');
                $('#modal_po_steps').modal('show');
                $("#item-table-modal").tabulator("redraw");
                
                $("#item-table-modal").tabulator("setData", "PurchaseOrder.aspx/Fetch_PO_Items", "{POnum:'" + ponumber + "'}", ajaxConfig);
                $("#item-table-modal").tabulator("redraw", true);
            }


            $('#inp_confirmedOrder, #inp_unconfirmedOrder').on('click', function (e) {
                

                if ($(this).not(':checked').length) {
                    if (this.id === "inp_confirmedOrder" && $("#inp_unconfirmedOrder").not(':checked').length)
                    {
                      
                        $('#inp_unconfirmedOrder').prop('checked', true);
                    }
                    else if(this.id === "inp_unconfirmedOrder" && $("#inp_confirmedOrder").not(':checked').length)
                    {
                        $('#inp_confirmedOrder').prop('checked', true);
                    }
                   
                }
            });

            

            /* On click for searchbutton and the show/hide icon. Hides the container div that contains input fields etc so that only our table is displayed */
            $('#btnViewDetails, #searchbutton, #btnViewDetailsNEWPO').on('click', function (e) {
                openOrCloseFieldArea($(this), e);
            });

            function openOrCloseFieldArea(targetElement, e)
            {
                if (e)
                {
                    e.preventDefault();
                    e.stopPropagation();
                }
                
                var containerElement = $(targetElement).parent().next();

                
                var hiddenicon = false;
                if ($(containerElement).is(":hidden")) {
                    hiddenicon = true;
                }

                $(containerElement).slideToggle(500);
                if (hiddenicon == true) {
                    $(targetElement).find('i.icon').removeClass('up').addClass('down')
                }
                else {
                    $(targetElement).find('i.icon').removeClass('down').addClass('up');
                }

                if ($(containerElement).is(":hidden")) {
                    var hiddenicon = true;
                }
            }




            $('#deliver_notdeliver').on('click', function (e) {
                if ($('#deliver_notdeliver').is(':checked')) {
                    $('#lbl_not_del').fadeTo("slow", 0.25);
                    $('#lbl_del').fadeTo("slow", 1);
                }
                else {
                    $('#lbl_del').fadeTo("slow", 0.25);
                    $('#lbl_not_del').fadeTo("slow", 1)
                }
            });






            
            $('#btnDownloadCSV').on('click', function (e) {
                $("#item-table-modal").tabulator("download", "csv", "data.csv");
            });

            




            /**  OUR TABLES CREATED BY THE GREAT TABULATOR PLUGIN. **/
            /**  THE TABULATOR WEBPAGE IS http://tabulator.info    HERE YOU CAN FIND ALL INFO YOU NEED ABOUT THIS TABLE PLUGIN **/





            /* TABLE IN TAB NEW PURCHASEORDER FOR DISPLAYING ADDED ITEMS TO ORDER */

            $("#item-table-modal").tabulator({
                // set height of table, this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
                layout: "fitColumns", //fit columns to width of table (optional)
                selectable: true,     //true means we can select multiple rows   
                pagination: "local",
                paginationSize: 5,

                columns: [ //Define Table Columns
                    { title: "Varenr", field: "ID_ITEM", align: "center" },
                    { title: "Varegruppe", field: "ITEM_CATG_DESC", align: "center" },
                    { title: "Antall bestilt", field: "ORDERQTY", align: "center", editor: "number" },
                    { title: "Kostpris", field: "BUYCOST", align: "center", editor: "number" },
                    { title: "Totalkostnad", field: "TOTALCOST", align: "center" },
                ],
                

                cellEdited: function (cell) {

                    //IF cell is a totalcost cell, then do not trigger this. Totalcost gets edited but only through buy*orderqty
                    if (cell.getField() !== "TOTALCOST")
                    {
                        var row = cell.getRow();
                        var totalCell = row.getCell("TOTALCOST");
                        var buycost = cell.getData().BUYCOST
                        var orderqty = cell.getData().ORDERQTY;

                        var total = cell.getData().BUYCOST * cell.getData().ORDERQTY;

                        totalCell.setValue(total, true);
                        var polineno = getPOlineno("#item-table-modal", cell.getData().ID_ITEM);

                        
                        var ponumber = $('#pomodal_details_ponumber').text();
                        updatePOitem(ponumber, polineno, orderqty, buycost, total);
                    }
                    

                   
               },
                

                rowSelectionChanged: function (data, rows) {
                    //rows - array of row components for the selected rows in order of selection
                    //data - array of data objects for the selected rows in order of selection
                    if (rows.length === 0) {
                        $("#btnDeleteRowModal").addClass("disabled");
                    }
                    else {
                        $("#btnDeleteRowModal").removeClass("disabled");
                    }
                },

                ajaxResponse: function (url, params, response) {
                    console.log("url is: " + url);
                    console.log("params is: " + params);                  
                    console.log(typeof(response.d[0].TOTALCOST));
                    //url - the URL of the request
                    //params - the parameters passed with the request
                    //response - the JSON object returned in the body of the response.

                    return response.d; //return the d property of a response json object
                },
                dataLoading: function (data) { //we need this because data that comes in is strings, cant be 
                    //data - the data loading into the table
                },




            });


            /* WHEN CLICKING THIS BUTTON, ITEM IS ADDED TO THE TABLE */
            $("#btnAddItemToTableModal").on('click', function (e)
            {
                var vgruppe = myNameSpace.get("item_catg_desc");
                var nr = $("#txtbxSparepartModal").val();
                var ant = $("#txtbxQuantityModal").val();
                var kost = $("#txtbxCostModal").val();
                var total = kost * ant;

                if (addItemToTable("#item-table-modal", nr))
                {
                    $("#item-table-modal").tabulator("addData", [{ ITEM_CATG_DESC: vgruppe, ID_ITEM: nr, ORDERQTY: ant, BUYCOST: kost, TOTALCOST: total }], false);
                    $('#txtbxSparepartModal').focus();
                    $('#txtbxSparepartModal').focus();
                    $('#txtbxSparepartModal').val("");
                    $('#txtbxCostModal').val("");
                    $('#txtbxQuantityModal').val("");
                }
                else {
                    alert("Denne varen finnes allerede på ordren. Du kan endre antallet manuelt i tabellen");
                }
                
            });

            

            $("#item-table").tabulator({
                //height: 340, // set height of table, this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
                layout: "fitColumns", //fit columns to width of table (optional)
                selectable: true,     //true means we can select multiple rows             
                columns: [ //Define Table Columns
                    { formatter: "rownum", align: "center", width: 40 },
                    { title: "Varenr", field: "ID_ITEM", align: "center" },
                    { title: "Varegruppe", field: "ITEM_CATG_DESC", align: "center" },                                      
                    { title: "Antall bestilt", field: "ORDERQTY", align: "center", editor: "number"},
                    { title: "Kostpris", field: "BUYCOST", align: "center", editor: "number" },
                    { title: "Totalkostnad", field: "TOTALCOST", align: "center" },
                ],
                cellEdited: function (cell) {
                    
                    var row = cell.getRow();
                    var totalCell = row.getCell("TOTALCOST");
                  
                    var total = cell.getData().BUYCOST * cell.getData().ORDERQTY;
                   
                    totalCell.setValue(total, true)
                },

                rowSelectionChanged: function (data, rows) {
                    //rows - array of row components for the selected rows in order of selection
                    //data - array of data objects for the selected rows in order of selection
                    if(rows.length === 0)
                    {
                        $("#btnDeleteRow").addClass("disabled");
                    }
                    else 
                    {
                        $("#btnDeleteRow").removeClass("disabled");
                    }
                },
               
                
                    
               
            });

            $('#<%=TextBox9.ClientID%>').on('keydown',  function (e) {
                var keyCode = e.keyCode || e.which;

                
                if (keyCode == 9) { //tab
                    e.preventDefault();
                    addItemToTableNEWPO();
                    $('#<%=txtbxSpareNum.ClientID%>').focus();
                }
            });

          

            /* WHEN CLICKING THIS BUTTON, ITEM IS ADDED TO THE TABLE */
            $("#btnAddItemToTable").on('click', function (e) {

                addItemToTableNEWPO();
                
                
            });

            function addItemToTableNEWPO()
            {
                var leverandor  =  $('#<%=txtbxSupplier.ClientID%>').val()
                var ankomst     =  $('#<%=txtbxExpDelivery.ClientID%>').val()
                var ordretype   =  $('#<%=ddlOrderType.ClientID%>').val()
                var frakt       =  $('#<%=ddlDeliveryMethod.ClientID%>').val()
                var nr = $('#<%=TextBox1.ClientID%>').val()
                var vgruppe = myNameSpace.get("item_catg_desc");
                var ant         =  1
                var kost        =  1
                var total       =  1
                
             
                if (validFields(leverandor,ankomst, ordretype, frakt, vgruppe, nr, ant, kost, total))
                {
                    if (addItemToTable("#item-table", nr))
                    {
                      
                        $("#item-table").tabulator("addData", [{ ITEM_CATG_DESC: 0, ID_ITEM: nr, ORDERQTY: ant, BUYCOST: kost, TOTALCOST: total }], false);
                        $("#btnSavePurchaseOrderSuggestion").removeClass("disabled");
                        $("#btnSavePurchaseOrderConfirmation").removeClass("disabled");
                        $('#<%=txtbxSpareNum.ClientID%>').val("");
                        //emptyAllFields(false);
                    }
                    else
                    {
                        alert("Denne varen finnes allerede på ordren. Du kan endre antallet manuelt i tabellen");
                    }
                    
                }
                
            }

            $(window).resize(function () {
                $("#item-table").tabulator("redraw", true); //trigger full rerender including all data and rows
            });
            
            /* When clicking delete item(fjern vare) delete the selected row */

            function deleteRowsFromTable(tablename)
            {
                var selectedRows = $(tablename).tabulator("getSelectedRows");
                console.log(selectedRows);
                for(i = 0; i < selectedRows.length; i++)
                {
                    if ($(tablename).tabulator("getRows").length === 1)
                    {
                        if (confirm("Du vil nå slette siste varen på ordren, og bestillingen vil bli slettet. Ønsker du dette?"))
                        {
                            selectedRows[i].delete();
                        }
                        
                    }
                    else
                    {

                        selectedRows[i].delete();

                    }
                    
                }
            }
            $("#btnDeleteRowModal").on('click', function (e) {

                if (confirm("Vil du slette varen(e)?")) {
                    deleteRowsFromTable("#item-table-modal");
                }


            });

            $("#btnDeleteRow").on('click', function (e) {
                
                if (confirm("Vil du slette varen(e)?"))
                {
                    deleteRowsFromTable("#item-table");
                }
                

            });


            /** BEFORE ADDING AN ITEM TO THE TABLE, WE NEED TO VALIDATE THE FIELDS WHETHER THEY ARE FILLED CORRECTLY ETC **/
            function validFields(leverandor, ankomst, ordretype, forsendelse, varegruppe, nr, ant, kost, total) 
            {
               
                var retValue = 1;
                var alreadyAlerted = 0;

                if ($.inArray(nr, items) !== -1)
                {
                    console.log("nr"+nr);
                    console.log(items);
                    alert("Denne varen er allerede lagt til!");
                    retValue = 0;
                    alreadyAlerted = 1;
                }

                if (leverandor == undefined || leverandor == "") {

                    retValue = 0;
                    if (!alreadyAlerted) alert("Leverandør mangler");
                    alreadyAlerted = 1;
                }

                if (ankomst == undefined || ankomst == "") {

                    retValue = 0;
                    if (!alreadyAlerted) alert("Forventet ankomstdato mangler");
                    alreadyAlerted = 1;
                }

                if (ordretype == undefined || ordretype == "") {

                    retValue = 0;
                    if (!alreadyAlerted) alert("Ordretype mangler");
                    alreadyAlerted = 1;
                }
                if(forsendelse === undefined || forsendelse === "")
                {
                    retValue = 0;
                    if (!alreadyAlerted) alert("Forsendelse mangler");
                    alreadyAlerted = 1;
                }


                if (nr === undefined || nr === "") {

                    retValue = 0;
                    if (!alreadyAlerted) alert("Varenr mangler");
                    alreadyAlerted = 1;
                }

              
                return retValue;
            }

            /* TABLE IN TAB PURCHASEORDERS FOR SEARCHING FOR POs */
            
               $("#example-table").tabulator({
                   height: 640, // set height of table, this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
                   minWidth: 20,
                   movableColumns: true, //enable user movable rows
                    layout: "fitColumns", //fit columns to width of table (optional) 
                    responsiveLayout: true,
                    selectable: 1,     //true means we can select a row. 1 means one row is selectable, 2 means 2 etc...
                    //groupBy: "PONUMBER",
                    //groupStartOpen: false,
                    //groupHeader: function (value, count, data) {
                        //value - the value all members of this group share
                        //count - the number of rows in this group
                        //data - an array of all the row data objects in this group
                       /* var str = "";
                        if (count > 1) str = " varer)";
                        else str = " vare )";

                        return value + "<span style='color:#d00; margin-left:10px;'>(" + count + str + "<span style='margin-right:300px;'>";
                    },*/
                 

                    rowContext: function (e, row) {
                        //e - the click event object
                        //row - row component
                        //alert();
                        //e.preventDefault(); // prevent the browsers default context menu form appearing.
                    },
                    

                    ajaxResponse: function (url, params, response) {
                        console.log("url is: " + url);
                        console.log("params is: " + params);
                        
                        //url - the URL of the request
                        //params - the parameters passed with the request
                        //response - the JSON object returned in the body of the response.

                        return response.d; //return the d property of a response json object
                    },

                    headerFilterPlaceholder: "Filtrer data", //set column header placeholder text
                    columns: [ //Define Table Columns
                        { title: "Bestillingsnr", field: "NUMBER", width: 150, align: "center",headerFilter:"input", headerClick:function(e, column){
                            //e - the click event object
                            //column - column component
                            console.log("ss");
                        },},
                        { title: "Leverandørnavn", field: "SUPP_NAME", align: "center", headerFilter: "input" },
                        { title: "Leverandørnr", field: "SUPP_CURRENTNO", align: "center", headerFilter: "input" },
                        //{ title: "Varenr", field: "ID_ITEM", align: "center", headerFilter: "input" },
                        { title: "Ordretype", field: "ID_ORDERTYPE", align: "center", headerFilter: "input" },
                        { title: "Ordredato", field: "DT_CREATED_SIMPLE", sorter: "date", align: "center", headerFilter: "input" },
                        { title: "Forventet levert", field: "DT_EXPECTED_DELIVERY", sorter: "date", align: "center", headerFilter: "input" },
                        //{ title: "Sum", field: "BUYCOST", align: "center", headerFilter: "input" },
                        //{ title: "Antall deler", field: "ORDERQTY", align: "center", headerFilter: "input" },
                       
                        { title: "Bestilling bekreftet", field: "STATUS", align: "center", formatter: "tickCross", headerFilter: "input" },
                        { title: "Levert", field: "FINISHED", align: "center", formatter: "tickCross", headerFilter: "input" },

                    ],


               });

               $(window).resize(function () {
                   $("#example-table").tabulator("redraw", true); //trigger full rerender including all data and rows
               });
            
           
               
            $('#searchbutton').on('click', function (e) {
                console.log("ajax request button clicked");

                var ajaxConfig = {
                    type: "POST", //set request type to Position
                    contentType: 'application/json; charset=utf-8', //set specific content type
                };

                var ponum = $('#<%=txtbxPOnumbersearch.ClientID%>').val();
                console.log(ponum);
                if (ponum == "" || ponum == undefined)
                {
                    ponum = "%";
                }

                var supp = $('#<%=txtbxInfoSupplier.ClientID%>').val();
                if (supp == "" || supp == undefined)
                {
                    supp = "%";
                }
                var spare = $('#<%=txtbxSparepartNumber.ClientID%>').val();
                if (spare == "" || spare == undefined) {
                    spare = "%";
                }

                var from = $('#<%=txtbxDateFrom.ClientID%>').val();
                if (from == "" || from == undefined) {
                    from = 0;
                }
                else { from = convertDate(from); }
                
                var to = $('#<%=txtbxDateTo.ClientID%>').val();
                if (to == "" || to == undefined) {
                    to = 0;
                }
                else { to = convertDate(to); }
                
                var isdel = true;
                
                $("#example-table").tabulator("setData", "PurchaseOrder.aspx/Fetch_PurchaseOrders", "{'POnum': '" + ponum + "', 'supplier': '" + supp + "', 'fromDate': '" + from + "', 'toDate': '" + to + "', 'spareNumber': '" + "%" + "', 'isDelivered': '" + "%" + "', 'isConfirmedOrder': '" + true + "', 'isUnconfirmedOrder': '" + true + "', 'isExactPOnum': '" + false + "', 'isExactSupp': '" + false + "'}", ajaxConfig); //make ajax request with advanced config options
                $("#example-table").tabulator("redraw",true);
            });




            /* RESTORDER TABLE */

            $("#restorder-table").tabulator({
                height: 340, // set height of table, this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
                layout: "fitColumns", //fit columns to width of table (optional)                  

                /*ajaxResponse: function (url, params, response) {
                    console.log("url is: " + url);
                    console.log("params is: " + params);
                    console.log("response is: " + response);
                    //url - the URL of the request
                    //params - the parameters passed with the request
                    //response - the JSON object returned in the body of the response.

                    return response.d; //return the d property of a response json object
                },*/

                columns: [ //Define Table Columns
                    { title: "Bestillingsnr", field: "PONUMBER", width: 150, align: "center" , headerFilter: "input"},      
                    { title: "Leverandørnavn", field: "SUPP_NAME", align: "center", headerFilter:"input"},
                    { title: "Ordreslag", field: "ID_ORDERTYPE", align: "center", headerFilter: "input" },
                    { title: "Ordredato", field: "DT_POORDER", sorter: "date", align: "center", headerFilter: "input" },
                    { title: "Forventet levert", field: "DT_EXPDLVDATE", sorter: "date", align: "center", headerFilter: "input" },
                    { title: "Sum", field: "BUYCOST", align: "center", headerFilter: "input" },
                    { title: "Antall deler", field: "DELIVERED", align: "center", headerFilter: "input" },
                    { title: "Levert", field: "DELIVERED", align: "center", formatter: "tickCross", headerFilter: "input" },

                ],


            });
            $(window).resize(function () {
                $("#restorder-table").tabulator("redraw", true); //trigger full rerender including all data and rows
            });
            

          
        });
        
    </script>


    <asp:HiddenField ID="hdnSelect" runat="server" />
    <div class="overlayHide">
        <asp:Label ID="RTlblError" runat="server" CssClass="lblErr" meta:resourcekey="RTlblErrorResource1"></asp:Label>
    </div>
    <div id="systemMessage" class="ui message"></div>

    <div class="ui grid">
        <div id="tabFrame" class="sixteen wide column">
            <input type="button" id="btnPurchaseOrders" value="Bestillinger" class="cTab ui btn" data-tab="PurchaseOrders" />
            <input type="button" id="btnNewPurchaseOrder" value="Ny bestilling" class="cTab ui btn" data-tab="NewPurchaseOrder" />
            <input type="button" id="btnRestOrder" value="Restordre" class="cTab ui btn" data-tab="RestOrder" />
        </div>
    </div>


    <%--Begin tab PurchaseOrders--%>

    <div id="tabPurchaseOrders" class="tTab">
        <div class="ui form stackable two column grid ">

            <div class="fifteen wide column">

                <h3 id="lblPOsearch" runat="server" class="ui top attached tiny header">Bestillingssøk:</h3>
                <div class="ui attached segment">
                    <label class="inHeaderCheckbox">
                        View/Hide
                            <button id="btnViewDetails" class="ui btn mini">
                                <i class="caret down icon"></i>
                            </button>
                    </label>
                    <div class="searchvalues-container">
                        <div class="fields">
                            <div class="six wide field">
                            </div>
                            <div class="six wide field">
                            </div>

                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblPOnumber" runat="server">Bestillingsnummer</label>
                                <asp:TextBox ID="txtbxPOnumbersearch" runat="server" data-submit="ID_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>


                        </div>

                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblInfoSupplier" runat="server">Leverandør</label>
                                <asp:TextBox ID="txtbxInfoSupplier" runat="server" data-submit="ID_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>


                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="lblSparepartNumber" runat="server">Vare</label>
                                <asp:TextBox ID="txtbxSparepartNumber" runat="server" data-submit="ITEM_DISC_CODE_BUY" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>



                        </div>
                        <div class="fields">
                            <div class="one wide field">
                                <label id="lblDateFrom" runat="server">Fra dato</label>
                                <asp:TextBox ID="txtbxDateFrom" runat="server" data-submit="ANNOTATION" meta:resourcekey="txtTechMakeResource1" Enabled="false"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                                <label id="lblDateTo" runat="server">Til dato</label>
                                <asp:TextBox ID="txtbxDateTo" runat="server" data-submit="ANNOTATION" meta:resourcekey="txtTechMakeResource1" Enabled="false"></asp:TextBox>
                            </div>

                        </div>

                        <div class="fields">
                            <div class="three wide field">

                                <div class="ui toggle checkbox">
                                    <input id="inp_unconfirmedOrder" type="checkbox" name="public" checked="checked">
                                    <label>Forslag</label>
                                </div>


                            </div>
                        </div>
                        <div class="fields">
                            <div class="three wide field">

                                <div class="ui toggle checkbox">
                                    <input id="inp_confirmedOrder" type="checkbox" name="public" checked="checked">
                                    <label>Bestilling</label>
                                </div>


                            </div>
                        </div>

                        <div class="fields">
                            <div class="six wide field">
                                <div class="inline field">
                                    <div class="justForLabelSize">
                                        <label id="lbl_not_del">Ikke levert</label>
                                        <div class="ui toggle checkbox">

                                            <input id="deliver_notdeliver" type="checkbox" name="public">
                                           <label id="lbl_del">Levert</label>
                                        </div>
                                        
                                        
                                    </div>
                                </div>


                            </div>
                        </div>
                        <div class="fields">
                            <div class="three wide field">

                                <input type="button" id="searchbutton" value="Søk" class="ui orange button" />
                              


                            </div>

                        </div>

                    </div>
            </div>
            </div>
            <%--End of Purchase order segment--%>
            <div class="fifteen wide column">
                <div id="example-table" class="mytabulatorclass"></div>
            </div>



        </div>
    </div>

    <%--End tab PurchaseOrders--%>


    <%--Begin tab NewPurchaseOrder--%>

    <div id="tabNewPurchaseOrder" class="tTab">
        <div class="ui form stackable two column grid ">
            <div class="fifteen wide column">
                
                <h3 id="lblPurchaseDetails" class="ui top attached tiny header">Bestillingsdetaljer</h3>
                <div class="ui attached segment">
                    
                    
                    
                    <asp:Label ID="lblSerialnrPO" class="inHeaderTextField1" Text="Serienr. Bestilling:" runat="server"></asp:Label>
                    <asp:Label ID="lblSerNum" class="inHeaderTextField2" Text="" runat="server"></asp:Label>
                    <asp:Label ID="lblOD" class="inHeaderTextField3" Text="Bestillingsdato:" runat="server"></asp:Label>
                    <asp:Label ID="lblOrderDate" class="inHeaderTextField4" Text="" runat="server"></asp:Label>
                    <label class="inHeaderCheckbox">
                        Vis/Lukk
                            <button id="btnViewDetailsNEWPO" class="ui btn mini">
                                <i class="caret down icon"></i>
                            </button>
                    </label>
                    <div class="itemadd-container">
                
               
                    <div class="fields">

                        <div class="two wide field">
                            <label id="Label2" runat="server">Leverandør</label>

                        </div>
                        
                        <div class="three wide field">
                            <asp:TextBox ID="txtbxSupplier" runat="server" data-submit="SAVE_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            
                        </div>

                        <div class="one wide field">
                            <asp:TextBox ID="txtbxSupplierNameNEWPO" runat="server" Enabled="false" ForeColor="Red"></asp:TextBox>
                            
                            
                        </div>
                        </div>
                       
                    <div class="fields">
                         <div class="two wide field">
                            <label id="Label4" runat="server">Ordretype</label>
                        </div>
                        <div class="two wide field">
                            <asp:DropDownList ID="ddlOrderType" CssClass="dropdowns" runat="server" meta:resourcekey="ddlordertypeFormResource1">
                                <asp:ListItem Text="" Value="" Selected="true"/>
                                <asp:ListItem Text="RE" Value="RE" />
                                <asp:ListItem Text="LO" Value="LO"/>
                            </asp:DropDownList>
                        </div>
                        <div class="one wide field">
                                <input type="button" id="btnAdvSalesman" runat="server" class="ui btn mini" value="+" />
                         </div>
                        </div>
                    
                    <div class="fields">
                        <div class="two wide field">
                            <label id="Label5" runat="server">Forsendelsesmåte</label>
                        </div>
                        
                        <div class="three wide field">
                            <asp:DropDownList ID="ddlDeliveryMethod" CssClass="dropdowns" runat="server" meta:resourcekey="ddlordertypeFormResource1">
                                <asp:ListItem Text="" Value="" Selected="true"/>
                                <asp:ListItem Text="Tog" Value="66" />
                                <asp:ListItem Text="Bil" Value="Bil" />
                                <asp:ListItem Text="Hente selv" Value="Hente selv"/>
                            </asp:DropDownList>
                        </div>
                        </div>
                    
                    
                   <div class="fields">

                        <div class="two wide field">
                            <label id="Label3" runat="server">Forventet ankomst</label>
                        </div>
                        <div class="two wide field">
                            <asp:TextBox ID="txtbxExpDelivery" CssClass="NEWpodatepicker" runat="server" data-submit="SAVE_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1" ForeColor="Red" Enabled="false" ></asp:TextBox>
                        </div>
                        
                       
                        </div>
                                                                                                               
                </div>
                    </div>
            </div>
            <div class="fifteen wide column">
                <h3 id="lblNPOchange" runat="server" class="ui top attached tiny header">Varedetaljer:</h3>
                <div class="ui attached segment">
                    <div class="fields">
                        <div class="two wide field">
                            <label id="Label7" runat="server">Varenr</label>
                        </div>
                        
                        <div class="three wide field">
                            <asp:TextBox ID="txtbxSpareNum" runat="server" data-submit="SAVE_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1" Enabled="false"></asp:TextBox>
                        </div>
                        
                        <div class="two wide field">
                            <asp:TextBox ID="TextBox1" runat="server" Enabled="false" ForeColor="Red" ></asp:TextBox>
                                                     
                        </div>
                        
                        
                    </div>
                    <div class="fields">
                        <div class="two wide field">
                            <label id="Label11" runat="server">Kostpris</label>
                        </div>
                        
                        <div class="two wide field">
                            <asp:TextBox ID="TextBox8" runat="server" data-submit="SAVE_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1" Enabled="true"></asp:TextBox>
                        </div>
                        
                        
                        
                    </div>
                    <div class="fields">
                        <div class="two wide field">
                            <label id="Label12" runat="server">Antall</label>
                        </div>
                       
                        <div class="two wide field">
                            <asp:TextBox ID="TextBox9" runat="server" data-submit="SAVE_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1" Enabled="true"></asp:TextBox>
                        </div>
                        
                        
                        
                    </div>
                    
                                                            
                    <input type="button" id="btnAddItemToTable" value="Legg til vare" class="ui button positive" />
                    <input type="button" id="btnDeleteRow" value="Fjern vare" class="ui button negative disabled" />
                </div>
            </div>
            <div class="fifteen wide column">
                <div id="item-table" class="mytabulatorclass"></div>
                <input type="button" id="btnSavePurchaseOrderSuggestion" value="Lagre forslag" class="ui button orange disabled" />
                <input type="button" id="btnSavePurchaseOrderConfirmation" value="Send Bestilling" class="ui button positive disabled" />
            </div>
            
        </div>
    </div>

    <%-- Salesman Modal --%>
    <div id="modAdvSalesman" class="modal hidden">
        <div class="modHeader">
            <h2 id="lblAdvSalesman" runat="server">Ordretype</h2>
            <div class="modClose"><i class="remove icon"></i></div>
        </div>
        <div class="modContent">
            <div class="ui form">
                <div class="field">
                    <label class="sr-only">Nytt kjøretøy</label>
                    <div class="ui small info message">
                        <p id="lblAdvSalesmanStatus" runat="server">Ordretypestatus</p>
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
                                   
                                </select>--%>
                            </div>
                            <div class="eight wide field">
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanCode" Text="Leverandør" runat="server" meta:resourcekey="lblAdvSalesmanCodeResource1"></asp:Label></label>
                                    <asp:TextBox ID="txtAdvSalesmanLogin" runat="server" meta:resourcekey="txtAdvSalesmanLoginResource1"></asp:TextBox>
                                </div>
                                <div class="field">
                                    <label>
                                        <asp:Label ID="lblAdvSalesmanFname" Text="Ordretype" runat="server" meta:resourcekey="lblAdvSalesmanFnameResource1"></asp:Label></label>
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
   

    <%--End tab NewPurchaseOrder--%>


   
    
    
    
    
    
    
    
     <%--Begin tab RestOrder--%>
    

    <div id="tabRestOrder" class="tTab">
        <div class="ui form stackable two column grid ">

            <div class="fifteen wide column">

                <h3 id="H1" runat="server" class="ui top attached tiny header">Restordresøk:</h3>
                <div class="ui attached segment">
                    <label class="inHeaderCheckbox">
                        Vis/Lukk
                            <button id="btnViewDetailsRestorder" class="ui btn mini">
                                <i class="caret down icon"></i>
                            </button>
                    </label>
                    <div class="rest-containers">
                        <div class="fields">
                            <div class="six wide field">
                            </div>
                            <div class="six wide field">
                            </div>

                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="Label1" runat="server">Bestillingsnummer</label>
                                <asp:TextBox ID="TextBox2" runat="server" data-submit="ID_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>


                        </div>

                        <div class="fields">
                            <div class="two wide field">
                                <label id="Label6" runat="server">Leverandør</label>
                                <asp:TextBox ID="TextBox3" runat="server" data-submit="ID_SUPPLIER_ITEM" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>


                        </div>
                        <div class="fields">
                            <div class="two wide field">
                                <label id="Label8" runat="server">Vare</label>
                                <asp:TextBox ID="TextBox4" runat="server" data-submit="ITEM_DISC_CODE_BUY" meta:resourcekey="txtTechMakeResource1"></asp:TextBox>
                            </div>



                        </div>
                        <div class="fields">
                            <div class="one wide field">
                                <label id="Label9" runat="server">Fra dato</label>
                                <asp:TextBox ID="TextBox5" runat="server" data-submit="ANNOTATION" meta:resourcekey="txtTechMakeResource1" Enabled="false"></asp:TextBox>
                            </div>
                            <div class="one wide field">
                                <label id="Label10" runat="server">Til dato</label>
                                <asp:TextBox ID="TextBox6" runat="server" data-submit="ANNOTATION" meta:resourcekey="txtTechMakeResource1" Enabled="false"></asp:TextBox>
                            </div>

                        </div>

                        
                       
                        <div class="fields">
                            <div class="three wide field">

                                <input type="button" id="searchbuttonRestorder" value="Søk" class="ui orange button" />
                              


                            </div>

                        </div>

                    </div>
            </div>
            </div>
            <%--End of search segment--%>
            <div class="fifteen wide column">
                <div id="restorder-table" class="mytabulatorclass"></div>
            </div>



        </div>
    </div>

    <%--End tab RestOrder--%>




    <%--MODALS--%>


    <div class="ui modal" id="modal_po_steps">
        <a class="ui red ribbon label">Oversikt</a>
        <i class="close icon"></i>
        <div class="header">
             <div class="ui three top attached steps">                   
                    <div class="active step" id="step_po_first">
                        <i class="payment icon"></i>
                        <div class="content">
                            <div class="title">Bestillingsforslag</div>
                            <div class="description">Legg til varer og fyll ut ordredetaljer</div>
                        </div>
                    </div>
                 <div class="disabled step" id="step_po_second">
                     <i class="truck icon"></i>
                     <div class="content">
                         <div class="title">Send bestilling</div>
                         <div class="description">Verifiser bestillingsdetaljer</div>
                     </div>
                 </div>
                 <div class="disabled step" id="step_po_third">
                     <i class="info icon"></i>
                     <div class="content">
                         <div class="title">Ordrestatus</div>
                         <div class="description">Se status for ordre</div>
                     </div>
                 </div>

             </div>
        </div>
        <div class="content">
              
                <div class="modal_po_divstep1">
                    
                    <div class="ui header">Legg til varer</div>
                    <div class="fields">
                        <div class="six wide field">
                            <div class="ui red horizontal label">Serienummer</div>
                            <a class="detail" id="pomodal_details_ponumber"></a>


                            <div class="ui blue horizontal label" style="margin-left: 2em">Leverandør</div>
                            <a class="detail" id="pomodal_details_supplier"></a>

                            <div class="ui green horizontal label" style="margin-left: 2em"">Ordretype</div>
                            <a class="detail" id="pomodal_details_ordertype"></a>

                        </div>

                    </div>
                    <div class="fields">
                        <div class="six wide field">
                            <div class="ui small right labeled input" style="margin-top: 2em" id="txtbxSparepartModalparent">
                                <input type="text" placeholder="Søk vare" id="txtbxSparepartModal" />
                                
                                <div class="ui small dropdown label" id="ddlLocalNonstock">
                                    <div class="text">Lokal</div>
                                    <i class="dropdown icon"></i>
                                    <div class="menu">
                                        <div class="item">Lokal</div>
                                        <div class="item">Non-stock</div>
                                        
                                    </div>
                                </div>
                                
                                
                            </div>
                            <div class="ui small right labeled input" id="txtbxCostModalparent">
                                <input type="text" id="txtbxCostModal" class="inputNumberDot"/>
                            </div>
                            <div class="ui small right labeled input" id="txtbxQuantityModalparent" >
                                <input type="text" id="txtbxQuantityModal" class="inputNumberDot"/>
                            </div>
                            
                            
                            <input type="button" id="btnAddItemToTableModal" value="Legg til vare" class="ui button positive disabled" />
                            <input type="button" id="btnDeleteRowModal" value="Fjern vare" class="ui button negative disabled" />

                        </div>
                        
                            
                                <div class="ui pointing red basic label " id="modalPointingLabel">Ugyldig vare!</div>
  
                              <div class="ui pointing red basic label " id="modalPointingLabelPrice" style="margin-left: 14em">Kostpris!</div>
                 

                        </div>
                   
                   
                    



                    <div id="item-table-modal" class="mytabulatorclass"></div>



                </div>
                     
                <div class="modal_po_divstep2">
                    <div class="ui header">Bestillingsdetaljer</div>
                    <div class="fields">
                        <div class="three wide field">
                            <div class="ui red horizontal label">Forventet levering</div>
                            <a class="detail" id="pomodal_details_expdel"></a>
                            <div class="ui green horizontal label" style="margin-left: 2em">Forsendelsesmåte</div>
                            <a class="detail" id="pomodal_details_delmethod"></a>
                           
                        </div>
                        <input type="button" id="btnDownloadCSV" value="Last ned csv" class="ui button positive"  style="margin-top: 2em"/>
                    </div>

                </div>
                <div class="modal_po_divstep3">
                    <div class="ui header">Bestillingsdetaljer</div>
                    <div class="fields">
                        <div class="three wide field">
                            <div class="ui label">
                                Her er detaljene
                            </div>
                        </div>
                    </div>

                </div>
            

        </div>
        <div class="actions">
            <div class="ui red deny button" id="po_modal_cancel"> Avbryt </div>
            <div class="ui disabled left labeled icon button" id="po_modal_previous"> 
                Forrige 
                <i class="chevron left icon"></i>
            </div>
            <div class="ui positive right labeled icon button" id="po_modal_next">
                <div>Neste</div> 
                 
                <i class="chevron right icon"></i>
            </div>



        </div>
    </div>


    <div class="ui basic modal" id="modal_po_confirmorder">
        <div class="ui icon header">
            <i class="archive icon"></i>
            Archive Old Messages
        </div>
        <div class="content">
            <p>Your inbox is getting full, would you like us to enable automatic archiving of old messages?</p>
        </div>
        <div class="actions">
            <div class="ui red basic cancel inverted button">
                <i class="remove icon"></i>
                No
            </div>
            <div class="ui green ok inverted button">
                <i class="checkmark icon"></i>
                Yes
            </div>
        </div>
    </div>

</asp:Content>


