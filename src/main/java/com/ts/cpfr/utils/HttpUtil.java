package com.ts.cpfr.utils;

import com.alibaba.fastjson.JSONObject;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * @Classname HttpUtil
 * @Description
 * @Date 2018/10/16 16:27
 * @Created by cjw
 */
public class HttpUtil {
    public static JSONObject doPost(String url, ParamData pd) throws Exception {
        HttpClient httpClient = HttpClientBuilder.create().build();
        HttpPost httpPost = new HttpPost(url);
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        for (Object key : pd.keySet()) {
            params.add(new BasicNameValuePair((String) key, (String) pd.get(key)));
        }
        UrlEncodedFormEntity entity = new UrlEncodedFormEntity(params, "UTF-8");
        httpPost.setEntity(entity);
        HttpResponse httpResponse = httpClient.execute(httpPost);

        JSONObject jsonObject = null;
        if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            HttpEntity httpEntity = httpResponse.getEntity();
            String result = EntityUtils.toString(httpEntity, "UTF-8");
            jsonObject = JSONObject.parseObject(result);
        }
        return jsonObject;
    }

    public static JSONObject doGet(String url) throws Exception {
        HttpClient httpClient = HttpClientBuilder.create().build();
        //设置连接超时和读取超时
        HttpGet httpGet = new HttpGet(url);
        RequestConfig requestConfig = RequestConfig.custom()
          .setConnectTimeout(5000)
          .setConnectionRequestTimeout(1000)
          .setSocketTimeout(5000)
          .build();
        httpGet.setConfig(requestConfig);
        HttpResponse httpResponse = httpClient.execute(httpGet);
        HttpEntity entity = httpResponse.getEntity();
        if (entity != null) {
            String result = EntityUtils.toString(entity, "UTF-8");
            JSONObject jsonObject = JSONObject.parseObject(result);
            return jsonObject;
        }
        httpGet.releaseConnection();
        return null;
    }

    public static JSONObject doPost(String url, String outStr) throws ParseException, IOException {
        HttpClient httpClient = HttpClientBuilder.create().build();
        //设置连接超时和读取超时
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 15000);
        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 20000);

        HttpPost httpPost = new HttpPost(url);
        httpPost.setEntity(new StringEntity(outStr, "UTF-8"));
        HttpResponse response = httpClient.execute(httpPost);

        JSONObject jsonObject = null;
        //获取连接状态码
        int statusCode = response.getStatusLine().getStatusCode();
        if (statusCode == HttpStatus.SC_OK) {
            HttpEntity httpEntity = response.getEntity();
            String result = EntityUtils.toString(httpEntity, "UTF-8");
            jsonObject = JSONObject.parseObject(result);
        }

        httpPost.releaseConnection();
        return jsonObject;
    }

    public static JSONObject doPostWithPairs(String url, List<NameValuePair> params) throws ParseException, IOException {
        HttpClient httpClient = HttpClientBuilder.create().build();
        //设置连接超时和读取超时
        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 15000);
        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 20000);

        HttpPost httpPost = new HttpPost(url);

        httpPost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
        HttpResponse response = httpClient.execute(httpPost);

        JSONObject jsonObject = null;
        //获取连接状态码
        int statusCode = response.getStatusLine().getStatusCode();
        if (statusCode == HttpStatus.SC_OK) {
            HttpEntity httpEntity = response.getEntity();
            String result = EntityUtils.toString(httpEntity, "UTF-8");
            jsonObject = JSONObject.parseObject(result);
        }

        httpPost.releaseConnection();
        return jsonObject;
    }

    /**
     * 从微信服务器下载媒体文件
     * 返回：
     * HTTP/1.1 200 OK
     * Connection: close
     * Content-Type: image/jpeg
     * Content-disposition: attachment; filename="MEDIA_ID.jpg"
     * Date: Sun, 06 Jan 2013 10:20:18 GMT
     * Cache-Control: no-cache, must-revalidate
     * Content-Length: 339721
     */
    //    public static ParamData doGetFileFromWeiXin(ParamData pd) throws ParseException, IOException {
    //        HttpClient httpClient = HttpClientBuilder.create().build();
    //        //设置连接超时和读取超时
    //        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 15000);
    //        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 20000);
    //        //获取微信下载媒体文件地址
    ////        String url = String.format(Constants.GET_WEIXIN_MEDIA_URL, pd.getString("accessToken"), pd.getString("mediaId"));
    //
    //        HttpPost httpPost = new HttpPost(url);
    //        HttpResponse response = httpClient.execute(httpPost);
    //
    //        //获取连接状态码
    //        int statusCode = response.getStatusLine().getStatusCode();
    //        if (statusCode == HttpStatus.SC_OK) {
    //            HttpEntity httpEntity = response.getEntity();
    //            String uploadType = httpEntity.getContentType().getValue();
    //            long contentLength = httpEntity.getContentLength();
    //            String strSize = String.valueOf(contentLength);
    //            int intSize = Integer.parseInt(strSize);
    //
    //            InputStream content = httpEntity.getContent();
    //            byte[] buffer = new byte[intSize];
    //            int readCount = 0; // 已经成功读取的字节的个数
    //            while (readCount < intSize) {
    //                readCount += content.read(buffer, readCount, intSize - readCount);
    //            }
    //            String contentString = new BASE64Encoder().encodeBuffer(buffer);
    //
    //            pd.put("uploadType", uploadType);
    //            pd.put("fileSize", strSize);
    //            pd.put("content", contentString);
    //        }
    //        //        httpPost.releaseConnection();//有流不能关，close时自动关
    //        return pd;
    //    }
    //
    //    //上传文件
    //    @SuppressWarnings({"rawtypes", "unchecked"})
    //    public static JSONObject doPostWithFile(String url, CommonsMultipartFile file, ParamData pd) throws IOException {
    //        HttpClient httpClient = HttpClientBuilder.create().build();
    //        //设置连接超时和读取超时
    //        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 15000);
    //        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 20000);
    //
    //        HttpPost httpPost = new HttpPost(url);
    //
    //        MultipartEntity entity = new MultipartEntity();
    //
    //        entity.addPart(file.getName(), new InputStreamBody(file.getInputStream(), file.getOriginalFilename()));//getFieldName ,getName
    //        Iterator iterator = pd.entrySet().iterator();
    //        while (iterator.hasNext()) {
    //            Map.Entry entry = (Map.Entry) iterator.next();
    //            Object valueObj = entry.getValue();
    //            String name = (String) entry.getKey();
    //            String value = "";
    //            if (valueObj != null) {
    //                value = valueObj.toString();
    //            }
    //            entity.addPart(name, new StringBody(value, Charset.forName("utf-8")));
    //        }
    //
    //        httpPost.setEntity(entity);
    //
    //        HttpResponse response = httpClient.execute(httpPost);
    //
    //        JSONObject jsonObject = null;
    //        //获取连接状态码
    //        int statusCode = response.getStatusLine().getStatusCode();
    //        if (statusCode == HttpStatus.SC_OK) {
    //            HttpEntity httpEntity = response.getEntity();
    //            String result = EntityUtils.toString(httpEntity, "UTF-8");
    //            jsonObject = JSONObject.parseObject(result);
    //        }
    //
    //        httpPost.releaseConnection();
    //        return jsonObject;
    //    }
    //
    //    public static ParamData doGetFile(String url, ParamData pd) throws ParseException, IOException {
    //        HttpClient httpClient = HttpClientBuilder.create().build();
    //        //设置连接超时和读取超时
    //        httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 15000);
    //        httpClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 20000);
    //
    //        HttpPost httpPost = new HttpPost(url);
    //
    //        httpPost.addHeader("filePath", pd.getString("filePath"));
    //        httpPost.addHeader("uploadType", pd.getString("uploadType"));
    //        HttpResponse response = httpClient.execute(httpPost);
    //
    //        //获取连接状态码
    //        int statusCode = response.getStatusLine().getStatusCode();
    //        if (statusCode == HttpStatus.SC_OK) {
    //            HttpEntity httpEntity = response.getEntity();
    //            String uploadType = httpEntity.getContentType().getValue();
    //            String fileSize = String.valueOf(httpEntity.getContentLength());
    //            InputStream in = httpEntity.getContent();
    //            pd.put("content", in);
    //            pd.put("fileSize", fileSize);
    //            pd.put("uploadType", uploadType);
    //        }
    //
    //        return pd;
    //    }
}
