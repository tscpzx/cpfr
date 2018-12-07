package com.ts.cpfr.ehcache.listener;

import com.ts.cpfr.utils.SysLog;

import net.sf.ehcache.CacheException;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Status;
import net.sf.ehcache.event.CacheManagerEventListener;

/**
 * @Classname MyCacheManagerEventListener
 * @Description
 * @Date 2018/12/7 10:21
 * @Created by cjw
 */
public class MyCacheManagerEventListener implements CacheManagerEventListener {

    private final CacheManager cacheManager;

    MyCacheManagerEventListener(CacheManager cacheManager) {
        this.cacheManager = cacheManager;
    }

    //方法会在CacheManagerEventListener实现类实例化后被调用，用于初始化CacheManagerEventListener。
    @Override
    public void init() throws CacheException {
        SysLog.info("cache init");
    }

    //方法返回当前CacheManagerEventListener所处的状态，可选值有STATUS_UNINITIALISED、STATUS_ALIVE和STATUS_SHUTDOWN。
    @Override
    public Status getStatus() {
        SysLog.info("cache getStatus");
        return null;
    }

    //方法用于释放资源。
    @Override
    public void dispose() throws CacheException {
        SysLog.info("cache dispose");
    }

    //会在往CacheManager中添加Cache时被调用。
    @Override
    public void notifyCacheAdded(String cacheName) {
        SysLog.info("cache Added" + cacheName);
    }

    //方法会在从CacheManager中移除Cache时被调用。
    @Override
    public void notifyCacheRemoved(String cacheName) {
        SysLog.info("cache Removed" + cacheName);
    }
}
