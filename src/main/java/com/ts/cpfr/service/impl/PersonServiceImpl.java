package com.ts.cpfr.service.impl;

import com.arcsoft.face.FaceEngine;
import com.arcsoft.face.FaceInfo;
import com.arcsoft.face.enums.ImageFormat;
import com.github.pagehelper.PageHelper;
import com.ts.cpfr.dao.DeviceDao;
import com.ts.cpfr.dao.GroupDao;
import com.ts.cpfr.dao.PersonDao;
import com.ts.cpfr.dao.TableDao;
import com.ts.cpfr.service.PersonService;
import com.ts.cpfr.utils.ArcFace;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.HandleEnum;
import com.ts.cpfr.utils.PageData;
import com.ts.cpfr.utils.ParamData;
import com.ts.cpfr.utils.ResultData;
import com.ts.cpfr.utils.SocketEnum;
import com.ts.cpfr.utils.SystemConfig;
import com.ts.cpfr.websocket.SocketMessageHandle;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.socket.TextMessage;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;

/**
 * @Classname PersonServiceImpl
 * @Description
 * @Date 2018/11/6 10:45
 * @Created by cjw
 */
@Service
public class PersonServiceImpl implements PersonService {
    @Resource
    private DeviceDao mDeviceDao;
    @Resource
    private PersonDao mPersonDao;
    @Resource
    private GroupDao mGroupDao;
    @Resource
    private TableDao mTableDao;
    @Autowired
    private SocketMessageHandle mSocketMessageHandle;

    @Override
    public ResultData<PageData<ParamData>> getPersonList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> personList = mPersonDao.selectPersonList(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(personList));
    }

    @Override
    public ResultData<PageData<ParamData>> getPersonBase64List(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> personList = mPersonDao.selectPersonListWithBlob(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(personList));
    }

    @Transactional
    @Override
    public ResultData<ParamData> addPerson(CommonsMultipartFile file, ParamData pd) {
        if (file.getSize() / 1024 > 65)
            return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
        if (!file.getContentType().contains("image"))
            return new ResultData<>(HandleEnum.FAIL, "文件类型有误!");

        pd.put("blob_image", file.getBytes());
        if (mPersonDao.insertPerson(pd))
            return new ResultData<>(HandleEnum.SUCCESS);
        return new ResultData<>(HandleEnum.FAIL);
    }

    private int faceEngine(byte[] bytes) {
        ArcFace.ImageInfo imageInfo = ArcFace.getArcFace().getRGBData(bytes);
        FaceEngine faceEngine = ArcFace.getFaceEngine();

        //人脸检测
        List<FaceInfo> faceInfoList = new ArrayList<>();
        faceEngine.detectFaces(imageInfo.getRgbData(), imageInfo.getWidth(), imageInfo.getHeight(), ImageFormat.CP_PAF_BGR24, faceInfoList);
        return faceInfoList.size();
    }

    @Transactional
    @Override
    public ResultData<ParamData> updatePerson(CommonsMultipartFile file, ParamData pd) throws IOException {
        if (file.getSize() / 1024 > 65)
            return new ResultData<>(HandleEnum.FAIL, "上传失败，图片过大!");
        if (!file.getContentType().contains("image"))
            return new ResultData<>(HandleEnum.FAIL, "文件类型有误!");

        //        int num = faceEngine(file.getBytes());
        //        if (num <= 0)
        //            return new ResultData<>(HandleEnum.FAIL, "未识别到人脸");
        //        else if (num > 1)
        //            return new ResultData<>(HandleEnum.FAIL, "识别到多张人脸");

        pd.put("blob_image", file.getBytes());
        if (mPersonDao.updatePersonInfo(pd)) {
            List<String> deviceSnLists = mDeviceDao.selectDeviceSnByPersonId(pd);
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1003_PERSON_UPDATE, null);
            for (String deviceSn : deviceSnLists) {
                mSocketMessageHandle.sendMessageToDevice(deviceSn, message);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        } else
            return new ResultData<>(HandleEnum.FAIL);
    }

    @Transactional
    @Override
    public ResultData<ParamData> updatePerson(ParamData pd) throws IOException {
        if (mPersonDao.updatePersonInfo(pd)) {
            List<String> deviceSnLists = mDeviceDao.selectDeviceSnByPersonId(pd);
            TextMessage message = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1003_PERSON_UPDATE, null);
            for (String deviceSn : deviceSnLists) {
                mSocketMessageHandle.sendMessageToDevice(deviceSn, message);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        } else
            return new ResultData<>(HandleEnum.FAIL);
    }

    @Transactional
    @Override
    public ResultData<ParamData> deletePerson(ParamData pd) throws IOException {
        if (mPersonDao.deletePerson(pd)) {
            List<String> deviceSnLists = mDeviceDao.selectDeviceSnByPersonId(pd);
            TextMessage personMessage = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1003_PERSON_UPDATE, null);
            TextMessage grantMessage = mSocketMessageHandle.obtainMessage(SocketEnum.CODE_1004_GRANT_UPDATE, null);
            for (String deviceSn : deviceSnLists) {
                mSocketMessageHandle.sendMessageToDevice(deviceSn, personMessage);
                mSocketMessageHandle.sendMessageToDevice(deviceSn, grantMessage);
            }
            return new ResultData<>(HandleEnum.SUCCESS);
        } else
            return new ResultData<>(HandleEnum.FAIL);
    }

    @Override
    public ParamData queryPerson(ParamData pd) {
        ParamData data = mPersonDao.selectPerson(pd);
        data.put("group_list", mGroupDao.selectGroupListByPersonID(pd));
        return data;
    }

    public byte[] blobToByte(Blob blob) throws Exception {
        InputStream is = blob.getBinaryStream();
        byte[] bs = new byte[1024 * 10];
        int len = -1;
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        while ((len = is.read(bs)) != -1) {
            os.write(bs, 0, len);
        }
        byte[] bytes = os.toByteArray();
        os.close();
        is.close();
        return bytes;
    }

    @Transactional
    @Override
    public boolean uploadImageFile(CommonsMultipartFile file, ParamData pd) throws Exception {
        BufferedOutputStream fos = null;
        try {
            String realPath = SystemConfig.UPLOAD_IMAGE_DIR;
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
    public void loadImageFile(ParamData pd, HttpServletResponse response) throws Exception {
        BufferedInputStream bis = null;
        BufferedOutputStream fos = null;
        try {
            File file = new File(pd.getString("image_path"));
            if (file.exists()) {
                bis = new BufferedInputStream(new FileInputStream(file));
                fos = new BufferedOutputStream(response.getOutputStream());

                response.setHeader("Cache-Control", "no-cache,must-revalidate");//告诉浏览器当前页面不进行缓存，每次访问的时间必须从服务器上读取最新的数据
                response.setContentLength(bis.available());

                byte[] buffer = new byte[1024 << 2];
                int length;
                while ((length = bis.read(buffer)) > 0) {
                    fos.write(buffer, 0, length);
                }
                fos.flush();
            }

        } finally {
            if (bis != null)
                bis.close();
            if (fos != null)
                fos.close();
        }
    }

    @Override
    public void file2base64(List<ParamData> list) throws Exception {
        for (ParamData pd : list) {
            file2base64(pd);
        }
    }

    @Override
    public void file2base64(ParamData pd) throws Exception {
        File file = new File(pd.getString("image_path"));
        if (file.exists()) {
            FileInputStream fis = new FileInputStream(file);
            byte[] bytes = new byte[fis.available()];
            fis.read(bytes);
            pd.put("base_image", bytes);
        }
        pd.remove("image_path");
    }

    @Override
    public void blob2base64(List<ParamData> list) throws Exception {
        for (ParamData pd : list) {
            blob2base64(pd);
        }
    }

    @Override
    public void blob2base64(ParamData pd) throws Exception {
        ParamData paramData = mPersonDao.selectImage(pd);
        if (paramData != null) {
            pd.put("base_image", paramData.get("blob_image"));
        }
        pd.remove("wid");
    }

    @Override
    public ResultData<PageData<ParamData>> getAccessDeviceList(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> deviceList = mDeviceDao.selectAccessDeviceListByPersonId(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(deviceList));
    }

    @Transactional
    @Override
    public ResultData<ParamData> batchUpload(CommonsMultipartFile[] files, ParamData pd) {
        for (int i = 0; i < files.length; i++) {
            try {
                CommonsMultipartFile file = files[i];
                if ((file.getSize() / 1024) > 65)
                    continue;

                String fileName = file.getOriginalFilename();
                String[] split = fileName.split("\\.")[0].split("-");
                String groupName = "";
                String personName = "";
                if (split.length <= 1) {
                    personName = split[0];
                } else if (split.length == 2) {
                    groupName = split[0];
                    personName = split[1];
                }

                ParamData data = new ParamData();
                data.put("person_name", personName);
                data.put("blob_image", file.getBytes());
                data.put("wid", pd.get("wid"));
                mPersonDao.insertPerson(data);
                data.put("person_id", mTableDao.selectLastInsertID());

                data.put("group_name", groupName);
                if (!StringUtils.isEmpty(groupName)) {
                    ParamData group = mGroupDao.selectGroupByGroupName(data);
                    if (group != null) {
                        data.put("group_id", group.get("group_id") + "");
                        mGroupDao.insertGroupPerson(data);
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                return new ResultData<>(HandleEnum.FAIL);
            }
        }
        return new ResultData<>(HandleEnum.SUCCESS);
    }

    @Override
    public ResultData<ParamData> getGroupPersonList(ParamData pd) {
        List<ParamData> groupList = mGroupDao.selectGroupPersonListMap(pd);
        if (groupList == null)
            groupList = new ArrayList<>();
        ParamData other = new ParamData();
        other.put("group_id", 0);
        other.put("group_name", "未分组");
        other.put("person_list", mPersonDao.selectPersonListNoGroup(pd));
        groupList.add(other);

        if (!StringUtils.isEmpty(pd.getString("device_sn"))) {
            List<ParamData> personList = mPersonDao.selectGrantPersonListByDeviceSn(pd);
            List personIds = CommUtil.getIntListFromObjList(personList, "person_id");

            if (personIds != null)
                for (ParamData g : groupList) {
                    List<ParamData> gPersonList = (List<ParamData>) g.get("person_list");
                    Iterator<ParamData> it = gPersonList.iterator();
                    while (it.hasNext()) {
                        ParamData person = it.next();
                        if (personIds.contains(person.get("person_id")))
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
    public ResultData<PageData<ParamData>> getPersonListByGroup(ParamData pd) {
        int pageNum = CommUtil.paramConvert(pd.getString("pageNum"), 0);//当前页
        int pageSize = CommUtil.paramConvert(pd.getString("pageSize"), 0);//每一页10条数据

        if (pageSize != 0)
            PageHelper.startPage(pageNum, pageSize);
        List<ParamData> personList = mPersonDao.selectPersonListByGroupID(pd);
        return new ResultData<>(HandleEnum.SUCCESS, new PageData<>(personList));
    }

    @Override
    public ResultData<List<ParamData>> getListGroupUnSelected(ParamData pd) {
        List<ParamData> personList = mPersonDao.selectPersonList(pd);
        List<ParamData> gPersonList = mPersonDao.selectPersonListByGroupID(pd);

        List personIds = CommUtil.getIntListFromObjList(gPersonList, "person_id");

        if (personIds != null){
            Iterator<ParamData> it = personList.iterator();
            while (it.hasNext()) {
                ParamData person = it.next();
                if (personIds.contains(person.get("person_id")))
                    //                            device.put("disabled", true);//不可点击
                    it.remove();
            }
        }
        return new ResultData<>(HandleEnum.SUCCESS, personList);
    }
}
