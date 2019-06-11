package com.ts.cpfr.solrj;


import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrInputDocument;
import org.junit.Before;
import org.junit.Test;

import java.util.List;
import java.util.Map;

/**
 * @Classname SolrJCrud
 * @Description
 * @Date 2018/12/11 11:43
 * @Created by cjw
 */
public class SolrJCrud {

    private SolrClient solrClient;

    /**
     * 初始化solrClient
     */
    @Before
    public void before() {
        solrClient = new HttpSolrClient.Builder("http://localhost:8088/solr/collection1").build();
    }

    /**
     * 通过对象添加单条数据，若添加时id已存在，那么solr会执行修改操作
     */
    @Test
    public void addBean() throws Exception {

        User user = new User("6", "小美眉");

        solrClient.addBean(user);
        solrClient.commit();
    }

    /**
     * 批量添加 也就是第六节提到的方式一
     */
    @Test
    public void addBeans() throws Exception {

        // 从数据库查出所有的user,UserService操作数据库部分的代码省略
//        List<User> users = UserService.getUsers();

        // 添加
//        solrClient.addBeans(users);
//        solrClient.commit();
    }

    /**
     * 通过document添加单条数据
     */
    @Test
    public void addDocument() throws Exception {

        SolrInputDocument document = new SolrInputDocument();
        document.addField("id", "5");
        document.addField("name", "帅哥");

        solrClient.add(document);
        solrClient.commit();
    }

    /**
     * 两种删除方式
     */
    @Test
    public void deleteById() throws Exception {

        // 方式一：根据id删除
        solrClient.deleteById("6");

        // 方式二：根据查询结构删除
        solrClient.deleteByQuery("name:小美眉");

        solrClient.commit();
    }

    /**
     * 查询
     */
    @Test
    public void query() throws Exception {

        // 构造搜索条件
        SolrQuery solrQuery = new SolrQuery();

        // 设置搜索关键词
        solrQuery.setQuery("name:1234");

        // 设置排序
        solrQuery.setSort("id", SolrQuery.ORDER.desc);

        // 设置分页信息
        solrQuery.setStart(0);
        solrQuery.setRows(2);

        // 设置高亮
        solrQuery.setHighlight(true); // 开启高亮组件
        solrQuery.addHighlightField("name");// 高亮字段
        solrQuery.setHighlightSimplePre("<em>");// 标记，高亮关键字前缀
        solrQuery.setHighlightSimplePost("</em>");// 后缀

        // 执行查询
        QueryResponse response = solrClient.query(solrQuery);

        // 获取查询结果
        List<User> users = response.getBeans(User.class);

        // 将高亮的标识写进对象的name字段上
        Map<String, Map<String, List<String>>> map = response.getHighlighting();
        for (Map.Entry<String, Map<String, List<String>>> highlighting : map.entrySet()) {
            for (User user : users) {
                if (!highlighting.getKey().equals(user.getUserId().toString())) {
                    continue;
                }
                user.setName(highlighting.getValue().get("name").toString());
                break;
            }
        }

        System.out.println("查询结果 ："+users.size());

        // 打印搜索结果
        for (User user : users) {
            System.out.println(user);
        }
    }
}

