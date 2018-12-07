package com.ts.cpfr.ehcache.listener;

import net.sf.ehcache.event.CacheEventListener;
import net.sf.ehcache.event.CacheEventListenerFactory;

import java.util.Properties;

/**
 * @Classname MyCacheEventListenerFactory
 * @Description
 * @Date 2018/12/7 10:48
 * @Created by cjw
 */
public class MyCacheEventListenerFactory extends CacheEventListenerFactory {

    @Override
    public CacheEventListener createCacheEventListener(Properties properties) {
        return new MyCacheEventListener();
    }

}
