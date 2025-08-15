local utils = require("user.codecompanion.utils")

local theme_migration_content = function()
  return [[### Flutter Theme Migration

I need help transitioning our app's styling approach from using direct AppTextStyles references to using Flutter's ThemeData with extensions. Here's my specific request:

1. Please analyze two files:
   - `/home/nihal/dev/flutter/works/raf-pharmacy/lib/resources/app_textstyles.dart` (our current styling approach)
   - `/home/nihal/dev/flutter/works/innsof_ecommerce/lib/utils/theme/widget_themes/text_theme.dart` (the theme implementation we want to use)

2. Once you've analyzed them, I need you to convert text style references in our UI files (buffers I'll share) from using the AppTextStyles approach to using the context.textTheme extension method.

3. Implementation requirements:
   - Replace all instances of AppTextStyles with context.textTheme.[appropriate style]
   - Make sure to use the textTheme extension method on the BuildContext (context) to access styles
   - Preserve font weight settings by using .copyWith(fontWeight: FontWeight.w###) where necessary
   - If TextStyle has other properties in AppTextStyles, also include those in the copyWith

4. I'll share multiple files sequentially. For each one:
   - Analyze the current usage of AppTextStyles
   - Show me the complete updated code using the theme approach
   - Apply the changes to the buffer when requested

Please first examine the two reference files I mentioned so you understand both approaches thoroughly before making changes.]]
end

local theme_files_analysis_content = function()
  return [[Please use the @mcp tool to analyze these two files:
1. `/home/nihal/dev/flutter/works/raf-pharmacy/lib/resources/app_textstyles.dart`
2. `/home/nihal/dev/flutter/works/innsof_ecommerce/lib/utils/theme/widget_themes/text_theme.dart`

Provide a mapping between the styles in AppTextStyles and the equivalent in the textTheme extension approach, explaining how you'll transform them.]]
end

return utils.create_workflow(
  "Migrate from direct AppTextStyles to ThemeData with extensions",
  52,
  "thememigration",
  {
    {
      utils.create_system_message(
        "You are an expert Flutter developer specializing in UI architecture and theming. You have deep knowledge of Flutter's ThemeData system, TextTheme extensions, and best practices for maintaining consistent styling across applications."
      ),
      {
        role = "user",
        content = utils.with_auto_tool_mode(theme_migration_content),
        opts = {
          auto_submit = true,
        },
      },
    },
    {
      {
        role = "user",
        content = theme_files_analysis_content,
        opts = {
          auto_submit = true,
        },
      },
    },
    {
      {
        role = "user",
        content = "Now please analyze the code in #buffer{watch} and convert all AppTextStyles references to use context.textTheme with the appropriate extension methods. Use the @editor tool to update the buffer with the changes. Explain the transformations you've made.",
        opts = {
          auto_submit = true,
        },
      },
    },
    {
      {
        role = "user",
        content = "Please verify that all AppTextStyles references have been properly converted to context.textTheme. Also ensure you've preserved all additional style properties and font weights through copyWith as needed.",
        opts = {
          auto_submit = false,
        },
      },
    }
  }
)
