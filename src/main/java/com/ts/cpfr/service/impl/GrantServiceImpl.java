package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.GrantDao;
import com.ts.cpfr.ehcache.Memory;
import com.ts.cpfr.service.GrantService;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.transaction.Transactional;

/**
 * @Classname GrantService
 * @Description
 * @Date 2018/11/15 17:26
 * @Created by cjw
 */
@Service
@Transactional
public class GrantServiceImpl implements GrantService {

    @Resource
    private GrantDao mGrantDao;
    @Autowired
    private Memory memory;

    @Override
    public ResultData<List<ParamData>> addGrants(ParamData pd) {
        String person_ids = pd.getString("person_ids");
        String device_ids = pd.getString("device_ids");
        String type = pd.getString("type");
        String pass_number = pd.getString("pass_number");
        String pass_start_time = pd.getString("pass_start_time");
        String pass_end_time = pd.getString("pass_end_time");

        List<ParamData> list = new ArrayList<>();
        String[] personIdArr = person_ids.split(",");
        String[] deviceIdArr = device_ids.split(",");
        for (String personId : personIdArr) {
            for (String deviceId : deviceIdArr) {
                ParamData paramData = new ParamData();
                int person_id = Integer.parseInt(personId);
                int device_id = Integer.parseInt(deviceId);
                paramData.put("person_id", person_id);
                paramData.put("device_id", device_id);
                paramData.put("type", type);
                paramData.put("pass_number", pass_number);
                paramData.put("pass_start_time", pass_start_time);
                paramData.put("pass_end_time", pass_end_time);
                list.add(paramData);
            }
        }

        ParamData paramData = new ParamData();
        paramData.put("wid", memory.getLoginUser().getWId());
        paramData.put("list", list);
        if (mGrantDao.insertGrants(paramData)) return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }
}
