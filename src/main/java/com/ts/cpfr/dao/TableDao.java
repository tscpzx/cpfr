package com.ts.cpfr.dao;

/**
 * @Classname TableDao
 * @Description
 * @Date 2018/10/22 14:52
 * @Created by cjw
 */
public interface TableDao {
    int selectLastInsertID();

    boolean createTblDevcie(int wid);

    boolean createTblPerson(int wid);

    boolean createTblGroup(int wid);
}
