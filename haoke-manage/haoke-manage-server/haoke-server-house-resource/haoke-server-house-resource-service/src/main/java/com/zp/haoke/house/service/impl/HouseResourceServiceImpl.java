package com.zp.haoke.house.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zp.haoke.framework.core.enums.HouseRentStatus;
import com.zp.haoke.house.domain.convert.HouseResourceConvert;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.domain.vo.HouseResourceDetailVO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import com.zp.haoke.house.mapper.HouseResourceMapper;
import com.zp.haoke.house.service.IHouseResourceService;
import lombok.AllArgsConstructor;
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
    public int saveHouseResource(HouseResourceCreateDTO houseResourceCreateDTO) {
        HouseResourcePO houseResourcePO = houseResourceConvert.toEntity(houseResourceCreateDTO);
        // 新增房源默认状态为待审核
        houseResourcePO.setStatus(HouseRentStatus.PENDING);
        log.info("新增房源: id={}, title={}, status={}", houseResourcePO.getId(), houseResourcePO.getTitle(), houseResourcePO.getStatus());
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
    public IPage<HouseResourceVO> queryPageList() {
        IPage<HouseResourcePO> page = baseMapper.selectPage(new Page<>(), null);
//        List<HouseResourceVO> voList = houseResourceConvert.toDTOList(page.getRecords());
//        Page<HouseResourceVO> voPage = new Page<>(
//                page.getCurrent(),
//                page.getSize(),
//                page.getTotal()
//        );
//
//        voPage.setRecords(voList);
//
//        return voPage;
        return page.convert(houseResourceConvert::toVO);
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
