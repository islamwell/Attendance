import 'package:flutter/material.dart';

// Material 3 Color Scheme
const kPrimaryColor = Color(0xFF6750A4); // Primary purple
const kSecondaryColor = Color(0xFF625B71); // Secondary
const kTertiaryColor = Color(0xFF7D5260); // Tertiary

const kPrimaryContainer = Color(0xFFEADDFF);
const kSecondaryContainer = Color(0xFFE8DEF8);
const kTertiaryContainer = Color(0xFFFFD8E4);

const kSurfaceColor = Color(0xFFFFFBFE);
const kSurfaceVariant = Color(0xFFE7E0EC);
const kBackgroundColor = Color(0xFFFFFBFE);

const kErrorColor = Color(0xFFB3261E);
const kSuccessColor = Color(0xFF2E7D32);
const kWarningColor = Color(0xFFF57C00);

const kOnPrimaryColor = Color(0xFFFFFFFF);
const kOnSecondaryColor = Color(0xFFFFFFFF);
const kOnBackgroundColor = Color(0xFF1C1B1F);
const kOnSurfaceColor = Color(0xFF1C1B1F);
const kOnErrorColor = Color(0xFFFFFFFF);

const kOutlineColor = Color(0xFF79747E);

// Attendance Status Colors
const kPresentColor = Color(0xFF2E7D32); // Green
const kAbsentColor = Color(0xFFB3261E); // Red
const kExcusedColor = Color(0xFFF57C00); // Orange

// Legacy colors (for gradual migration)
const kPrimaryColor2 = Color(0xFF79A7D3);
const kPrimaryColor3 = Color(0xFF6883BC);
const kTextColor = Color(0xFFE3E3E3);
const kTextColor2 = Color(0XFF312E2E);
const kTextColor3 = Color(0xFF4a5f72);

// Spacing
const double kDefaultPadding = 16.0;
const double kSmallPadding = 8.0;
const double kLargePadding = 24.0;
const double kExtraLargePadding = 32.0;

// Border Radius
const double kDefaultBorderRadius = 12.0;
const double kLargeBorderRadius = 16.0;
const double kExtraLargeBorderRadius = 28.0;

// Elevation
const double kDefaultElevation = 1.0;
const double kMediumElevation = 3.0;

// Material 3 Theme Configuration
ThemeData getMaterial3Theme() {
  final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: kPrimaryColor,
    onPrimary: kOnPrimaryColor,
    primaryContainer: kPrimaryContainer,
    onPrimaryContainer: const Color(0xFF21005D),
    secondary: kSecondaryColor,
    onSecondary: kOnSecondaryColor,
    secondaryContainer: kSecondaryContainer,
    onSecondaryContainer: const Color(0xFF1D192B),
    tertiary: kTertiaryColor,
    onTertiary: kOnSecondaryColor,
    tertiaryContainer: kTertiaryContainer,
    onTertiaryContainer: const Color(0xFF31111D),
    error: kErrorColor,
    onError: kOnErrorColor,
    errorContainer: const Color(0xFFF9DEDC),
    onErrorContainer: const Color(0xFF410E0B),
    surface: kSurfaceColor,
    onSurface: kOnSurfaceColor,
    surfaceContainerHighest: kSurfaceVariant,
    onSurfaceVariant: const Color(0xFF49454F),
    outline: kOutlineColor,
    outlineVariant: const Color(0xFFCAC4D0),
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    inverseSurface: const Color(0xFF313033),
    onInverseSurface: const Color(0xFFF4EFF4),
    inversePrimary: const Color(0xFFD0BCFF),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: kBackgroundColor,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: kSurfaceColor,
      foregroundColor: kOnSurfaceColor,
      surfaceTintColor: kSurfaceColor,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: kOnSurfaceColor,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: kDefaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      color: kSurfaceColor,
      surfaceTintColor: kPrimaryColor,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: kDefaultElevation,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kExtraLargeBorderRadius),
        ),
      ),
    ),

    // Filled Button Theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kExtraLargeBorderRadius),
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kExtraLargeBorderRadius),
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        borderSide: const BorderSide(color: kErrorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        borderSide: const BorderSide(color: kErrorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: kMediumElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kLargeBorderRadius),
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: kSecondaryContainer,
      deleteIconColor: kOnSecondaryColor,
      labelStyle: const TextStyle(color: kOnSurfaceColor),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: kOutlineColor,
      thickness: 1,
      space: 1,
    ),
  );
}
