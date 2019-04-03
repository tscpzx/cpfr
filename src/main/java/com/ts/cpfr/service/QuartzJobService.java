package com.ts.cpfr.service;

import com.ts.cpfr.entity.QuartzJobModel;

import java.util.List;

/**
 * @Classname QuartzJobService
 * @Description
 * @Date 2019/4/3 11:40
 * @Created by cjw
 */
public interface QuartzJobService {
    List<QuartzJobModel> getAll();
}
