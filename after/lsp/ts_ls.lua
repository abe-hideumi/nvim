-- typescript-language-server の設定
-- invoice の生成物 node_modules/.prisma/client/index.d.ts が 100MB 超（190万行）あり、
-- tsserver の既定ヒープ 3GB では読み切れず SIGABRT で落ちる。
-- 落ちたことは画面に出ず gd が「No locations found」になるだけなので、先にヒープを広げておく
return {
	init_options = {
		maxTsServerMemory = 8192,
	},
}
