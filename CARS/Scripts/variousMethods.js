/***
    This file is for various methods through the program that are written ONCE here, and can be used by many files later on by including this script.
    Writing the exact same function multiple times is bad practice: you can easily make mistakes, its time consuming, 
    and you have to change the same method EVERY single place you used this particular method.
***/


$(document).ready(function ()
{
    /*
        Function that opens a new window. Often used when clicking a button and the new window can for instance show more information about a customer.
    */

    function moreInfo(page, title) {

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


});