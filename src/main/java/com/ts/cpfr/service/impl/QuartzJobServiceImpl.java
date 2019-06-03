package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.dao.QuartzJobDao;
import com.ts.cpfr.entity.QuartzJobModel;
import com.ts.cpfr.quartz.QuartzJobManager;
import com.ts.cpfr.service.QuartzJobService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

/**
 * @Classname QuartzJobServiceImpl
 * @Description
 * @Date 2019/4/3 11:42
 * @Created by cjw
 */
@Service
public class QuartzJobServiceImpl implements QuartzJobService {
    @Resource
    private QuartzJobDao mQuartzJobDao;
    @Resource
    private PersonDao mPersonDao;
    @Autowired
    QuartzJobManager mQuartzJobManager;

    @Override
    public List<QuartzJobModel> getAll() {

        return null;
    }

    @Override
    public ResultData<ParamData> runJob(ParamData pd) {
        if (mQuartzJobDao.updateJobStatus(pd)) {
            QuartzJobModel quartzJobModel = mQuartzJobDao.selectJob(pd);
            //sql
            List<ParamData> peopleList = mPersonDao.selectPersonIdByAttendId(pd);
            String personIds = "";
            for (ParamData id : peopleList) {
                String personId = id.get("person_id").toString();
                personIds += personId + (",");
            }
            Map<String, String> map = new HashMap<>();
            map.put("wid", pd.get("wid").toString());
            map.put("ids", personIds);
            mQuartzJobManager.addJob(quartzJobModel, map);
            return new ResultData<>(HandleEnum.SUCCESS, "成功生效");
        } else
            return new ResultData<>(HandleEnum.FAIL);
    }


}
