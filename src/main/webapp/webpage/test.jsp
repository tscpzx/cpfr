<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/10/29
  Time: 9:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title style="font-size: 1cm;">Title</title>
</head>
<body>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/component/element-ui/index.css">
<script src="${pageContext.request.contextPath}/resource/js/vue.min.js"></script>
<script src="${pageContext.request.contextPath}/resource/component/element-ui/index.js"></script>
<div id="app">
    <el-button type="text" @click="dialogVisible = true">点击打开 Dialog</el-button>

    <el-dialog title="提示" :visible.sync="dialogVisible" width="30%" :before-close="handleClose">
        <span>这是一段信息</span>
        <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
</div>

<script>
    var Main = {
        data() {
            return {
                dialogVisible: false
            };
        },
        methods: {
            handleClose(done) {
                this.$confirm('确认关闭？')
                    .then(_ => {
                        done();
                    })
                    .catch(_ => {});
            }
        }
    };
    var Ctor = Vue.extend(Main)
    new Ctor().$mount('#app')
</script>

</body>
</html>
