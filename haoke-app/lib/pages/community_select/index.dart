import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/models/city/city_model.dart';
import 'package:haoke_rent/models/community/community_model.dart';
import 'package:haoke_rent/services/api_service.dart';
import 'package:haoke_rent/utils/common_toast.dart';

class CommunitySelectPage extends StatefulWidget {
  const CommunitySelectPage({super.key});

  @override
  State<CommunitySelectPage> createState() => _CommunitySelectPageState();
}

class _CommunitySelectPageState extends State<CommunitySelectPage> {
  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final ApiService apiService = ApiService();

  Timer? searchDebounce;
  bool isLoading = false;
  bool isCreating = false;
  bool isCityLoading = false;
  String keyword = '';
  String errorMessage = '';
  String cityErrorMessage = '';
  List<CommunityModel> communities = [];
  List<CityModel> cityTree = [];
  CityModel? selectedProvince;
  CityModel? selectedCity;
  CityModel? selectedArea;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
    _loadCityTree();
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    searchController.dispose();
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _loadCommunities({String keyword = ''}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await apiService.queryCommunities(keyword: keyword);
      if (!mounted) {
        return;
      }
      setState(() {
        communities = response.data ?? [];
        if (!response.isSuccess) {
          errorMessage = response.message;
        }
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        errorMessage = context.tr('load_communities_failed');
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    final nextKeyword = value.trim();
    setState(() {
      keyword = nextKeyword;
    });
    if (nameController.text != nextKeyword) {
      nameController.text = nextKeyword;
    }

    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _loadCommunities(keyword: nextKeyword);
    });
  }

  Future<void> _loadCityTree() async {
    setState(() {
      isCityLoading = true;
      cityErrorMessage = '';
    });

    try {
      final response = await apiService.queryCityTree();
      if (!mounted) {
        return;
      }
      setState(() {
        cityTree = response.data ?? [];
        if (!response.isSuccess) {
          cityErrorMessage = response.message;
        }
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        cityErrorMessage = context.tr('load_cities_failed');
      });
    } finally {
      if (mounted) {
        setState(() {
          isCityLoading = false;
        });
      }
    }
  }

  void _selectCommunity(CommunityModel community) {
    Navigator.of(context).pop(community);
  }

  Future<void> _addCommunity() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      CommonToast.showToast(context.tr('community_name_required'),
          context: context);
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      final response = await apiService.createCommunity(
        CommunityModel(
          name: name,
          province: selectedProvince?.name ?? '',
          city: selectedCity?.name ?? '',
          area: selectedArea?.name ?? '',
          address: addressController.text.trim(),
        ),
      );

      if (!mounted) {
        return;
      }
      if (response.isSuccess && response.data != null) {
        _selectCommunity(response.data!);
      } else {
        CommonToast.showToast(
          response.message.isEmpty
              ? context.tr('create_community_failed')
              : response.message,
          context: context,
        );
      }
    } catch (e) {
      if (mounted) {
        CommonToast.showToast(context.tr('create_community_failed'),
            context: context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isCreating = false;
        });
      }
    }
  }

  Future<void> _pickCity() async {
    if (isCityLoading) {
      return;
    }
    if (cityTree.isEmpty) {
      CommonToast.showToast(
        cityErrorMessage.isEmpty
            ? context.tr('load_cities_failed')
            : cityErrorMessage,
        context: context,
      );
      _loadCityTree();
      return;
    }

    final result = await showModalBottomSheet<_CitySelection>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return _CityPickerSheet(
          title: context.tr('choose_city'),
          provinces: cityTree,
          selectedCityId: selectedCity?.id,
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      selectedProvince = result.province;
      selectedCity = result.city;
      selectedArea = null;
    });
  }

  Future<void> _pickArea() async {
    final city = selectedCity;
    if (city == null) {
      CommonToast.showToast(context.tr('please_choose_city'), context: context);
      return;
    }
    if (city.children.isEmpty) {
      CommonToast.showToast(context.tr('no_area_options'), context: context);
      return;
    }

    final result = await showModalBottomSheet<CityModel>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return _AreaPickerSheet(
          title: context.tr('choose_area'),
          areas: city.children,
          selectedAreaId: selectedArea?.id,
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      selectedArea = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('choose_community'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
        children: [
          TextField(
            controller: searchController,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: context.tr('community_search_hint'),
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: keyword.isEmpty
                  ? null
                  : IconButton(
                      tooltip: context.tr('clear_search'),
                      icon: const Icon(Icons.cancel_rounded),
                      onPressed: () {
                        searchDebounce?.cancel();
                        searchController.clear();
                        nameController.clear();
                        setState(() {
                          keyword = '';
                        });
                        _loadCommunities();
                      },
                    ),
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(title: context.tr('nearby_communities')),
          const SizedBox(height: 8),
          if (isLoading)
            const _LoadingCommunities()
          else if (errorMessage.isNotEmpty)
            _ErrorCommunities(
              message: errorMessage,
              onRetry: () => _loadCommunities(keyword: keyword),
            )
          else if (communities.isEmpty)
            _EmptyCommunityTip(keyword: keyword)
          else
            ...communities.map(
              (item) => _CommunityTile(
                item: item,
                onTap: () => _selectCommunity(item),
              ),
            ),
          const SizedBox(height: 22),
          _SectionTitle(title: context.tr('add_new_community')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5EEEB)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: context.tr('community_name'),
                    hintText: context.tr('community_name_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SelectField(
                        label: context.tr('community_city'),
                        hint: isCityLoading
                            ? context.tr('city_loading')
                            : context.tr('community_city_hint'),
                        value: selectedCity?.name ?? '',
                        onTap: isCityLoading ? null : _pickCity,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SelectField(
                        label: context.tr('community_area'),
                        hint: context.tr('community_area_hint'),
                        value: selectedArea?.name ?? '',
                        onTap: _pickArea,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: context.tr('community_address'),
                    hintText: context.tr('community_address_hint'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: isCreating ? null : _addCommunity,
            icon: isCreating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_home_work_rounded),
            label: Text(context.tr('use_this_community')),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2B2A),
      ),
    );
  }
}

class _CommunityTile extends StatelessWidget {
  final CommunityModel item;
  final VoidCallback onTap;

  const _CommunityTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EEEB)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.apartment_rounded,
            color: Color(0xFF0F8F7A),
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(item.displayAddress),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final VoidCallback? onTap;

  const _SelectField({
    required this.label,
    required this.hint,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        child: Text(
          hasValue ? value : hint,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: hasValue ? const Color(0xFF1F2B2A) : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _CitySelection {
  final CityModel province;
  final CityModel city;

  const _CitySelection({
    required this.province,
    required this.city,
  });
}

class _CityPickerSheet extends StatelessWidget {
  final String title;
  final List<CityModel> provinces;
  final String? selectedCityId;

  const _CityPickerSheet({
    required this.title,
    required this.provinces,
    this.selectedCityId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            _PickerTitle(title: title),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: provinces.length,
                itemBuilder: (context, index) {
                  final province = provinces[index];
                  final cities = province.children;
                  if (cities.isEmpty) {
                    return _PickerOption(
                      title: province.name,
                      selected: province.id == selectedCityId,
                      onTap: () => Navigator.of(context).pop(
                        _CitySelection(province: province, city: province),
                      ),
                    );
                  }

                  return ExpansionTile(
                    initiallyExpanded:
                        cities.any((city) => city.id == selectedCityId),
                    title: Text(
                      province.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    children: cities
                        .map(
                          (city) => _PickerOption(
                            title: city.name,
                            selected: city.id == selectedCityId,
                            onTap: () => Navigator.of(context).pop(
                              _CitySelection(
                                province: province,
                                city: city,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaPickerSheet extends StatelessWidget {
  final String title;
  final List<CityModel> areas;
  final String? selectedAreaId;

  const _AreaPickerSheet({
    required this.title,
    required this.areas,
    this.selectedAreaId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.56,
        child: Column(
          children: [
            _PickerTitle(title: title),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: areas.length,
                itemBuilder: (context, index) {
                  final area = areas[index];
                  return _PickerOption(
                    title: area.name,
                    selected: area.id == selectedAreaId,
                    onTap: () => Navigator.of(context).pop(area),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTitle extends StatelessWidget {
  final String title;

  const _PickerTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2B2A),
              ),
            ),
          ),
          IconButton(
            tooltip: context.tr('cancel'),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _PickerOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? const Color(0xFF0F8F7A) : const Color(0xFF1F2B2A),
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: Color(0xFF0F8F7A))
          : null,
    );
  }
}

class _LoadingCommunities extends StatelessWidget {
  const _LoadingCommunities();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 28),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCommunities extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCommunities({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EEEB)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFFB25A3C),
            size: 34,
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(context.tr('retry')),
          ),
        ],
      ),
    );
  }
}

class _EmptyCommunityTip extends StatelessWidget {
  final String keyword;

  const _EmptyCommunityTip({required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EEEB)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.domain_add_rounded,
            color: Color(0xFF0F8F7A),
            size: 38,
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('community_not_found'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (keyword.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              keyword,
              style: const TextStyle(color: Color(0xFF6F7E7B)),
            ),
          ],
        ],
      ),
    );
  }
}
