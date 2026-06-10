package com.zp.haoke.house.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.zp.haoke.house.domain.dto.NewsArticleCreateDTO;
import com.zp.haoke.house.domain.dto.NewsArticleQueryDTO;
import com.zp.haoke.house.domain.dto.NewsArticleUpdateDTO;
import com.zp.haoke.house.domain.po.NewsArticlePO;
import com.zp.haoke.house.domain.vo.NewsArticleVO;
import jakarta.validation.Valid;

public interface INewsArticleService extends IService<NewsArticlePO> {

    NewsArticleVO create(@Valid NewsArticleCreateDTO createDTO);

    NewsArticleVO update(@Valid NewsArticleUpdateDTO updateDTO);

    NewsArticleVO queryById(String id);

    IPage<NewsArticleVO> queryPageList(NewsArticleQueryDTO queryDTO);

    IPage<NewsArticleVO> queryPublishedPageList(NewsArticleQueryDTO queryDTO);

    Boolean updateStatus(String id, Integer status);

    Boolean deleteById(String id);
}
