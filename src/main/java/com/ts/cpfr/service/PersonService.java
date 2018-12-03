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

    boolean uploadImage(CommonsMultipartFile file, ParamData pd) throws Exception;

    boolean addPerson(ParamData pd);

    ParamData queryPerson(ParamData pd);

    void loadImage(ParamData pd, HttpServletResponse response) throws Exception;

    void base64Convert(List<ParamData> list) throws Exception;

    void base64Convert(ParamData pd) throws Exception;
}
