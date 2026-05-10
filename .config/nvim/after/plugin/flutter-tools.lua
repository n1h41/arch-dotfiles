-- flutter-tools.nvim fixes
--
-- Two problems addressed here:
--
-- 1) `:FlutterReanalyse` errors with:
--      not found: "dart/reanalyze" request handler for client "GitHub Copilot"
--    Cause: flutter-tools' `dart_reanalyze` calls `vim.lsp.buf_request(0, "dart/reanalyze")`
--    which fans the request out to ALL clients attached to the buffer. Copilot is attached
--    too and (correctly) doesn't implement `dart/reanalyze`, so neovim raises.
--    Fix: monkeypatch `dart_reanalyze` to send the request to the dartls client only.
--
-- 2) After hitting a DAP breakpoint and resuming (using the mason `dart-debug-adapter`,
--    not flutter-tools' built-in runner), LSP-driven completion stops returning items
--    in every dart buffer until the analysis server is poked. Triggering
--    `dart/reanalyze` after `event.continued` reliably wakes it back up.

local ok_ft, ft_lsp = pcall(require, 'flutter-tools.lsp')
if not ok_ft then return end

local SERVER_NAME = 'dartls'

local function get_dart_client(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = SERVER_NAME })
	return clients[1]
end

-- Fix 1: scope dart/reanalyze to the dart client only
ft_lsp.dart_reanalyze = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local client = get_dart_client(bufnr)
	if not client then
		vim.notify('dartls is not attached to this buffer', vim.log.levels.WARN)
		return
	end
	client:request('dart/reanalyze', nil, function(err)
		if err then
			vim.notify('dart/reanalyze failed: ' .. tostring(err.message or err),
				vim.log.levels.ERROR)
		end
	end, bufnr)
end

-- Fix 2: kick the analyzer after DAP resumes so completion comes back
local ok_dap, dap = pcall(require, 'dap')
if ok_dap then
	dap.listeners.after['event_continued']['flutter-tools-reanalyze'] = function(session)
		if not session or session.config.type ~= 'dart' then return end
		-- Send to any dart buffer that has dartls attached; the request is global.
		local clients = vim.lsp.get_clients({ name = SERVER_NAME })
		local client = clients[1]
		if not client then return end
		vim.defer_fn(function()
			client:request('dart/reanalyze', nil, function(err)
				if err then
					vim.notify('post-resume dart/reanalyze failed: ' ..
						tostring(err.message or err), vim.log.levels.WARN)
				end
			end)
		end, 150)
	end
end
