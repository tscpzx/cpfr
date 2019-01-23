package com.ts.cpfr.dao;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname RecordDao
 * @Description
 * @Date 2018/12/5 10:46
 * @Created by cjw
 */
public interface RecordDao {
    List<ParamData> selectRecordListWithBlob(ParamData pd);
    boolean deleteRecord(ParamData pd);
}
