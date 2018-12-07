package com.ts.cpfr.ehcache.listener;

import com.ts.cpfr.ehcache.ThreadToken;
import com.ts.cpfr.entity.LoginUser;
import com.ts.cpfr.utils.SysLog;

import net.sf.ehcache.CacheException;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import net.sf.ehcache.event.CacheEventListener;

/**
 * @Classname MyCacheEventListener
 * @Description
 * @Date 2018/12/7 10:45
 * @Created by cjw
 */
public class MyCacheEventListener implements CacheEventListener {

    //方法会在往Cache中移除单个元素时被调用，即在调用Cache的remove方法之后被调用。
    @Override
    public void notifyElementRemoved(Ehcache cache, Element element) throws CacheException {
        if (element.getObjectKey().equals(ThreadToken.getToken())) {
            LoginUser user = (LoginUser) element.getObjectValue();
            SysLog.info(user.getName() + " removed");
            ThreadToken.clearToken();
        }
    }

    //方法会在往Cache中添加元素时被调用。调用Cache的put方法添加元素时会被阻塞，直到对应的notifyElementPut方法返回之后。
    @Override
    public void notifyElementPut(Ehcache cache, Element element) throws CacheException {
    }

    //方法，当往Cache中put一个已经存在的元素时就会触发CacheEventListener的notifyElementUpdated方法，此时put操作也会处于阻塞状态，直到notifyElementUpdated方法执行完毕。
    @Override
    public void notifyElementUpdated(Ehcache cache, Element element) throws CacheException {
    }

    //方法，当Ehcache检测到Cache中有元素已经过期的时候将调用notifyElementExpired方法。
    @Override
    public void notifyElementExpired(Ehcache cache, Element element) {
        if (element.getObjectKey().equals(ThreadToken.getToken())) {
            LoginUser user = (LoginUser) element.getObjectValue();
            SysLog.info(user.getName() + " expired");
            ThreadToken.clearToken();
        }
    }

    //方法将会在元素被驱除的时候调用。
    @Override
    public void notifyElementEvicted(Ehcache cache, Element element) {
    }

    //方法将在调用Cache的removeAll方法之后被调用。
    @Override
    public void notifyRemoveAll(Ehcache cache) {
    }

    //方法用于释放资源。
    @Override
    public void dispose() {
    }

    public Object clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException();
    }

}
