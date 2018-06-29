$(document).ready(function () {

});
var systemMSG = function (type, string, duration) {
    if (window.parent != undefined && window.parent != null && window.parent.length > 0) { //checks if it should add the message to the current frame or parent frame
        var sysMSG = $('#systemMessage', window.parent.document);
    } else {
        var sysMSG = $('#systemMessage');
    }
    sysMSG.html(string);
    switch (type) {
        case 'success':
            sysMSG.removeClass('negative info').addClass('success');
            break;
        case 'error':
            sysMSG.removeClass('success info').addClass('negative');
            break;
        default:
            sysMSG.removeClass('success negative').addClass('info');
    }
    sysMSG.removeClass('fadeOut').addClass('fadeIn');
    setTimeout(function () {
        sysMSG.addClass('fadeOut');
    }, duration);
}
function requiredFields(check, submitfield) {
    var reqInp
    submitfield ? reqInp = $('[data-required="REQUIRED"][' + submitfield + ']') : reqInp = $('[data-required="REQUIRED"]');
    var  error = false;
    $.each(reqInp, function (key, value) {
        var obj = $(value);
        var lbl = obj.parent('div').children('span, label');
        console.log(obj);
        lbl.addClass('required');
        if (check === true) {
            if ($.trim(obj.val()).length <= 0) {
                lbl.addClass('required-error');
                obj.addClass('required-error');
                error = true;
            }
        }
    });
    if (error === true) {
        systemMSG('error', 'Some required field are missing information.', 4000);
        return false;
    } else {
        $('.required-error').removeClass('required-error');
        return true;
    }
}
function clearFormElements(selector) {
    $(selector).find(':input').each(function () {
        switch (this.type) {
            case 'password':
            case 'text':
            case 'textarea':
            case 'file':
            case 'select-one':
            case 'select-multiple':
                $(this).val('');
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        }
    });

}

/*
      Function that opens a new window. Often used when clicking a button and the new window can for instance show more information about a customer.
  */

function moreInfo(page, title)
{

    var $dialog = $('<div id="testdialog"></div>')
                   .html('<iframe id="testifr" style="border: 0px;" src="' + page + '" width="1000px" height="800px"></iframe>')
                   .dialog
                   ({
                       autoOpen: false,
                       modal: true,
                       height: 800,
                       width: '80%',
                       title: title
                   });
    $dialog.dialog('open');
}

function openSparepartGridWindow(optionalArg) {
  
    
    if (optionalArg == "LocalSPDetail")
    {   
        var page = "../Transactions/frmWOSearchPopup.aspx?Search=SPDetail"
    }
    else
    {     
        var page = "../Transactions/frmWOSearchPopup.aspx?Search=Spare"
    }
           
    var $dialog = $('<div id="testdialog" style="width:100%;height:100%"></div>')
                   .html('<iframe id="testifr" style="border: 0px; overflow:scroll" src="' + page + '" width="100%" height="100%"></iframe>')
                   .dialog({
                       autoOpen: false,
                       modal: true,
                       height: 700,
                       width: 1100,
                       title: "Varesøk"
                   });
    $dialog.dialog('open');
    
}

