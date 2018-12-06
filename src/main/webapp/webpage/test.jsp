<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@include file="../resource/inc/incCss.jsp" %>
    <%@include file="../resource/inc/incJs.jsp" %>

    <style>
        .container {
            width: 500px;
            height: 500px;
        }

        .small {
            width: 400px;
            height: 300px;
            overflow: hidden;
        }
    </style>
</head>
<body>
<div class="container">
    <img src="${pageContext.request.contextPath}/resource/images/test.jpg">
</div>
<div class="small"></div>
<div class="cavans"></div>
<button id="bt">裁剪</button>

<script type="text/javascript">

    $('.container>img').cropper({
        aspectRatio: 4 / 3,
        viewMode: 0,
        preview: ".small"
    });

    $('#bt').click(function () {
        console.log($('.container>img').cropper('getCroppedCanvas'));
        var cas = $('.container>img').cropper('getCroppedCanvas', {
            width: 240,
            height: 320,
            minWidth: 240,
            minHeight: 320,
            maxWidth: 480,
            maxHeight: 640,
            fillColor: '#000',
            imageSmoothingEnabled: false,//如果图像被设置为平滑(true，默认)
            imageSmoothingQuality: 'high'//设置图像的质量
        });

        cas.toBlob(function (e) {
            console.log("toblob-")
            console.log(e);  //生成Blob的图片格式
            var timestamp = Date.parse(new Date());
            e.name = timestamp + ".jpeg";
        }, 'image/jpeg',0.5);

        var base64url = cas.toDataURL('image/jpeg',0.5);
        console.log("base64-")
        console.log(dataURLtoBlob(base64url)); //生成base64图片的格式
        $('.cavans').html(cas)  //在body显示出canvas元素
    })

    //将base64格式图片转换为文件形式
    function dataURLtoBlob(dataurl) {
        var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
            bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
        while (n--) {
            u8arr[n] = bstr.charCodeAt(n);
        }
        return new Blob([u8arr], {type: mime});
    }
</script>

</body>
</html>
