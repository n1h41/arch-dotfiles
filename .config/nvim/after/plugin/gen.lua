local status, gen = pcall(require, "gen")
if (not status) then
  return
end

gen.prompts['Ask'] = {
  prompt = "Regarding the following text, $input: $text",
  replace = false,
}

gen.prompts['Time Complexity'] = {
  prompt =
  "Find Time Complexity of the given code:\n$text\n Only output the result in the format: ```...``` ",
  replace = false,
}
