package com.ts.cpfr.service.impl;

import com.ts.cpfr.dao.app.FaceAppDao;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.GrantDao;
import com.ts.cpfr.dao.GroupDao;
import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.dao.TableDao;
import com.ts.cpfr.ehcache.AppMemory;
import com.ts.cpfr.entity.AppDevice;
import com.ts.cpfr.service.FaceAppService;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SocketEnum;
import com.ts.cpfr.utils.SystemConfig;
import com.ts.cpfr.websocket.SocketMessageHandle;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;

import sun.misc.BASE64Decoder;

/**
 * @Classname AppServiceImpl
 * @Description
 * @Date 2018/11/22 15:25
 * @Created by cjw
 */
@Service
public class FaceFaceAppServiceImpl implements FaceAppService {
    @Resource
    private FaceAppDao mFaceAppDao;
    @Resource
    private DeviceDao mDeviceDao;
    @Resource
    private PersonDao mPersonDao;
    @Resource
    private GrantDao mGrantDao;
    @Resource
    private GroupDao mGroupDao;
    @Resource
    private TableDao mTableDao;
    @Autowired
    private AppMemory memory;
    @Autowired
    private SocketMessageHandle mSocketMessageHandle;

    @Transactional
    @Override
    public ResultData<ParamData> register(ParamData pd) {
        String deviceSn = pd.getString(CommConst.DEVICE_SN);
        if (StringUtils.isEmpty(deviceSn))
            return new ResultData<>(HandleEnum.FAIL, "设备序列号不能为空");
        ParamData paramData = mDeviceDao.selectInActDevice(pd);
        if (paramData == null) {
            if (mFaceAppDao.insertInActDevice(pd)) {
                return new ResultData<>(HandleEnum.SUCCESS, "已注册新设备");
            }
        } else
            return new ResultData<>(HandleEnum.SUCCESS, "设备已注册");
        return new ResultData<>(HandleEnum.FAIL, "设备注册失败，请重新连接");
    }

    @Override
    public ResultData<ParamData> getDeviceInfo(ParamData pd) {
        ParamData paramData = mFaceAppDao.selectDevice(pd);
        return new ResultData<>(HandleEnum.SUCCESS, paramData);
    }

    @Override
    public ResultData<List<ParamData>> getPersonBase64List(ParamData pd) {
        System.out.println("===================================");
        System.out.println(new Date().toString());
        System.out.println("客户端 " + pd.getString(CommConst.DEVICE_SN) + "开始下载人员");
        List<ParamData> list = mFaceAppDao.selectPersonListWithBlob(pd);
        return new ResultData<>(HandleEnum.SUCCESS, list);
    }

    @Override
    public ResultData<List<ParamData>> getGrantList(ParamData pd) {
        List<ParamData> list = mFaceAppDao.selectGrantList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, list);
    }

    @Transactional
    @Override
    @Deprecated
    public ResultData<ParamData> addRecord(CommonsMultipartFile file, HttpServletRequest request) {
        if (file.getSize() / 1024 > 65)
            return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
        if (!file.getContentType().contains("image"))
            return new ResultData<>(HandleEnum.FAIL, "文件类型有误!");
        ParamData pd = new ParamData();
        AppDevice cache = memory.getCache(getTokenFromRequest(request));
        pd.put(CommConst.DEVICE_SN, cache.getDeviceSn());
        pd.put("person_id", request.getParameter("person_id"));
        pd.put("recog_type", request.getParameter("recog_type"));
        pd.put("record_image", file.getBytes());
        pd.put("wid", cache.getWid());
        if (mFaceAppDao.insertRecord(pd)) {
            return new ResultData<>(HandleEnum.SUCCESS);
        }

        return new ResultData<>(HandleEnum.FAIL);
    }

    @Transactional
    @Override
    public ResultData<ParamData> addRecord(ParamData pd) throws Exception {
        String base64Image = pd.getString("file");
        if (StringUtils.isEmpty(base64Image))
            return new ResultData<>(HandleEnum.FAIL);
        byte[] blobImage = new BASE64Decoder().decodeBuffer(base64Image);
        if (blobImage != null) {
            if (blobImage.length / 1024 > 65)
                return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
            pd.put("record_image", blobImage);
            if (mFaceAppDao.insertRecord(pd) && mFaceAppDao.updateGrantPassNumber(pd))
                return new ResultData<>(HandleEnum.SUCCESS);

        }
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Transactional
    @Override
    @Deprecated
    public boolean uploadRecordImage(CommonsMultipartFile file, ParamData pd) throws Exception {
        BufferedOutputStream fos = null;
        try {
            String realPath = SystemConfig.UPLOAD_RECORD_IMAGE_DIR;
            CommUtil.mkdir(realPath);
            String[] suffix = file.getContentType().split("/");
            String fileName = CommUtil.get32UUID() + "." + suffix[1];
            String filePath = realPath + fileName;

            fos = new BufferedOutputStream(new FileOutputStream(filePath));
            fos.write(file.getBytes());
            fos.flush();

            //判断文件是否上传成功
            File file1 = new File(filePath);
            if (file1.exists() && file1.length() == file.getSize()) {
                pd.put("image_path", filePath);
                return true;
            }
        } finally {
            if (fos != null)
                fos.close();
        }
        return false;
    }

    @Override
    public ResultData<ParamData> getCurrentDate() {
        ParamData pd = new ParamData();
        pd.put("current_date", mFaceAppDao.selectNow());
        return new ResultData<>(HandleEnum.SUCCESS, pd);
    }

    @Transactional
    @Override
    @Deprecated
    public ResultData<ParamData> addPersonWithGrant(CommonsMultipartFile file, HttpServletRequest request) throws Exception {
        if (file.getSize() / 1024 > 65)
            return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
        if (!file.getContentType().contains("image"))
            return new ResultData<>(HandleEnum.FAIL, "文件类型有误!");

        ParamData pd = new ParamData();
        AppDevice cache = memory.getCache(getTokenFromRequest(request));
        pd.put(CommConst.DEVICE_SN, cache.getDeviceSn());
        pd.put("person_name", request.getParameter("person_name"));
        pd.put("emp_number", request.getParameter("emp_number"));
        pd.put("blob_image", file.getBytes());
        pd.put("wid", cache.getWid());

        boolean a = mPersonDao.insertPerson(pd);
        boolean b = mGrantDao.insertGrantDeviceSnPersonId(pd);

        String groupName = request.getParameter("group_name");
        pd.put("group_name", groupName);
        if (!StringUtils.isEmpty(groupName)) {
            ParamData group = mGroupDao.selectGroupByGroupName(pd);
            if (group != null) {
                pd.put("group_id", group.get("group_id") + "");
                mPersonDao.updatePersonGroupID(pd);
            }
        }

        if (a && b) {
            mSocketMessageHandle.sendMessageToDevice(cache.getDeviceSn(), mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1004_GRANT_UPDATE, null));
            ParamData person = mPersonDao.selectPerson(pd);
            return new ResultData<>(HandleEnum.SUCCESS, person);
        }

        return new ResultData<>(HandleEnum.FAIL);
    }

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
            boolean b = mGrantDao.insertGrantDeviceSnPersonId(pd);

            String groupName = pd.getString("group_name");
            pd.put("group_name", groupName);
            if (!StringUtils.isEmpty(groupName)) {
                ParamData group = mGroupDao.selectGroupByGroupName(pd);
                if (group != null) {
                    pd.put("group_id", group.get("group_id") + "");
                    mPersonDao.updatePersonGroupID(pd);
                }
            }

            if (a && b) {
                mSocketMessageHandle.sendMessageToDevice(pd.getString(CommConst.DEVICE_SN), mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1004_GRANT_UPDATE, null));

                ParamData person = mFaceAppDao.selectPerson(pd);
                return new ResultData<>(HandleEnum.SUCCESS, person);
            }
        }
        return new ResultData<>(HandleEnum.FAIL);
    }

    @Transactional
    @Override
    public ResultData<List<ParamData>> syncPerson(ParamData pd) {
        mFaceAppDao.updateGrantSyncStatus(pd);
        return new ResultData<>(HandleEnum.SUCCESS, mFaceAppDao.selectPersonListNoIn(pd));
    }

    @Override
    public void downloadApk(ParamData pd, HttpServletRequest request, HttpServletResponse response) throws Exception {
        BufferedInputStream bis = null;
        BufferedOutputStream fos = null;
        String apkPath = "";
        try {
            String applicationId = pd.getString("application_id");
            apkPath = request.getServletContext().getRealPath(SystemConfig.DOWNLOAD_APK_PATH + applicationId + ".apk");
            File file = new File(apkPath);
            bis = new BufferedInputStream(new FileInputStream(file));
            fos = new BufferedOutputStream(response.getOutputStream());

            response.setContentLength(bis.available());

            byte[] buffer = new byte[1024 * 10];
            int length;
            while ((length = bis.read(buffer)) > 0) {
                fos.write(buffer, 0, length);
            }
            fos.flush();

        } finally {
            if (bis != null)
                bis.close();
            if (fos != null)
                fos.close();
        }
    }

    @Override
    public ResultData<ParamData> getLastVersionInfo(ParamData pd) {
        pd.put("version", CommUtil.getProperties(pd.getString("application_id")));
        pd.put("description", "暂无");
        return new ResultData<>(HandleEnum.SUCCESS, pd);
    }

    @Override
    public void downloadImage(ParamData pd, HttpServletResponse response) throws Exception {
        BufferedOutputStream bos = null;
        try {
            ParamData paramData = mPersonDao.selectImage(pd);
            byte[] byteImage = (byte[]) paramData.get("blob_image");

            bos = new BufferedOutputStream(response.getOutputStream());
            bos.write(byteImage);
            bos.flush();
        } finally {
            if (bos != null)
                bos.close();
        }
    }

    @Override
    public ResultData<List<ParamData>> getPersonList(ParamData pd) {
        return new ResultData<>(HandleEnum.SUCCESS, mFaceAppDao.selectPersonList(pd));
    }

    @Override
    public ResultData<ParamData> uploadDeviceInfo(ParamData pd) {
        if (mFaceAppDao.updateDeviceConfig(pd))
            return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }

    private String getTokenFromRequest(HttpServletRequest request) {
        String token = request.getHeader(CommConst.ACCESS_APP_TOKEN);
        if (StringUtils.isEmpty(token)) {
            // 从请求信息中获取token值
            token = request.getParameter(CommConst.ACCESS_APP_TOKEN);
        }
        return token;
    }
}
