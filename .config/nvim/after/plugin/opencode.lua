vim.notify("Opencode loaded", vim.log.levels.INFO)

vim.g.opencode_opts = {
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
			- For size and height, user MediaQuery.sizeOf(context).width/height insted of MediaQuery.of(context).size.height/width

2. WITHOUT changing any functional behavior, improve code:
   - Remove redundant code
   - Fix any style issues
   - Improve naming if unclear
   - Simplify complex expressions
   - Apply proper nullable handling practices
	 - Lift large handler funcitons as separate functions
			]],
		},
	}
}
