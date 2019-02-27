package com.ts.cpfr.ehcache;

import com.ts.cpfr.entity.AppDevice;

import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PreDestroy;

/**
 * @Classname AppMemory
 * @Description
 * @Date 2019/2/19 9:48
 * @Created by cjw
 */
@Component
public class AppMemory {

    @Autowired
    private Cache ehcache;

    /**
     * 关闭缓存管理器
     */
    @PreDestroy
    protected void shutdown() {
        if (ehcache != null) {
            ehcache.getCacheManager().shutdown();
        }
    }

    /**
     * 保存当前登录用户信息
     * timeToLiveSeconds -->当对象自从被存放到缓存中后，如果处于缓存中的时间超过了 timeToLiveSeconds属性值,这个对象就会过期，
     * EHCache将把它从缓存中清除；即缓存自创建日期起能够存活的最长时间，单位为秒(s)
     * <p>
     * timeToIdleSeconds -->  当对象自从最近一次被访问后，如果处于空闲状态的时间超过了timeToIdleSeconds属性值，这个对象就会过期，
     * EHCache将把它从缓存中清空；即缓存被创建后，最后一次访问时间到缓存失效之时，两者之间的间隔，单位为秒(s)
     */
    public void putCache(AppDevice device) {
        // 生成seed和token值
        String seed = TokenProcessor.getInstance().generateSeed(device.getDeviceSn());
        String token = TokenProcessor.getInstance().generateToken(device.getDeviceSn());

        // 保存token到登录用户中
        device.setToken(token);
        // 清空之前的登录信息
        removeCache(device.getDeviceSn());
        // 保存新的token和登录信息
        ehcache.put(new Element(seed, token));
        ehcache.put(new Element(token, device));
    }

    /**
     * 获取当前线程中的用户信息
     */
    public AppDevice getCache(String token) {
        Element element = ehcache.get(token);
        return element == null ? null : (AppDevice) element.getObjectValue();
    }

    /**
     * 根据token检查用户是否登录
     */
    public boolean checkCache(String token) {
        Element element = ehcache.get(token);
        return element != null && element.getObjectValue() != null;
    }

    /**
     * 清空登录信息
     */
    public void removeCache(String deviceSn) {
        if (!StringUtils.isEmpty(deviceSn)) {
            // 根据登录的用户名生成seed，然后清除登录信息
            // 根据seed找到对应的token
            String seed = TokenProcessor.getInstance().generateSeed(deviceSn + "");
            Element element = ehcache.get(seed);
            if (element != null) {
                // 根据token清空之前的登录信息
                Object token = element.getObjectValue();
                ehcache.remove(seed);
                ehcache.remove(token);
            }
        }
    }

    public String getToken(String deviceSn) {
        if (!StringUtils.isEmpty(deviceSn)) {
            // 根据登录的用户名生成seed，然后清除登录信息
            // 根据seed找到对应的token
            String seed = TokenProcessor.getInstance().generateSeed(deviceSn + "");
            return (String) ehcache.get(seed).getObjectValue();
        }
        return null;
    }
}
