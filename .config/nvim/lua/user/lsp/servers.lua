-- LSP server definitions using modern vim.lsp.config (nvim 0.11+).
-- Shared on_attach and capabilities come from lua/user/lsp/init.lua.

local lsp = require("user.lsp")
local on_attach = lsp.on_attach
local capabilities = lsp.capabilities

-- Lua language server
vim.lsp.config.lua_ls = {
	on_attach = on_attach,
	capabilities = capabilities,
	on_init = function(client)
		if not client.workspace_folders or #client.workspace_folders == 0 then
			return
		end

		local path = client.workspace_folders[1].name
		if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
			runtime = {
				version = 'LuaJIT'
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
				}
			}
		})
	end,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			}
		}
	}
}

-- Go language server
vim.lsp.config.gopls = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = vim.fs.root(0, { "go.mod", ".git" }),
}

-- HTML language server
vim.lsp.config.html = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "templ" },
}

-- HTMX language server
vim.lsp.config.htmx = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "templ" },
}

-- Tailwind CSS
vim.lsp.config.tailwindcss = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "typescriptreact", "typescript.tsx", "templ" },
	settings = {
		tailwindCSS = {
			includeLanguages = {
				templ = "html",
			}
		}
	}
}

-- C/C++ (ESP-IDF clangd)
vim.lsp.config.clangd = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "c", "cpp", "objc", "objcpp", "h" },
	cmd = { "/home/n1h41/tools/esp-clang/bin/clangd", "--background-index", "--query-driver=**", "--offset-encoding=utf-16" },
}

-- QML language server
vim.lsp.config.qmlls = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "qml" },
}

-- C# (OmniSharp)
vim.lsp.config.omnisharp = {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
}

-- Filetype detection for dotted filetypes used by DevOps language servers
vim.filetype.add({
	pattern = {
		-- Docker Compose
		["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
		["docker%-compose%.ya?ml"] = "yaml.docker-compose",
		["compose%.ya?ml"] = "yaml.docker-compose",
		-- Ansible
		[".*playbook.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
		[".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*/ansible/.*%.ya?ml"] = "yaml.ansible",
	},
})

-- Kubernetes schema glob patterns for common manifest locations/names.
-- Directory patterns cover kustomize + gitops layouts (base/, overlays/, crons/,
-- configs/, ...). ArgoCD Application/ApplicationSet/AppProject manifests live under
-- these dirs and resolve via the CRD store, so only non-k8s files (kustomization.yaml,
-- helm values, Chart.yaml, compose) are excluded. Spring Boot application*.yml lives in
-- src/main/resources, outside these dirs, so it never matches the dir patterns.
-- NOTE: yamlls matches with picomatch { bash = true } — inside !(...) only literal
-- words work (a '*' silently breaks the whole extglob into match-everything).
local k8s_excl = "!(kustomization|values|Chart|compose|docker-compose)"
local k8s_dirs = {
	"k8s*", "kubernetes", "manifests", "deploy", "base*", "overlays*",
	"resources", "crons", "configs", "*deployment*",
	-- nginx-ingress CRs (VirtualServer/Policy/TransportServer/APPolicy/APLogConf/
	-- DosProtectedResource/APDosPolicy). Matching the k8s schema here triggers yamlls'
	-- CRD auto-detect (datreeio/CRDs-catalog), which routes builtin vs CRD per GVK.
	"nginx",
}
local k8s_schema_patterns = {}
for _, dir in ipairs(k8s_dirs) do
	table.insert(k8s_schema_patterns, ("**/%s/**/%s.{yml,yaml}"):format(dir, k8s_excl))
end
local k8s_kinds = {
	"deployment", "service", "ingress", "configmap", "secret", "namespace",
	"statefulset", "daemonset", "cronjob", "pv", "pvc", "hpa",
	"networkpolicy", "serviceaccount", "poddisruptionbudget",
	"rolebinding", "clusterrole",
}
for _, kind in ipairs(k8s_kinds) do
	table.insert(k8s_schema_patterns, ("**/*%s*.{yml,yaml}"):format(kind))
end

-- YAML language server
vim.lsp.config.yamlls = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "yaml", "yml" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(vim.fs.root(fname, { ".git", ".editorconfig", "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" })
			or vim.fs.dirname(fname))
	end,
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			format = { enable = true },
			kubernetesCRDStore = {
				enable = true,
			},
			schemas = {
				kubernetes = k8s_schema_patterns,
				["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
				["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
				["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
				["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
					"docker-compose*.{yml,yaml}", "compose*.{yml,yaml}",
				},
				["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
				["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
			},
		},
	},
}

-- Helm language server (delegates values files to yaml-language-server)
vim.lsp.config.helm_ls = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "helm", "yaml.helm" },
	settings = {
		["helm-ls"] = {
			yamlls = {
				path = "yaml-language-server",
			},
		},
	},
}

-- Dockerfile language server
vim.lsp.config.dockerls = {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Docker Compose language service (attaches to yaml.docker-compose filetype)
vim.lsp.config.docker_compose_language_service = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "yaml.docker-compose" },
}

-- Bash language server
vim.lsp.config.bashls = {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Terraform language server
vim.lsp.config.terraformls = {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Ansible language server (attaches to yaml.ansible filetype)
vim.lsp.config.ansiblels = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "yaml.ansible" },
}

-- Flutter tools (uses its own LSP integration)
local ok, flutter = pcall(require, 'flutter-tools')
if ok then
	flutter.setup {
		ui = {
			border = "rounded",
			notification_style = 'plugin'
		},
		decorations = {
			statusline = {
				app_version = true,
				device = true,
				project_config = true,
			}
		},
		debugger = {
			enabled = true,
			run_via_dap = true,
			exception_breakpoints = { "uncaught" }
		},
		flutter_path = "/home/n1h41/develop/flutter/bin/flutter",
		fvm = false,
		default_run_args = {
			flutter = "--print-dtd"
		},
		widget_guides = {
			enabled = true,
		},
		dev_log = {
			enabled = true,
			notify_errors = false,
			open_cmd = "tabnew",
		},
		dev_tools = {
			autostart = true,
			auto_open_browser = false,
		},
		outline = {
			open_cmd = "50vnew",
			auto_open = false
		},
		lsp = {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				showTodos = false,
				completeFunctionCalls = true,
				analysisExcludedFolders = {
					"/home/n1h41/.pub-cache/hosted/",
					"/home/n1h41/flutter/",
				},
				renameFilesWithClasses = "prompt",
				enableSnippets = true,
				updateImportsOnRename = true,
			}
		}
	}
end
