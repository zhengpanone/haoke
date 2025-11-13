import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final bool showLocation; // 展示位置按钮
  final Function? goBackCallback; // 回退按钮回调
  final String inputValue; // 输入框值
  final String defaultInputValue; // 输入框默认值
  final Function? onCancel; // 取消按钮回调
  final bool showMap; // 展示地图按钮
  final Function? onSearch; // 搜索按钮回调
  final ValueChanged<String>? onSearchSubmit;

  const SearchBar({
    super.key,
    this.showLocation = false,
    this.showMap = false,
    this.inputValue = '',
    this.defaultInputValue = '请输入搜索条件',
    this.goBackCallback,
    this.onCancel,
    this.onSearch,
    this.onSearchSubmit,
  }); // 输入框内容变化回调

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _searchText = '';

  late TextEditingController _controller;

  late FocusNode _focus;

  void _onClean() {
    _controller.clear();
    setState(() {
      _searchText = '';
    });
    // 失焦（清空后也不要自动弹键盘）
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _controller = TextEditingController(text: widget.inputValue);
  }

  @override
  void dispose() {
    _focus.dispose(); // 释放资源
    _controller.dispose(); // 避免内存泄漏
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showLocation)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Icon(Icons.room, color: Colors.red, size: 20),
                  Text(
                    '北京',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        if (widget.goBackCallback != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: widget.goBackCallback as void Function()?,
              child: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
          ),
        Expanded(
          child: Container(
            height: 34,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(17),
            ),
            margin: EdgeInsets.only(right: 8),
            child: TextField(
              focusNode: _focus,
              onChanged: (value) => {
                setState(() {
                  _searchText = value;
                }),
              },
              onTap: () {
                // 如果不是搜索页，立刻失焦
                if (widget.onSearchSubmit == null) {
                  // 焦点切换到一个新的临时节点，避免原节点状态残留。
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                if (widget.onSearch != null) {
                  widget.onSearch!();
                }
              },
              onSubmitted: widget.onSearchSubmit,
              textInputAction: TextInputAction.search,
              controller: _controller,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.search, color: Colors.grey, size: 20),
                ),
                suffixIcon: GestureDetector(
                  onTap: _onClean,
                  child: Icon(
                    Icons.clear,
                    color: _searchText == '' ? Colors.grey[200] : Colors.grey,
                    size: 20,
                  ),
                ),
                hintText: '请输入搜索条件',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                contentPadding: EdgeInsets.only(top: 0, left: -12),
              ),
            ),
          ),
        ),
        if (widget.onCancel != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: widget.onCancel as void Function()?,
              child: Text(
                '取消',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        if (widget.showMap)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.map, color: Colors.red, size: 20),
            ),
          ),
      ],
    );
  }
}
