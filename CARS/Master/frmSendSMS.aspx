<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="frmSendSMS.aspx.vb" Inherits="CARS.frmSendSMS" MasterPageFile="~/MasterPage.Master" %>

<%@ PreviousPageType VirtualPath="~/master/frmCustomerDetail.aspx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            //$('#txtContactPerson').val("LOADED");;
            $('#tabSMSMessage').removeClass('hidden');
            $('#btnSMSMessage').addClass('tabActive');
            if ($('#<%=txtEmail.ClientID%>:text').val().length == 0)
                $('#<%=cbSendEmail.ClientID%>').prop('disabled', true);
            else
                $('#<%=cbSendEmail.ClientID%>').prop('disabled', false);
            <%--if ($('#<%=txtMobile.ClientID%>:text').val().length == 0)
                $('#<%=cbSendSMS.ClientID%>').prop('disabled', true);
            else
                $('#<%=cbSendSMS.ClientID%>').prop--%>('disabled', false);

            //#btnSMSMessage, #btnSMSTexts, #btnAutomation, #btnGroupSMS, #btnSMSHistory, #btnEmailHistory, #btnConfiguration
            //#tabSMSMessage, #tabSMSTexts, #tabAutomation, #tabGroupSMS, #tabSMSHistory, #tabEmailHistory, #tabConfiguration
            var clickedNew = 0;
            $('#modSMSTexts').addClass('hidden');
            $('#tabAutomation, #tabGroupSMS, #tabSMSHistory, #tabEmailHistory, #tabConfiguration').addClass('hidden');
            $('.overlayHide').removeClass('ohActive');

            $('#btnSMSMessage').on('click', function () {
                $('#tabAutomation, #tabGroupSMS, #tabSMSHistory, #tabEmailHistory, #tabConfiguration').addClass('hidden');
                $('#tabSMSMessage').removeClass('hidden');
                $('#btnSMSTexts, #btnAutomation, #btnGroupSMS, #btnSMSHistory, #btnEmailHistory, #btnConfiguration').removeClass('tabActive');
                $('#btnSMSMessage').addClass('tabActive');
            });

            //$('#btnSMSTexts').on('click', function () {
            //    //$('#txtContactPerson').val("LOADED");
            //    $('#tabSMSMessage, #tabAutomation, #tabGroupSMS, #tabSMSHistory, #tabEmailHistory, #tabConfiguration').addClass('hidden');
            //    $('#tabSMSTexts').removeClass('hidden');
            //    $('#btnSMSMessage, #btnAutomation, #btnGroupSMS, #btnSMSHistory, #btnEmailHistory, #btnConfiguration').removeClass('tabActive');
            //    $('#btnSMSTexts').addClass('tabActive');
            //});

            $('#btnAutomation').on('click', function () {
                //$('#txtContactPerson').val("LOADED");
                $('#tabSMSMessage, #tabGroupSMS, #tabSMSHistory, #tabEmailHistory, #tabConfiguration').addClass('hidden');
                $('#tabAutomation').removeClass('hidden');
                $('#btnSMSMessage, #btnSMSTexts, #btnGroupSMS, #btnSMSHistory, #btnEmailHistory, #btnConfiguration').removeClass('tabActive');
                $('#btnAutomation').addClass('tabActive');
            });

            $('#btnGroupSMS').on('click', function () {
                //$('#txtContactPerson').val("LOADED");
                $('#tabSMSMessage, #tabAutomation, #tabSMSHistory, #tabEmailHistory, #tabConfiguration').addClass('hidden');
                $('#tabGroupSMS').removeClass('hidden');
                $('#btnSMSMessage, #btnSMSTexts, #btnAutomation, #btnSMSHistory, #btnEmailHistory, #btnConfiguration').removeClass('tabActive');
                $('#btnGroupSMS').addClass('tabActive');
            });

            $('#btnSMSHistory').on('click', function () {
                //$('#txtContactPerson').val("LOADED");
                $('#tabSMSMessage, #tabAutomation, #tabGroupSMS, #tabEmailHistory, #tabConfiguration').addClass('hidden');
                $('#tabSMSHistory').removeClass('hidden');
                $('#btnSMSMessage, #btnSMSTexts, #btnAutomation, #btnGroupSMS, #btnEmailHistory, #btnConfiguration').removeClass('tabActive');
                $('#btnSMSHistory').addClass('tabActive');
            });

            $('#btnEmailHistory').on('click', function () {
                //$('#txtContactPerson').val("LOADED");
                $('#tabSMSMessage, #tabAutomation, #tabGroupSMS, #tabSMSHistory, #tabConfiguration').addClass('hidden');
                $('#tabEmailHistory').removeClass('hidden');
                $('#btnSMSMessage, #btnSMSTexts, #btnAutomation, #btnGroupSMS, #btnSMSHistory, #btnConfiguration').removeClass('tabActive');
                $('#btnEmailHistory').addClass('tabActive');
            });

            $('#btnConfiguration').on('click', function () {
                //$('#txtContactPerson').val("LOADED");
                $('#tabSMSMessage, #tabAutomation, #tabGroupSMS, #tabSMSHistory, #tabEmailHistory').addClass('hidden');
                $('#tabConfiguration').removeClass('hidden');
                $('#btnSMSMessage, #btnSMSTexts, #btnAutomation, #btnGroupSMS, #btnSMSHistory, #btnEmailHistory').removeClass('tabActive');
                $('#btnConfiguration').addClass('tabActive');
            });
            //$('#txtLastRegDate').datepicker();
            //jQuery('#datetimepicker3').datetimepicker({
            //    format: 'd.m.Y H:i',
            //    inline: true,
            //    lang: 'no'
            //});
            //$('#datePicker1').datepicker();
            //$('#datePicker1').on('click', function () {
            //    jQuery('#datetimepicker3').datetimepicker('show');
            //});

            $('#<%=optSMSText.ClientID%>').on('change', function () {
                $('#<%=txtSMSText.ClientID%>').val($('#<%=optSMSText.ClientID%> option:selected').text());
            });

            $('#<%=btnEditSMSText.ClientID%>').on('click', function () {
                $('.overlayHide').addClass('ohActive');
                $('#modSMSTexts').removeClass('hidden');
                $('#<%=txtEditSMSText.ClientID%>').val($('#<%=txtSMSText.ClientID%>').val());
            });
            $('#<%=txtEmail.ClientID%>').on('blur', function () {
                if ($('#<%=txtSubject.ClientID%>:text').val().length == 0 || $('#<%=txtEmail.ClientID%>:text').val().length == 0)
                    $('#<%=cbSendEmail.ClientID%>').prop('disabled', true);
                else
                    $('#<%=cbSendEmail.ClientID%>').prop('disabled', false);
            });
            $('#<%=txtSubject.ClientID%>').on('blur', function () {
                if ($('#<%=txtSubject.ClientID%>:text').val().length == 0 || $('#<%=txtEmail.ClientID%>:text').val().length == 0)
                    $('#<%=cbSendEmail.ClientID%>').prop('disabled', true);
                else
                    $('#<%=cbSendEmail.ClientID%>').prop('disabled', false);
            });
            $('#btnEditSMSSave').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modSMSTexts').addClass('hidden');
                $('#<%=txtSMSText.ClientID%>').val($('#<%=txtEditSMSText.ClientID%>').val());
                if (clickedNew == 0) {
                    var count = $("#<%=optSMSText.ClientID%>").val();
                    //Save to database
                }
                else {
                    var count = $("#<%=optSMSText.ClientID%> option").length;
                    //Save to database
                    //$("<option value=" + count + ">" + $('#<%=txtEditSMSText.ClientID%>').val() + "</option>").appendTo("#<%=optSMSText.ClientID%>");
                }
                clickedNew = 0;
            });

            $('#btnEditSMSCancel').on('click', function () {
                $('.overlayHide').removeClass('ohActive');
                $('#modSMSTexts').addClass('hidden');
            });
            $('#btnEditSMSNew').on('click', function () {
                clickedNew = 1;
                $('#<%=txtEditSMSText.ClientID%>').val('');
            });


            $('.modClose').on('click', function () {
                $('#modSMSTexts').addClass('hidden');
                $('.overlayHide').removeClass('ohActive');
            });

            $.datepicker.setDefaults($.datepicker.regional["no"]);

            $('#<%=txtSendDate.ClientID%>').on('click', function () {
                //$(function () {
                $(".txtSendDate").datepicker({
                    altField: '#txtSendDate',
                    showWeek: true
                });
                //$("#txtSendDate").datepicker("show");


            });
            //$("#txtSendDate").datepicker({
            //    buttonImage: "../images/calendar_icon.gif",
            //    buttonImageOnly: true,
            //    showOn: "button",
            //    //altField: '#txtSendDate',
            //    showWeek: true
            //});
            //$("#btnSendDate").on('click', function () {

            //    //$.datepicker({
            //    //    altField: '#txtSendDate',
            //    //    showWeek: true
            //    //});
            //    $(".btnSendDate").datepicker("show");
            //    //alert('heisan');
            //});

            //$(".btnSendDate").datepicker("show");

            //function calendar() {
            //    datepicker("show");
            //};

            $("#<%=txtSendDate.ClientID%>").datepicker({
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
            //calendar();
            //$('#txtSendDate').blur(function () {
            //    var str = $('#txtSendDate').val();
            //    if ($('#txtSendDate').val() == "dd") {
            //        $('#txtSendDate').val($.datepicker.formatDate('dd.mm.yy', new Date()));
            //    }
            //    if ($('#txtSendDate').val().length == 6) {
            //        $('#txtSendDate').val($.datepicker.formatDate('dd.mm.yy', new Date("20" + str.substr(4, 2), str.substr(2, 2) - 1, str.substr(0, 2))));
            //    }
            //    if ($('#txtSendDate').val().length == 8) {
            //        $('#txtSendDate').val($.datepicker.formatDate('dd.mm.yy', new Date(str.substr(4, 4), str.substr(2, 2) - 1, str.substr(0, 2))));
            //    }
            //});

            /*   GENERAL FUNCTIONS   */
            $('#click').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $('#carsWrapper').toggleClass('on');
            });

        });

    </script>
    <div class="overlayHide ohActive"></div>
    <div id="carsWrapper">
        <div id="carsContent">
            <div class="ui grid">
                <div class="sixteen wide column">
                    <div class="ui form ">
                        <div class="ui grid">
                            <div class="sixteen wide column">
                                <input type="button" value="SMS Message" id="btnSMSMessage" class="ui btn" />
                                <input type="button" value="Automation" id="btnAutomation" class="ui btn" />
                                <input type="button" value="Group SMS" id="btnGroupSMS" class="ui btn" />
                                <input type="button" value="SMS History" id="btnSMSHistory" class="ui btn" />
                                <input type="button" value="Email History" id="btnEmailHistory" class="ui btn" />
                                <input type="button" value="Configuration" id="btnConfiguration" class="ui btn" />
                            </div>
                        </div>
                        <div class="ui divider"></div>
                    </div>
                </div>
            </div>

            <div id="modSMSTexts" class="hidden">
                <div class="modHeader">
                    <h2>Edit SMS Text</h2>
                    <div class="modClose"><i class="remove icon"></i></div>
                </div>
                <div class="ui grid">
                    <div class="one wide column"></div>
                    <div class="fifteen wide column">
                        <div class="ui form">
                            &nbsp
                                   
                            <div class="fields">
                                <div class="fourteen wide field">
                                    <asp:TextBox ID="txtEditSMSText" runat="server" CssClass="texttest" TextMode="multiline"></asp:TextBox>
                                </div>
                            </div>
                            &nbsp
                                   
                            <div class="fields">
                                <div class="one wide field">
                                </div>
                                <div class="four wide field">
                                    <input type="button" id="btnEditSMSSave" class="ui btn wide" value="Save" />
                                </div>
                                <div class="four wide field">
                                    <input type="button" id="btnEditSMSCancel" class="ui btn wide" value="Cancel" />
                                </div>
                                <div class="four wide field">
                                    <input type="button" id="btnEditSMSNew" class="ui btn wide" value="New" />
                                </div>
                                <div class="one wide field">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%--                    ############################### tabSMSMessage ##########################################--%>
            <div id="tabSMSMessage">
                <div class="ui grid">
                    <div class="seven wide column">
                        <div class="ui form ">
                            <div class="fields">
                                <div class="six wide field">
                                    <asp:Label ID="lblName" Text="Name" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="txtName" runat="server" CssClass="texttest" BackColor="#cccccc"></asp:TextBox>
                                </div>
                                <div class="one wide field">
                                    <%--<asp:Label ID="Label17" Text="Name" runat="server" CssClass="centerlabel"></asp:Label>--%>
                                    <asp:TextBox ID="TextBox8" runat="server" CssClass="texttest" Visible="false"></asp:TextBox>
                                </div>
                                <div class="three wide field">
                                    <asp:Label ID="Label9" Text="blank" runat="server" CssClass="blanklabel"></asp:Label>
                                    <label>
                                        <asp:CheckBox ID="cbSendSMS" runat="server" Text="Send SMS" Checked="false" />
                                    </label>
                                </div>
                                <div class="five wide field">
                                    <asp:Label ID="Label15" Text="blank" runat="server" CssClass="blanklabel"></asp:Label>
                                    <label>
                                        <asp:CheckBox ID="cbSendEmail" runat="server" Text="Send Email" Checked="false" />
                                    </label>
                                </div>
                            </div>
                            <div class="fields">
                                <div class="four wide field">
                                    <asp:Label ID="lblMobile" Text="Mobile" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="txtMobile" runat="server" CssClass="texttest"></asp:TextBox>
                                </div>
                                <div class="eight wide field">
                                    <asp:Label ID="lblEmail" Text="Email" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="texttest"></asp:TextBox>
                                </div>
                            </div>
                            <div class="fields">
                                <div class="three wide field">
                                    <asp:Label ID="lblSMSTexts" Text="SMS Texts" runat="server" CssClass="centerlabel"></asp:Label>
                                    <select ID="optSMSText" class="attached dropdowns" runat="server">
                                        <option value="0">Hei, Deres bestilling er nå ankommet vårt lager</option>
                                        <option value="1">Takk for besøket</option>
                                        <option value="2">Takk for alt..</option>
                                    </select>
                                </div>
                                <div class="two wide field">
                                    <asp:Label ID="Label11" Text="blank" runat="server" CssClass="blanklabel"></asp:Label>
                                    <input type="button" value="Edit" id="btnEditSMSText" class="btntest" runat="server" />
                                </div>
                                <div class="seven wide field">
                                    <asp:Label ID="lblSubject" Text="Subject" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="txtSubject" runat="server" CssClass="texttest"></asp:TextBox>
                                </div>
                                <div class="twelve wide field">
                                    <asp:Label ID="lblSMSText" Text="Text" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="txtSMSText" runat="server" CssClass="texttest" TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>
                        <%--</div>--%>
                        <div class="fields">
                            <div class="four wide field">
                                <asp:Label ID="lblSendDate" Text="Send date" runat="server" CssClass="centerlabel"></asp:Label>
                                <asp:TextBox ID="txtSendDate" runat="server" TextMode="Time" CssClass="texttest"></asp:TextBox>
                            </div>
                            <div class="two wide field">
                                    <asp:Label ID="lblTimeToSend" Text="Time" runat="server" CssClass="centerlabel"></asp:Label>
                                    <select id="optTimeToSend" class="attached dropdowns">
                                        <option value="0">00:00</option>
                                        <option value="1">00:30</option>
                                        <option value="2">01:00</option>
                                        <option value="3">01:30</option>
                                        <option value="4">02:00</option>
                                        <option value="5">02:30</option>
                                        <option value="6">03:00</option>
                                        <option value="7">03:30</option>
                                        <option value="8">04:00</option>
                                        <option value="9">04:30</option>
                                        <option value="10">05:00</option>
                                        <option value="11">05:30</option>
                                        <option value="12">06:00</option>
                                        <option value="13">06:30</option>
                                        <option value="14">07:00</option>
                                        <option value="15">07:30</option>
                                        <option value="16">08:00</option>
                                        <option value="17">08:30</option>
                                        <option value="18">09:00</option>
                                        <option value="19">09:30</option>
                                        <option value="20">10:00</option>
                                        <option value="21">10:30</option>
                                        <option value="22">11:00</option>
                                        <option value="23">11:30</option>
                                        <option value="24">12:00</option>
                                        <option value="25">12:30</option>
                                        <option value="26">13:00</option>
                                        <option value="27">13:30</option>
                                        <option value="28">14:00</option>
                                        <option value="29">14:30</option>
                                        <option value="30">15:00</option>
                                        <option value="31">15:30</option>
                                        <option value="32">16:00</option>
                                        <option value="33">16:30</option>
                                        <option value="34">17:00</option>
                                        <option value="35">17:30</option>
                                        <option value="36">18:00</option>
                                        <option value="37">18:30</option>
                                        <option value="38">19:00</option>
                                        <option value="39">19:30</option>
                                        <option value="40">20:00</option>
                                        <option value="41">20:30</option>
                                        <option value="42">21:00</option>
                                        <option value="43">21:30</option>
                                        <option value="44">22:00</option>
                                        <option value="45">22:30</option>
                                        <option value="46">23:00</option>
                                        <option value="47">23:30</option>

                                    </select>
                                </div>
                            <div class="two wide field">
                                <asp:Label ID="Label16" Text="blank" runat="server" CssClass="blanklabel"></asp:Label>
                                <input type="button" value="Send" id="btnSendSMS-Mail" class="btntest" />
                            </div>
                        </div>
                       </div>
                        <div class="eight wide column">
                            <div class="ui form ">
                                <div class="twelve wide field">
                                    <asp:Label ID="lblStatus" Text="Status" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="txtStatus" runat="server" CssClass="texttest"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                     </div>
                </div>
            </div>


            <%--                    ############################### tabAutomation ##########################################--%>
            <div id="tabAutomation">
                <div class="ui grid">
                    <div class="seven wide column">

                        <%--PART 1--%>
                        <div class="ui form">
                            <div class="fields" style="background-color: #E0E0E0">
                                <h4>
                                    <asp:Label ID="lblHandingInOut" Text="Handing in/out to workshop" runat="server" CssClass="centerlabel"></asp:Label></h4>
                            </div>
                        </div>
                        <asp:Label ID="Label2" Text="blank" runat="server" CssClass="blanklabel"></asp:Label>
                        <div class="ui grid">
                            <div class="six wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="ten wide field">
                                            <label>
                                                <asp:CheckBox ID="cbConfirmAppointment" runat="server" Text="Confirm appointment" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="five wide field">
                                            <label>
                                                <asp:CheckBox ID="cbShowSMS1" runat="server" Text="Show SMS" Checked="false" />
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="ten wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <asp:TextBox ID="TextBox4" runat="server" CssClass="texttest" TextMode="multiline" Height="75px"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ui divider"></div>

                        <%--PART 2--%>
                        <div class="ui grid">
                            <div class="six wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="ten wide field">
                                            <label>
                                                <asp:CheckBox ID="cbConfirmHandingIn" runat="server" Text="Confirm handing in" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="five wide field">
                                            <label>
                                                <asp:CheckBox ID="cbShowSMS2" runat="server" Text="Show SMS" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="three wide field">
                                            <asp:TextBox ID="txtHoursBeforeAgreed" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                        <div class="thirteen wide field">
                                            <asp:Label ID="lblHoursBeforeAgreed" Text="hrs. before agreed" runat="server" CssClass="centerlabel"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="ten wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <asp:TextBox ID="txtConfirmHandingIn" runat="server" CssClass="texttest" TextMode="multiline" Height="75px"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ui divider"></div>

                        <%--PART 3--%>
                        <div class="ui grid">
                            <div class="six wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="ten wide field">
                                            <label>
                                                <asp:CheckBox ID="cbConfirmHandingOut" runat="server" Text="Confirm handing out" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="five wide field">
                                            <label>
                                                <asp:CheckBox ID="cbShowSMS3" runat="server" Text="Show SMS" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="three wide field">
                                            <asp:TextBox ID="txtMinBeforeFinish" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                        <div class="thirteen wide field">
                                            <asp:Label ID="lblMinBeforeFinish" Text="min. before agreed finish" runat="server" CssClass="centerlabel"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="ten wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <asp:TextBox ID="txtConfirmHandingOut" runat="server" CssClass="texttest" TextMode="multiline" Height="75px"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%--PART 4--%>
                        <div class="ui form">
                            <div class="fields" style="background-color: #E0E0E0">
                                <h4>
                                    <asp:Label ID="lblWorkshopVisit" Text="Workshop visit" runat="server" CssClass="centerlabel"></asp:Label></h4>
                            </div>
                        </div>
                        <asp:Label ID="Label1" Text="blank" runat="server" CssClass="blanklabel"></asp:Label>
                        <div class="ui grid">
                            <div class="six wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="ten wide field">
                                            <label>
                                                <asp:CheckBox ID="cbFollowUp" runat="server" Text="Followup after visit" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="five wide field">
                                            <label>
                                                <asp:CheckBox ID="cbShowSMS4" runat="server" Text="Show SMS" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="three wide field">
                                            <asp:TextBox ID="txtDaysAfter" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                        <div class="thirteen wide field">
                                            <asp:Label ID="lblDaysAfter" Text="days after" runat="server" CssClass="centerlabel"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="ten wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <asp:TextBox ID="TextBox5" runat="server" CssClass="texttest" TextMode="multiline" Height="75px"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%--PART 5--%>
                        <div class="ui form">
                            <div class="fields" style="background-color: #E0E0E0">
                                <h4>
                                    <asp:Label ID="lblArrivalOrdParts" Text="Arrival ordered parts" runat="server" CssClass="centerlabel"></asp:Label></h4>
                            </div>
                        </div>
                        <asp:Label ID="Label3" Text="blank" runat="server" CssClass="blanklabel"></asp:Label>
                        <div class="ui grid">
                            <div class="six wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="ten wide field">
                                            <label>
                                                <asp:CheckBox ID="cbConfirmReceive" runat="server" Text="Confirm receive parts" Checked="false" />
                                            </label>
                                        </div>
                                        <div class="five wide field">
                                            <label>
                                                <asp:CheckBox ID="cbShowSMS5" runat="server" Text="Show SMS" Checked="false" />
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="ten wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <asp:TextBox ID="txtArrivalOrdParts" runat="server" CssClass="texttest" TextMode="multiline" Height="75px"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%--END PART 5--%>
                    </div>
                </div>
            </div>

            <%--                    ############################### tabGroupSMS ##########################################--%>
            <div id="tabGroupSMS">

                <div class="ui grid">
                    <div class="six wide column">
                        <div class="ui form ">
                            <div class="fields">
                                <div class="six wide field">
                                    <asp:Label ID="lblSMSGroup" Text="Group name" runat="server" CssClass="centerlabel"></asp:Label>
                                    <div class="ten wide field">
                                        <select id="cmbSMSGroup" class="dropdowns">
                                            <option value="0" selected></option>
                                            <option value="1">Test1</option>
                                            <option value="2">Test2</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%--PART 1--%>
                        <div class="ui form">
                            &nbsp
                            <div class="eleven wide field">
                                <div class="fields" style="background-color: #E0E0E0">
                                    <h4>
                                        <asp:Label ID="Label4" Text="Import customers" runat="server" CssClass="centerlabel"></asp:Label></h4>
                                </div>
                            </div>
                            <asp:Label ID="lblSMSCustomer" Text="Customer no." runat="server" CssClass="centerlabel"></asp:Label>
                            <div class="inline fields">
                                <div class="four wide field">
                                    <asp:TextBox ID="txtSMSCustomer" runat="server" CssClass="texttest"></asp:TextBox>
                                </div>
                                <div class="two wide field">
                                    <input type="button" id="btnSMSCustomer" class="btntest" value="Hent">
                                </div>
                            </div>
                        </div>

                        <div class="ui form">
                            &nbsp
                             <div class="eleven wide field">
                                 <div class="fields" style="background-color: #E0E0E0">
                                     <h4>
                                         <asp:Label ID="Label6" Text="Import from file" runat="server" CssClass="centerlabel"></asp:Label></h4>
                                 </div>
                             </div>
                            <asp:Label ID="lblSMSImportfile" Text="File" runat="server" CssClass="centerlabel"></asp:Label>
                            <div class="inline fields">
                                <div class="eight wide field">
                                    <asp:TextBox ID="txtSMSImportfile" runat="server" CssClass="texttest" Width="100%"></asp:TextBox>
                                </div>
                                <div class="two wide field">
                                    <input type="button" id="btnBrowsefolders" class="btntest" value="Browse">
                                </div>
                            </div>
                            <div class="inline fields">
                                <div class="three wide field">
                                    <asp:Label ID="Label10" Text="Name start pos." runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="TextBox1" runat="server" CssClass="texttest" Width="50%"></asp:TextBox>
                                </div>
                                <div class="three wide field">
                                    <asp:Label ID="Label13" Text="Name length" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="TextBox6" runat="server" CssClass="texttest" Width="50%"></asp:TextBox>
                                </div>
                            </div>
                            <div class="inline fields">
                                <div class="three wide field">
                                    <asp:Label ID="Label12" Text="Mob.no start pos." runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="TextBox3" runat="server" CssClass="texttest" Width="50%"></asp:TextBox>
                                </div>
                                <div class="three wide field">
                                    <asp:Label ID="Label14" Text="Mob.no length" runat="server" CssClass="centerlabel"></asp:Label>
                                    <asp:TextBox ID="TextBox7" runat="server" CssClass="texttest" Width="50%"></asp:TextBox>
                                </div>
                                <div class="two wide field">
                                    <input type="button" id="btnSMSImportfile" class="btntest" value="Import">
                                </div>
                            </div>

                        </div>


                        <div class="ui form">
                            &nbsp
                             <div class="eleven wide field">
                                 <div class="fields" style="background-color: #E0E0E0">
                                     <h4>
                                         <asp:Label ID="Label7" Text="Customers birthday" runat="server" CssClass="centerlabel"></asp:Label></h4>
                                 </div>
                             </div>
                            <asp:Label ID="Label5" Text="Birthday" runat="server" CssClass="centerlabel"></asp:Label>
                            <div class="inline fields">
                                <div class="eight wide field">
                                    <asp:TextBox ID="txtBirthday" runat="server" CssClass="texttest"></asp:TextBox>
                                </div>
                                <div class="two wide field">
                                    <input type="button" id="btnBirthday" class="btntest" value="Hent">
                                </div>
                            </div>
                        </div>
                    </div>



                    <div class="six wide column">
                        <div class="ui form ">
                            <div class="fields">
                                <div class="seven wide field">
                                    <asp:Label ID="Label8" Text="Group list" runat="server" CssClass="centerlabel"></asp:Label>
                                    <%--<asp:TextBox ID="TextBox2" runat="server" CssClass="texttest"></asp:TextBox>--%>
                                    <table class="ui celled table">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Mobile</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Cell</td>
                                                <td>Cell</td>
                                            </tr>
                                            <tr>
                                                <td>Cell</td>
                                                <td>Cell</td>
                                            </tr>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th colspan="3">
                                                    <div class="ui right floated pagination menu">
                                                        <a class="icon item">
                                                            <i class="left chevron icon"></i>
                                                        </a>
                                                        <a class="item">1</a>
                                                        <a class="item">2</a>
                                                        <a class="item">3</a>
                                                        <a class="item">4</a>
                                                        <a class="icon item">
                                                            <i class="right chevron icon"></i>
                                                        </a>
                                                    </div>
                                                </th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>


            <%--                    ############################### tabSMSHistory ##########################################--%>
            <div id="tabSMSHistory">
                <table class="ui celled table">
                    <thead>
                        <tr>
                            <th>Phone no.</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>User</th>
                            <th>Text</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                        </tr>
                        <tr>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="3">
                                <div class="ui right floated pagination menu">
                                    <a class="icon item">
                                        <i class="left chevron icon"></i>
                                    </a>
                                    <a class="item">1</a>
                                    <a class="item">2</a>
                                    <a class="item">3</a>
                                    <a class="item">4</a>
                                    <a class="icon item">
                                        <i class="right chevron icon"></i>
                                    </a>
                                </div>
                            </th>
                        </tr>
                    </tfoot>
                </table>
            </div>


            <%--                    ############################### tabEmailHistory ##########################################--%>
            <div id="tabEmailHistory">
                <table class="ui celled table">
                    <thead>
                        <tr>
                            <th>Email</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Subject</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                        </tr>
                        <tr>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                            <td>Cell</td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="3">
                                <div class="ui right floated pagination menu">
                                    <a class="icon item">
                                        <i class="left chevron icon"></i>
                                    </a>
                                    <a class="item">1</a>
                                    <a class="item">2</a>
                                    <a class="item">3</a>
                                    <a class="item">4</a>
                                    <a class="icon item">
                                        <i class="right chevron icon"></i>
                                    </a>
                                </div>
                            </th>
                        </tr>
                    </tfoot>
                </table>
            </div>


            <%--                    ############################### tabConfiguration ##########################################--%>
            <div id="tabConfiguration">
                <div class="ui grid">
                    <div class="eight wide column">
                        <div class="ui grid">
                            <div class="eight wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="eight wide field">
                                            <asp:Label ID="lblUserId" Text="User ID" runat="server" CssClass="centerlabel"></asp:Label>
                                            <asp:TextBox ID="txtUserId" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                        <div class="eight wide field">
                                            <asp:Label ID="lblSMSSender" Text="Sender SMS" runat="server" CssClass="centerlabel"></asp:Label>
                                            <asp:TextBox ID="txtSMSSender" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="eight wide field">
                                            <asp:Label ID="lblPassword" Text="Password" runat="server" CssClass="centerlabel"></asp:Label>
                                            <asp:TextBox ID="txtPassword" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                        <div class="eight wide field">
                                            <asp:Label ID="lblSMSOperator" Text="SMS operator" runat="server" CssClass="centerlabel"></asp:Label>
                                            <asp:TextBox ID="txtSMSOperator" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="sixteen wide field">
                                            <asp:Label ID="lblEmailSender" Text="Sender mail" runat="server" CssClass="centerlabel"></asp:Label>
                                            <asp:TextBox ID="txtEmailSender" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="four wide column">
                                <div class="ui form ">
                                    <div class="fields">
                                        <div class="ten wide field">
                                            &nbsp
                                            <label>
                                                <asp:RadioButton ID="rbSMSTele" runat="server" Text="SMS Telefonkat." GroupName="SMSOperator" Checked="true" AutoPostBack="false" />
                                            </label>
                                            <label>
                                                <asp:RadioButton ID="rbSMSCerum" runat="server" Text="SMS Cerum" GroupName="SMSOperator" Checked="true" AutoPostBack="false" />
                                            </label>
                                            <label>
                                                <asp:RadioButton ID="rbSMSGlobi" runat="server" Text="SMS GlobiSMS" GroupName="SMSOperator" Checked="true" AutoPostBack="false" />
                                            </label>
                                            <div class="sixteen wide field">
                                                <asp:Label ID="lblSMSType" Text="SMS utgave" runat="server" CssClass="centerlabel"></asp:Label>
                                                <asp:TextBox ID="txtSMSType" runat="server" CssClass="texttest"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="four wide column">
                                <div class="ui form">
                                    <div class="fields" style="background-color: #E0E0E0">
                                        <h4>
                                            <asp:Label ID="lblSMSCount" Text="SMS counting" runat="server" CssClass="centerlabel"></asp:Label></h4>
                                    </div>
                                    <div class="fields">
                                        <div class="ten wide field">
                                            <asp:Label ID="lblStart" Text="Start" runat="server" CssClass="centerlabel"></asp:Label>
                                            <asp:TextBox ID="txtStart" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="ten wide field">
                                            <asp:Label ID="lblCount" Text="Count" runat="server" CssClass="centerlabel"></asp:Label>
                                            <asp:TextBox ID="txtCount" runat="server" CssClass="texttest"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="eight wide column">
                            <div class="ui form">
                                &nbsp
                                <div class="fields" style="background-color: #E0E0E0">
                                    <h4>
                                        <asp:Label ID="lblPosttext" Text="Post text" runat="server" CssClass="centerlabel"></asp:Label></h4>
                                </div>
                                &nbsp
                                <div class="fields">
                                    <div class="sixteen wide field">
                                        <asp:TextBox ID="txtPosttext" runat="server" CssClass="texttest"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <div class="ui form">
                                &nbsp
                                <div class="fields" style="background-color: #E0E0E0">
                                    <h4>
                                        <asp:Label ID="lblGreetVisit" Text="BilXtra greeting after visit" runat="server" CssClass="centerlabel"></asp:Label></h4>
                                </div>
                                &nbsp
                                <div class="inline fields">
                                    <div class="sixteen wide field">
                                        <label>
                                            <asp:CheckBox ID="cbGreetVisit" runat="server" Width="200%" Text="Send SMS" />
                                        </label>
                                        <asp:TextBox ID="txtGreetVisit" runat="server" CssClass="texttest" Width="90%"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <div class="ui form">
                                &nbsp
                                <div class="fields" style="background-color: #E0E0E0">
                                    <h4>
                                        <asp:Label ID="lblGreetMobility" Text="BilXtra greeting after Mobility warranty" runat="server" CssClass="centerlabel"></asp:Label></h4>
                                </div>
                                &nbsp
                                <div class="inline fields">
                                    <div class="sixteen wide field">
                                        <label>
                                            <asp:CheckBox ID="cbGreetMobility" runat="server" Width="200%" Text="Send SMS" />
                                        </label>
                                        <asp:TextBox ID="txtGreetMobility" runat="server" CssClass="texttest" Width="90%"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <%--######### End tabs #############--%>
        </div>
    </div>
</asp:Content>
