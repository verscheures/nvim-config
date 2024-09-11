-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.root_spec = { "cwd" }

opts = {
	-- make sure mason installs the server
	servers = {
		yamlls = {
			-- Have to add this for yamlls to understand that we support line folding
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
			-- lazy-load schemastore when needed
			on_new_config = function(new_config)
				new_config.settings.yaml.schemas = vim.tbl_deep_extend(
					"force",
					new_config.settings.yaml.schemas or {},
					require("schemastore").yaml.schemas()
				)
			end,
			settings = {
				redhat = { telemetry = { enabled = false } },
				yaml = {
					keyOrdering = false,
					format = {
						enable = true,
					},
					validate = true,
					flowSequence = "forbid",
					flowMapping = "forbid",
					schemaStore = {
						-- Must disable built-in schemaStore support to use
						-- schemas from SchemaStore.nvim plugin
						enable = false,
						-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
						url = "",
					},
				},
			},
		},
	},
	setup = {
		yamlls = function()
			-- Neovim < 0.10 does not have dynamic registration for formatting
			if vim.fn.has("nvim-0.10") == 0 then
				LazyVim.lsp.on_attach(function(client, _)
					if client.name == "yamlls" then
						client.server_capabilities.documentFormattingProvider = true
					end
				end)
			end
		end,
	},
}
