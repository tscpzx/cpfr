package com.ts.cpfr.controller;

import com.ts.cpfr.controller.base.WebBaseController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
public class PageController extends WebBaseController {
    @Autowired
    private LocaleResolver localeResolver;

    @RequestMapping(value = {"/login", "/web", "/register"})
    public ModelAndView page(HttpServletRequest request, HttpServletResponse response, String lang) {
        if ("en_US".equals(lang)) {
            localeResolver.setLocale(request, response, Locale.US);
        } else if ("zh_CN".equals(lang)) {
            localeResolver.setLocale(request, response, Locale.CHINA);
        } else
            localeResolver.setLocale(request, response, Locale.CHINA);
        return new ModelAndView(request.getServletPath());
    }

    @RequestMapping(value = {"/page/device/*", "/page/person/*", "/page/group/*", "/page/record/*","/page/attend/*"})
    public ModelAndView page2(HttpServletRequest request, HttpServletResponse response) {
        String[] pages = request.getServletPath().split("page");
        return new ModelAndView(pages[1]);
    }
}
