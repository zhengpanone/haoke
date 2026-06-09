package com.zp.haoke.house.service.impl;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.core.toolkit.support.SFunction;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.framework.core.enums.HouseRentStatus;
import com.zp.haoke.house.domain.convert.HouseResourceConvert;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.dto.HouseResourceQueryDTO;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.domain.vo.HouseResourceDetailVO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import com.zp.haoke.house.mapper.HouseResourceMapper;
import com.zp.haoke.house.service.IHouseResourceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class HouseResourceServiceImpl extends ServiceImpl<HouseResourceMapper, HouseResourcePO> implements IHouseResourceService {

    private final HouseResourceConvert houseResourceConvert;

    @Override
    public int saveHouseResource(HouseResourceCreateDTO houseResourceCreateDTO, String landlordId) {
        HouseResourcePO houseResourcePO = houseResourceConvert.toEntity(houseResourceCreateDTO);
        houseResourcePO.setStatus(HouseRentStatus.PENDING);
        houseResourcePO.setLandlordId(landlordId);
        log.info("create house resource: id={}, title={}, status={}, landlordId={}",
                houseResourcePO.getId(), houseResourcePO.getTitle(), houseResourcePO.getStatus(), landlordId);
        int rows = baseMapper.insert(houseResourcePO);
        log.info("create house resource done: rows={}", rows);
        return rows;
    }

    @Override
    public HouseResourceDetailVO queryById(String id) {
        HouseResourcePO houseResourcePO = baseMapper.selectById(id);
        return houseResourceConvert.toDetailVO(houseResourcePO);
    }

    @Override
    public IPage<HouseResourceVO> queryPageList(HouseResourceQueryDTO queryDTO) {
        HouseResourceQueryDTO query = ensureQuery(queryDTO);
        Page<HouseResourcePO> page = Page.of(query.getPageNum(), query.getPageSize());
        LambdaQueryWrapper<HouseResourcePO> wrapper = buildWrapper(query)
                .orderByDesc(HouseResourcePO::getCreateTime);
        return baseMapper.selectPage(page, wrapper).convert(houseResourceConvert::toVO);
    }

    @Override
    public IPage<HouseResourceVO> queryRecommendPageList(HouseResourceQueryDTO queryDTO) {
        HouseResourceQueryDTO query = ensurePublicQuery(queryDTO);
        Page<HouseResourcePO> page = Page.of(query.getPageNum(), query.getPageSize());
        LambdaQueryWrapper<HouseResourcePO> wrapper = buildWrapper(query)
                .orderByDesc(HouseResourcePO::getCreateTime);
        return baseMapper.selectPage(page, wrapper).convert(houseResourceConvert::toVO);
    }

    @Override
    public IPage<HouseResourceVO> queryHotPageList(HouseResourceQueryDTO queryDTO) {
        HouseResourceQueryDTO query = ensurePublicQuery(queryDTO);
        Page<HouseResourcePO> page = Page.of(query.getPageNum(), query.getPageSize());
        LambdaQueryWrapper<HouseResourcePO> wrapper = buildWrapper(query)
                .orderByDesc(HouseResourcePO::getRent)
                .orderByDesc(HouseResourcePO::getCreateTime);
        return baseMapper.selectPage(page, wrapper).convert(houseResourceConvert::toVO);
    }

    @Override
    public IPage<HouseResourceVO> queryNearbyPageList(HouseResourceQueryDTO queryDTO) {
        HouseResourceQueryDTO query = ensurePublicQuery(queryDTO);
        Page<HouseResourcePO> page = Page.of(query.getPageNum(), query.getPageSize());
        LambdaQueryWrapper<HouseResourcePO> wrapper = buildWrapper(query)
                .orderByDesc(HouseResourcePO::getUpdateTime);
        return baseMapper.selectPage(page, wrapper).convert(houseResourceConvert::toVO);
    }

    @Override
    public Boolean deleteByIds(String id) {
        return baseMapper.deleteById(id) > 0;
    }

    @Override
    public Boolean updateById(HouseResourceUpdateDTO houseResourceUpdateDTO) {
        return false;
    }

    private HouseResourceQueryDTO ensureQuery(HouseResourceQueryDTO queryDTO) {
        HouseResourceQueryDTO query = queryDTO == null ? new HouseResourceQueryDTO() : queryDTO;
        if (query.getPageNum() == null || query.getPageNum() < 1) {
            query.setPageNum(1);
        }
        if (query.getPageSize() == null || query.getPageSize() < 1) {
            query.setPageSize(10);
        }
        return query;
    }

    private HouseResourceQueryDTO ensurePublicQuery(HouseResourceQueryDTO queryDTO) {
        HouseResourceQueryDTO query = ensureQuery(queryDTO);
        if (query.getStatus() == null && CollUtil.isEmpty(query.getStatusList())) {
            query.setStatusList(List.of(HouseRentStatus.APPROVED));
        }
        return query;
    }

    private LambdaQueryWrapper<HouseResourcePO> buildWrapper(HouseResourceQueryDTO query) {
        LambdaQueryWrapper<HouseResourcePO> wrapper = new LambdaQueryWrapper<>();
        String keyword = StringUtils.isNotBlank(query.getKeyword()) ? query.getKeyword().trim() : query.getTitle();

        wrapper.and(StringUtils.isNotBlank(keyword), nested -> nested
                        .like(HouseResourcePO::getTitle, keyword)
                        .or()
                        .like(HouseResourcePO::getHouseType, keyword)
                        .or()
                        .like(HouseResourcePO::getHouseDesc, keyword))
                .eq(StringUtils.isNotBlank(query.getEstateId()), HouseResourcePO::getEstateId, query.getEstateId())
                .eq(query.getRentMethod() != null, HouseResourcePO::getRentMethod, query.getRentMethod())
                .ge(query.getMinRent() != null, HouseResourcePO::getRent, query.getMinRent())
                .le(query.getMaxRent() != null, HouseResourcePO::getRent, query.getMaxRent())
                .eq(query.getStatus() != null, HouseResourcePO::getStatus, query.getStatus())
                .in(CollUtil.isNotEmpty(query.getStatusList()), HouseResourcePO::getStatus, query.getStatusList())
                .in(CollUtil.isNotEmpty(query.getOrientations()), HouseResourcePO::getOrientation, query.getOrientations())
                .in(CollUtil.isNotEmpty(query.getDecorations()), HouseResourcePO::getDecoration, query.getDecorations());

        addLikeAny(wrapper, query.getHouseTypes(), HouseResourcePO::getHouseType);
        addLikeAny(wrapper, query.getFloorKeywords(), HouseResourcePO::getFloor);
        return wrapper;
    }

    private void addLikeAny(
            LambdaQueryWrapper<HouseResourcePO> wrapper,
            List<String> values,
            SFunction<HouseResourcePO, ?> column) {
        List<String> cleaned = values == null ? List.of() : values.stream()
                .filter(StringUtils::isNotBlank)
                .map(String::trim)
                .toList();
        if (cleaned.isEmpty()) {
            return;
        }
        wrapper.and(nested -> {
            for (int i = 0; i < cleaned.size(); i++) {
                if (i > 0) {
                    nested.or();
                }
                nested.like(column, cleaned.get(i));
            }
        });
    }
}
