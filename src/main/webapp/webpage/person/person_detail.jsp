<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .person_detail_box {
        padding: 20px;
    }

    .el-input {
        width: 400px;
    }

    .div_group {
        margin: 10px 0 10px 0;
    }

    .div_group label {
        width: 150px;
        text-align: right;
        float: left;
        font-size: 14px;
        color: #606266;
        line-height: 40px;
        padding: 0 12px 0 0;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
    }
</style>
<div class="person_detail_box">
    <div id="person_detail">
        <template>
            <el-tabs type="card" v-model="activeName">
                <%--基本信息--%>
                <el-tab-pane label="基本信息" name="first">
                    <%@include file="inc_tabs/base_info.jsp" %>
                </el-tab-pane>
                <%--可通行设备--%>
                <el-tab-pane label="可通行设备" name="second">
                    <%@include file="inc_tabs/access_device.jsp" %>
                </el-tab-pane>
            </el-tabs>
        </template>
    </div>
</div>

<script type="text/javascript">
    var data = '${data}';
    //base64去换行
    data = data.replace(/<\/?.+?>/g, "");
    data = data.replace(/[\r\n]/g, "");
    data = $.parseJSON(data);
    new Vue({
        el: "#person_detail",
        data: function () {
            return {
                data: data,
                activeName: 'first',
                tableData:[],
                personModel: {
                    person_name:data.person_name ,
                    emp_number:data.emp_number
                },
            }
        },
        methods: {
            updatePerson(formName) {
                var model = this.$refs[formName].model;
                ajaxPost({
                    url: "${pageContext.request.contextPath}/person/updatePerson",
                    data: {
                        person_name: model.person_name,
                        emp_number:model.emp_number
                    },
                    success: function (data) {
                        layAlertSuccess(data.message);
                    }
                });

            },

        },
        filters: {
            formatDate: function (time) {
                var data = new Date(time);
                return formatDate(data, 'yyyy-MM-dd hh:mm:ss');
            }
        }
    });
</script>