-- ============================================================================
-- Flutter Bloc Configuration
-- ============================================================================
-- This configuration sets up key mappings for Flutter Bloc development.
-- It includes key mappings to create new Blocs and Cubits using the
-- flutter-bloc.nvim plugin.
--
-- Repo: https://github.com/wa11breaker/flutter-bloc.nvim
-- ============================================================================

vim.keymap.set("n", "<leader>fbb", ":FlutterCreateBloc<CR>", {
	desc = "Create Flutter Bloc",
	silent = true,
})

vim.keymap.set("n", "<leader>fbc", ":FlutterCreateCubit<CR>", {
	desc = "Create Flutter Cubit",
	silent = true,
})
