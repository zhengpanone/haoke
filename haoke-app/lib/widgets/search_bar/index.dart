import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final bool showLocation;
  final Function? goBackCallback;
  final String inputValue;
  final String defaultInputValue;
  final Function? onCancel;
  final bool showMap;
  final Function? onSearch;
  final ValueChanged<String>? onSearchSubmit;

  const SearchBar({
    super.key,
    this.showLocation = false,
    this.showMap = false,
    this.inputValue = '',
    this.defaultInputValue = 'Search community, area, subway...',
    this.goBackCallback,
    this.onCancel,
    this.onSearch,
    this.onSearchSubmit,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _searchText = '';
  late TextEditingController _controller;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _controller = TextEditingController(text: widget.inputValue);
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onClean() {
    _controller.clear();
    setState(() {
      _searchText = '';
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showLocation)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6F2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on_rounded,
                    color: Color(0xFF0F8F7A), size: 16),
                SizedBox(width: 4),
                Text(
                  'Beijing',
                  style: TextStyle(
                    color: Color(0xFF0F8F7A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (widget.goBackCallback != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: widget.goBackCallback as void Function()?,
              child: const Icon(Icons.arrow_back_rounded,
                  color: Color(0xFF374544), size: 20),
            ),
          ),
        Expanded(
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFDBE9E5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              focusNode: _focus,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              onTap: () {
                if (widget.onSearchSubmit == null) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                if (widget.onSearch != null) {
                  widget.onSearch!();
                }
              },
              onSubmitted: widget.onSearchSubmit,
              textInputAction: TextInputAction.search,
              controller: _controller,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2B2A)),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: Color(0xFF9AA8A5), size: 20),
                suffixIcon: GestureDetector(
                  onTap: _onClean,
                  child: Icon(
                    Icons.cancel_rounded,
                    color: _searchText.isEmpty
                        ? Colors.transparent
                        : const Color(0xFFB4C0BE),
                    size: 18,
                  ),
                ),
                hintText: widget.defaultInputValue,
                hintStyle:
                    const TextStyle(fontSize: 13, color: Color(0xFF9AA8A5)),
                contentPadding: const EdgeInsets.only(top: 1),
              ),
            ),
          ),
        ),
        if (widget.onCancel != null)
          GestureDetector(
            onTap: widget.onCancel as void Function()?,
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF4A5B58),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        if (widget.showMap)
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.map_rounded,
                color: Color(0xFF0F8F7A), size: 20),
          ),
      ],
    );
  }
}
