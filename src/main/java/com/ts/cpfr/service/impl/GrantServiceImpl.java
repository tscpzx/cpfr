package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.GrantDao;
import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.service.GrantService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SocketEnum;
import com.ts.cpfr.websocket.SocketMessageHandle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;

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
    @Resource
    private DeviceDao mDeviceDao;
    @Autowired
    private WebMemory memory;
    @Autowired
    private SocketMessageHandle mSocketMessageHandle;

    @Override
    public ResultData<ParamData> addGrant(ParamData pd) throws Exception {
        String person_ids = pd.getString("person_ids");
        String device_ids = pd.getString("device_ids");
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
                paramData.put("pass_number", pass_number);
                paramData.put("pass_start_time", pass_start_time);
                paramData.put("pass_end_time", pass_end_time);
                list.add(paramData);
            }
        }

        ParamData paramData = new ParamData();
        paramData.put("wid", memory.getCache(pd.getString(CommConst.ACCESS_CPFR_TOKEN)).getWid());
        paramData.put("list", list);
        if (mGrantDao.insertGrant(paramData)) {
            //通知设备权限更新
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1004_GRANT_UPDATE, null);
            List<ParamData> deviceSnList = mDeviceDao.selectDeviceSnList(paramData);
            for (ParamData p : deviceSnList) {
                mSocketMessageHandle.sendMessageToDevice(p.getString(CommConst.DEVICE_SN), message);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        }
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> banGrant(ParamData pd) throws Exception {
        String person_ids = pd.getString("person_ids");
        String device_ids = pd.getString("device_ids");

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
                list.add(paramData);
            }
        }

        ParamData paramData = new ParamData();
        paramData.put("wid", memory.getCache(pd.getString(CommConst.ACCESS_CPFR_TOKEN)).getWid());
        paramData.put("list", list);
        if (mGrantDao.updateGrantBan(paramData)) {
            //通知设备权限更新
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1004_GRANT_UPDATE, null);
            List<ParamData> deviceSnList = mDeviceDao.selectDeviceSnList(paramData);
            for (ParamData p : deviceSnList) {
                mSocketMessageHandle.sendMessageToDevice(p.getString(CommConst.DEVICE_SN), message);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        }
        return new ResultData<>(HandleEnum.FAIL);
    }
}
