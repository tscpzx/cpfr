/* layer弹出层 */
function layTip(msg) {
    layer.msg(msg);
}

//icon 0 警告 1 打钩 2 打叉 3 问号 4 锁头
function layAlert(msg) {
    layer.alert(msg, {
        icon: 0,
        shadeClose: true
    });
}

function layLoading1() {
    return layer.load(0, {
        shade: false
    });
}

function layLoading2() {
    return layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
}

//loading带文字
function layLoading3(msg) {
    return layer.msg(msg, {
        icon: 16
        , shade: 0.01
        , time: 10000
    });
}

/* ajax请求 */
function ajax(type, jsonObj) {
    var beforeSend = jsonObj.beforeSend;
    var url = jsonObj.url;
    var data = jsonObj.data;
    var success = jsonObj.success;
    var complete = jsonObj.complete;//成败成功都会回调
    var error = jsonObj.error;
    var xhr = $.ajax({
        type: type,
        beforeSend: beforeSend,
        url: url,
        data: data,
        async: true,
        success: success,
        complete: complete,
        error: error
    });
    return xhr;
}

function ajaxPost(jsonObj) {
    ajax("POST", jsonObj);
}

function ajaxGet(jsonObj) {
    ajax("GET", jsonObj);
}