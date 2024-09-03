local lsp_zero = require("lsp-zero")
lsp_zero.preset({
	manage_nvim_cmp = false,
})

require("mason").setup({})
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
		rust_analyzer = lsp_zero.noop,
	},
})
