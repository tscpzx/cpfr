package com.ts.cpfr.controller.base;

import com.ts.cpfr.ehcache.WebMemory;
import com.ts.cpfr.utils.CommConst;
import com.ts.cpfr.utils.CommUtil;
import com.ts.cpfr.utils.ParamData;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @Classname WebBaseController
 * @Description
 * @Date 2019/2/20 17:08
 * @Created by cjw
 */
public class WebBaseController extends BaseController {
    @Autowired
    private WebMemory memory;

    /**
     * 初始化参数
     *
     * @return
     */
    public ParamData paramDataInit() {
        ParamData pd = new ParamData(this.getRequest());
        String token = CommUtil.getTokenFromRequest(this.getRequest());
        if (!StringUtils.isEmpty(token) && memory.checkCache(token)) {
            pd.put(CommConst.ACCESS_CPFR_TOKEN, token);
            pd.put("wid", memory.getCache(token).getWid());
        }
        return pd;
    }
}
