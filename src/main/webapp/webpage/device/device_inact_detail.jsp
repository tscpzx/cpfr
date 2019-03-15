<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/resource/inc/lang.jsp" %>
<style type="text/css">
    .device_detail_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }

    #btn_active {
        margin-left: 20px;
    }
</style>
<div class="device_detail_box">
    <div id="device_detail">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item>${equ_management}</el-breadcrumb-item>
            <el-breadcrumb-item>${device_not_activated}</el-breadcrumb-item>
            <el-breadcrumb-item>${data.device_sn}</el-breadcrumb-item>
        </el-breadcrumb>

        <el-form label-width="200px" :model="model" :rules="rule" ref="form">
            <el-form-item label="${devise_serial_number}">
                <span>${data.device_sn}</span>
            </el-form-item>
            <el-form-item label="ARCFACE_APP_ID" prop="arcface_app_id">
                <el-input id="input_grant_key" value="${data.mac_grant_key}" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="ARCFACE_SDK_KEY">
                <el-input value="" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="ARCFACE_ACTIVEKEY">
                <el-input value="" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="BAIDU_TTS_APPID">
                <el-input value="" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="BAIDU_TTS_APPKEY">
                <el-input value="" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="BAIDU_TTS_SECRETKEY">
                <el-input value="" type="text" autocomplete="off" size="small"></el-input>
            </el-form-item>
            <el-form-item label="${registration_time}">
                <span>${data.register_time}</span>
            </el-form-item>
            <el-form-item label="${online}">
                <c:if test="${data.online==1}"> <span>${online}</span></c:if>
                <c:if test="${data.online==0}"> <span>${offline}</span></c:if>
            </el-form-item>
            <el-form-item label="${active_state}">
                <c:if test="${data.status==1}">
                    <span>${activated}</span>
                </c:if>
                <c:if test="${data.status==0}">
                    <span>${inactivated}</span>
                    <el-button type="primary" round id="btn_active" @click="onClick">${activation}</el-button>
                </c:if>
            </el-form-item>
        </el-form>
    </div>
</div>

<script type="text/javascript">
    new Vue({
        el: "#device_detail",
        data: {
            model: {
                arcface_app_id: '',
                arcface_sdk_key: '',
                arcface_activekey: '',
                baidu_tts_appid: '',
                baidu_tts_appkey: '',
                baidu_tts_secretkey: ''
            },
            rule: {
                arcface_app_id: [
                    {required: true, message: '请填入授权码', trigger: 'change'}
                ]
            }
        },
        methods: {
            onClick() {
                this.$refs.form.validate((valid) => {
                    if (!valid) return;
                    var mac_grant_key = $('#input_grant_key').val().trim();
                    if (!mac_grant_key) {
                        layTip("${device_cannot_empty}");
                        return;
                    }
                    ajaxPost({
                        url: "${pageContext.request.contextPath}/device/activate",
                        data: {
                            device_sn: '${data.device_sn}',
                            mac_grant_key: mac_grant_key
                        },
                        success: function (result) {
                            layAlert1(result.message);
                            if (0 === result.code) {
                                $("#device_tree").load("device/device_tree");
                                $("#device_content").load("${pageContext.request.contextPath}/device/inact_detail?device_sn=" + '${data.device_sn}');
                            }
                        }
                    })
                });
            }
        }
    });
</script>
