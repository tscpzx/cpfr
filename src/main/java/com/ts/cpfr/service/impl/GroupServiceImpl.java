package com.ts.cpfr.service.impl;

import com.github.pagehelper.PageHelper;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.GroupDao;
import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.service.GroupService;
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
 * @Classname GroupServiceImpl
 * @Description
 * @Date 2018/11/14 10:20
 * @Created by cjw
 */
@Service
@Transactional
public class GroupServiceImpl implements GroupService {
    @Resource
    private GroupDao mGroupDao;
    @Resource
    private PersonDao mPersonDao;
    @Resource
    private DeviceDao mDeviceDao;
    @Autowired
    private WebMemory memory;

    @Override
    public ResultData<PageData<ParamData>> getGroupList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据
        pd.put("wid", memory.getCache().getWid());

        if (pageSize != 0) PageHelper.startPage(pageNum, pageSize);
        List<ParamData> groupList = mGroupDao.selectGroupList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(groupList));
    }

    @Override
    public ParamData queryGroup(ParamData pd) {
        pd.put("wid", memory.getCache().getWid());
        ParamData group = mGroupDao.selectGroup(pd);
        List<ParamData> personList = mPersonDao.selectPersonList(pd);
        List<ParamData> deviceList = mDeviceDao.selectDeviceList(pd);
        ParamData data = new ParamData();
        data.put("group", group);
        data.put("person_list", personList);
        data.put("device_list", deviceList);
        return data;
    }

    @Override
    public ResultData<ParamData> addGroup(ParamData pd) {
        pd.put("wid", memory.getCache().getWid());
        if (mGroupDao.insertGroup(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        else return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> addGroupPerson(ParamData pd) {
        String person_ids = pd.getString("person_ids");

        List<ParamData> list = new ArrayList<>();
        String[] personIdArr = person_ids.split(",");
        for (String personId : personIdArr) {
            ParamData paramData = new ParamData();
            int person_id = Integer.parseInt(personId);
            paramData.put("person_id", person_id);
            list.add(paramData);
        }

        ParamData paramData = new ParamData();
        paramData.put("wid", memory.getCache().getWid());
        paramData.put("group_id", pd.getString("group_id"));
        paramData.put("list", list);
        if (mPersonDao.updatePersonGroupID(paramData)) return new ResultData<>(HandleEnum.SUCCESS);
        else return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> addGroupDevice(ParamData pd) {
        String device_ids = pd.getString("device_ids");

        List<ParamData> list = new ArrayList<>();
        String[] deviceIdArr = device_ids.split(",");
        for (String deviceId : deviceIdArr) {
            ParamData paramData = new ParamData();
            int device_id = Integer.parseInt(deviceId);
            paramData.put("device_id", device_id);
            list.add(paramData);
        }

        ParamData paramData = new ParamData();
        paramData.put("wid", memory.getCache().getWid());
        paramData.put("group_id", pd.getString("group_id"));
        paramData.put("list", list);
        if (mDeviceDao.updateDeviceGroupID(paramData)) return new ResultData<>(HandleEnum.SUCCESS);
        else return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> updateGroupInfo(ParamData pd) {
        pd.put("wid", memory.getCache().getWid());
        if (mGroupDao.updateGroupInfo(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> deleteGroup(ParamData pd) {
        pd.put("wid", memory.getCache().getWid());
        if (mGroupDao.deleteGroup(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> deleteGroupPerson(ParamData pd) {
        pd.put("wid", memory.getCache().getWid());
        if (mPersonDao.deletePersonGroupID(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ResultData<ParamData> deleteGroupDevice(ParamData pd) {
        pd.put("wid", memory.getCache().getWid());
        if (mDeviceDao.deleteDeviceGroupID(pd)) return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }
}
