package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.app.ManagerAppDao;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.dao.TableDao;
import com.ts.cpfr.service.ManagerAppService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SocketEnum;
import com.ts.cpfr.websocket.SocketMessageHandle;

import org.apache.commons.lang.StringUtils;
import org.apache.http.util.TextUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.transaction.Transactional;

import sun.misc.BASE64Decoder;

/**
 * @Classname ConfigServiceImpl
 * @Description
 * @Date 2019/5/16 16:11
 * @Created by cjw
 */
@Service
public class ManagerAppServiceImpl implements ManagerAppService {

    @Resource
    private PersonDao mPersonDao;
    @Resource
    private TableDao mTableDao;
    @Resource
    private ManagerAppDao mManagerAppDao;
    @Resource
    private DeviceDao mDeviceDao;
    @Autowired
    private SocketMessageHandle mSocketMessageHandle;

    @Transactional
    @Override
    public ResultData<ParamData> addPersonWithGrant(ParamData pd) throws Exception {
        String base64Image = pd.getString("file");
        if (StringUtils.isEmpty(base64Image))
            return new ResultData<>(HandleEnum.FAIL);
        byte[] blobImage = new BASE64Decoder().decodeBuffer(base64Image);
        if (blobImage != null) {
            if (blobImage.length / 1024 > 65)
                return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");

            pd.put("blob_image", blobImage);
            boolean a = mPersonDao.insertPerson(pd);
            pd.put("person_id", mTableDao.selectLastInsertID());

            String device_ids = pd.getString("device_ids");
            if (!TextUtils.isEmpty(device_ids)) {
                List<ParamData> list = new ArrayList<>();
                String[] deviceIdArr = device_ids.split(",");
                for (String deviceId : deviceIdArr) {
                    ParamData paramData = new ParamData();
                    int device_id = Integer.parseInt(deviceId);
                    paramData.put("device_id", device_id);
                    list.add(paramData);
                }
                pd.put("list", list);
                boolean b = mManagerAppDao.insertGrantDeviceIdsPersonId(pd);

                if (b) {
                    List<ParamData> deviceSnList = mDeviceDao.selectDeviceSnList(pd);
                    for (ParamData p : deviceSnList) {
                        String deviceSn = p.getString(CommConst.DEVICE_SN);
                        mSocketMessageHandle.sendMessageToDevice(deviceSn, mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1003_PERSON_UPDATE, null));
                        mSocketMessageHandle.sendMessageToDevice(deviceSn, mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1004_GRANT_UPDATE, null));
                    }

                }
                return new ResultData<>(HandleEnum.SUCCESS);
            }
        }
        return new ResultData<>(HandleEnum.FAIL);
    }
}
