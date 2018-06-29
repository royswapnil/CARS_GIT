<%@ Page Language="vb" MasterPageFile="~/MasterPage.Master" AutoEventWireup="false" CodeBehind="frmUpZipCodes.aspx.vb" Inherits="CARS.frmUpZipCodes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMainPanel" runat="Server">

    <script>
        $(document).ready(function () {
            $('#btnImportZipcode').on('click', function () {
                var btn = $(this)
                btn.addClass('loading').prop('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: 'frmUpZipCodes.aspx/Update_ZipCodes',
                    data: '{}',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    async: true,
                    success: function (Result) {
                        var cnt = Result.d[0];
                        var ins = Result.d[1] == 0 ? 'Ingen' : Result.d[1];
                        var upd = Result.d[2] == 0 ? 'ingen' : Result.d[2]
                        var resString = 'Det ble lest ' + cnt + ' postnummer. ' + ins + ' av disse var nye og ' + upd + ' postnummer ble oppdatert med ny informasjon.';
                        systemMSG('success', resString, 6000);
                        if (Result.d.length > 0) {
                            btn.removeClass('loading').prop('disabled', false);
                        }
                    },
                    failure: function () {
                        alert("Failed!");
                    }
                });
            });
        });
    </script>
    <div id="systemMessage" class="ui message"> </div>
    <button id="btnImportZipcode" class="ui primary button" type="button">Oppdater Postnummertabell</button>
    </asp:Content>