package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

/**
 * @Classname PersonService
 * @Description
 * @Date 2018/11/6 10:44
 * @Created by cjw
 */
public interface PersonService {
    List<ParamData> getPersonList(ParamData pd);

    boolean uploadImageFile(CommonsMultipartFile file, ParamData pd) throws Exception;

    boolean addPerson(ParamData pd);

    ParamData queryPerson(ParamData pd);

    void loadImageFile(ParamData pd, HttpServletResponse response) throws Exception;

    void file2base64(List<ParamData> list) throws Exception;

    void file2base64(ParamData pd) throws Exception;

    void blob2base64(List<ParamData> list) throws Exception;

    void blob2base64(ParamData pd) throws Exception;

    List<ParamData> getPersonBase64List(ParamData pd);
}
