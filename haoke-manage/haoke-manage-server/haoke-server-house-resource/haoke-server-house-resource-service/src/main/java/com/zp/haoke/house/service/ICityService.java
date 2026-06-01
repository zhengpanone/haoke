package com.zp.haoke.house.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zp.haoke.house.domain.dto.CityCreateDTO;
import com.zp.haoke.house.domain.dto.CityQueryDTO;
import com.zp.haoke.house.domain.dto.CityUpdateDTO;
import com.zp.haoke.house.domain.po.CityPO;
import com.zp.haoke.house.domain.vo.CityVO;

import java.util.List;

public interface ICityService extends IService<CityPO> {
    CityVO createCity(CityCreateDTO createDTO);

    CityVO updateCity(CityUpdateDTO updateDTO);

    CityVO queryById(String id);

    List<CityVO> queryList(CityQueryDTO queryDTO);

    List<CityVO> queryTree();

    List<CityVO> queryHot();

    boolean deleteCity(String id);
}
