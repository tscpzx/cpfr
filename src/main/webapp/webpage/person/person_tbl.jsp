<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<style type="text/css">
    .person_tbl_box {
        padding: 20px;
        text-align: center;
    }

    .person_tbl_box .el-table {
        margin: 0 auto;
    }

    .el-form-item {
        text-align: left;
    }
</style>
<div class="person_tbl_box">
    <div id="person_tbl">
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 15px;">
            <el-breadcrumb-item><spring:message code="people_management"/></el-breadcrumb-item>
            <el-breadcrumb-item><spring:message code="people_list"/></el-breadcrumb-item>
        </el-breadcrumb>

        <el-form>
            <el-form-item>
                <el-row>
                    <div style="float: right">
                        <spring:message code="please_enter_the_search_content" var="search_content"/>
                        <el-input style="width: 200px;" v-model="keyword" size="small" placeholder="${search_content}"></el-input>
                        <el-button type="primary" size="small" @click="selectPerson"><spring:message code="search"/>
                        </el-button>
                    </div>
                </el-row>
            </el-form-item>
        </el-form>

        <template>
            <el-table :data="tableData" style="width: 100%" stripe>
                <spring:message code="people_id" var="people_id_lang"/>
                <el-table-column prop="person_id" label="${people_id_lang}">
                </el-table-column>
                <spring:message code="name" var="name_lang"/>
                <el-table-column prop="person_name" label="${name_lang}">
                </el-table-column>
                <spring:message code="job_number" var="job_number_lang"/>
                <el-table-column prop="emp_number" label="${job_number_lang}">
                </el-table-column>
                <spring:message code="the_bottom_picture" var="the_bottom_picture_lang"/>
                <el-table-column label="${the_bottom_picture_lang}">
                    <template slot-scope="scope">
                        <img class="image_tbl" v-bind:src="'data:image/jpeg;base64,'+scope.row.base_image">
                        <%--<img class="image_tbl" v-bind:src="'${pageContext.request.contextPath}/person/image?image_path='+scope.row.image_path">--%>
                    </template>
                </el-table-column>
                <spring:message code="registration_time" var="registration_time_lang"/>
                <el-table-column label="${registration_time_lang}">
                    <template slot-scope="scope">
                        <i class="el-icon-time"></i>
                        <span style="margin-left: 10px">{{ scope.row.add_time}}</span>
                    </template>
                </el-table-column>
            </el-table>
        </template>

        <template>
            <spring:message code="next_page" var="next_page_lang"/>
            <spring:message code="previous_page" var="previous_page_lang"/>
            <div class="block">
                <el-pagination ref="pagination"
                               @size-change="handleChange"
                               @current-change="handleChange"
                               :current-page.sync="currentPage"
                               :page-size.sync="pageSize"
                               :page-sizes="pageSizes"
                               prev-text="${previous_page_lang}"
                               next-text="${next_page_lang}"
                               layout="total, sizes, prev, pager, next, jumper"
                               :total="total">
                </el-pagination>
            </div>
        </template>
    </div>
</div>

<script type="text/javascript">
    var vm = new Vue({
        el: "#person_tbl",
        data: {
            tableData: [],
            searching: true,
            currentPage: 1,
            pageSizes: [5, 10, 20],
            pageSize: 5,
            total: '',
            keyword: ''
        },
        methods: {
            handleChange(val) {
                ajaxPersonPage({
                    pageNum:this.currentPage,
                    pageSize:this.pageSize
                });
            },
            selectPerson(){
                ajaxPersonPage({
                    pageNum: 1,
                    pageSize: this.pageSize,
                    keyword: this.keyword
                    });
            }
        }
    });

    ajaxPersonPage({
        pageNum:vm.currentPage,
        pageSize:vm.pageSize
    });

    function ajaxPersonPage(data) {
        ajaxGet({
            url: "${pageContext.request.contextPath}/person/list_base64",
            data: data,
            success: function (result) {
                vm.total = result.data.total;
                vm.tableData = result.data.list;
            }
        });
    }

</script>
