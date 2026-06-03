package com.zp.haoke.house.service.impl;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.metadata.OrderItem;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
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

@Slf4j
@Service
@RequiredArgsConstructor
public class HouseResourceServiceImpl extends ServiceImpl<HouseResourceMapper, HouseResourcePO> implements IHouseResourceService {

    private final HouseResourceConvert houseResourceConvert;

    @Override
    public int saveHouseResource(HouseResourceCreateDTO houseResourceCreateDTO, String landlordId) {
        HouseResourcePO houseResourcePO = houseResourceConvert.toEntity(houseResourceCreateDTO);
        // 新增房源默认状态为待审核
        houseResourcePO.setStatus(HouseRentStatus.PENDING);
        // 设置房东ID为当前登录用户
        houseResourcePO.setLandlordId(landlordId);
        log.info("新增房源: id={}, title={}, status={}, landlordId={}", houseResourcePO.getId(), houseResourcePO.getTitle(), houseResourcePO.getStatus(), landlordId);
        int rows = baseMapper.insert(houseResourcePO);
        log.info("新增房源完成: rows={}", rows);
        return rows;
    }

    @Override
    public HouseResourceDetailVO queryById(String id) {
        HouseResourcePO houseResourcePO = baseMapper.selectById(id);
        return houseResourceConvert.toDetailVO(houseResourcePO);
    }

    @Override
    public IPage<HouseResourceVO> queryPageList(HouseResourceQueryDTO queryDTO) {
        LambdaQueryWrapper<HouseResourcePO> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.isNotBlank(queryDTO.getTitle()), HouseResourcePO::getTitle, queryDTO.getTitle())
                .eq(StringUtils.isNotBlank(queryDTO.getEstateId()), HouseResourcePO::getEstateId, queryDTO.getEstateId())
                .eq(queryDTO.getRentMethod() != null, HouseResourcePO::getRentMethod, queryDTO.getRentMethod())
                .eq(queryDTO.getStatus() != null, HouseResourcePO::getStatus, queryDTO.getStatus())
                .in(CollUtil.isNotEmpty(queryDTO.getStatusList()), HouseResourcePO::getStatus, queryDTO.getStatusList());
//                .orderByDesc(HouseResourcePO::getCreateTime);

        IPage<HouseResourcePO> page = Page.of(queryDTO.getCurrentPage(), queryDTO.getPageSize());
        IPage<HouseResourcePO> poPage = baseMapper.selectPage(page, wrapper);
        return poPage.convert(houseResourceConvert::toVO);
    }

    @Override
    public Boolean deleteByIds(String id) {
        return null;
    }

    @Override
    public Boolean updateById(HouseResourceUpdateDTO houseResourceUpdateDTO) {
        return null;
    }
}
