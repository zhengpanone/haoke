package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.house.domain.dto.NewsArticleCreateDTO;
import com.zp.haoke.house.domain.dto.NewsArticleQueryDTO;
import com.zp.haoke.house.domain.dto.NewsArticleUpdateDTO;
import com.zp.haoke.house.domain.po.NewsArticlePO;
import com.zp.haoke.house.domain.vo.NewsArticleVO;
import com.zp.haoke.house.mapper.NewsArticleMapper;
import com.zp.haoke.house.service.INewsArticleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class NewsArticleServiceImpl extends ServiceImpl<NewsArticleMapper, NewsArticlePO> implements INewsArticleService {

    private static final int STATUS_PUBLISHED = 2;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public NewsArticleVO create(NewsArticleCreateDTO createDTO) {
        NewsArticlePO po = new NewsArticlePO();
        fillCreate(po, createDTO);
        baseMapper.insert(po);
        return toVO(po);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public NewsArticleVO update(NewsArticleUpdateDTO updateDTO) {
        NewsArticlePO po = new NewsArticlePO();
        po.setId(updateDTO.getId());
        fillUpdate(po, updateDTO);
        baseMapper.updateById(po);
        return queryById(updateDTO.getId());
    }

    @Override
    public NewsArticleVO queryById(String id) {
        return toVO(baseMapper.selectById(id));
    }

    @Override
    public IPage<NewsArticleVO> queryPageList(NewsArticleQueryDTO queryDTO) {
        NewsArticleQueryDTO query = ensureQuery(queryDTO);
        Page<NewsArticlePO> page = Page.of(query.getPageNum(), query.getPageSize());
        return baseMapper.selectPage(page, buildWrapper(query)).convert(this::toVO);
    }

    @Override
    public IPage<NewsArticleVO> queryPublishedPageList(NewsArticleQueryDTO queryDTO) {
        NewsArticleQueryDTO query = ensureQuery(queryDTO);
        query.setStatus(STATUS_PUBLISHED);
        Page<NewsArticlePO> page = Page.of(query.getPageNum(), query.getPageSize());
        return baseMapper.selectPage(page, buildWrapper(query)).convert(this::toVO);
    }

    @Override
    public Boolean updateStatus(String id, Integer status) {
        NewsArticlePO po = new NewsArticlePO();
        po.setId(id);
        po.setStatus(status);
        if (isPublished(status)) {
            po.setPublishTime(LocalDateTime.now());
        }
        return baseMapper.updateById(po) > 0;
    }

    @Override
    public Boolean deleteById(String id) {
        return baseMapper.deleteById(id) > 0;
    }

    private NewsArticleQueryDTO ensureQuery(NewsArticleQueryDTO queryDTO) {
        NewsArticleQueryDTO query = queryDTO == null ? new NewsArticleQueryDTO() : queryDTO;
        if (query.getPageNum() == null || query.getPageNum() < 1) {
            query.setPageNum(1);
        }
        if (query.getPageSize() == null || query.getPageSize() < 1) {
            query.setPageSize(10);
        }
        return query;
    }

    private LambdaQueryWrapper<NewsArticlePO> buildWrapper(NewsArticleQueryDTO query) {
        return new LambdaQueryWrapper<NewsArticlePO>()
                .like(StringUtils.isNotBlank(query.getTitle()), NewsArticlePO::getTitle, query.getTitle())
                .eq(query.getStatus() != null, NewsArticlePO::getStatus, query.getStatus())
                .orderByDesc(NewsArticlePO::getSort)
                .orderByDesc(NewsArticlePO::getPublishTime)
                .orderByDesc(NewsArticlePO::getCreateTime);
    }

    private void fillCreate(NewsArticlePO po, NewsArticleCreateDTO dto) {
        po.setTitle(dto.getTitle());
        po.setSummary(dto.getSummary());
        po.setContent(dto.getContent());
        po.setCoverUrl(dto.getCoverUrl());
        po.setSource(dto.getSource());
        po.setStatus(dto.getStatus() == null ? 1 : dto.getStatus());
        po.setSort(dto.getSort() == null ? 0 : dto.getSort());
        po.setPublishTime(resolvePublishTime(po.getStatus(), dto.getPublishTime()));
    }

    private void fillUpdate(NewsArticlePO po, NewsArticleUpdateDTO dto) {
        po.setTitle(dto.getTitle());
        po.setSummary(dto.getSummary());
        po.setContent(dto.getContent());
        po.setCoverUrl(dto.getCoverUrl());
        po.setSource(dto.getSource());
        po.setStatus(dto.getStatus());
        po.setSort(dto.getSort());
        po.setPublishTime(resolvePublishTime(dto.getStatus(), dto.getPublishTime()));
    }

    private LocalDateTime resolvePublishTime(Integer status, LocalDateTime publishTime) {
        if (publishTime != null) {
            return publishTime;
        }
        return isPublished(status) ? LocalDateTime.now() : null;
    }

    private boolean isPublished(Integer status) {
        return status != null && status == STATUS_PUBLISHED;
    }

    private NewsArticleVO toVO(NewsArticlePO po) {
        if (po == null) {
            return null;
        }
        NewsArticleVO vo = new NewsArticleVO();
        vo.setId(po.getId());
        vo.setTitle(po.getTitle());
        vo.setSummary(po.getSummary());
        vo.setContent(po.getContent());
        vo.setCoverUrl(po.getCoverUrl());
        vo.setSource(po.getSource());
        vo.setStatus(po.getStatus());
        vo.setSort(po.getSort());
        vo.setPublishTime(po.getPublishTime());
        vo.setCreated(po.getCreateTime());
        vo.setUpdated(po.getUpdateTime());
        return vo;
    }
}
