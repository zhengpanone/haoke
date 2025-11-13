package com.zp.haoke.house.domain.convert;

import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import com.zp.haoke.house.domain.vo.HouseResourceDetailVO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;

import java.util.ArrayList;
import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface HouseResourceConvert {
    // 静态实例，用于非 Spring 环境
    HouseResourceConvert INSTANCE = Mappers.getMapper(HouseResourceConvert.class);


    HouseResourcePO toEntity(HouseResourceCreateDTO houseResourceCreateDTO);

    HouseResourceVO toVO(HouseResourcePO po);

    @Mapping(target = "facilities", source = "facilities", qualifiedByName = "mapFacilities")
    HouseResourceDetailVO toDetailVO(HouseResourcePO po);

    List<HouseResourceVO> toDTOList(List<HouseResourcePO> list);

    @Named("mapFacilities")
    default List<HouseResourceDetailVO.FacilityVO> mapFacilities(String facilities) {
        if (facilities == null || facilities.trim().isEmpty()) {
            return new ArrayList<>();
        }
        // 将逗号分隔的ID字符串转换为FacilityVO列表
        // 注意：这里只做简单的ID转换，实际应用中可能需要查询设施表获取详细信息
        String[] ids = facilities.split(",");
        List<HouseResourceDetailVO.FacilityVO> facilityList = new ArrayList<>();
        for (String id : ids) {
            if (!id.trim().isEmpty()) {
                HouseResourceDetailVO.FacilityVO facilityVO = new HouseResourceDetailVO.FacilityVO();
                facilityVO.setId(Long.parseLong(id.trim()));
                // 这里可以设置默认值，或者从设施表中查询
                facilityVO.setName("设施" + id.trim());
                facilityVO.setIcon("icon-facility-" + id.trim());
                facilityList.add(facilityVO);
            }
        }
        return facilityList;
    }
}
