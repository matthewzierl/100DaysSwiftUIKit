var Action = function() { }

Action.prototype = {

    run: function(parameters) {
        parameters.completionFunction({"URL": document.URL, "title": document.title});
    },
    
    finalize: function(parameters) {
        // Add any finalization code here if needed
        var customJavascript = parameters["customJavascript"];
        eval(customJavascript)
    }
    
};

var ExtensionPreprocessingJS = new Action

