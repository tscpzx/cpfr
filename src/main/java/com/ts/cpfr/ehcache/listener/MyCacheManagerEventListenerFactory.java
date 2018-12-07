package com.ts.cpfr.ehcache.listener;

import net.sf.ehcache.CacheManager;
import net.sf.ehcache.event.CacheManagerEventListener;
import net.sf.ehcache.event.CacheManagerEventListenerFactory;

import java.util.Properties;

/**
 * @Classname MyCacheManagerEventListenerFactory
 * @Description
 * @Date 2018/12/7 10:23
 * @Created by cjw
 */
public class MyCacheManagerEventListenerFactory extends CacheManagerEventListenerFactory {

    @Override
    public CacheManagerEventListener createCacheManagerEventListener(CacheManager cacheManager, Properties properties) {
        return new MyCacheManagerEventListener(cacheManager);
    }
}
