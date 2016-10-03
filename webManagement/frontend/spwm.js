var initialBoxWidth;

function loadContent(pathToDoc) {
    $("#content-box").load(pathToDoc);
}

function fixContentBoxPosition() {
    var docWidth = parseInt($(document).width())

    var targetMargin = docWidth / 2 - initialBoxWidth / 2;

    $("#content-box").css("margin-left",targetMargin);
    $("#content-box").css("margin-right",targetMargin);
}

$(document).ready(function() {
    initialBoxWidth = parseInt($("#content-box").css("width"));
    fixContentBoxPosition();
    loadContent("login.html");
});

$(window).resize(function() {
    fixContentBoxPosition();
});