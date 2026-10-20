-- External linter integration via nvim-lint.
-- Linters are Mason-provided binaries (mason bin dir is on PATH inside nvim).

local ok, lint = pcall(require, 'lint')
if not ok then
	return
end

-- kube-linter is not shipped with nvim-lint, define it here.
-- NOTE: kube-linter works on parsed objects and reports no line numbers,
-- so all diagnostics are pinned to the top of the buffer with the object
-- name included in the message.
lint.linters.kube_linter = {
	cmd = 'kube-linter',
	stdin = false,
	append_fname = true,
	args = { 'lint', '--format', 'json' },
	ignore_exitcode = true, -- exits 1 when any check fails
	parser = function(output)
		local diagnostics = {}
		-- JSON null decodes to vim.NIL (userdata), so check types explicitly
		local ok_decode, decoded = pcall(vim.json.decode, output)
		if not ok_decode or type(decoded) ~= 'table' or type(decoded.Reports) ~= 'table' then
			return diagnostics
		end
		-- JSON null decodes to vim.NIL (userdata); normalize nested fields
		local function tbl(v)
			if type(v) == 'table' then
				return v
			end
			return {}
		end
		local function str(v, fallback)
			if type(v) == 'string' then
				return v
			end
			return fallback
		end
		for _, report in ipairs(decoded.Reports) do
			local obj = tbl(tbl(report.Object).K8sObject)
			local gvk = tbl(obj.GroupVersionKind)
			table.insert(diagnostics, {
				lnum = 0,
				col = 0,
				end_lnum = 0,
				end_col = 0,
				severity = vim.diagnostic.severity.WARN,
				source = 'kube-linter',
				message = ('[%s] %s/%s: %s'):format(
					str(report.Check, 'check'),
					str(gvk.Kind, 'object'),
					str(obj.Name, '?'),
					str(tbl(report.Diagnostic).Message, '')
				),
			})
		end
		return diagnostics
	end,
}

lint.linters_by_ft = {
	dockerfile = { 'hadolint' },
	sh = { 'shellcheck' },
	yaml = { 'yamllint' },
}

-- Path fragments that mark a yaml file as a Kubernetes manifest
local k8s_path_fragments = {
	'k8s/', 'kubernetes/', 'manifests/', 'deploy/', 'base/', 'overlays/',
	'resources/', 'crons/', 'configs/',
}

-- Basenames that live inside manifest dirs but are NOT k8s objects
-- (kube-linter would error on them)
local non_manifest_basenames = {
	'^kustomization%.', '^values', '^Chart%.', '^docker%-compose', '^compose%.',
}

local function is_k8s_manifest(bufnr)
	if vim.bo[bufnr].filetype ~= 'yaml' then
		return false
	end
	local name = vim.api.nvim_buf_get_name(bufnr)
	local basename = vim.fs.basename(name)
	for _, pat in ipairs(non_manifest_basenames) do
		if basename:find(pat) then
			return false
		end
	end
	for _, fragment in ipairs(k8s_path_fragments) do
		if name:find(fragment, 1, true) then
			return true
		end
	end
	return false
end

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
	group = vim.api.nvim_create_augroup('NvimLint', { clear = true }),
	callback = function(args)
		lint.try_lint(nil, { bufnr = args.buf })
		if is_k8s_manifest(args.buf) then
			lint.try_lint('kube_linter', { bufnr = args.buf })
		end
	end,
})
