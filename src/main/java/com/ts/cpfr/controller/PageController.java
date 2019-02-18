package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.BaseController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @Classname LangController
 * @Description
 * @Date 2019/2/14 14:19
 * @Created by cjw
 */
@Controller
public class PageController extends BaseController {
    @Autowired
    private LocaleResolver localeResolver;

    @RequestMapping("/{page}")
    public ModelAndView page(HttpServletRequest request, HttpServletResponse response, @PathVariable String page, String lang) {
        if ("en_US".equals(lang)) {
            localeResolver.setLocale(request, response, Locale.US);
        } else if ("zh_CN".equals(lang)) {
            localeResolver.setLocale(request, response, Locale.CHINA);
        }
        return new ModelAndView(page);
    }

    @RequestMapping(value = {"/device/*", "/person/*", "/group/*", "/record/*"})
    public ModelAndView device(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView(request.getServletPath());
    }
}
