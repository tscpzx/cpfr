package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.RecordDao;
import com.ts.cpfr.service.RecordService;
import com.ts.cpfr.utils.ParamData;

import org.springframework.stereotype.Service;

import java.util.List;

import javax.annotation.Resource;

/**
 * @Classname RecordServiceImpl
 * @Description
 * @Date 2018/12/5 10:45
 * @Created by cjw
 */
@Service
public class RecordServiceImpl implements RecordService {
    @Resource
    RecordDao mRecordDao;

    @Override
    public List<ParamData> getRecordBase64List(ParamData pd) {
        return mRecordDao.selectRecordListWithBlob(pd);
    }
}
