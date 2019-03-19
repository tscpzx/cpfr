package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname AppService
 * @Description
 * @Date 2018/11/22 15:24
 * @Created by cjw
 */
public interface AppService {
    ResultData<ParamData> register(ParamData paramDataInit);

    ResultData<ParamData> getDeviceInfo(ParamData pd);

    ResultData<List<ParamData>> getPersonBase64List(ParamData pd);

    ResultData<List<ParamData>> getGrantList(ParamData pd);

    ResultData<ParamData> addRecord(CommonsMultipartFile file, HttpServletRequest request);

    ResultData<ParamData> addRecord(ParamData pd) throws Exception;

    boolean uploadRecordImage(CommonsMultipartFile file, ParamData pd) throws Exception;

    ResultData<ParamData> getCurrentDate();

    ResultData<ParamData> addPersonWithGrant(CommonsMultipartFile file, HttpServletRequest request) throws Exception;

    ResultData<ParamData> addPersonWithGrant(ParamData pd) throws Exception;

    ResultData<List<ParamData>> comparePersonDownlNum(ParamData pd);

    void downloadApk(HttpServletRequest request, HttpServletResponse response, String key) throws Exception;

    ResultData<ParamData> getLastVersionInfo();
}
