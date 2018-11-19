package com.ts.cpfr.service;

import com.ts.cpfr.utils.ParamData;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.sql.Blob;
import java.util.List;

/**
 * @Classname PersonService
 * @Description
 * @Date 2018/11/6 10:44
 * @Created by cjw
 */
public interface PersonService {
    List<ParamData> getPersonList(ParamData pd);

    boolean uploadImage(CommonsMultipartFile file, ParamData pd);

    boolean addPerson(ParamData pd);

    ParamData queryPerson(ParamData pd);

    byte[] blobToByte(Blob blob) throws Exception;
}
