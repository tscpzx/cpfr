function l(str) {
    console.log(str);
}

/* layer弹出层 */
function layTip(msg) {
    top.layer.msg(msg);
}

//icon 0 警告 1 打钩 2 打叉 3 问号 4 锁头
function layAlert1(msg) {
    return top.layer.msg(msg, {
        icon: 0
        , shade: 0.01
        , time: 3000
    });
}

function layAlert2(msg) {
    top.layer.alert(msg, {
        icon: 0,
        shadeClose: true
    });
}

function layLoading1() {
    return top.layer.load(0, {
        shade: false
    });
}

function layLoading2() {
    return top.layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
}

//loading带文字
function layLoading3(msg) {
    return top.layer.msg(msg, {
        icon: 16
        , shade: 0.01
        , time: 10000
    });
}

function elmLoading1() {
    return new Vue().$loading();
}

function elmAlert1(msg) {
    new Vue().$alert(msg, '提示', {
        type: 'warning',
        showConfirmButton: false,
        closeOnClickModal: true
    });
}

/* ajax请求 */
function ajax(type, jsonObj) {
    // var loading = layLoading1();
    var loading = elmLoading1();

    var beforeSend = jsonObj.beforeSend;
    var url = jsonObj.url;
    var data = jsonObj.data;
    var success = function (result) {
        // console.log(JSON.stringify(result, null, 1));
        // top.layer.close(loading);
        loading.close();
        if (checkSession(result)) {
            if (result.code !== 0) {
                layAlert1(result.message);
                return;
            }
            jsonObj.success(result);
        }
    };
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

function checkSession(data) {
    if (102 === data.code) {
        top.layer.confirm(data.message + ',是否重新登录?', {
            icon: 0,
            title: '提示',
            btn: ['确定', '取消'],
            btn1: function (index) {
                top.window.location.href = "/webpage/login";
                layer.close(index);
            },
            btn2: function (index) {
                layer.close(index);
            }
        });
        return false;
    }
    return true;
}

function formatDate(date, fmt) {
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length));
    }
    let o = {
        'M+': date.getMonth() + 1,
        'd+': date.getDate(),
        'h+': date.getHours(),
        'm+': date.getMinutes(),
        's+': date.getSeconds()
    };
    for (let k in o) {
        if (new RegExp(`(${k})`).test(fmt)) {
            let str = o[k] + '';
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? str : padLeftZero(str));
        }
    }
    return fmt;
}