package com.ts.cpfr.controller.base;

import com.ts.cpfr.ehcache.AppMemory;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.ParamData;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;

/**
 * @Classname AppBaseController
 * @Description
 * @Date 2019/2/20 17:08
 * @Created by cjw
 */
public class AppBaseController extends BaseController{
    @Autowired
    private AppMemory memory;

    /**
     * 初始化参数
     *
     * @return
     */
    public ParamData paramDataInit() {
        ParamData pd = new ParamData(this.getRequest());
        String token = getTokenFromRequest(this.getRequest());
        if (!StringUtils.isEmpty(token) && memory.checkCache(token)) {
            pd.put(CommConst.ACCESS_APP_TOKEN, token);
            pd.put(CommConst.DEVICE_SN, memory.getCache(token).getDeviceSn());
            pd.put("wid", memory.getCache(token).getWid());
        }
        return pd;
    }

    private String getTokenFromRequest(HttpServletRequest request){
        String token = request.getHeader(CommConst.ACCESS_APP_TOKEN);
        if (StringUtils.isEmpty(token)) {
            // 从请求信息中获取token值
            token = request.getParameter(CommConst.ACCESS_APP_TOKEN);
        }

        return token;
    }
}
