package com.ts.cpfr.service;

import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

/**
 * @Classname PersonService
 * @Description
 * @Date 2018/11/6 10:44
 * @Created by cjw
 */
public interface PersonService {
    ResultData<PageData<ParamData>> getPersonList(ParamData pd);

    ResultData<PageData<ParamData>> getPersonBase64List(ParamData pd);

    ResultData<ParamData> addPerson(CommonsMultipartFile file, ParamData pd);

    ResultData<ParamData> updatePerson(CommonsMultipartFile file, ParamData pd) throws IOException;

    ResultData<ParamData> updatePerson(ParamData pd) throws IOException;

    ResultData<ParamData> deletePerson(ParamData pd) throws IOException;

    ParamData queryPerson(ParamData pd);

    boolean uploadImageFile(CommonsMultipartFile file, ParamData pd) throws Exception;

    void loadImageFile(ParamData pd, HttpServletResponse response) throws Exception;

    void file2base64(List<ParamData> list) throws Exception;

    void file2base64(ParamData pd) throws Exception;

    void blob2base64(List<ParamData> list) throws Exception;

    void blob2base64(ParamData pd) throws Exception;

    ResultData<PageData<ParamData>> getAccessDeviceList(ParamData pd);

    ResultData<ParamData> batchUpload(CommonsMultipartFile[] files, ParamData pd);

    ResultData<ParamData> getListByGroup(ParamData pd);
}
