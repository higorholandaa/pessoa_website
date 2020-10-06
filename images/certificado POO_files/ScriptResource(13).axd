var IsInRequestHandlerMode = false;
function EndRequestHandler(sender, args) {
    IsInRequestHandlerMode = false;
    if (args.get_error() != undefined) {
        var errorMessage = "";
        if (args.get_response().get_statusCode() == '200') {
            errorMessage = args.get_error().message;
            var nIndex = errorMessage.indexOf("\n");
            if (nIndex > -1) errorMessage = errorMessage.substr(nIndex, errorMessage.len);
        }
        else if ((args.get_response().get_statusCode() == '12007') || (args.get_response().get_statusCode() == '12029')) {
            errorMessage = 'Internet connection failed. Please, check your internet connection.';
        }
        else {
            // Error occurred somewhere other than the server page.
            errorMessage = 'Catch a unspecified ajax error. Return status: ' + args.get_response().get_statusCode();
        }
        alert(errorMessage);
        args.set_errorHandled(true);
    }
}
function BeginRequestHandler(sender, args) {
    if (IsInRequestHandlerMode) {
        args.cancel = true;
        return;
    }
    IsInRequestHandlerMode = true;

    var r = args.get_request();
    if (r.get_headers()["X-MicrosoftAjax"]) {
        b = r.get_body();
        var a = "__MicrosoftAjax=" + encodeURIComponent(r.get_headers()["X-MicrosoftAjax"]);
        if (b != null && b.length > 0) {
            b += "&";
        }
        else
            b = "";
        r.set_body(b + a);
    }
}
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

if (typeof ($) == "function") {
    $(document).ready(function () { $(document.body).fadeIn({ step: function () { $(window).trigger("resize"); } }); });
} else {
    document.body.style.display = "inherit";
}