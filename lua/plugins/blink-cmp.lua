-- LSP・スニペット・バッファ内の単語・ファイルパスの候補をまとめて出す補完プラグイン
-- 候補の中身を作るのは LSP サーバー（`lsp.lua`）で、ここがやるのは
-- 「いつ出すか・どう並べるか・どう見せるか」だけ
-- キーは preset = "default" のものをそのまま使う（一覧は ../README.md）
return {
	"saghen/blink.cmp",

	-- スニペット集。`sources` の "snippets" が参照する
	dependencies = {
		"rafamadriz/friendly-snippets",
	},

	-- タグ付きリリースを指すと、絞り込み用の Rust バイナリがビルド済みで落ちてくる
	-- （cargo を入れずに済む）。v2 は未リリースなので跨がないよう 1.* に固定する
	version = "1.*",

	opts = {
		keymap = {
            preset = "default",
            -- 候補があればenterで確定する
            ["<CR>"] = { "accept", "fallback" },
        },
		-- Nerd Font（HackGen NF）が入っている前提。無い環境ではアイコンが豆腐になる
		appearance = { nerd_font_variant = "mono" },

		-- 選択中の候補のドキュメントを自動で開く（既定は false）。
		-- K を押さなくても型とコメントが読めるので有効にしている
		completion = { documentation = { auto_show = true } },

		-- 前から順に優先される。LSP が黙る場面（コメント内など）でも
		-- buffer が拾うので候補が途切れない
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
