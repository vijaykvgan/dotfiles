return {
	{
		"folke/sidekick.nvim",
		event = "VeryLazy",
		opts = {
			cli = {
				win = {
					layout = "left",
				},
				tools = {
					cursor = {
						env = {
							HTTP_PROXY = "http://proxy.wal-mart.com:9080",
							HTTPS_PROXY = "http://proxy.wal-mart.com:9080",
							http_proxy = "http://proxy.wal-mart.com:9080",
							https_proxy = "http://proxy.wal-mart.com:9080",
							NO_PROXY = "127.0.0.1,localhost,.walmart.net,.walmartlabs.com,.local,.walmart.com,wmlink,.github.com",
							no_proxy = "127.0.0.1,localhost,.walmart.net,.walmartlabs.com,.local,.walmart.com,wmlink,.github.com",
							AGENT_CLI_CREDENTIAL_STORE = "file",
						},
					},
					["wibey-nightly"] = {
						cmd = { "wibey-nightly" },
					},
				},
			},
		},
	},
}
