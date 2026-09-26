import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';

/// Modular, dedicated bottom sheet widget for filtering and sorting employee records.
/// Encapsulates its own temporary selection state without relying on inline StatefulBuilders.
class FilterBottomSheet extends StatefulWidget {
  final String initialField;
  final String initialCountry;
  final String initialSort;
  final List<String> availableCountries;
  final Function(String field, String country, String sort) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialField,
    required this.initialCountry,
    required this.initialSort,
    required this.availableCountries,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required String initialField,
    required String initialCountry,
    required String initialSort,
    required List<String> availableCountries,
    required Function(String field, String country, String sort) onApply,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : Colors.white;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (_) => FilterBottomSheet(
        initialField: initialField,
        initialCountry: initialCountry,
        initialSort: initialSort,
        availableCountries: availableCountries,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedField;
  late String _selectedCountry;
  late String _selectedSort;

  static const List<String> _filterFields = [
    'All',
    'Name',
    'Email',
    'Mobile',
    'Country',
    'ID',
  ];

  @override
  void initState() {
    super.initState();
    _selectedField = widget.initialField;
    _selectedCountry = widget.initialCountry;
    _selectedSort = widget.initialSort;
  }

  void _resetAll() {
    setState(() {
      _selectedField = 'All';
      _selectedCountry = 'All';
      _selectedSort = 'Name';
    });
  }

  void _apply() {
    widget.onApply(_selectedField, _selectedCountry, _selectedSort);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppResponsive.scale(context, 20.0),
          AppResponsive.scale(context, 12.0),
          AppResponsive.scale(context, 20.0),
          AppResponsive.scale(context, 20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: AppResponsive.scale(context, 16.0)),

            // Header: Title + Reset All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Color(0xFF4F46E5),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Filter & Sort',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 18.0),
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _resetAll,
                  child: const Text(
                    'Reset All',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Section 1: Filter By Field
            Text(
              'FILTER BY FIELD',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 11.5),
                fontWeight: FontWeight.w700,
                color: secondaryTextColor,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: AppResponsive.scale(context, 8.0)),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _filterFields.map((field) {
                final isSelected = _selectedField == field;
                return ChoiceChip(
                  label: Text(field == 'All' ? 'All Fields' : field),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedField = field);
                  },
                  selectedColor: const Color(0xFF4F46E5),
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : primaryTextColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: AppResponsive.fontSize(context, 12.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF4F46E5) : borderColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppResponsive.scale(context, 16.0)),

            // Section 2: Filter By Country
            Text(
              'FILTER BY COUNTRY',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 11.5),
                fontWeight: FontWeight.w700,
                color: secondaryTextColor,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: AppResponsive.scale(context, 8.0)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.availableCountries.map((country) {
                  final isSelected = _selectedCountry.toLowerCase() == country.toLowerCase();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(country),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCountry = country);
                      },
                      selectedColor: const Color(0xFF4F46E5),
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : primaryTextColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: AppResponsive.fontSize(context, 12.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF4F46E5) : borderColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: AppResponsive.scale(context, 16.0)),

            // Section 3: Sort Options
            Text(
              'SORT BY',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 11.5),
                fontWeight: FontWeight.w700,
                color: secondaryTextColor,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: AppResponsive.scale(context, 8.0)),
            Row(
              children: [
                _buildSortRadio('Name', 'Name (A-Z)', Icons.sort_by_alpha_rounded),
                const SizedBox(width: 8),
                _buildSortRadio('ID', 'ID Number', Icons.tag_rounded),
                const SizedBox(width: 8),
                _buildSortRadio('Date', 'Newest', Icons.calendar_today_rounded),
              ],
            ),
            SizedBox(height: AppResponsive.scale(context, 20.0)),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: AppResponsive.scale(context, 13.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                ),
                onPressed: _apply,
                child: Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 15.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortRadio(String value, String label, IconData icon) {
    final isSelected = _selectedSort == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedSort = value),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF4F46E5).withValues(alpha: 0.1)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? const Color(0xFF4F46E5) : borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18.0,
                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
              ),
              const SizedBox(height: 4.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF4F46E5) : primaryTextColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
