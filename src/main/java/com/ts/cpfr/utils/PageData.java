package com.ts.cpfr.utils;

import com.github.pagehelper.PageSerializable;

import java.util.List;

/**
 * @Classname Page
 * @Description
 * @Date 2018/12/12 13:33
 * @Created by cjw
 */
public class PageData<T> extends PageSerializable<T> {
    public PageData(List<T> list) {
        super(list);
    }

    @Override
    public String toString() {
        return "Page{total=" + this.total + ", list=" + this.list + '}';
    }
}
