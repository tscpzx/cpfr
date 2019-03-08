package com.ts.cpfr.dao;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname PersonDao
 * @Description
 * @Date 2018/11/6 10:42
 * @Created by cjw
 */
public interface PersonDao {
    ParamData selectPerson(ParamData pd);

    List<ParamData> selectPersonList(ParamData pd);

    boolean insertPerson(ParamData pd);

    boolean updatePersonListGroupID(ParamData pd);

    boolean updatePersonGroupID(ParamData pd);

    ParamData selectImage(ParamData pd);

    List<ParamData> selectPersonListWithBlob(ParamData pd);

    List<ParamData> selectGrantPersonListByDeviceSn(ParamData pd);

    boolean updatePersonInfo(ParamData pd);

    boolean deletePerson(ParamData pd);

    boolean deletePersonGroupID(ParamData pd);

    List<ParamData> selectPersonListNoIn(ParamData pd);
}
