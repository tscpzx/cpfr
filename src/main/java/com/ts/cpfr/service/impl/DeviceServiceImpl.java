package com.ts.cpfr.service.impl;

import com.github.pagehelper.PageHelper;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.GroupDao;
import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.dao.UserDao;
import com.ts.cpfr.ehcache.AppMemory;
import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.entity.AppDevice;
import com.ts.cpfr.entity.UserInfo;
import com.ts.cpfr.service.DeviceService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SocketEnum;
import com.ts.cpfr.websocket.SocketMessageHandle;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.transaction.Transactional;

/**
 * @Classname DeviceServiceImpl
 * @Description
 * @Date 2018/10/19 11:22
 * @Created by cjw
 */
@Service
public class DeviceServiceImpl implements DeviceService {

    private static final int STATUS_1_DEVICE_ONLINE = 1;
    private static final int STATUS_1_DEVICE_ACTIVATED = 1;

    @Resource
    private DeviceDao mDeviceDao;
    @Resource
    private PersonDao mPersonDao;
    @Resource
    private GroupDao mGroupDao;
    @Resource
    private UserDao mUserDao;
    @Autowired
    private WebMemory memory;
    @Autowired
    private AppMemory appMemory;
    @Autowired
    private SocketMessageHandle mSocketMessageHandle;

    @Override
    public ResultData<PageData<ParamData>> getDeviceList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> deviceList = mDeviceDao.selectDeviceList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(deviceList));
    }

    @Override
    public ResultData<PageData<ParamData>> getInActDeviceList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> inActDeviceList = mDeviceDao.selectInActDeviceList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(inActDeviceList));
    }

    @Transactional
    @Override
    public ResultData<ParamData> activateDevice(ParamData pd) throws Exception {
        UserInfo userInfo = memory.getCache(pd.getString(CommConst.ACCESS_CPFR_TOKEN));
        ParamData paramData = mDeviceDao.selectInActDevice(pd);
        if (paramData == null)
            return new ResultData<>(HandleEnum.FAIL, "设备不存在");
        pd.put("user_id", userInfo.getUserId());
        pd.put("wid", userInfo.getWid());
        if (STATUS_1_DEVICE_ONLINE == (Integer) paramData.get("online")) {
            //激活成功，往对应仓库插入设备，返回
            if (mDeviceDao.insertDevice(pd)) {
                //激活成功 缓存token
                String device_sn = pd.getString(CommConst.DEVICE_SN);
                AppDevice device = new AppDevice(device_sn, userInfo.getWid());
                appMemory.putCache(device);

                //通知设备激活成功
                ParamData data = new ParamData();
                data.put(CommConst.ACCESS_APP_TOKEN, appMemory.getToken(device_sn));
                mSocketMessageHandle.sendMessageToDevice(device_sn, mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1001_DEVICE_ACTIVATE, data));
                return new ResultData<>(HandleEnum.SUCCESS);
            }
            return new ResultData<>(HandleEnum.FAIL);
        } else {
            return new ResultData<>(HandleEnum.FAIL, "设备不在线");
        }
    }

    @Override
    public ParamData queryInActDevice(ParamData pd) {
        return mDeviceDao.selectInActDevice(pd);
    }

    @Override
    public ParamData queryDevice(ParamData pd) {
        ParamData data = mDeviceDao.selectDevice(pd);
        data.putAll(mDeviceDao.selectSyncDownlStatus(pd));
        data.put("group_list", mGroupDao.selectGroupListByDeviceSn(pd));
        return data;
    }

    @Override
    public void updateDeviceOnline(ParamData pd) {
        mDeviceDao.updateInActDeviceOnline(pd);
        int deviceStatus = mDeviceDao.selectDeviceStatusByDeviceSn(pd);
        pd.put("device_status", deviceStatus);
        if (STATUS_1_DEVICE_ACTIVATED == deviceStatus) {
            pd.put("wid", mDeviceDao.selectWidByDeviceSn(pd));
            mDeviceDao.updateDeviceOnline(pd);
        }
    }

    @Override
    public ResultData<PageData<ParamData>> getGrantPersonList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> personList = mPersonDao.selectGrantPersonListByDeviceSn(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(personList));
    }

    @Transactional
    @Override
    public ResultData<ParamData> changeDeviceInfo(ParamData pd) throws Exception {
        if (mDeviceDao.updateDeviceInfo(pd)) {
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1002_DEVICE_UPDATE, null);
            mSocketMessageHandle.sendMessageToDevice(pd.getString(CommConst.DEVICE_SN), message);
            return new ResultData<>(HandleEnum.SUCCESS);
        } else
            return new ResultData<>(HandleEnum.FAIL);
    }

    @Transactional
    @Override
    public ResultData<ParamData> deleteDevice(ParamData pd) throws Exception {
        String deviceSn = mDeviceDao.selectDeviceSnByDeviceID(pd);
        if (!StringUtils.isEmpty(deviceSn)) {
            pd.put("device_sn", deviceSn);
            if (mDeviceDao.deleteDeviceByDeviceID(pd)) {
                TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1005_DEVICE_DELETE, null);
                mSocketMessageHandle.sendMessageToDevice(deviceSn, message);
                //移除app缓存
                appMemory.removeCache(deviceSn);
                return new ResultData<>(HandleEnum.SUCCESS);
            }
        }
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ParamData queryDeviceGrantKey(ParamData pd) {
        return mDeviceDao.selectDeviceGrantKey(pd);
    }

    @Override
    public ResultData<ParamData> checkAppVersionUpdate(ParamData pd) throws Exception {
        ParamData device = mDeviceDao.selectDevice(pd);
        String appVersionStr = device.getString("app_version");
        if (StringUtils.isEmpty(appVersionStr))
            return new ResultData<>(HandleEnum.FAIL, "未设置版本号");

        String projectDlPath = CommUtil.getProjectDlPath();
        if(StringUtils.isEmpty(projectDlPath))
            return new ResultData<>(HandleEnum.FAIL, "更新路径不存在");

        File dir = new File(projectDlPath);
        File[] files = dir.listFiles();//绝对路径

        if(files==null||files.length==0)
            return new ResultData<>(HandleEnum.SUCCESS, "暂无更新");

        String[] appVersions = appVersionStr.split(",");
        boolean hasNewVersion = false;
        for (String appVersion : appVersions) {
            String[] split = appVersion.split("_");
            String applicationId = split[0];

            for (File file : files) {
                if (file.getName().contains(applicationId)) {
                    int versionCode = Integer.parseInt(split[1]);
                    String appNewVersionStr = file.getName().split("_")[1].split("\\.")[0];
                    int appNewVersion = Integer.parseInt(appNewVersionStr);
                    if (appNewVersion > versionCode) {
                        hasNewVersion = true;
                    }
                }
            }

        }
        if (hasNewVersion) {
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1008_NEW_APP_VERSION, null);
            mSocketMessageHandle.sendMessageToDevice(device.getString("device_sn"), message);
            return new ResultData<>(HandleEnum.NEW_APP_VERSION_105);
        }

        return new ResultData<>(HandleEnum.SUCCESS, "当前已是最新系统");
    }

    @Override
    public ResultData<ParamData> getGroupDeviceList(ParamData pd) {
        List<ParamData> groupList = mGroupDao.selectGroupDeviceListMap(pd);
        if (groupList == null)
            groupList = new ArrayList<>();
        ParamData other = new ParamData();
        other.put("group_id", 0);
        other.put("group_name", "未分组");
        other.put("device_list", mDeviceDao.selectDeviceListNoGroup(pd));
        groupList.add(other);

        if (!StringUtils.isEmpty(pd.getString("person_id"))) {//删除这个人对应的设备
            List<ParamData> deviceList = mDeviceDao.selectAccessDeviceListByPersonId(pd);
            List deviceIds = CommUtil.getIntListFromObjList(deviceList, "device_id");

            if (deviceIds != null)
                for (ParamData g : groupList) {
                    List<ParamData> gDeviceList = (List<ParamData>) g.get("device_list");
                    Iterator<ParamData> it = gDeviceList.iterator();
                    while (it.hasNext()) {
                        ParamData device = it.next();
                        if (deviceIds.contains(device.get("device_id")))
                            //                            device.put("disabled", true);//不可点击
                            it.remove();
                    }
                }
        }

        ParamData result = new ParamData();
        result.put("list", groupList);
        return new ResultData<>(HandleEnum.SUCCESS, result);
    }

    @Override
    public ResultData<PageData<ParamData>> getDeviceListByGroup(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> deviceList = mDeviceDao.selectDeviceListByGroupID(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(deviceList));
    }

    @Override
    public void updateAllDeviceOffline() {
        List<ParamData> widList = mUserDao.selectWidList();
        ParamData data = new ParamData();
        data.put("list", widList);
        mDeviceDao.updateAllDeviceOffline(data);
    }

    @Override
    public ResultData<List<ParamData>> getListGroupUnSelected(ParamData pd) {
        List<ParamData> deviceList = mDeviceDao.selectDeviceList(pd);
        List<ParamData> gDeviceList = mDeviceDao.selectDeviceListByGroupID(pd);

        List deviceIds = CommUtil.getIntListFromObjList(gDeviceList, "device_id");

        if (deviceIds != null) {
            Iterator<ParamData> it = deviceList.iterator();
            while (it.hasNext()) {
                ParamData device = it.next();
                if (deviceIds.contains(device.get("device_id")))
                    //                            device.put("disabled", true);//不可点击
                    it.remove();
            }
        }
        return new ResultData<>(HandleEnum.SUCCESS, deviceList);
    }
}
