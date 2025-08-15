local utils = require("user.codecompanion.utils")

local dart_refactor_content = function()
  return [[### Dart Code Refactoring

I need you to perform code refactoring across several Dart files in my Flutter project. Here are the specific replacements I need:

1. Replace all instances of `Dimens.constPadding` with `ISizes.md`
2. Replace all instances of `Dimens.constWidth` with:
```dart
const SizedBox(
  width: ISizes.md,
)
```
3. Replace all instances of `Dimens.constHeight` with:
```dart
const SizedBox(
  height: ISizes.md,
)
```

For each buffer I share with you, please:
1. Scan the entire file for these patterns
2. Apply all the replacements needed
3. Let me know what changes were made in which files]]
end

return utils.create_workflow(
  "Automate Flutter code refactoring in Innsof Ecommerce project",
  50,
  "dartrefactor",
  {
    {
      utils.create_system_message(
        "You are an expert Flutter/Dart developer specializing in code refactoring. You will help the user refactor their Dart code by making specific replacements across multiple files."
      ),
      {
        role = "user",
        content = utils.with_auto_tool_mode(dart_refactor_content),
        opts = {
          auto_submit = true,
        },
      },
    },
    {
      {
        role = "user",
        content = "Now please analyze and refactor the code in #buffer{watch} using the @editor tool.",
        opts = {
          auto_submit = true,
        },
      },
    }
  }
)
