package com.ts.cpfr.dao.app;

import com.ts.cpfr.utils.ParamData;

import java.util.List;

/**
 * @Classname FaceAppDao
 * @Description
 * @Date 2018/11/22 15:32
 * @Created by cjw
 */
public interface FaceAppDao {
    boolean insertInActDevice(ParamData pd);

    ParamData selectDevice(ParamData pd);

    int selectUserWid(ParamData pd);

    List<ParamData> selectGrantList(ParamData pd);

    boolean insertRecord(ParamData pd);

    List<ParamData> selectPersonListWithBlob(ParamData pd);

    String selectNow();

    boolean updateGrantPassNumber(ParamData pd);

    List<ParamData> selectPersonList(ParamData pd);

    List<ParamData> selectPersonListNoIn(ParamData pd);

    ParamData selectPerson(ParamData pd);

    boolean updatePunch(ParamData pd);

    boolean updateDeviceConfig(ParamData pd);

    boolean updateGrantSyncStatus(ParamData pd);
}
