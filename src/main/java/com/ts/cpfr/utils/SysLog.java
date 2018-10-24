package com.ts.cpfr.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author panteng
 * @version V0.0.1
 * @Description 日志记录类
 * @date 2016-09-08
 */
public class SysLog {
    private static Logger log = LoggerFactory.getLogger(SysLog.class);

    /**
     * 打印信息
     */
    public static void info(String src) {
        String location = "";
        StackTraceElement[] stacks = Thread.currentThread().getStackTrace();
        location = stacks[2].getClassName() + "." + stacks[2].getMethodName() + "(" + stacks[2].getLineNumber() + ")";
        log.info(location + src);
    }
}