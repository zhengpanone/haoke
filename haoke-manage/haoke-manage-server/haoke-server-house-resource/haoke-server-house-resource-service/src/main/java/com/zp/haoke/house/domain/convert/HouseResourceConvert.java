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

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface HouseResourceConvert {
    HouseResourceConvert INSTANCE = Mappers.getMapper(HouseResourceConvert.class);

    HouseResourcePO toEntity(HouseResourceCreateDTO houseResourceCreateDTO);

    default HouseResourceVO toVO(HouseResourcePO po) {
        if (po == null) {
            return null;
        }

        HouseResourceVO vo = new HouseResourceVO();
        vo.setId(po.getId());
        vo.setTitle(po.getTitle());
        vo.setEstateId(po.getEstateId());
        vo.setBuildingNum(po.getBuildingNum());
        vo.setBuildingUnit(po.getBuildingUnit());
        vo.setBuildingFloorNum(po.getBuildingFloorNum());
        vo.setRent(po.getRent() == null ? null : BigDecimal.valueOf(po.getRent()));
        vo.setRentMethod(po.getRentMethod() == null ? null : String.valueOf(po.getRentMethod()));
        vo.setPaymentMethod(po.getPaymentMethod());
        vo.setHouseType(po.getHouseType());
        vo.setCoveredArea(parseDecimal(po.getCoveredArea()));
        vo.setUseArea(po.getUseArea());
        vo.setFloor(po.getFloor());
        vo.setOrientation(po.getOrientation() == null ? null : String.valueOf(po.getOrientation()));
        vo.setDecoration(po.getDecoration() == null ? null : String.valueOf(po.getDecoration()));
        vo.setFacilities(po.getFacilities());
        vo.setDescription(po.getHouseDesc());
        vo.setContact(po.getContact());
        vo.setMobile(po.getMobile());
        vo.setStatus(po.getStatus() == null ? null : po.getStatus().getCode());
        vo.setCreated(po.getCreateTime());
        vo.setUpdated(po.getUpdateTime());
        vo.setImageUrl(firstImage(po.getPic()));
        vo.setTags(buildTags(po));
        vo.setSubTitle(buildSubTitle(po));
        return vo;
    }

    @Mapping(target = "houseResources", source = "po")
    @Mapping(target = "estate", ignore = true)
    @Mapping(target = "images", source = "pic", qualifiedByName = "mapImages")
    @Mapping(target = "facilities", source = "facilities", qualifiedByName = "mapFacilities")
    HouseResourceDetailVO toDetailVO(HouseResourcePO po);

    List<HouseResourceVO> toDTOList(List<HouseResourcePO> list);

    @Named("mapImages")
    default List<HouseResourceDetailVO.ImageVO> mapImages(String pic) {
        List<HouseResourceDetailVO.ImageVO> imageList = new ArrayList<>();
        if (pic == null || pic.trim().isEmpty()) {
            return imageList;
        }

        String[] urls = pic.split(",");
        for (int i = 0; i < urls.length; i++) {
            if (!urls[i].trim().isEmpty()) {
                HouseResourceDetailVO.ImageVO imageVO = new HouseResourceDetailVO.ImageVO();
                imageVO.setUrl(urls[i].trim());
                imageVO.setSortOrder(i + 1);
                imageList.add(imageVO);
            }
        }
        return imageList;
    }

    @Named("mapFacilities")
    default List<HouseResourceDetailVO.FacilityVO> mapFacilities(String facilities) {
        List<HouseResourceDetailVO.FacilityVO> facilityList = new ArrayList<>();
        if (facilities == null || facilities.trim().isEmpty()) {
            return facilityList;
        }

        String[] ids = facilities.split(",");
        for (String id : ids) {
            String value = id.trim();
            if (!value.isEmpty()) {
                HouseResourceDetailVO.FacilityVO facilityVO = new HouseResourceDetailVO.FacilityVO();
                facilityVO.setId(Long.parseLong(value));
                facilityVO.setName(facilityName(value));
                facilityVO.setIcon("icon-facility-" + value);
                facilityList.add(facilityVO);
            }
        }
        return facilityList;
    }

    private BigDecimal parseDecimal(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private String firstImage(String pic) {
        if (pic == null || pic.trim().isEmpty()) {
            return "";
        }
        String[] urls = pic.split(",");
        return urls.length == 0 ? "" : urls[0].trim();
    }

    private List<String> buildTags(HouseResourcePO po) {
        List<String> tags = new ArrayList<>();
        String decoration = decorationName(po.getDecoration());
        String rentMethod = rentMethodName(po.getRentMethod());
        if (!decoration.isEmpty()) {
            tags.add(decoration);
        }
        if (!rentMethod.isEmpty()) {
            tags.add(rentMethod);
        }
        if (po.getFacilities() != null && !po.getFacilities().trim().isEmpty()) {
            tags.add("配套齐全");
        }
        return tags;
    }

    private String buildSubTitle(HouseResourcePO po) {
        List<String> parts = new ArrayList<>();
        if (po.getHouseType() != null && !po.getHouseType().trim().isEmpty()) {
            parts.add(po.getHouseType().trim());
        }
        if (po.getCoveredArea() != null && !po.getCoveredArea().trim().isEmpty()) {
            parts.add(po.getCoveredArea().trim() + "㎡");
        }
        if (po.getFloor() != null && !po.getFloor().trim().isEmpty()) {
            parts.add(po.getFloor().trim());
        }
        return String.join(" · ", parts);
    }

    private String decorationName(Integer decoration) {
        if (decoration == null) {
            return "";
        }
        return switch (decoration) {
            case 1 -> "精装";
            case 2 -> "简装";
            case 3 -> "毛坯";
            default -> "";
        };
    }

    private String rentMethodName(Integer rentMethod) {
        if (rentMethod == null) {
            return "";
        }
        return rentMethod == 2 ? "合租" : "整租";
    }

    private String facilityName(String value) {
        return switch (value) {
            case "1" -> "空调";
            case "2" -> "冰箱";
            case "3" -> "洗衣机";
            case "4" -> "电视";
            case "5" -> "宽带";
            default -> "设施" + value;
        };
    }
}
