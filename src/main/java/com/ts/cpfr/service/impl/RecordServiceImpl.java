package com.ts.cpfr.service.impl;

import com.github.pagehelper.PageHelper;
import com.ts.cpfr.dao.RecordDao;
import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.service.RecordService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.transaction.Transactional;

/**
 * @Classname RecordServiceImpl
 * @Description
 * @Date 2018/12/5 10:45
 * @Created by cjw
 */
@Service
@Transactional
public class RecordServiceImpl implements RecordService {
    @Resource
    RecordDao mRecordDao;
    @Autowired
    private WebMemory memory;

    @Override
    public ResultData<PageData<ParamData>> getRecordBase64List(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> recordList = mRecordDao.selectRecordListWithBlob(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(recordList));
    }

    @Override
    public ResultData<ParamData> deleteRecord(ParamData pd) {
        if (mRecordDao.deleteRecord(pd)) {
            return new ResultData<>(HandleEnum.SUCCESS);
        } else return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> deleteRecordLists(ParamData pd) {
        String record_ids = pd.getString("record_ids");
        List<ParamData> list = new ArrayList<>();
        String[] recordIdArr = record_ids.split(",");
        for (String recordId : recordIdArr) {
                ParamData paramData = new ParamData();
                int record_id = Integer.parseInt(recordId);
                paramData.put("record_id", record_id);
                list.add(paramData);
        }

        ParamData paramData = new ParamData();
        paramData.put("wid", memory.getCache(pd.getString(CommConst.ACCESS_CPFR_TOKEN)).getWid());
        paramData.put("list", list);
        if (mRecordDao.deleteRecordLists(paramData)) {
            return new ResultData<>(HandleEnum.SUCCESS);
        }
        return new ResultData<>(HandleEnum.FAIL);

    }

    @Override
    public ResultData<ParamData> clearRecord(ParamData pd) {
        if (mRecordDao.deleteRecodeAll(pd)) return new ResultData<>(HandleEnum.SUCCESS,"删除成功");
        else return new ResultData<>(HandleEnum.FAIL,"删除失败");
    }

}
