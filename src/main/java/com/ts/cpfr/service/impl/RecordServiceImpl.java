package com.ts.cpfr.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ts.cpfr.dao.RecordDao;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.service.RecordService;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    private Memory memory;

    @Override
    public ResultData<PageInfo<ParamData>> getRecordBase64List(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据
        pd.put("wid", memory.getLoginUser().getWId());

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> recordList = mRecordDao.selectRecordListWithBlob(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageInfo<>(recordList));
    }
}
