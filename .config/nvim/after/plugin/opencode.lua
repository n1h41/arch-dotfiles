local status, _ = pcall(require, "opencode")
if not status then
	return
end

vim.o.autoread = true

---@type opencode.Opts
vim.g.opencode_opts = {
	provider = {
		enabled = "snacks",
	},
	prompts = {
		flutter_format = {
			description = "Format Flutter code",
			prompt = [[
### Flutter Code Formatting

Please help me format my Flutter code at @buffer according to best practices. When formatting the code, please:

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
   - Replace fixed sizes with MediaQuery
     - Use appropriate MediaQuery Methods
       - For size and height, use MediaQuery.sizeOf(context).width/height instead of MediaQuery.of(context).size.height/width

2. WITHOUT changing any functional behavior, improve code:
   - Remove redundant code
   - Fix any style issues
   - Improve naming if unclear
   - Simplify complex expressions
   - Apply proper nullable handling practices
   - Lift large handler functions as separate functions
]],
			submit = true,
		},
	},
}
