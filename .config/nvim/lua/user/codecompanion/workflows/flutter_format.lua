local utils = require("user.codecompanion.utils")

local flutter_format_content = function()
	return [[### Flutter Code Formatting

Please help me format my Flutter code according to best practices. When formatting the code, please:

#### Follow the official Dart Style Guide
1. Apply Flutter-specific formatting conventions:
   - Use proper widget structure with consistent indentation
   - Format widget trees for readability (one widget per line for complex widgets)
   - Properly align parameters and trailing commas for enhanced readability
   - Extract repeated widgets into reusable variables or methods
   - Use const constructors where appropriate
   - Format string interpolation consistently
   - Apply proper spacing around operators, brackets, and parentheses
   - Organize import statements according to best practices
   - Add proper documentation for public APIs

2. WITHOUT changing any functional behavior, improve code:
   - Remove redundant code
   - Fix any style issues
   - Improve naming if unclear
   - Simplify complex expressions
   - Apply proper nullable handling practices
	 - Lift large handler funcitons as separate functions

Let me know you're ready, and I'll share my Flutter code with you.]]
end

return utils.create_workflow(
	"Format Flutter/Dart code according to best practices",
	51,
	"flutterformat",
	{
		{
			utils.create_system_message(
				"You are an expert Flutter developer with deep knowledge of Dart style guides, Flutter best practices, and code optimization techniques. You'll help the user format and optimize their Flutter code to follow industry best practices and Flutter team's official style guidelines."
			),
			{
				role = "user",
				content = utils.with_auto_tool_mode(flutter_format_content),
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			{
				role = "user",
				content = function(context)
					local filetype = context and context.filetype or "dart"
					return
							"Please analyze the code in #{buffer} and format it according to Flutter best practices. Use @{neovim} tool apply format edits to file in buffer. The file is a " ..
							filetype .. " file. Please provide a brief explanation of the formatting changes you've made."
				end,
				opts = {
					auto_submit = true,
				},
			},
		},
		{
			{
				role = "user",
				content =
				"Thank you. Could you also explain any non-obvious formatting choices you made and why they align with Flutter best practices?",
				opts = {
					auto_submit = false,
				},
			},
		}
	}
)
